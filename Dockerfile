FROM factual/docker-cdh5-dev

ENV SPARK_VERSION=2.1.0-bin-hadoop2.6

#Spark
ADD http://d3kbcqa49mib13.cloudfront.net/spark-$SPARK_VERSION.tgz /tmp/
RUN cd /tmp/ && tar xzf spark-$SPARK_VERSION.tgz && mv spark-$SPARK_VERSION $SPARK_HOME
RUN echo "export PATH=$SPARK_HOME/bin:\$PATH" >> /etc/profile
RUN echo "export HADOOP_CONF_DIR=$HADOOP_CONF_DIR" >> /etc/profile
RUN echo "export SPARK_HOME=$SPARK_HOME" >> /etc/profile
RUN mkdir -p /etc/spark/ && ln -s $SPARK_HOME/conf /etc/spark/conf

ENV PATH=$SPARK_PATH/bin:$PATH
RUN apt-get update && apt-get -y install curl wget cronolog
ADD spark-defaults.conf /opt/spark/conf/


