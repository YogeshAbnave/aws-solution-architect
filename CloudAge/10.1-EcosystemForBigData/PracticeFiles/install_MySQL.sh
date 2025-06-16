
 #!/bin/bash

# Update package index
sudo apt-get update

# Remove any old MySQL versions
sudo apt-get purge -y mysql-server mysql-client mysql-common
sudo apt-get autoremove -y
sudo apt-get autoclean
sudo rm -rf /etc/mysql /var/lib/mysql /var/log/mysql

# Install MySQL server
sudo apt-get install -y mysql-server

# Secure MySQL installation (non-interactive)
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'YourStrongPassword'; FLUSH PRIVILEGES;"

# Enable and start MySQL service
sudo systemctl enable mysql
sudo systemctl start mysql

# Confirm MySQL is running
sudo systemctl status mysql


