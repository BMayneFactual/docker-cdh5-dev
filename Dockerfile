FROM factual/docker-cdh5-base

# for ruby 2.3
RUN apt-add-repository ppa:brightbox/ruby-ng

ENV MAVEN_VERSION=3.3.9
ENV THRIFT_VERSION=0.9.2
ENV SPARK_VERSION=2.1.0-bin-hadoop2.6
ENV SPARK_HOME=/opt/spark
ENV MAVEN_PATH=/opt/apache-maven
ENV HADOOP_CONF_DIR=/etc/hadoop/conf

RUN apt-get update
RUN apt-get install -y git-core sudo build-essential automake unzip zlib1g-dev liblzo2-dev libcurl4-gnutls-dev libncurses5-dev bison flex libboost-all-dev libevent-dev
RUN apt-get install -y vim emacs
RUN apt-get install -y ruby2.3 ruby2.3-dev nodejs npm python3 python3-dev
RUN gem install bundler --no-rdoc --no-ri

RUN apt-get install -y ldap-utils libpam-ldap libnss-ldap nslcd

RUN apt-get install -y openjdk-8-jdk-headless ant

RUN apt-get upgrade -y

#maven
ADD http://apache.cs.utah.edu/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz /tmp/
RUN cd /tmp/ && tar xzf apache-maven-$MAVEN_VERSION-bin.tar.gz && mv apache-maven-$MAVEN_VERSION $MAVEN_PATH
RUN ln -s $MAVEN_PATH/bin/mvn /usr/bin/mvn

RUN update-ca-certificates -f

#lein
ADD https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein /bin/lein
ENV LEIN_ROOT=true
RUN chmod 755 /bin/lein
RUN lein --version

#thrift
ADD http://archive.apache.org/dist/thrift/$THRIFT_VERSION/thrift-$THRIFT_VERSION.tar.gz /tmp/ 
RUN cd /tmp/ && tar xzf thrift-$THRIFT_VERSION.tar.gz && cd thrift-$THRIFT_VERSION && ./configure --without-ruby --without-cpp --without-nodejs --without-python && make install
RUN rm -rf thrift-$THRIFT_VERSION*

#Drake
ADD https://raw.githubusercontent.com/Factual/drake/master/bin/drake /bin/drake
RUN chmod 755 /bin/drake

#Spark
ADD http://d3kbcqa49mib13.cloudfront.net/spark-$SPARK_VERSION.tgz /tmp/
RUN cd /tmp/ && tar xzf spark-$SPARK_VERSION.tgz && mv spark-$SPARK_VERSION $SPARK_HOME 
RUN echo "export PATH=$SPARK_HOME/bin:\$PATH" >> /etc/profile
RUN echo "export HADOOP_CONF_DIR=$HADOOP_CONF_DIR" >> /etc/profile
RUN echo "export SPARK_HOME=$SPARK_HOME" >> /etc/profile
RUN mkdir -p /etc/spark/ && ln -s $SPARK_HOME/conf /etc/spark/conf

#man
RUN apt-get purge -y manpages manpages-dev man-db
RUN apt-get install -y manpages manpages-dev man-db

#cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
ADD bootstrap.sh /etc/my_init.d/099_bootstrap

#new things
ENV PATH=$SPARK_PATH/bin:$PATH
RUN apt-get update && apt-get -y install curl wget cronolog
ADD spark-defaults.conf /opt/spark/conf/
