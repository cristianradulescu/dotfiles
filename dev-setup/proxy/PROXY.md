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
6. **Reverse SSH Tunnel**: Connects host laptop to remote laptop's SOCKS proxy
7. **Remote Laptop**: Routes traffic through VPN to protected services

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
    "exampleprotected:3031"
    "new-domain-protected.com:443"  # Add here
)
```

2. Edit `docker-compose.yml`:

```yaml
extra_hosts:
  - "exampleprotected.com:host-gateway"
  - "new-domain.com:host-gateway"  # Add here
```

3. Restart both the proxy script and Docker containers.
