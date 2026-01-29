# Create user with a home directory and bash shell
adduser deployer

# Add to the sudo group so they can run administrative commands
usermod -aG sudo deployer

# Copy your SSH key to the new user so Ansible can connect
mkdir -p /home/deployer/.ssh
cp /root/.ssh/authorized_keys /home/deployer/.ssh/
chown -R deployer:deployer /home/deployer/.ssh