# Hadoop-env.sh modifications for AWS S3 integration

# Add AWS SDK and Hadoop-AWS jars to the classpath
export HADOOP_CLASSPATH=$HADOOP_CLASSPATH:$HADOOP_HOME/share/hadoop/tools/lib/*

# Ensure the AWS SDK and Hadoop-AWS jars are available to MapReduce jobs
export HADOOP_USER_CLASSPATH_FIRST=true

# Optional: Set AWS region as environment variable (alternative to core-site.xml)
# export AWS_REGION=us-east-1

# Optional: Set AWS credentials as environment variables (alternative to core-site.xml)
# export AWS_ACCESS_KEY_ID=YOUR_ACCESS_KEY
# export AWS_SECRET_ACCESS_KEY=YOUR_SECRET_KEY
