FROM mspertus/mpcs53014_hive:latest

MAINTAINER Mike Spertus <mike@spertus.com>
RUN chown hadoop:hadoop /home/hadoop/.bashrc
# Switch To Hadoop User
USER hadoop
WORKDIR /home/hadoop

# Download and Install HBase
RUN wget http://archive.apache.org/dist/hbase/2.0.2/hbase-2.0.2-bin.tar.gz && tar -xvzf hbase-2.0.2-bin.tar.gz && rm hbase-2.0.2-bin.tar.gz && mv hbase-2.0.2 hbase

# Copy HBase config
COPY hbase-site.xml /home/hadoop/hbase/conf/hbase-site.xml
RUN echo "export PATH=\$PATH:/home/hadoop/hbase/bin" >>/home/hadoop/.bashrc

#Expose Hadoop Ports
EXPOSE 8088 9870 9000 10000 4040 8042 8030 8031 8032 8888 30000-50000 3000-3100

# Start startup Script
ENTRYPOINT ["/startup.sh"]


