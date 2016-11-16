FROM factual/docker-cdh5-dev

ENV PATH=$SPARK_PATH/bin:$PATH
RUN apt-get update && apt-get -y install curl wget cronolog
ADD spark-defaults.conf /opt/spark/conf/


