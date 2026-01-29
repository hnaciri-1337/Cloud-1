#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}--- Cloud-1 Deployment Verification ---${NC}"

# 1. Check if all containers are running
echo -e "\n[1/5] Checking Containers..."
containers=("nginx" "wordpress" "mysql" "phpmyadmin")
for container in "${containers[@]}"; do
    if [ "$(docker inspect -f '{{.State.Running}}' $container 2>/dev/null)" == "true" ]; then
        echo -e "  - $container: ${GREEN}RUNNING${NC}"
    else
        echo -e "  - $container: ${RED}STOPPED/MISSING${NC}"
    fi
done

# 2. Verify Firewall (UFW) Status
echo -e "\n[2/5] Checking Firewall (Port 3306 must be blocked)..."
if sudo ufw status | grep -q "3306"; then
    echo -e "  - Port 3306: ${RED}OPEN (SECURITY RISK)${NC}"
else
    echo -e "  - Port 3306: ${GREEN}SECURE (BLOCKED)${NC}"
fi

# 3. Check Persistence Directories
echo -e "\n[3/5] Checking Data Persistence..."
if [ -d "$HOME/data/mysql" ] && [ -d "$HOME/data/wordpress" ]; then
    echo -e "  - Volumes: ${GREEN}EXIST${NC}"
else
    echo -e "  - Volumes: ${RED}MISSING${NC}"
fi

# 4. Verify HTTPS/TLS Access
echo -e "\n[4/5] Checking HTTPS Status..."
domain=$(grep "DOMAIN_NAME" $HOME/Inception/srcs/.env | cut -d'=' -f2)
if curl -sI "https://$domain" --insecure | grep -q "HTTP/1.1 200\|HTTP/2"; then
    echo -e "  - HTTPS Access: ${GREEN}SUCCESSFUL${NC}"
else
    echo -e "  - HTTPS Access: ${RED}FAILED${NC}"
fi

# 5. Check Internal Network Communication
echo -e "\n[5/5] Checking Container Inter-connectivity..."
if docker exec nginx ping -c 1 wordpress > /dev/null; then
    echo -e "  - Nginx to WordPress: ${GREEN}CONNECTED${NC}"
else
    echo -e "  - Nginx to WordPress: ${RED}DISCONNECTED${NC}"
fi

echo -e "\n${GREEN}Verification Complete!${NC}"