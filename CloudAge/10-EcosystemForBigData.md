# Hadoop Setup Commands

## 1. Java Installation and Configuration

```bash
sudo apt update
sudo apt install openjdk-8-jdk -y
java -version
javac
```

## 2. User Setup for Hadoop

```bash
sudo adduser hadoop
sudo usermod -aG sudo hadoop
su - hadoop
```

## 3. Set Java and Hadoop Environment Variables

Edit `.bashrc`:

```bash
nano ~/.bashrc
```

Add the following lines:

```bash
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export HADOOP_HOME=/usr/local/hadoop
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
```

Apply changes:

```bash
source ~/.bashrc
```

## 4. Hadoop Version Check

```bash
hadoop version
/usr/local/hadoop/bin/hadoop version
```

## 5. SSH Key Generation for Hadoop Cluster

```bash
ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -N ""
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
chmod 700 ~/.ssh
```

## 6. Using `dsh` for Parallel Commands

```bash
sudo apt install dsh
sudo apt install openjdk-8-jdk-headless
apt list --upgradable
dsh -a sudo apt install openjdk-8-jdk-headless -y
```

## 7. Compile and Package WordCount MapReduce Program

```bash
file WordCount.java
mkdir wordcount_classes
javac -d wordcount_classes/ WordCount.java
jar -cvf wordcount.jar -C wordcount_classes/.
```

## 8. Upload to HDFS and Execute

```bash
hadoop fs -put wordcount_classes /user/ubuntu/
hadoop jar /usr/local/hadoop-examples-1.2.1.jar WordCount input output
```

## 9. Java and CLASSPATH

```bash
echo $CLASSPATH
export CLASSPATH=/usr/local/hadoop/hadoop-core-1.2.1.jar
```

## 10. Apache Hive Installation

```bash
wget https://archive.apache.org/dist/hive/hive-1.2.2/apache-hive-1.2.2-bin.tar.gz
tar -zxf apache-hive-1.2.2-bin.tar.gz
sudo mv apache-hive-1.2.2-bin /usr/local/hive

nano ~/.bashrc
# Add:
export HIVE_HOME=/usr/local/hive
export PATH=$PATH:$HIVE_HOME/bin

exec bash

cd $HIVE_HOME/conf
cp hive-env.sh.template hive-env.sh
nano $HIVE_HOME/conf/hive-env.sh
# Add:
export HADOOP_HOME=/usr/local/hadoop

hadoop fs -chmod -R 777 /tmp
hive
```

## 11. Load Server Log Data into Hive

```bash
# Assume log file generated via `generate_logs.py`
hadoop fs -rmr /user/ubuntu/*
hadoop fs -copyFromLocal /home/ubuntu/eventlog.log /user/ubuntu/serverlog.log
hadoop fs -ls /user/ubuntu/

hive
CREATE DATABASE server;
SHOW DATABASES;
USE server;

CREATE TABLE serverlogs (
  time STRING,
  ip STRING,
  country STRING,
  status STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
LOCATION '/user/ubuntu/';

SELECT * FROM serverlogs LIMIT 10;
SELECT * FROM serverlogs WHERE country = 'IN' LIMIT 5;
SELECT * FROM serverlogs WHERE country = 'IN' AND status = 'ERROR';
SELECT * FROM serverlogs WHERE country = 'FR' AND status = 'SUCCESS';
SELECT ip, time FROM serverlogs;
SELECT DISTINCT ip FROM serverlogs;

CREATE TABLE doc (text STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\n'
STORED AS TEXTFILE;

LOAD DATA INPATH '/user/ubuntu/*' OVERWRITE INTO TABLE doc;

SELECT word, COUNT(*)
FROM doc
LATERAL VIEW explode(split(text, ' ')) lTable AS word
GROUP BY word;
```

## 12. Useful Commands Recap

```bash
jps
history
readlink -f $(which java)
```

---

---

## Hadoop MapReduce: Word Count Example

### 1. Prepare Your Hadoop Node

- Ensure your single-node Hadoop cluster is running. Use `jps` to verify that NameNode, DataNode, JobTracker, and TaskTracker are active.

### 2. Create and Compile the WordCount Program

```bash
cat > WordCount.java
```
Paste the following code, then press `CTRL+D` to save:

```java
import java.io.IOException;
import java.util.*;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.conf.*;
import org.apache.hadoop.io.*;
import org.apache.hadoop.mapred.*;

public class WordCount {
    public static class Map extends MapReduceBase implements Mapper {
        private final static IntWritable one = new IntWritable(1);
        private Text word = new Text();
        public void map(LongWritable key, Text value, OutputCollector output, Reporter reporter) throws IOException {
            String line = value.toString();
            StringTokenizer tokenizer = new StringTokenizer(line);
            while (tokenizer.hasMoreTokens()) {
                word.set(tokenizer.nextToken());
                output.collect(word, one);
            }
        }
    }
    public static class Reduce extends MapReduceBase implements Reducer {
        public void reduce(Text key, Iterator values, OutputCollector output, Reporter reporter) throws IOException {
            int sum = 0;
            while (values.hasNext()) {
                sum += values.next().get();
            }
            output.collect(key, new IntWritable(sum));
        }
    }
    public static void main(String[] args) throws Exception {
        JobConf conf = new JobConf(WordCount.class);
        conf.setJobName("wordcount");
        conf.setOutputKeyClass(Text.class);
        conf.setOutputValueClass(IntWritable.class);
        conf.setMapperClass(Map.class);
        conf.setReducerClass(Reduce.class);
        conf.setInputFormat(TextInputFormat.class);
        conf.setOutputFormat(TextOutputFormat.class);
        FileInputFormat.setInputPaths(conf, new Path(args[0]));
        FileOutputFormat.setOutputPath(conf, new Path(args[1]));
        JobClient.runJob(conf);
    }
}
```

Set Hadoop classpath and compile:

```bash
export CLASSPATH=/usr/local/hadoop/hadoop-core-1.2.1.jar
mkdir wordcount_classes
javac -d wordcount_classes/ WordCount.java
jar -cvf wordcount.jar -C wordcount_classes/ .
```

### 3. Upload Input Data and Run the Job

- Upload your text file (e.g., `en.7nov.txt`) to the Hadoop node if needed.
- Put the file into HDFS:

```bash
hadoop fs -put en.7nov.txt .
hadoop fs -du en.7nov.txt
```

- Run the MapReduce job:

```bash
hadoop jar wordcount.jar WordCount en.7nov.txt result
```

### 4. View Results

```bash
hadoop fs -ls /user/ubuntu/result
hadoop fs -get /user/ubuntu/result/part-00000 results
cat results
sort -n -k2 results > result
cat result
```

---

## Apache Hive: Installation & Usage

### 1. Install Hive

```bash
wget http://www-us.apache.org/dist/hive/hive-1.2.2/apache-hive-1.2.2-bin.tar.gz
tar -zxf apache-hive-1.2.2-bin.tar.gz
sudo mv apache-hive-1.2.2-bin /usr/local/hive
```

Add to `.bashrc`:

```bash
export HIVE_HOME=/usr/local/hive
export PATH=$PATH:$HIVE_HOME/bin
```

Reload shell:

```bash
exec bash
```

### 2. Configure Hive

```bash
cd $HIVE_HOME/conf
cp hive-env.sh.template hive-env.sh
nano hive-env.sh
# Add:
export HADOOP_HOME=/usr/local/hadoop
```

Set Hadoop permissions:

```bash
hadoop fs -chmod -R 777 /tmp
```

### 3. Using Hive

Start Hive:

```bash
hive
```

**Load Data:**

```bash
wget https://s3.amazonaws.com/cloud-age/eventlog.log
hadoop fs -copyFromLocal eventlog.log /user/ubuntu/serverlog.log
```

**Create Database and Table:**

```sql
CREATE DATABASE server;
USE server;
CREATE TABLE serverdata (time STRING, ip STRING, country STRING, status STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '|' LOCATION '/user/ubuntu/';
```

**Sample Queries:**

```sql
SELECT * FROM serverdata LIMIT 10;
SELECT * FROM serverdata WHERE country = "IN" LIMIT 5;
SELECT * FROM serverdata WHERE country = "GB";
SELECT * FROM serverdata WHERE country = "IN" AND status = "ERROR";
SELECT * FROM serverdata WHERE country = "FR" AND status = "SUCCESS";
SELECT ip, time FROM serverdata;
SELECT DISTINCT ip, time FROM serverdata;
```

**Word Count in Hive:**

```sql
CREATE TABLE doc(text STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\n' STORED AS TEXTFILE;
LOAD DATA INPATH '/user/ubuntu/serverlog.log' OVERWRITE INTO TABLE doc;
SELECT word, COUNT(*) FROM doc LATERAL VIEW explode(split(text, ' ')) lTable AS word GROUP BY word;
```

---

## Apache Pig: Installation & Usage

### 1. Install Pig

```bash
wget https://archive.apache.org/dist/pig/pig-0.16.0/pig-0.16.0.tar.gz
tar -zxvf pig-0.16.0.tar.gz
sudo mv pig-0.16.0 /usr/local/pig
```

Add to `.bashrc`:

```bash
export PIG_HOME=/usr/local/pig
export PATH=$PATH:$PIG_HOME/bin
```

Reload shell:

```bash
exec bash
```

### 2. Using Pig

Start Pig:

```bash
pig
```

**Word Count Example:**

```pig
lines = LOAD '/user/hive/warehouse/server.db/doc/serverlog.log' AS (line:chararray);
words = FOREACH lines GENERATE FLATTEN(TOKENIZE(line)) AS word;
grouped = GROUP words BY word;
wordcount = FOREACH grouped GENERATE group, COUNT(words);
DUMP wordcount;
```

---

## Apache Flume: Log Data Ingestion

### 1. Install and Configure Flume

```bash
sudo apt-get update && sudo apt-get upgrade -y
wget http://archive.apache.org/dist/flume/1.4.0/apache-flume-1.4.0-bin.tar.gz
tar -zxvf apache-flume-1.4.0-bin.tar.gz
```

Edit Flume environment:

```bash
cd apache-flume-1.4.0-bin/conf/
cp flume-env.sh.template flume-env.sh
nano flume-env.sh
# Add:
export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64
export FLUME_CLASSPATH="/home/ubuntu/apache-flume-1.4.0-bin/lib/*.jar"
```

Create `flume.conf` with:

```
cloudage.sources = eventlog
cloudage.channels = file_channel
cloudage.sinks = sink_to_hdfs

cloudage.sources.eventlog.type = exec
cloudage.sources.eventlog.command = tail -F /var/log/flume/eventlog.log
cloudage.sources.eventlog.restart = true
cloudage.sources.eventlog.batchSize = 1000

cloudage.sinks.sink_to_hdfs.type = hdfs
cloudage.sinks.sink_to_hdfs.hdfs.fileType = DataStream
cloudage.sinks.sink_to_hdfs.hdfs.path = hdfs://localhost:9000/user/ubuntu/flume/events
cloudage.sinks.sink_to_hdfs.hdfs.filePrefix = eventlog
cloudage.sinks.sink_to_hdfs.hdfs.fileSuffix = .log
cloudage.sinks.sink_to_hdfs.hdfs.batchSize = 1000

cloudage.channels.file_channel.type = file
cloudage.channels.file_channel.checkpointDir = /var/log/flume/checkpoint
cloudage.channels.file_channel.dataDirs = /var/log/flume/data

cloudage.sources.eventlog.channels = file_channel
cloudage.sinks.sink_to_hdfs.channel = file_channel
```

### 2. Prepare Directories

```bash
sudo mkdir -p /var/log/flume/checkpoint /var/log/flume/data
sudo chmod 777 -R /var/log/flume
hadoop fs -mkdir -p /user/ubuntu/flume/events
```

### 3. Generate and Ingest Logs

```bash
wget https://s3.amazonaws.com/cloud-age/generate_logs.py
# Edit and run the script as needed.
```

---

## Final Notes

- Always verify file paths and permissions.
- Use secure methods for remote operations.
- For production, set appropriate permissions (avoid `chmod 777`).
- Use Beeline for secure Hive access in production environments.

---


Certainly! Here is a structured table for each question, including **all options**, the **correct option**, and a **brief description** for each answer:

---

### 1. According to Cloudera, which file format provides better query performance and compression in Hive?
- **Options:**  
  - Avro  
  - ORC  
  - Parquet  
  - TextFile  
- **Correct Option:** ORC  
- **Description:** ORC (Optimized Row Columnar) is a columnar storage format that provides high compression and fast query performance, especially in Hive.

---

### 2. Apache Flume is written in:
- **Options:**  
  - JavaScript  
  - Java  
  - Python  
  - None of the above  
- **Correct Option:** Java  
- **Description:** Flume is developed in Java, making it compatible with the Hadoop ecosystem.

---

### 3. Can you connect Tableau or Power BI to Hive?
- **Options:**  
  - It cannot be connected as it is only a data warehousing tool  
  - Yes, it can be connected  
  - No, it cannot be connected  
  - Tableau is a standalone application; it does not connect at all  
- **Correct Option:** Yes, it can be connected  
- **Description:** Both Tableau and Power BI can connect to Hive using ODBC/JDBC drivers for analytics and visualization.

---

### 4. Data Ingestion is:
- **Options:**  
  - The development and design of databases  
  - Storing data within a system in its original format  
  - The process of collecting data from data sources/databases and moving it to target systems.  
  - A database used for reporting and analytics  
- **Correct Option:** The process of collecting data from data sources/databases and moving it to target systems.  
- **Description:** Data ingestion is about moving data from various sources into a storage or processing system.

---

### 5. Hive is a SQL-based data warehouse system for Hadoop that analyzes large datasets stored in Hadoop-compatible file systems.
- **Options:**  
  - Yes  
  - No  
- **Correct Option:** Yes  
- **Description:** Hive allows SQL-like querying on large datasets stored in Hadoop.

---

### 6. How do you create a nested partitioned table in Hive?
- **Options:**  
  - PARTITIONED BY (column1, column2)  
  - PARTITIONED TABLE (column1, column2).  
  - PARTITIONED (column1, column2).  
  - NESTED PARTITIONED BY (column1, column2).  
- **Correct Option:** PARTITIONED BY (column1, column2)  
- **Description:** This syntax creates a Hive table partitioned by multiple columns.

---

### 7. How do you create a partition dynamically while loading data into a Hive table?
- **Options:**  
  - INSERT INTO TABLE ... PARTITION  
  - LOAD DATA ... INTO TABLE ... PARTITION  
  - LOAD DATA ... PARTITION ... INTO TABLE  
  - INSERT INTO PARTITION ... SELECT FROM  
- **Correct Option:** INSERT INTO TABLE ... PARTITION  
- **Description:** This command enables dynamic partition creation during data insertion.

---

### 8. How do you create a table in Hive with a specific column delimiter?
- **Options:**  
  - ROW FORMAT DELIMITED BY  
  - ROWS DELIMITED BY  
  - FIELDS DELIMITED BY  
  - COLUMNS DELIMITED BY  
- **Correct Option:** FIELDS DELIMITED BY  
- **Description:** This clause specifies the delimiter for columns in Hive tables.

---

### 9. How do you enable dynamic partitioning in Hive?
- **Options:**  
  - SET hive.exec.dynamic.partition=true;  
  - SET hive.partitioning.dynamic=true;  
  - SET hive.dynamic.partitioning=true;  
  - SET hive.exec.partition.dynamic=true;  
- **Correct Option:** SET hive.exec.dynamic.partition=true;  
- **Description:** This property must be set to allow dynamic partitioning in Hive.

---

### 10. How do you grant all privileges on a database to a user in MySQL?
- **Options:**  
  - GRANT ALL PRIVILEGES  
  - GRANT DATABASE PRIVILEGES  
  - GRANT DATABASE ACCESS  
  - GRANT ALL ON DATABASE  
- **Correct Option:** GRANT ALL PRIVILEGES  
- **Description:** This command grants all available privileges to a user in MySQL.

---

### 11. How do you list files in a directory in Hadoop?
- **Options:**  
  - hadoop fs -ls  
  - hadoop ls  
  - hadoop dir  
  - hadoop files  
- **Correct Option:** hadoop fs -ls  
- **Description:** Lists the contents of a directory in HDFS.

---

### 12. How do you load data from a CSV file into a Hive partitioned table?
- **Options:**  
  - LOAD DATA INFILE  
  - LOAD DATA INTO  
  - LOAD DATA LOCAL INPATH  
  - LOAD DATA PARTITION  
- **Correct Option:** LOAD DATA LOCAL INPATH  
- **Description:** Loads data from the local filesystem into a Hive table.

---

### 13. How do you load data from a staging table into a target table in Hive?
- **Options:**  
  - INSERT INTO TABLE ... SELECT FROM ...  
  - LOAD DATA INFILE ... INTO TABLE ...  
  - LOAD DATA FROM ... INTO TABLE ...  
  - INSERT OVERWRITE TABLE ... SELECT FROM ...  
- **Correct Option:** INSERT INTO TABLE ... SELECT FROM ...  
- **Description:** Copies data from one Hive table to another.

---

### 14. How do you specify a specific partition while deleting data from a Hive table?
- **Options:**  
  - DELETE FROM ... WHERE PARTITION  
  - DELETE PARTITION  
  - TRUNCATE PARTITION  
  - ALTER TABLE .. DROP PARTITION ..  
- **Correct Option:** ALTER TABLE .. DROP PARTITION ..  
- **Description:** Drops a specific partition and its data from a Hive table.

---

### 15. How do you specify the delimiter for fields in a Hive table?
- **Options:**  
  - FIELDS DELIMITED BY  
  - FIELDS TERMINATED BY  
  - FIELDS SEPARATED BY  
  - FIELDS ENCLOSED BY  
- **Correct Option:** FIELDS TERMINATED BY  
- **Description:** Defines the character that separates fields in each row.

---

### 16. How does HBase achieve data locality?
- **Options:**  
  - By storing data in memory.  
  - By placing data on the same physical node as the computation.  
  - By replicating data across multiple nodes.  
  - By compressing data before storage.  
- **Correct Option:** By placing data on the same physical node as the computation.  
- **Description:** Data is stored close to where it is processed for better performance.

---

### 17. How does HBase ensure high availability of data?
- **Options:**  
  - By replicating data across multiple Region Servers.  
  - By compressing data before storage.  
  - By storing data in memory before flushing to disk.  
  - By using distributed file storage in HDFS.  
- **Correct Option:** By replicating data across multiple Region Servers.  
- **Description:** Data is replicated to multiple nodes to ensure availability.

---

### 18. How does HBase handle schema evolution?
- **Options:**  
  - By automatically updating the schema of existing data.  
  - By enforcing a fixed schema and rejecting incompatible changes.  
  - By requiring manual schema updates for each change.  
  - By converting data to a different format during schema changes.  
- **Correct Option:** By enforcing a fixed schema and rejecting incompatible changes.  
- **Description:** Column families are fixed and incompatible changes are not allowed.

---

### 19. How is data organized in HBase?
- **Options:**  
  - Tables and rows  
  - Documents and collections  
  - Key-value pairs  
  - Nodes and relationships  
- **Correct Option:** Key-value pairs  
- **Description:** Data in HBase is stored as key-value pairs.

---

### 20. In which folder do we keep all the 3rd party software in Linux?
- **Options:**  
  - usr  
  - var  
  - sbin  
  - anywhere  
- **Correct Option:** usr  
- **Description:** Third-party software is commonly installed in `/usr` or `/usr/local`.

---

### 21. In which format does data typically travel on a network?
- **Options:**  
  - Binary format  
  - XML format  
  - JSON format  
  - Text format  
- **Correct Option:** Binary format  
- **Description:** Data is transmitted in binary format for efficiency.

---

### 22. In which version of Hadoop is the hdfs dfs command supported?
- **Options:**  
  - Hadoop 1.x  
  - Hadoop 2.x  
  - Hadoop 4.x  
  - Hadoop 5.x  
- **Correct Option:** Hadoop 2.x  
- **Description:** The `hdfs dfs` command was introduced in Hadoop 2.x.

---

### 23. Select the correct statement.
- **Options:**  
  - In the production environment, we get a hive prompt on CLI.... In the production environment, we get a beeline prompt for CLI and HUE browser for GUI.  
  - In the production environment, hive is obsolete.  
  - In the production environment, the hive prompt is always available on the terminal.  
- **Correct Option:** In the production environment, we get a hive prompt on CLI.... In the production environment, we get a beeline prompt for CLI and HUE browser for GUI.  
- **Description:** Beeline is preferred for CLI access and HUE for GUI in production.

---

### 24. Select the secured method to interact with Hive.
- **Options:**  
  - Hive prompt  
  - Beeline  
  - Kerberos  
  - HUE  
- **Correct Option:** Beeline  
- **Description:** Beeline supports secure authentication and is recommended for production.

---

### 25. Statement: hadoop fs -mkdir  creates a directory on the Linux filesystem.
- **Options:**  
  - True  
  - False  
  - Maybe  
- **Correct Option:** False  
- **Description:** The command creates a directory in HDFS, not on the local filesystem.

---

### 26. What are the different types of Distributed File Systems?
- **Options:**  
  - Tape file systems, Windows Distributed File System.  
  - Network File System, Transnational file systems.  
  - HDFS, GFS, MapR FS, S3, EMR FS.  
  - None of the above.  
- **Correct Option:** HDFS, GFS, MapR FS, S3, EMR FS.  
- **Description:** These are all distributed file systems used in big data and cloud.

---

### 27. What are the different types of processing?
- **Options:**  
  - Batch processing and real-time processing.  
  - Distributed processing.  
  - Ad-hoc and Parallel processing.  
  - All of the above.  
- **Correct Option:** All of the above.  
- **Description:** All listed types are valid forms of data processing.

---

### 28. What are the fundamental pillars of the well-architected framework?
- **Options:**  
  - Reliability and Operational excellence.  
  - Security and Performance efficiency.  
  - Cost optimization and Sustainability.  
  - All of the above.  
- **Correct Option:** All of the above.  
- **Description:** All these pillars are part of a well-architected framework.

---

### 29. What are the uses of Flume?
- **Options:**  
  - Flume is used to extract streaming data from sources such as social media and web logs, and then store it on HDFS.  
  - Flume is used to transfer data between RDBMS and HDFS.  
  - Both A & B  
  - None of the above.  
- **Correct Option:** Flume is used to extract streaming data from sources such as social media and web logs, and then store it on HDFS.  
- **Description:** Flume is primarily used for ingesting streaming data into HDFS.

---

### 30. What command is used to exit the MySQL command-line interface?
- **Options:**  
  - QUIT  
  - EXIT  
  - END  
  - CLOSE  
- **Correct Option:** EXIT  
- **Description:** Typing `EXIT` (or `QUIT`) exits the MySQL CLI.

---

### 31. What does HBase use to ensure data integrity in case of failures or crashes?
- **Options:**  
  - Write-ahead logs (WAL)  
  - Data replication  
  - Checksums  
  - Region splits  
- **Correct Option:** Write-ahead logs (WAL)  
- **Description:** WAL records changes before they are written to disk, ensuring recoverability.

---

### 32. What does High Availability refer to in Hadoop 2.x?
- **Options:**  
  - Ensuring the availability of high-speed network connections.  
  - Ensuring the availability of high-performance hardware infrastructure.  
  - Ensuring that the Hadoop cluster is always running without any downtime.  
  - Ensuring the availability of high-capacity storage devices.  
- **Correct Option:** Ensuring that the Hadoop cluster is always running without any downtime.  
- **Description:** High Availability ensures minimal downtime in Hadoop clusters.

---

### 33. What does the dot at the end of the following command refer to: hadoop fs -get .?
- **Options:**  
  - The current working directory.  
  - The parent directory.  
  - A file extension.  
  - It has no special meaning.  
- **Correct Option:** The current working directory.  
- **Description:** A single dot (`.`) refers to the current directory in Unix-like systems.

---

### 34. What does the following command do: hadoop fs mkdir ?
- **Options:**  
  - Lists files in a directory on the Linux filesystem.  
  - Copies files between the Hadoop Distributed File System (HDFS) and the local filesystem.  
  - Creates a new directory in the Hadoop Distributed File System (HDFS).  
  - Deletes a directory from the HDFS.  
- **Correct Option:** Creates a new directory in the Hadoop Distributed File System (HDFS).  
- **Description:** The command creates a directory in HDFS.

---

### 35. What is a jar file?
- **Options:**  
  - Java archival file is not a pack of Classes.  
  - Java archival file is a pack of Objects.  
  - Java archival file is a pack of Classes.  
  - Java archival file is a pack of both Classes as well as Objects.  
- **Correct Option:** Java archival file is a pack of Classes.  
- **Description:** A JAR file packages Java class files and resources for distribution.

---

### 36. What is a JDBC connector used for?
- **Options:**  
  - Connecting Java applications to databases using the JDBC API.  
  - Transferring data between Hadoop and external systems.  
  - Enabling secure communication between databases and applications.  
  - Creating complex SQL queries in Java.  
- **Correct Option:** Connecting Java applications to databases using the JDBC API.  
- **Description:** JDBC connectors allow Java apps to interact with databases.

---

### 37. What is a JDBC connector?
- **Options:**  
  - It is a driver that enables Java programs to interact with databases using the JDBC API.  
  - It is a tool that connects multiple JDBC drivers to a single database.  
  - It is a protocol used for secure communication between databases and applications.  
  - It is a framework for building complex SQL queries in Java.  
- **Correct Option:** It is a driver that enables Java programs to interact with databases using the JDBC API.  
- **Description:** JDBC connectors are drivers for Java-database interaction.

---

### 38. What is a sink in Flume?
- **Options:**  
  - It specifies the name prefixed to the files created by Apache Flume in the HDFS directory.  
  - It specifies the suffix used for the temporary files that Flume actively writes into.  
  - It specifies the number of events written to a file before it is transferred into HDFS.  
  - None of the above.  
- **Correct Option:** It specifies the name prefixed to the files created by Apache Flume in the HDFS directory.  
- **Description:** The sink delivers events to the final destination, controlling file naming.

---

### 39. What is an RPC call?
- **Options:**  
  - Remote Process Call  
  - Remote Procedure Call  
  - Reliable Process Communication  
  - Reliable Procedure Communication  
- **Correct Option:** Remote Procedure Call  
- **Description:** RPC allows a program to execute code on a remote system as if it were local.

---

### 40. What is another term commonly used for storage in Linux?
- **Options:**  
  - Dumping  
  - Keep  
  - Hold to storage  
  - Maintain  
- **Correct Option:** Dumping  
- **Description:** "Dumping" refers to saving data or memory contents to storage, often for backup or debugging.

---
Here is the complete Q\&A (Questions 41 to 80), with all options and correct answers clearly marked. Each question includes a brief explanation or reasoning for the correct answer:

---

### **Question 41**

**What is Apache Flume?**
A) Apache Flume is a reliable and distributed system for collecting, aggregating and moving massive quantities of log data.
B) It has a simple yet flexible architecture based on streaming data flows.
C) Apache Flume is used to collect log data present in log files from web servers and aggregate it into HDFS for analysis.
D) **All of the above.** ✅
**Explanation:** Flume is designed specifically for efficiently collecting, aggregating, and moving large amounts of log data from multiple sources into HDFS.

---

### **Question 42**

**What is data in motion?**
A) Data in file
B) **Streaming data** ✅
C) Data in storage
D) All of the above
**Explanation:** Data in motion refers to real-time data that is being transferred from one location to another, such as through Kafka or Flume.

---

### **Question 43**

**What is data integration?**
A) **The process of bringing data from various sources together to provide users with a unified view.** ✅
B) Collecting data from databases and moving it to target systems
C) Storing data in its original format
D) None of the above
**Explanation:** Data integration enables analytical platforms to work with data from disparate sources as a single, cohesive dataset.

---

### **Question 44**

**What is ETL?**
A) **Extracts, Transforms, and Loads data to a data warehouse.** ✅
B) Extracts, Loads, and Transforms data
C) Loads, Extracts, and Transforms
D) None of the above
**Explanation:** ETL is a core component of data warehousing pipelines.

---

### **Question 45**

**What is HBase?**
A) A column-oriented relational database
B) A distributed file system
C) A key-value store
D) **A column-oriented non-relational database management system** ✅
**Explanation:** HBase is a NoSQL database built on top of HDFS.

---

### **Question 46**

**What is Hive?**
A) **An open-source data warehouse system.** ✅
B) Relational database
C) Data scrubbing tool
D) All of the above
**Explanation:** Hive provides SQL-like querying over structured data in HDFS.

---

### **Question 47**

**What is OLAP?**
A) **Multidimensional analysis of large data from a data warehouse.** ✅
B) OLTP system for transactions
C) Single-dimensional analysis
D) All of the above
**Explanation:** OLAP allows for complex analytical queries over large data.

---

### **Question 48**

**What is Polyglot persistence?**
A) **Using multiple data storage technologies for an application.** ✅
B) Using only one database
C) Using only RDBMS
D) None of the above
**Explanation:** It reflects the reality of diverse storage needs in modern apps.

---

### **Question 49**

**What is Structured data according to ITIL?**
A) **Data in tabular format** ✅
B) Logs data queried with SQL
C) Streaming tabular data (Client Data)
D) Both A & C
**Explanation:** Structured data is typically organized into rows and columns.

---

### **Question 50**

**What is the abbreviation of SDK?**
A) Software Developing Kit
B) **Software Development Kit** ✅
C) Software Deleting Kit
D) Software Driver Kit
**Explanation:** SDK provides tools and libraries for application development.

---

### **Question 51**

**Advantage of HBase over RDBMS for OLAP workloads?**
A) **Scalability** ✅
B) Data locality
C) High availability
D) Flexible schema design
**Explanation:** HBase scales horizontally to handle big data.

---

### **Question 52**

**Default database used by Sqoop?**
A) Oracle
B) **MySQL** ✅
C) Option 3
D) Teradata
**Explanation:** Sqoop uses MySQL to store metadata and job-related info.

---

### **Question 53**

**Default replication factor in HDFS?**
A) 1
B) 2
C) **3** ✅
D) 4
**Explanation:** Default is 3 for fault tolerance.

---

### **Question 54**

**Default scheduling algorithm in YARN ResourceManager?**
A) FCFS
B) **Fair Scheduler** ✅
C) Capacity Scheduler
D) LRU
**Explanation:** Fair scheduler ensures equal resource sharing.

---

### **Question 55**

**Difference between Flume and Sqoop?**
A) Data cleansing tools
B) Both import RDBMS data
C) **Flume = Logs; Sqoop = RDBMS** ✅
D) Sqoop = Logs; Flume = RDBMS
**Explanation:** Flume deals with logs; Sqoop with relational data.

---

### **Question 56**

**Difference: `exec` vs `source` command?**
A) exec = execute script, source = source script
B) exec = executable, source = script
C) **exec = new shell, source = current shell** ✅
D) No difference
**Explanation:** `source` affects current shell; `exec` replaces current process.

---

### **Question 57**

**Default file format for Hive tables?**
A) **TextFile** ✅
B) ORC
C) Parquet
D) Avro
**Explanation:** Default is plain text unless specified.

---

### **Question 58**

**Parameter to specify query in Sqoop?**
A) **--query** ✅
B) --select
C) --data-query
D) --import-query
**Explanation:** `--query` allows for SQL-based imports in Sqoop.

---

### **Question 59**

**Primary advantage of HBase (column-oriented)?**
A) Improved write performance
B) Reduced storage
C) Faster loading
D) **Enhanced query performance** ✅
**Explanation:** Columnar design improves analytics on specific columns.

---

### **Question 60**

**Benefit of HBase's block cache?**
A) **Improved read performance** ✅
B) Reduced storage
C) Faster loading
D) Compression
**Explanation:** Frequently accessed data is cached for speed.

---

### **Question 61**

**RDBMS vs MySQL?**
A) RDBMS is specific DBMS
B) **RDBMS = general type; MySQL = specific RDBMS** ✅
C) Same thing
D) RDBMS = relational; MySQL = non-relational
**Explanation:** MySQL is an RDBMS implementation.

---

### **Question 62**

**Primary purpose of MapReduce?**
A) Data ingestion
B) Visualization
C) **Data processing** ✅
D) Security
**Explanation:** MapReduce processes large-scale data in Hadoop.

---

### **Question 63**

**Primary storage in Hadoop?**
A) HBase
B) **HDFS** ✅
C) Hive
D) Spark
**Explanation:** Hadoop’s file storage backbone is HDFS.

---

### **Question 64**

**Use case for HBase?**
A) **Real-time analytics** ✅
B) Batch processing
C) Data warehousing
D) Stream processing
**Explanation:** HBase supports low-latency reads/writes.

---

### **Question 65**

**Hive’s processing engine?**
A) MySQL
B) Hive SQL
C) **MapReduce** ✅
D) Java
**Explanation:** By default, Hive queries are converted to MapReduce.

---

### **Question 66**

**Prompt used in Pig?**
A) **Grunt** ✅
B) Hive prompt
C) Beeline
D) None
**Explanation:** Grunt is the interactive shell for Pig.

---

### **Question 67**

**Purpose of HBase compactions?**
A) Improve consistency
B) **Optimize storage and performance** ✅
C) Enable joins
D) Prevent access
**Explanation:** Compaction merges files for efficiency.

---

### **Question 68**

**Purpose of MySQL databases/tables?**
A) **Structured data storage** ✅
B) UI for MySQL
C) Complex calculations
D) Fault tolerance
**Explanation:** MySQL tables organize relational data.

---

### **Question 69**

**Region splitting in HBase?**
A) Write performance
B) **Horizontal scalability** ✅
C) Optimize query plans
D) Replication
**Explanation:** Regions split to distribute load.

---

### **Question 70**

**Purpose of `INSERT OVERWRITE` in Hive?**
A) Insert new
B) **Overwrite existing** ✅
C) Append data
D) Delete data
**Explanation:** This replaces table/partition data.

---

### **Question 71**

**Purpose of `LOCATION` in `CREATE TABLE` in Hive?**
A) Table name
B) File format
C) **Data location** ✅
D) Column schema
**Explanation:** Tells Hive where to read/write data.

---

### **Question 72**

**`MSCK REPAIR TABLE` in Hive?**
A) Repairs corrupt data
B) **Updates metadata after adding partitions** ✅
C) Deletes partitions
D) Checks schema
**Explanation:** Syncs metadata with file system.

---

### **Question 73**

**Purpose of NameNode in Hadoop?**
A) **Stores file metadata** ✅
B) Stores data blocks
C) Executes jobs
D) Allocates resources
**Explanation:** The NameNode is HDFS’s metadata manager.

---

### **Question 74**

**`PARTITION` in `LOAD DATA` in Hive?**
A) **Specifies partition for data** ✅
B) Filters data
C) Sorts data
D) File format
**Explanation:** Helps load data into specific partition.

---

### **Question 75**

**`PARTITIONED BY` in Hive?**
A) **Defines partition columns** ✅
B) Partitioning strategy
C) Separate directories
D) Data location
**Explanation:** Specifies which column(s) define partitions.

---

### **Question 76**

**`ROW FORMAT DELIMITED` in Hive?**
A) **Specifies delimiter** ✅
B) Row schema
C) Format of storage
D) Delimited mode
**Explanation:** Used for CSV/TSV data import.

---

### **Question 77**

**`ROW FORMAT SERDE` in Hive?**
A) **Defines storage format** ✅
B) Delimiter
C) Serialized mode
D) Encoding
**Explanation:** SERDE handles serialization/deserialization of rows.

---

### **Question 78**

**SecondaryNameNode purpose in Hadoop?**
A) **Backups of NameNode metadata** ✅
B) High availability
C) Stores data blocks
D) Job management
**Explanation:** Used for checkpointing the NameNode state.

---

### **Question 79**

**Purpose of `STORED AS ORC` in Hive?**
A) File format
B) Compression
C) Optimize performance
D) **Store data in ORC format** ✅
**Explanation:** ORC is a columnar format ideal for Hive.

---

### **Question 80**

**Purpose of `STORED AS PARQUET` in Hive?**
A) File format
B) Compression
C) Optimize performance
D) **Store data in Parquet format** ✅
**Explanation:** Parquet is another efficient columnar format.

---

Here’s the **full Q\&A from Question 81 to 120**, with **all options included** and the **correct answer marked**, along with brief explanations for each:

---

### **Q81. What is the purpose of the STORED AS TEXTFILE clause in Hive?**

* A. It compresses the table's data.
* B. It optimizes the performance of query execution.
* C. It specifies the file format of the table's data.
* ✅ **D. It stores the table's data in text file format.**
  📘 *Specifies the storage format for Hive table data.*

---

### **Q82. What is the purpose of the Write-Ahead Log (WAL) in HBase?**

* A. To store data in memory before flushing to disk
* ✅ **B. To ensure durability and recoverability of data**
* C. To manage data compactions
* D. To coordinate communication between HMaster and Region Servers
  📘 *WAL ensures no data is lost during failure.*

---

### **Q83. What is the purpose of the YARN NodeManager in Hadoop?**

* A. Storing the metadata of the files in HDFS
* B. Storing the data blocks of files in HDFS
* C. Managing the allocation of resources in the cluster
* ✅ **D. Executing MapReduce tasks**
  📘 *NodeManager launches and monitors containers.*

---

### **Q84. What is the recommended block size for HBase tables?**

* ✅ **A. 64 KB**
* B. 1 MB
* C. 8 KB
* D. 256 KB
  📘 *64 KB is a commonly recommended block size in HBase.*

---

### **Q85. What is the relationship between RDBMS and MySQL?**

* ✅ **A. RDBMS is a database management system, while MySQL is a specific RDBMS software.**
* B. MySQL is a database management system, while RDBMS is specific MySQL software.
* C. RDBMS and MySQL are two different terms for the same concept.
* D. RDBMS and MySQL have no relationship.
  📘 *MySQL is one implementation of an RDBMS.*

---

### **Q86. What is the role of the DataNode in Hadoop?**

* A. Storing the metadata of the files in HDFS
* ✅ **B. Storing the data blocks of the files in HDFS**
* C. Executing MapReduce tasks
* D. Allocating resources to jobs in YARN
  📘 *DataNode stores actual data in HDFS.*

---

### **Q87. What is the role of the HBase Memstore?**

* ✅ **A. Stores data in memory before flushing to disk.**
* B. Stores the write-ahead logs (WAL).
* C. Manages data compactions.
* D. Coordinates communication between HMaster and Region Servers.
  📘 *Acts as a temporary write buffer.*

---

### **Q88. What is the role of the ResourceManager in Hadoop YARN?**

* A. Managing the execution of MapReduce jobs
* B. Managing the storage of data in HDFS
* ✅ **C. Managing the allocation of resources in the cluster**
* D. Managing the security of the Hadoop cluster
  📘 *ResourceManager handles cluster resource allocation.*

---

### **Q89. What is the role of ZooKeeper in HBase?**

* A. Data storage and retrieval.
* B. Data replication and synchronization.
* ✅ **C. Coordination and configuration management.**
* D. Data indexing and querying.
  📘 *Ensures HBase coordination and failover.*

---

### **Q90. What type of data typically comes from RDBMS?**

* A. Unstructured data.
* B. Semi-Structured data.
* ✅ **C. Structured data.**
* D. All of the above.
  📘 *RDBMS is designed for structured tabular data.*

---

### **Q91. Where is the archival data stored in AWS?**

* A. It is stored on S3.
* ✅ **B. It is stored on Glaciers.**
* C. It is stored in Athena.
* D. It is stored on RDS.
  📘 *Amazon Glacier is optimized for archival.*

---

### **Q92. Where is the Hive data stored?**

* ✅ **A. /usr/hive/warehouse**
* B. /etc/bin
* C. /user/hadoop/hive
* D. /opt/cloudera/hive
  📘 *Default directory for Hive warehouse.*

---

### **Q93. Where is the location of data checkpointing in Flume?**

* A. var/log/local/data
* B. var/log/hdfs/data
* C. var/log/conf/data
* ✅ **D. var/log/flume/data**
  📘 *Channel checkpoint directory.*

---

### **Q94. Where is the Metadata of Hive stored?**

* A. NameNode
* ✅ **B. Hive Metastore**
* C. Hcatalog
* D. Mysql server
  📘 *Metastore stores table schema, partitions, etc.*

---

### **Q95. Which cache mechanism does HBase use to optimize query performance?**

* ✅ **A. Least Recently Used (LRU)**
* B. First In, First Out (FIFO)
* C. Least Frequently Used (LFU)
* D. Random Replacement
  📘 *HBase uses LRU for block caching.*

---

### **Q96. Which command is used to create a new database in MySQL?**

* ✅ **A. CREATE DATABASE**
* B. INSERT DATABASE
* C. UPDATE DATABASE
* D. ALTER DATABASE
  📘 *SQL syntax to create new DB.*

---

### **Q97. Which command is used to create a new table in MySQL?**

* ✅ **A. CREATE TABLE**
* B. INSERT INTO
* C. UPDATE TABLE
* D. ALTER TABLE

---

### **Q98. Which command is used to create a staging table in Hive?**

* A. CREATE STAGING TABLE
* ✅ **B. CREATE TEMPORARY TABLE**
* C. CREATE INTERIM TABLE
* D. CREATE TABLE
  📘 *Temporary tables are used for staging/intermediate data.*

---

### **Q99. Which command is used to create a table same as the existing table in Hive?**

* A. CREATE TABLE AS SELECT
* B. CREATE TABLE FROM SELECT
* ✅ **C. CREATE TABLE LIKE**
* D. CREATE TABLE AS
  📘 *LIKE copies structure, not data.*

---

### **Q100. Which command is used to create an external table in Hive with a specified location?**

* ✅ **A. CREATE EXTERNAL TABLE**
* B. CREATE TABLE
* C. CREATE HIVE TABLE
* D. CREATE EXTERNAL HIVE TABLE

---

### **Q101. Which command is used to create an external table in Hive with the ORC file format?**

* ✅ **A. CREATE EXTERNAL TABLE ... STORED AS ORC**
* B. CREATE TABLE ... STORED AS ORC
* C. CREATE ORC TABLE
* D. CREATE HIVE TABLE ... AS ORC

---

### **Q102. Which command is used to delete data from a Hive table?**

* A. DELETE FROM
* B. DROP DATA
* ✅ **C. TRUNCATE TABLE**
* D. DELETE TABLE

---

### **Q103. Which command is used to describe the structure of a table in MySQL?**

* ✅ **A. DESCRIBE TABLE**
* B. SHOW TABLE
* C. EXPLAIN TABLE
* D. VIEW TABLE

---

### **Q104. Which command is used to list files in a nested partition in Hive?**

* A. SHOW PARTITIONS
* B. LIST PARTITIONS
* ✅ ❌ **C. DESCRIBE PARTITION** *(Incorrect)*
* D. SHOW FILES
  📘 *Correct is A. SHOW PARTITIONS*

---

### **Q105. Which command is used to list partitions of a Hive table?**

* ✅ **A. SHOW PARTITIONS**
* B. LIST PARTITIONS
* C. DISPLAY PARTITIONS
* D. DESCRIBE PARTITIONS

---

### **Q106. Which command is used to load data from a local file system into a Hive table?**

* ✅ **A. LOAD DATA LOCAL INPATH**
* B. LOAD DATA INPATH
* C. LOAD DATA FROM LOCAL
* D. LOAD DATA FROM FILE

---

### **Q107. Which command is used to show all databases in MySQL?**

* ✅ **A. SHOW DATABASES**
* B. LIST DATABASES
* C. DISPLAY DATABASES
* D. SELECT DATABASES

---

### **Q108. Which command is used to switch to a specific database in MySQL?**

* A. SWITCH DATABASE
* ✅ **B. USE DATABASE**
* C. SELECT DATABASE
* D. SET DATABASE

---

### **Q109. Which component in HBase is responsible for managing data compactions?**

* A. HMaster
* ✅ **B. Region Server**
* C. WAL
* D. Memstore

---

### **Q110–112. Which component in HBase manages the assignment of regions to Region Servers?**

* ✅ **A. HMaster**
* B. ZooKeeper
* C. HDFS
* D. Memstore

---

### **Q113. Which component in HBase provides high availability and fault tolerance?**

* A. HDFS
* B. HMaster
* ✅ **C. ZooKeeper**
* D. Region Server

---

### **Q114. Which configuration files do you edit for a Flume agent?**

* A. flume.conf
* B. flume-env.sh
* C. log4j.properties
* ✅ **D. All of the above**

---

### **Q115. Which data do we query using Hive?**

* A. Semi-structured data
* B. Unstructured data
* ✅ **C. Structured data**
* D. All of the above

---

### **Q116. Which driver is used to connect to MySQL database using Sqoop?**

* ✅ **A. JDBC & ODBC connector**
* B. Teradata connector
* C. Netezza connector
* D. Java connector

---

### **Q117. Which feature of Hadoop enables distributed processing of large datasets?**

* A. Fault tolerance
* B. Reliability
* C. Data locality
* ✅ **D. Distributed computing model**

---

### **Q118. Which feature of Hadoop makes it highly scalable?**

* A. MapReduce
* B. HBase
* ✅ **C. HDFS**
* D. ZooKeeper

---

### **Q119. Which feature of HBase ensures high availability of data?**

* A. Region splitting
* B. Data compaction
* ✅ **C. Data replication**
* D. Block caching

---

### **Q120. Which feature of HBase makes it suitable for storing time-series data?**

* A. Region splitting
* B. Data replication
* C. Block cache
* ✅ **D. Timestamp-based versioning**

---

---

### **Q121. Which file system does HBase run on top of?**

* ✅ **A. HDFS (Hadoop Distributed File System)**
* B. NFS (Network File System)
* C. Ext4
* D. NTFS (New Technology File System)
  📘 *HBase stores its files on HDFS.*

---

### **Q122. Which Hadoop component is responsible for managing distributed file storage?**

* ✅ **A. HDFS**
* B. HBase
* C. Hive
* D. Spark
  📘 *HDFS is the storage layer of Hadoop.*

---

### **Q123. Which Hadoop feature provides fault tolerance in case of hardware failures?**

* ✅ **A. Data replication**
* B. Block caching
* C. Data compression
* D. Memstore
  📘 *Replication ensures data is not lost on node failure.*

---

### **Q124. Which HBase component handles the coordination between HMaster and Region Servers?**

* ✅ **A. ZooKeeper**
* B. Memstore
* C. WAL
* D. HDFS
  📘 *ZooKeeper keeps the cluster coordinated and available.*

---

### **Q125. Which HBase feature ensures data reliability in case of failures?**

* ✅ **A. Write-ahead logs (WAL)**
* B. Region splitting
* C. Data compaction
* D. Block cache
  📘 *WAL logs changes before applying them to ensure recovery.*

---

### **Q126. Which internet protocol version is used in Hadoop 3?**

* ✅ **A. IPv4**
* B. Ipv8
* C. Ipv6
* D. Ipv18
  📘 *Hadoop 3 supports IPv4 primarily, with some support for IPv6.*

---

### **Q127. Which is a general-purpose computing model and runtime system for distributed data analytics?**

* ✅ **A. Drill**
* B. Option 2 *(Invalid option)*
* C. Oozie
* D. All of the above
  📘 *Apache Drill is for distributed SQL querying.*

---

### **Q128. Which networking protocol is used in remote login servers?**

* ✅ **A. ssh**
* B. scp
* C. ftp
* D. smtp
  📘 *SSH provides secure remote login.*

---

### **Q129. Which of the following is a popular file transfer client for Windows?**

* A. FileZilla
* ✅ **B. WinSCP**
* C. PuTTY
* D. Cyberduck
  📘 *WinSCP is known for secure file transfer.*

---

### **Q130. Which of the following is NOT a valid MySQL data type?**

* A. INT
* B. VARCHAR
* C. BOOLEAN
* ✅ **D. FLOATING**
  📘 *FLOAT is valid, but “FLOATING” is not.*

---

### **Q131. Which of the following statements accurately describes the communication between a Datanode and a Namenode in Hadoop?**

* ✅ **A. The Datanode periodically sends heartbeat messages to the Namenode to indicate its availability.**
* B. The Datanode retrieves metadata information from the Namenode to perform data processing tasks.
* C. The Namenode sends replication requests to the Datanode to ensure data redundancy.
* D. The Datanode transfers data blocks to the Namenode for storage and processing.
  📘 *Heartbeat signals help the Namenode track active Datanodes.*

---

### **Q132. Which programming language is commonly used for writing MapReduce jobs in Hadoop?**

* ✅ **A. Java**
* B. Python
* C. C++
* D. Ruby
  📘 *Hadoop MapReduce is natively in Java.*

---

### **Q133. Which query language is used in Hive?**

* A. Java
* B. Mysql
* C. Pig Latin
* ✅ **D. HiveQL**
  📘 *HiveQL is SQL-like and used in Hive.*

---

### **Q134. Which Sqoop command is used to import data from MySQL to Hadoop in Parquet file format?**

* ✅ **A. sqoop import --as-parquetfile**
* B. sqoop import --parquet
* C. sqoop import --file-format parquet
* D. sqoop import --format parquet
  📘 *Parquet is a columnar format supported by Sqoop via this flag.*

---

### **Q135. Which type of compaction is typically performed manually by a Hadoop administrator?**

* ✅ **A. Major compaction**
* B. Minor compaction
* C. Bulk compaction
* D. Automated compaction
  📘 *Major compactions are resource-intensive and often scheduled manually.*

---

### **Q136. Which type of data is ingested through Sqoop?**

* ✅ **A. Structured data**
* B. Unstructured data
* C. Event log data
* D. All of the above
  📘 *Sqoop connects to RDBMS and handles structured data.*

---

