FROM marcelmittelstaedt/spark_base:latest

MAINTAINER Mike Spertus <mike@spertus.com>

# Switch hive to use mysql metastore
# RUN /bin/bash -c "debconf-set-selections <<< 'mysql-server mysql-server/root_password password hadoop'"
# RUN /bin/bash -c "debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password hadoop'"
# RUN apt-get install -y mysql-server
# RUN apt-get install -y libmysql-java

# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
RUN apt-get install -y nodejs

# Switch To Hadoop User
USER hadoop
WORKDIR /home/hadoop
# RUN ln -s /usr/share/java/mysql-connector-java.jar /home/hadoop/lib/mysql-connector-java.jar
COPY core-site.xml hadoop/etc/hadoop/core-site.xml
RUN ln -s /home/hadoop/hadoop/etc/core-site.xml /home/hadoop/spark/conf/core-site.xml

# Download and Install HBase
RUN wget http://archive.apache.org/dist/hbase/2.0.2/hbase-2.0.2-bin.tar.gz && tar -xvzf hbase-2.0.2-bin.tar.gz && rm hbase-2.0.2-bin.tar.gz && mv hbase-2.0.2 hbase

# Copy HBase config
COPY hbase-site.xml /home/hadoop/hbase/conf/hbase-site.xml
COPY create_hbase_table.txt /home/hadoop/create_hbase_table.txt

RUN mkdir /home/hadoop/inputs
COPY inputs /home/hadoop/inputs
RUN mkdir -p /home/hadoop/user/hive/warehouse
COPY user/hive/warehouse /home/hadoop/user/hive/warehouse

COPY IngestWeather-0.0.1-SNAPSHOT.jar /home/hadoop/IngestWeather-0.0.1-SNAPSHOT.jar
COPY init_tables.hql /home/hadoop/init_tables.hql

# Switch back to Root User
USER root
WORKDIR /
RUN chown -R hadoop:hadoop /home/hadoop/inputs
RUN chown -R hadoop:hadoop /home/hadoop/user
RUN echo "export PATH=\$PATH:/home/hadoop/hbase/bin" >>/home/hadoop/.bashrc

COPY init_container.sh /init_container.sh
COPY create_hbase_table.sh /create_hbase_table.sh
COPY write_to_hbase.hql /home/hadoop/write_to_hbase.hql
RUN chown hadoop:hadoop /home/hadoop/write_to_hbase.hql
COPY populate_hbase_table.sh /populate_hbase_table.sh


RUN /init_container.sh
RUN /create_hbase_table.sh
RUN /populate_hbase_table.sh

# Switch To Hadoop User
USER hadoop
WORKDIR /home/hadoop
RUN mkdir webapp
ADD webapp.tar.gz /home/hadoop
WORKDIR /home/hadoop/webapp
RUN npm install express
RUN npm install mustache
RUN npm install hbase-rpc-client

USER root
WORKDIR /

#Expose Hadoop Ports
EXPOSE 8088
EXPOSE 9870
EXPOSE 9000
EXPOSE 10000
EXPOSE 4040
EXPOSE 8042
EXPOSE 8030
EXPOSE 8031
EXPOSE 8032
EXPOSE 8888
EXPOSE 30000-50000
EXPOSE 3000-3100

# Start startup Script
ENTRYPOINT ["/startup.sh"]


