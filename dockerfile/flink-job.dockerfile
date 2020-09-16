FROM openjdk:8-jdk

ARG FLINK_VERSION=1.11.1
ARG GIT_TOKEN=
ARG branch
ARG flink_path=/usr/local/lib/python3.7/dist-packages/pyflink

RUN apt update \
    && apt install -y software-properties-common automake autoconf  \
       file  curl g++ gcc gnupg  make cmake python3 python3-dev python3-pip vim git maven zip wget tini cron \
    && pip3 install apache-flink==1.11.1  pyyml  \
    && wget -P ${flink_path}/lib/ https://repo.maven.apache.org/maven2/org/apache/flink/flink-csv/${FLINK_VERSION}/flink-csv-${FLINK_VERSION}.jar \
    && wget -P ${flink_path}/lib/ https://repo.maven.apache.org/maven2/org/apache/flink/flink-connector-jdbc_2.11/${FLINK_VERSION}/flink-connector-jdbc_2.11-${FLINK_VERSION}.jar \
    && wget -P ${flink_path}/lib/ https://repo.maven.apache.org/maven2/mysql/mysql-connector-java/8.0.19/mysql-connector-java-8.0.19.jar \
    && wget -P ${flink_path}/lib/ https://repo.maven.apache.org/maven2/org/apache/flink/flink-sql-connector-kafka_2.11/${FLINK_VERSION}/flink-sql-connector-kafka_2.11-${FLINK_VERSION}.jar \
    && wget -P ${flink_path}/lib/ https://repo.maven.apache.org/maven2/org/apache/flink/flink-sql-connector-elasticsearch6_2.11/${FLINK_VERSION}/flink-sql-connector-elasticsearch6_2.11-${FLINK_VERSION}.jar \
    && cp ${flink_path}/opt/flink-python_2.11-1.11.1.jar ${flink_path}/lib/flink-python_2.11-1.11.1.jar \
    && echo export PATH="/usr/local/lib/python3.7/dist-packages/pyflink/bin/:$PATH" >> ~/.bashrc \
    && rm -f /usr/bin/python /usr/bin/pip \
    && ln -s /usr/bin/python3.7 /usr/bin/python \
    && ln -s /usr/bin/pip3 /usr/bin/pip \
    && mkdir work  \
    && cd /work \
    && git clone https://${GIT_TOKEN}@github.com.XXXXXXXX.git

RUN cd /work/flink \
    && git checkout ${branch} \
    && git pull \
    && cd java \
    && mvn package \
    && cp target/flink-1.0-SNAPSHOT.jar ../XXXX/ \
    && rm -fr target/ ~/.m2/ ~/.cache/ \
    && cd ../XXXX/ \
    && zip -r flinkjob.zip ./*

ADD conf/flink/configs.yaml /work/flink/XXXX/configs/configs.yaml


WORKDIR /work/flink/XXXX/
ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "cron"]