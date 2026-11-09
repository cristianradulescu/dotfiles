# Proxy Setup Documentation

This document describes how to route traffic through a SOCKS5 proxy using a reverse SSH tunnel between two laptops. This 
is useful when you need to access services that are only available through a VPN connection on a remote machine.

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              HOST LAPTOP                                    │
│                         (Your development machine)                          │
│                                                                             │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌──────────────┐  │
│  │  Browser    │    │  PAC File   │    │   socat     │    │    socat     │  │
│  │  System     │───▶│   Server    │    │   rebind    │    │   forward    │  │
│  │  Apps       │    │  :8800      │    │   :1081     │    │   :3031      │  │
│  └─────────────┘    └─────────────┘    └──────┬──────┘    └───────┬──────┘  │
│         │                                      │                   │        │
│         │         ┌────────────────────────────┘                   │        │
│         │         │                                                │        │
│         ▼         ▼                                                │        │
│  ┌─────────────────────┐                                           │        │
│  │  Reverse SSH Tunnel │◀──────────────────────────────────────────┘        │
│  │  127.0.0.1:1080     │                                                    │
│  └──────────┬──────────┘                                                    │
│             │                                                               │
└─────────────┼───────────────────────────────────────────────────────────────┘
              │ SSH Connection
              │
┌─────────────┼───────────────────────────────────────────────────────────────┐
│             │                        REMOTE LAPTOP                          │
│             ▼                      (VPN connected machine)                  │
│  ┌─────────────────────┐                                                    │
│  │    SSH Server       │                                                    │
│  │    SOCKS5 Proxy     │────────▶  VPN  ────────▶  Protected Services       │
│  └─────────────────────┘                    (e.g., exampleprotected.com     │ 
│                                                                             │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Traffic Flow

1. **Browser/System Apps**: Use the PAC file to determine which traffic goes through the proxy
2. **Docker Containers**: Use `extra_hosts` to redirect specific domains to the host, where socat forwards through the SOCKS proxy
3. **PAC File Server**: Serves the proxy auto-config file to browsers and system applications
4. **socat rebind**: Exposes the reverse tunnel (bound to localhost) to all interfaces for Docker access
5. **socat forward**: Forwards specific domain:port combinations through the SOCKS proxy
6. **Docker Daemon**: Uses the SOCKS proxy directly for registry traffic (`docker login`, `pull`, `push`) via a one-time `daemon.json` config
7. **Git**: Uses the SOCKS proxy only for specific git hosts (SSH `ProxyCommand` or per-URL `http.<url>.proxy`)
8. **Reverse SSH Tunnel**: Connects host laptop to remote laptop's SOCKS proxy
9. **Remote Laptop**: Routes traffic through VPN to protected services

---

## Remote Laptop Setup (VPN Machine)

This is the laptop that has VPN access to the protected services.

### 1. Install OpenSSH Server

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install openssh-server

# Start and enable the service
sudo systemctl start ssh
sudo systemctl enable ssh

# Verify it's running
sudo systemctl status ssh
```

### 2. Configure SSH Server for Reverse Tunnels

Edit `/etc/ssh/sshd_config` and ensure these settings are present:

```
# Allow gateway ports for reverse tunnels
GatewayPorts no

# Keep connections alive
ClientAliveInterval 60
ClientAliveCountMax 3

# Allow TCP forwarding
AllowTcpForwarding yes
```

Restart SSH after changes:

```bash
sudo systemctl restart ssh
```

### 3. Create the Reverse Tunnel Script

Example [reverse_tunnel.sh](./reverse_tunnel.sh)

#### Script Parameters Explained

| Parameter | Description |
|-----------|-------------|
| `-4` | Force IPv4 |
| `-v` | Verbose mode for debugging connection issues |
| `-R 1080` | Create a reverse tunnel, exposing local SOCKS proxy on port 1080 of the remote host |
| `-N` | Don't execute remote commands, just forward ports |
| `-o ServerAliveInterval=60` | Send keepalive every 60 seconds |
| `-o ServerAliveCountMax=3` | Disconnect after 3 missed keepalives |
| `-o ExitOnForwardFailure=yes` | Exit if port forwarding fails (e.g., port already in use) |
| `my-work-machine` | SSH host alias (configured in `~/.ssh/config`) |

### 4. Configure SSH Client

On the remote laptop, add to `~/.ssh/config`:

```
Host my-work-machine
    HostName <host-laptop-ip>
    User <username>
    IdentityFile ~/.ssh/id_rsa
    DynamicForward 1080
```

The `DynamicForward 1080` creates a SOCKS5 proxy that routes traffic through the SSH connection.

### 5. Set Up SSH Key Authentication

```bash
# Generate key if not exists
ssh-keygen -t ed25519 -C "proxy-tunnel"

# Copy public key to host laptop
ssh-copy-id my-work-machine
```

### 6. Start the Reverse Tunnel

```bash
# Connect to VPN first, then:
./reverse_tunnel.sh
```

---

## Host Laptop Setup (Development Machine)

This is your main development machine where you run Docker, browsers, etc.

### 1. Install Required Packages

```bash
sudo apt update
sudo apt install openssh-server socat python3
```

### 2. Configure SSH Server

Ensure SSH server is running to accept the reverse tunnel connection:

```bash
sudo systemctl start ssh
sudo systemctl enable ssh
```

### 3. Create the PAC File

Example [proxy.pac](./proxy.pac)

#### PAC File Explained

- **`FindProxyForURL(url, host)`**: Called by browsers/apps for each request
- **`dominated` array**: List of domains that should use the proxy
- **`dnsDomainIs()`**: Checks if host matches domain or subdomain
- **`SOCKS5 localhost:1080`**: Route through SOCKS5 proxy
- **`DIRECT`**: Connect directly without proxy

### 4. Create the Start Proxy Script

Example [start-proxy.sh](./start-proxy.sh)

### 5. Configure Docker Compose

Add `extra_hosts` to your `docker-compose.yml` for each domain that needs proxying:

```yaml
services:
  php:
    extra_hosts:
      - "exampleprotected.com:host-gateway"
```

This maps the domain to your host machine inside the container, so traffic goes through socat instead of directly to the internet.

> /!\ Most likely the docker-compose.yml file is versioned, find a way to not commit the proxy changes!

### 6. Configure Docker Daemon Proxy

`extra_hosts` only covers traffic from *inside* containers. Registry operations (`docker login`, `docker pull`,
`docker push`, base images in `docker build`) are performed by the Docker daemon itself, so the daemon needs its own
proxy config. The CLI only talks to the daemon over its unix socket. Even `docker login` sends the credentials to the
daemon, which then contacts the registry.

This is a **one-time** setup (Docker Engine 23+). Add a `proxies` block to `/etc/docker/daemon.json`, merging it with
any keys already in the file (e.g. `log-driver`):

```json
{
  "proxies": {
    "http-proxy": "socks5://127.0.0.1:1080",
    "https-proxy": "socks5://127.0.0.1:1080",
    "no-proxy": "localhost,127.0.0.0/8,::1"
  }
}
```

Apply and verify:

```bash
sudo systemctl restart docker      # stops running containers unless "live-restore": true is set
docker info | grep -i proxy        # should show socks5://127.0.0.1:1080
docker login registry.example.com
```

The daemon runs on the host network, so it uses the tunnel port (`1080`) directly. The `1081` rebind is only
needed by containers. DNS for the registry hostname is resolved on the remote (VPN) side of the SOCKS proxy.

**Why not toggle it from `start-proxy.sh`?** Changing the daemon's proxy requires `sudo` and a daemon restart (which
stops running containers), and if the script dies without running its cleanup (`kill -9`, sleep, tunnel drop) the
daemon is left pointing at whatever state it was in. A static config avoids all of that.

**Trade-off**: *all* registry traffic (including Docker Hub) goes through the tunnel, and while the tunnel is down
every `pull`/`push`/`login` fails with `proxyconnect tcp: dial tcp 127.0.0.1:1080: connect: connection refused`.
Add registries that should always be reached directly to `no-proxy`. To go fully direct, remove the `proxies` block
and restart Docker.

> **Alternative: route only VPN registries through the tunnel.** Docker has no PAC support and `no-proxy` is only a
> denylist, so per-domain routing needs a small local proxy in between. [tinyproxy](https://tinyproxy.github.io/)
> (1.11+, available via apt) can run as an always-on service on `127.0.0.1:8888` with
> `Upstream socks5 127.0.0.1:1080 ".example.com"`, so only matching domains use the tunnel and everything else goes
> direct. Then point `daemon.json` at `http://127.0.0.1:8888` instead. Docker Hub keeps working off-VPN this way.
> tinyproxy only allows `CONNECT` to ports 443/563 by default, so add a `ConnectPort` line for any registry on
> another port.

### 7. Configure Git for VPN-Only Hosts

Git doesn't use the system (PAC) proxy, so configure it per host. Only the listed hosts go through the tunnel;
everything else (e.g. GitHub) stays direct.

#### SSH remotes (`git@git.example.com:...`)

Add a host entry to `~/.ssh/config`:

```
Host git.example.com
    ProxyCommand nc -X 5 -x 127.0.0.1:1080 %h %p
```

| Parameter | Description |
|-----------|-------------|
| `-X 5` | Use SOCKS v5 |
| `-x 127.0.0.1:1080` | SOCKS proxy address (the reverse tunnel) |
| `%h %p` | Target host and port, filled in by SSH. The hostname is resolved on the remote (VPN) side |

`-X`/`-x` require the OpenBSD netcat (`netcat-openbsd`, Ubuntu's default `nc`). Use one `Host` block per git server,
or list several hosts on the same line (`Host git.example.com gitlab.example.com`).

Verify:

```bash
ssh -T git@git.example.com
git ls-remote git@git.example.com:group/repo.git
```

#### HTTPS remotes (`https://git.example.com/...`)

Git supports a proxy per URL prefix:

```bash
git config --global http.https://git.example.com/.proxy socks5h://127.0.0.1:1080
```

Use `socks5h://` (not `socks5://`) so the hostname is resolved on the remote (VPN) side. Remove it with
`git config --global --unset http.https://git.example.com/.proxy`.

---

### Status Command

```bash
./start-proxy.sh status
```

Checks and reports on:
- **Reverse SSH Tunnel**: Is it running on 127.0.0.1:1080?
- **System Proxy**: Is GNOME configured to use the PAC file?
- **PAC File Server**: Is the HTTP server running and serving the file?
- **SOCKS Rebind**: Is the port exposed for Docker?
- **Port Forwards**: Are all target domains being forwarded?
- **Docker Daemon Proxy**: Is the daemon's HTTPS proxy pointing at the SOCKS tunnel? (read-only check, see
  [Configure Docker Daemon Proxy](#6-configure-docker-daemon-proxy))
- **VPN Connectivity**: Does the public IP seen through the SOCKS proxy match `VPN_IP_PREFIX`?

### Startup Sequence

#### Step 1: Verify Reverse Tunnel

The script won't start unless the reverse tunnel from the remote laptop is active.

#### Step 2: Kill Previous Instances

Cleans up any orphaned processes from previous runs.

#### Step 3: Start PAC File Server

Serves `proxy.pac` via HTTP. Browsers can't use `file://` URLs for PAC files, so we need an HTTP server.

**Why `--bind 0.0.0.0`?** Allows access from Docker containers if needed.

#### Step 4: Configure System Proxy

Configures GNOME to use the PAC file for automatic proxy configuration.

#### Step 5: Rebind SOCKS Port

**Problem**: The reverse tunnel binds to `127.0.0.1:1080`, which is not accessible from Docker containers.

**Solution**: Use socat to listen on all interfaces (`0.0.0.0:1081`) and forward to the tunnel.

| Parameter | Description |
|-----------|-------------|
| `TCP-LISTEN:1081` | Listen on port 1081 |
| `bind=0.0.0.0` | Accept connections from any interface |
| `fork` | Handle multiple concurrent connections |
| `reuseaddr` | Allow quick restart if port was recently used |
| `TCP:127.0.0.1:1080` | Forward to the reverse tunnel |

#### Step 6: Forward Target Domains

For each domain in `FORWARD_TARGETS`, creates a local listener that forwards through the SOCKS proxy.

**Example for exampleprotected.com:3031**:
1. Docker container connects to `exampleprotected.com:3031`
2. `extra_hosts` resolves this to the host machine
3. socat on port 3031 receives the connection
4. socat connects to the real server via SOCKS5 proxy
5. Traffic flows through reverse tunnel → VPN → target service

#### Step 7: Check Docker Daemon Proxy

Reports whether the Docker daemon is configured to use the SOCKS tunnel. Nothing is changed, because the daemon config
is a one-time setup.

### Cleanup on Exit

When you press Ctrl+C:
- All background processes (socat, python) are killed
- System proxy settings are reset to "none"

---

## Usage

### On Remote Laptop (VPN Machine)

```bash
# 1. Connect to VPN
# 2. Start reverse tunnel
./reverse_tunnel.sh
```

### On Host Laptop (Development Machine)

```bash
# Start all proxy services
./start-proxy.sh

# Check status
./start-proxy.sh status

# Stop (Ctrl+C in the terminal running start-proxy.sh)
```

---

## Troubleshooting

### Reverse tunnel not detected

```
Error: Reverse SSH tunnel not detected on 127.0.0.1:1080
```

**Solution**: Start the reverse tunnel on the remote laptop first.

### Connection refused from Docker

```
Failed to connect to host.docker.internal port 1080: Connection refused
```

**Possible causes**:
1. SOCKS rebind not running - check with `./start-proxy.sh status`
2. Wrong port - Docker should use the rebound port (1081) or use `extra_hosts` approach

### PAC file not working

**Check**:
1. PAC server running: `curl http://localhost:8800/proxy.pac`
2. System proxy configured: `gsettings get org.gnome.system.proxy mode` should return `'auto'`
3. Browser may need restart after proxy config change

### SSL certificate errors

When using socat to forward HTTPS traffic, the certificate is issued for the original domain. Ensure:
1. `extra_hosts` maps the exact domain name
2. Your app connects using the original domain name (not `host.docker.internal`)

### Docker login/pull fails with `proxyconnect`

```
proxyconnect tcp: dial tcp 127.0.0.1:1080: connect: connection refused
```

**Cause**: The daemon is configured to use the SOCKS proxy but the reverse tunnel is down.

**Solution**: Start the reverse tunnel, or temporarily remove the `proxies` block from `/etc/docker/daemon.json` and
`sudo systemctl restart docker`.

### Git over SSH hangs or fails with `Connection closed by UNKNOWN port 65535`

**Check**:
1. Tunnel is up: `./start-proxy.sh status`
2. `nc` is the OpenBSD variant: `nc -h 2>&1 | head -1`
3. Debug the connection: `ssh -vT git@git.example.com`

---

## Adding New Domains

### For Browser/System Apps

Edit `proxy.pac` and add the domain to the `dominated` array:

```javascript
var dominated = [
    "example.com",
    "new-domain.com"  // Add here
];
```

### For Docker Containers

1. Edit `start-proxy.sh` and add to `FORWARD_TARGETS`:

```bash
FORWARD_TARGETS=(
    "exampleprotected.com:3031"
    "new-domain.com:443"  # Add here
)
```

2. Edit `docker-compose.yml`:

```yaml
extra_hosts:
  - "exampleprotected.com:host-gateway"
  - "new-domain.com:host-gateway"  # Add here
```

3. Restart both the proxy script and Docker containers.

### For Docker Registries

Nothing to do: all registries already go through the tunnel. Add a registry to `no-proxy` in
`/etc/docker/daemon.json` only if it should be reached directly.

### For Git Hosts

Add the host to the `Host` line in `~/.ssh/config` (SSH remotes), or add another `http.<url>.proxy` entry (HTTPS
remotes). See [Configure Git for VPN-Only Hosts](#7-configure-git-for-vpn-only-hosts).
