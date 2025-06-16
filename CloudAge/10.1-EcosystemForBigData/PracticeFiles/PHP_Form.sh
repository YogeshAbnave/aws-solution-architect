
#!/bin/bash

# Update and install necessary packages
sudo apt update -y
sudo apt install -y apache2 php libapache2-mod-php mysql-server php-mysql

# Create a database and user for the web application
sudo mysql -u root -pYourStrongPassword <<MYSQL_SCRIPT
CREATE DATABASE webdata1;
CREATE USER 'webuser1'@'localhost' IDENTIFIED BY 'webpassword';
GRANT ALL PRIVILEGES ON webdata1.* TO 'webuser1'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

# Create a table in the database
sudo mysql -u root -pYourStrongPassword webdata1 <<MYSQL_TABLE
CREATE TABLE IF NOT EXISTS userdataa (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    address VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL
);
MYSQL_TABLE

# Create a PHP form to insert data into MySQL
sudo bash -c 'cat > /var/www/html/index.php' <<PHP_FORM
<!DOCTYPE html>
<html>
<head>
    <title>Data Ingestion Form</title>
</head>
<body>
    <h2>Submit Your Data</h2>
    <form action="submit.php" method="post">
        Name: <input type="text" name="name" required><br><br>
        Email: <input type="email" name="email" required><br><br>
        Address: <input type="text" name="address" required><br><br>
        City: <input type="text" name="city" required><br><br>
        <input type="submit" value="Submit">
    </form>
</body>
</html>
PHP_FORM

# Create a PHP script to handle form submission
sudo bash -c 'cat > /var/www/html/submit.php' <<PHP_SUBMIT
<?php
\$servername = "localhost";
\$username = "webuser1";
\$password = "webpassword";
\$dbname = "webdata1";

// Create connection
\$conn = new mysqli(\$servername, \$username, \$password, \$dbname);

// Check connection
if (\$conn->connect_error) {
    die("Connection failed: " . \$conn->connect_error);
}

// Get form data
\$name = \$_POST['name'];
\$email = \$_POST['email'];
\$address = \$_POST['address'];
\$city = \$_POST['city'];

// Insert data into database
\$sql = "INSERT INTO userdataa (name, email, address, city) VALUES ('\$name', '\$email', '\$address', '\$city')";

if (\$conn->query(\$sql) === TRUE) {
    echo "Record created successfully";
} else {
    echo "Error: " . \$sql . "<br>" . \$conn->error;
}

\$conn->close();
?>
PHP_SUBMIT

# Restart Apache to apply changes
sudo systemctl restart apache2

# Print completion message
echo "Setup complete!"
echo "Access the form at http://<your-server-ip>/index.php"
