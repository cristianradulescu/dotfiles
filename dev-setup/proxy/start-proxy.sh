#!/bin/bash

#-- Configuration --
# Directory where proxy.pac is located
PAC_DIR="/home/$USER/<proxy_dir>"
# Port for PAC file HTTP server
PAC_PORT=8800
# Port for reverse SSH tunnel SOCKS proxy
SOCKS_PORT=1080
# Port to expose the SOCKS proxy for Docker containers
SOCKS_REBIND_PORT=1081

# Domains to forward through SOCKS proxy (domain:port) for Docker
FORWARD_TARGETS=(
    "exampleprotected.com:3031"
)

# IP prefix to check for VPN connectivity
VPN_IP_PREFIX="1.111"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

show_status() {
    echo -e "${YELLOW}=== Proxy Status ===${NC}\n"

    # Check reverse tunnel
    echo -e "${YELLOW}Reverse SSH Tunnel:${NC}"
    if ss -tlnp | grep -q "127.0.0.1:${SOCKS_PORT}"; then
        echo -e "  ${GREEN}✓ Running on 127.0.0.1:${SOCKS_PORT}${NC}"
    else
        echo -e "  ${RED}✗ Not detected on 127.0.0.1:${SOCKS_PORT}${NC}"
    fi

    # Check system proxy
    echo -e "\n${YELLOW}System Proxy:${NC}"
    PROXY_MODE=$(gsettings get org.gnome.system.proxy mode)
    PROXY_URL=$(gsettings get org.gnome.system.proxy autoconfig-url)
    echo -e "  Mode: ${PROXY_MODE}"
    echo -e "  URL:  ${PROXY_URL}"
    if [[ "$PROXY_MODE" == "'auto'" ]] && [[ "$PROXY_URL" == *"proxy.pac"* ]]; then
        echo -e "  ${GREEN}✓ Configured correctly${NC}"
    else
        echo -e "  ${RED}✗ Not configured for PAC file${NC}"
    fi

    # Check PAC file server
    echo -e "\n${YELLOW}PAC File Server (port ${PAC_PORT}):${NC}"
    if ss -tlnp | grep -q ":${PAC_PORT}"; then
        echo -e "  ${GREEN}✓ Running${NC}"
        if curl -s "http://localhost:${PAC_PORT}/proxy.pac" > /dev/null 2>&1; then
            echo -e "  ${GREEN}✓ PAC file accessible${NC}"
        else
            echo -e "  ${RED}✗ PAC file not accessible${NC}"
        fi
    else
        echo -e "  ${RED}✗ Not running${NC}"
    fi

    # Check SOCKS rebind
    echo -e "\n${YELLOW}SOCKS Rebind (port ${SOCKS_REBIND_PORT}):${NC}"
    if ss -tlnp | grep -q ":${SOCKS_REBIND_PORT}"; then
        echo -e "  ${GREEN}✓ Running on 0.0.0.0:${SOCKS_REBIND_PORT}${NC}"
    else
        echo -e "  ${RED}✗ Not running${NC}"
    fi

    # Check forwarded targets
    echo -e "\n${YELLOW}Port Forwards:${NC}"
    for target in "${FORWARD_TARGETS[@]}"; do
        DOMAIN="${target%:*}"
        PORT="${target#*:}"
        if ss -tlnp | grep -q ":${PORT}"; then
            echo -e "  ${GREEN}✓ ${DOMAIN}:${PORT} → SOCKS proxy${NC}"
        else
            echo -e "  ${RED}✗ ${DOMAIN}:${PORT} not forwarded${NC}"
        fi
    done

    # Check VPN connectivity (test through SOCKS proxy)
    echo -e "\n${YELLOW}VPN Connectivity:${NC}"
    # Get public IP and compare with VPN IP prefix
    curl -s --proxy socks5://localhost:${SOCKS_PORT} --connect-timeout 5 https://api.ipify.org | grep -q "^${VPN_IP_PREFIX}"
    if [ $? -eq 0 ]; then
        echo -e "  ${GREEN}✓ VPN IP detected${NC}"
    else
        echo -e "  ${RED}✗ VPN IP not detected. VPN might be down${NC}"
    fi

    echo ""
    exit 0
}

cleanup() {
    echo -e "\n${YELLOW}Shutting down...${NC}"

    # Kill all background processes
    jobs -p | xargs -r kill 2>/dev/null

    # Reset proxy settings
    gsettings set org.gnome.system.proxy mode 'none'
    echo -e "${GREEN}Proxy settings reset${NC}"

    exit 0
}

trap cleanup SIGINT SIGTERM

# Handle command line arguments
case "${1:-}" in
    status)
        show_status
        ;;
    "")
        # No argument, continue with start
        ;;
    *)
        echo "Usage: $0 [status]"
        echo ""
        echo "Commands:"
        echo "  (none)    Start all proxy services"
        echo "  status    Show status of all services"
        exit 1
        ;;
esac

echo -e "${YELLOW}=== Proxy Setup Script ===${NC}\n"

# Check if reverse tunnel is running
if ! ss -tlnp | grep -q "127.0.0.1:${SOCKS_PORT}"; then
    echo -e "${RED}Error: Reverse SSH tunnel not detected on 127.0.0.1:${SOCKS_PORT}${NC}"
    echo "Start your reverse tunnel first, then run this script."
    exit 1
fi
echo -e "${GREEN}✓ Reverse SSH tunnel detected on port ${SOCKS_PORT}${NC}"

# Kill any existing socat/python processes from previous runs
pkill -f "socat.*TCP-LISTEN:${SOCKS_REBIND_PORT}" 2>/dev/null
pkill -f "socat.*TCP-LISTEN:3031" 2>/dev/null
pkill -f "python3 -m http.server ${PAC_PORT}" 2>/dev/null

# Start PAC file server
echo -e "\n${YELLOW}Starting PAC file server on port ${PAC_PORT}...${NC}"
cd "$PAC_DIR"
python3 -m http.server "$PAC_PORT" --bind 0.0.0.0 > /dev/null 2>&1 &
PAC_PID=$!
sleep 1

if ps -p $PAC_PID > /dev/null; then
    echo -e "${GREEN}✓ PAC server running at http://localhost:${PAC_PORT}/proxy.pac${NC}"
else
    echo -e "${RED}✗ Failed to start PAC server${NC}"
    exit 1
fi

# Configure system proxy
echo -e "\n${YELLOW}Configuring system proxy...${NC}"
gsettings set org.gnome.system.proxy mode 'auto'
gsettings set org.gnome.system.proxy autoconfig-url "http://localhost:${PAC_PORT}/proxy.pac"
echo -e "${GREEN}✓ System proxy configured${NC}"

# Rebind SOCKS port to all interfaces
echo -e "\n${YELLOW}Rebinding SOCKS port to all interfaces...${NC}"
socat TCP-LISTEN:${SOCKS_REBIND_PORT},bind=0.0.0.0,fork,reuseaddr TCP:127.0.0.1:${SOCKS_PORT} &
REBIND_PID=$!
sleep 1

if ps -p $REBIND_PID > /dev/null; then
    echo -e "${GREEN}✓ SOCKS proxy available on 0.0.0.0:${SOCKS_REBIND_PORT}${NC}"
else
    echo -e "${RED}✗ Failed to rebind SOCKS port${NC}"
    exit 1
fi

# Forward configured targets through SOCKS
echo -e "\n${YELLOW}Setting up port forwarding for Docker...${NC}"
for target in "${FORWARD_TARGETS[@]}"; do
    DOMAIN="${target%:*}"
    PORT="${target#*:}"

    socat TCP-LISTEN:${PORT},bind=0.0.0.0,fork,reuseaddr SOCKS5:localhost:${DOMAIN}:${PORT},socksport=${SOCKS_PORT} &
    FORWARD_PID=$!
    sleep 1

    if ps -p $FORWARD_PID > /dev/null; then
        echo -e "${GREEN}✓ ${DOMAIN}:${PORT} → SOCKS proxy${NC}"
    else
        echo -e "${RED}✗ Failed to forward ${DOMAIN}:${PORT}${NC}"
    fi
done

echo -e "\n${GREEN}=== Setup Complete ===${NC}"
echo -e "\nServices running:"
echo -e "  • PAC server:    http://localhost:${PAC_PORT}/proxy.pac"
echo -e "  • SOCKS rebind:  0.0.0.0:${SOCKS_REBIND_PORT} → 127.0.0.1:${SOCKS_PORT}"
for target in "${FORWARD_TARGETS[@]}"; do
    DOMAIN="${target%:*}"
    PORT="${target#*:}"
    echo -e "  • Forward:       ${DOMAIN}:${PORT}"
done

echo -e "\n${YELLOW}Press Ctrl+C to stop all services and reset proxy settings${NC}\n"

# Wait for all background processes
wait
