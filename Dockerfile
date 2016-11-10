FROM factual/docker-cdh5-dev

#spark
RUN apt-get update && apt-get -y install curl wget cronolog
RUN wget -O /usr/local/spark-1.6.1-bin-hadoop2.6.tgz http://d3kbcqa49mib13.cloudfront.net/spark-1.6.1-bin-hadoop2.6.tgz
RUN tar -xzf /usr/local/spark-1.6.1-bin-hadoop2.6.tgz -C /usr/local/
RUN rm /usr/local/spark-1.6.1-bin-hadoop2.6.tgz
ENV PATH=/usr/local/spark-1.6.1-bin-hadoop2.6/bin:$PATH
ENV HADOOP_CONF_DIR=/etc/hadoop/conf
ADD spark-defaults.conf /usr/local/spark-1.6.2-bin-hadoop2.6/conf/

RUN wget -O /usr/local/spark-2.0.0-bin-hadoop2.6.tgz http://d3kbcqa49mib13.cloudfront.net/spark-2.0.0-bin-hadoop2.6.tgz
RUN tar -xzf /usr/local/spark-2.0.0-bin-hadoop2.6.tgz -C /usr/local/
RUN rm /usr/local/spark-2.0.0-bin-hadoop2.6.tgz
ADD spark-defaults.conf /usr/local/spark-2.0.0-bin-hadoop2.6/conf/

