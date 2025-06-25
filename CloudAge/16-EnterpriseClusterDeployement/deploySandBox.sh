#!/bin/bash
# =====================================================================
# Automated Cloudera Manager Setup Script for RHEL 8.9
# =====================================================================

# Variables
LOG_FILE="/var/log/cloudera_setup.log"

MYSQL_PASSWORD="P@ssw0rd"
IP_ADDRESS=$(hostname -I | awk '{print $1}')

# Logging function
log() {
  local ts
  ts=$(date "+%Y-%m-%d %H:%M:%S")
  echo "[$ts] $1" | tee -a "$LOG_FILE"
}

# Check exit status of the last command
check_status() {
  local msg="$1"
  if [ $? -eq 0 ]; then
    log "SUCCESS: $msg"
  else
    log "ERROR: $msg failed"
    exit 1
  fi
}

# Package/file checks
is_package_installed() {
  rpm -q "$1" &>/dev/null
}
file_exists() {
  [ -f "$1" ]
}

# Prepare log file
sudo touch "$LOG_FILE"
sudo chmod 644 "$LOG_FILE"

log "Starting Cloudera Manager installation on RHEL 8.9"
log "==============================================================="

# 1) System update
log "Updating system packages..."
sudo yum update -y
check_status "System update"

# 2) Install prerequisites (e.g., wget)
for pkg in wget; do
  if ! is_package_installed "$pkg"; then
    log "Installing $pkg..."
    sudo yum install -y "$pkg"
    check_status "$pkg installation"
  else
    log "$pkg is already installed"
  fi
done

# 3) Java
if ! is_package_installed java-headless; then
  log "Installing Java..."
  sudo dnf install -y java-headless
  check_status "Java installation"
else
  log "Java is already installed"
fi

# 4) MySQL Connector
MYSQL_CONN="mysql-connector-j-9.3.0-1.el8.noarch"
if ! is_package_installed "$MYSQL_CONN"; then
  if ! file_exists "${MYSQL_CONN}.rpm"; then
    log "Downloading MySQL connector..."
    wget "https://dev.mysql.com/get/Downloads/Connector-J/${MYSQL_CONN}.rpm"
    check_status "MySQL connector download"
  else
    log "MySQL connector RPM exists"
  fi
  log "Installing MySQL connector..."
  sudo rpm -ivh "${MYSQL_CONN}.rpm"
  check_status "MySQL connector installation"
else
  log "MySQL connector already installed"
fi

# 5) MySQL repo
MYSQL_REPO="mysql80-community-release-el8-8.noarch"
if ! is_package_installed "$MYSQL_REPO"; then
  if ! file_exists "${MYSQL_REPO}.rpm"; then
    log "Downloading MySQL repository..."
    wget "https://dev.mysql.com/get/${MYSQL_REPO}.rpm"
    check_status "MySQL repository download"
  else
    log "MySQL repository RPM exists"
  fi
  log "Installing MySQL repository..."
  sudo rpm -ivh "${MYSQL_REPO}.rpm"
  check_status "MySQL repository installation"
else
  log "MySQL repository already installed"
fi

# 6) MySQL & dev packages
for pkg in mysql-devel python3-devel mysql-server; do
  if ! is_package_installed "$pkg"; then
    log "Installing $pkg..."
    sudo yum install -y --nogpgcheck "$pkg"
    check_status "$pkg installation"
  else
    log "$pkg is already installed"
  fi
done

# 7) Start MySQL
if ! systemctl is-active --quiet mysqld; then
  log "Starting MySQL service..."
  sudo systemctl start mysqld
  check_status "MySQL service start"
else
  log "MySQL is already running"
fi
log "Verifying MySQL status..."
sudo systemctl status mysqld
check_status "MySQL status check"

# 8) Cloudera Manager repo
if [ ! -f /etc/yum.repos.d/cloudera-manager.repo ]; then
  log "Creating Cloudera Manager repo file..."
  sudo tee /etc/yum.repos.d/cloudera-manager.repo > /dev/null <<EOF
[cloudera-manager]
name=Cloudera Manager
baseurl=https://archive.cloudera.com/cm7/7.4.4/redhat8/yum/
gpgkey=https://archive.cloudera.com/cm7/7.4.4/redhat8/yum/RPM-GPG-KEY-cloudera
gpgcheck=1
enabled=1
EOF
  check_status "Cloudera Manager repo creation"
else
  log "Cloudera Manager repo already exists"
fi

# 9) Yum cache
log "Refreshing yum cache..."
sudo yum clean all
sudo yum makecache
check_status "Yum cache rebuild"

# 10) Disable MySQL SSL
if ! grep -q '^ssl = 0' /etc/my.cnf.d/mysql-server.cnf; then
  log "Disabling MySQL SSL..."
  echo "ssl = 0" | sudo tee -a /etc/my.cnf.d/mysql-server.cnf
  check_status "Disabling MySQL SSL"
else
  log "MySQL SSL already disabled"
fi

# 11) Cloudera Agent & OpenJDK RPMs
CM_AGENT="cloudera-manager-agent-7.4.4-15850731.el8.x86_64"
OPENJDK_RPM="openjdk8-8.0+232_9-cloudera.x86_64"
for rpm_pkg in "$CM_AGENT" "$OPENJDK_RPM"; do
  pkg_name=$(basename "$rpm_pkg" .rpm)
  if ! is_package_installed "$pkg_name"; then
    if ! file_exists "${rpm_pkg}.rpm"; then
      log "Downloading $rpm_pkg..."
      wget "https://archive.cloudera.com/cm7/7.4.4/redhat8/yum/RPMS/x86_64/${rpm_pkg}.rpm"
      check_status "$rpm_pkg download"
    else
      log "$rpm_pkg RPM exists"
    fi
    log "Installing $rpm_pkg..."
    sudo yum install -y "./${rpm_pkg}.rpm"
    check_status "$rpm_pkg install"
  else
    log "$pkg_name already installed"
  fi
done

# 12) Server & daemons
if ! is_package_installed cloudera-manager-server || ! is_package_installed cloudera-manager-daemons; then
  log "Installing Cloudera Manager server & daemons..."
  sudo yum install -y cloudera-manager-server cloudera-manager-daemons
  check_status "CM server/daemons installation"
else
  log "CM server & daemons already installed"
fi

# 13) Start CM services
for svc in cloudera-scm-agent cloudera-scm-server; do
  if ! systemctl is-active --quiet "$svc"; then
    log "Starting $svc..."
    sudo systemctl start "$svc"
    check_status "$svc start"
  else
    log "$svc is already running"
  fi
done

# 14) MySQL DB setup
log "Configuring MySQL root user authentication..."
sudo mysql -u root -p <<EOF
ALTER USER 'root'@'localhost'
  IDENTIFIED WITH mysql_native_password
  BY 'P@ssw0rd';
FLUSH PRIVILEGES;
EOF
check_status "Reset root password"

log "Creating Cloudera Manager schemas & users..."

sudo mysql -u root -pP@ssw0rd <<EOF
-- Create databases and users with mysql_native_password plugin for MySQL 8.0+

CREATE DATABASE scm DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
CREATE USER 'scm'@'%' IDENTIFIED WITH mysql_native_password BY 'P@ssw0rd';
GRANT ALL ON scm.* TO 'scm'@'%';

CREATE DATABASE hive DEFAULT CHARACTER SET utf8;
CREATE USER 'hive'@'%' IDENTIFIED WITH mysql_native_password BY 'P@ssw0rd';
GRANT ALL ON hive.* TO 'hive'@'%';

CREATE DATABASE hue DEFAULT CHARACTER SET utf8;
CREATE USER 'hue'@'%' IDENTIFIED WITH mysql_native_password BY 'P@ssw0rd';
GRANT ALL ON hue.* TO 'hue'@'%';

CREATE DATABASE rman DEFAULT CHARACTER SET utf8;
CREATE USER 'rman'@'%' IDENTIFIED WITH mysql_native_password BY 'P@ssw0rd';
GRANT ALL ON rman.* TO 'rman'@'%';

CREATE DATABASE oozie DEFAULT CHARACTER SET utf8;
CREATE USER 'oozie'@'%' IDENTIFIED WITH mysql_native_password BY 'P@ssw0rd';
GRANT ALL ON oozie.* TO 'oozie'@'%';

CREATE DATABASE navs DEFAULT CHARACTER SET utf8;
CREATE USER 'navs'@'%' IDENTIFIED WITH mysql_native_password BY 'P@ssw0rd';
GRANT ALL ON navs.* TO 'navs'@'%';

CREATE DATABASE navms DEFAULT CHARACTER SET utf8;
CREATE USER 'navms'@'%' IDENTIFIED WITH mysql_native_password BY 'P@ssw0rd';
GRANT ALL ON navms.* TO 'navms'@'%';

CREATE DATABASE actmo DEFAULT CHARACTER SET utf8;
CREATE USER 'actmo'@'%' IDENTIFIED WITH mysql_native_password BY 'P@ssw0rd';
GRANT ALL ON actmo.* TO 'actmo'@'%';

CREATE DATABASE ranger DEFAULT CHARACTER SET utf8;
CREATE USER 'ranger'@'%' IDENTIFIED WITH mysql_native_password BY 'P@ssw0rd';
GRANT ALL ON ranger.* TO 'ranger'@'%';

-- Create admin user with full privileges
CREATE USER 'temp'@'%' IDENTIFIED WITH mysql_native_password BY 'P@ssw0rd';

GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, RELOAD, PROCESS, REFERENCES,
INDEX, ALTER, SHOW DATABASES, CREATE TEMPORARY TABLES, LOCK TABLES, EXECUTE,
REPLICATION SLAVE, REPLICATION CLIENT, CREATE VIEW, SHOW VIEW, CREATE ROUTINE,
ALTER ROUTINE, CREATE USER, EVENT, TRIGGER
ON *.* TO 'temp'@'%'
WITH GRANT OPTION;

FLUSH PRIVILEGES;

EOF
check_status "CM database setup"
#mysql -u root -pP@ssw0rd < sql_setup.sql
# 15) Prepare CM schema
log "Preparing Cloudera Manager database schema..."
sudo sh /opt/cloudera/cm/schema/scm_prepare_database.sh mysql -h localhost scm scm P@ssw0rd

# 16) Final service restarts
sudo systemctl restart cloudera-scm-server
sudo systemctl restart cloudera-scm-agent
check_status "Final service restarts"

log "==============================================================="
log "Installation completed successfully!"
log "Access Cloudera Manager at http://${IP_ADDRESS}:7180"
log "Username: admin"
log "Password: admin"
log "==============================================================="
exit 0

