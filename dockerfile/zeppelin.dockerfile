FROM openjdk:8-jre

USER root
ENV FLINK_HOME=/opt/flink
ARG flink_path=/usr/local/lib/python3.7/dist-packages/pyflink
ARG FLINK_VERSION=1.11.1

RUN apt update \
    && apt install -y software-properties-common automake autoconf  \
       file  curl g++ gcc gnupg  make cmake python3 python3-dev python3-pip vim wget tini \
    && pip3 install apache-flink==1.11.1  pyyml  
COPY zeppelin-0.9.0-SNAPSHOT.tar.gz /

RUN wget -P ${flink_path}/lib/ https://repo.maven.apache.org/maven2/org/apache/flink/flink-csv/${FLINK_VERSION}/flink-csv-${FLINK_VERSION}.jar; \
    wget -P ${flink_path}/lib/ https://repo.maven.apache.org/maven2/org/apache/flink/flink-connector-jdbc_2.11/${FLINK_VERSION}/flink-connector-jdbc_2.11-${FLINK_VERSION}.jar; \
    wget -P ${flink_path}/lib/ https://repo.maven.apache.org/maven2/mysql/mysql-connector-java/8.0.19/mysql-connector-java-8.0.19.jar; \
    wget -P ${flink_path}/lib/ https://repo.maven.apache.org/maven2/org/apache/flink/flink-sql-connector-kafka_2.11/${FLINK_VERSION}/flink-sql-connector-kafka_2.11-${FLINK_VERSION}.jar; \
    wget -P ${flink_path}/lib/ https://repo.maven.apache.org/maven2/org/apache/flink/flink-sql-connector-elasticsearch6_2.11/${FLINK_VERSION}/flink-sql-connector-elasticsearch6_2.11-${FLINK_VERSION}.jar; \
    cp ${flink_path}/opt/flink-python_2.11-${FLINK_VERSION}.jar ${flink_path}/lib/flink-python_2.11-${FLINK_VERSION}.jar; \
    ln -s /usr/bin/python3.7 /usr/bin/python; \
    ln -s /usr/bin/pip3 /usr/bin/pip; \
    rm -rf /zeppelin; \
    cd /; \
    tar xf zeppelin-0.9.0-SNAPSHOT.tar.gz; \
    mv zeppelin-0.9.0-SNAPSHOT zeppelin; \
    rm -f zeppelin-0.9.0-SNAPSHOT.tar.gz; \
    cd /zeppelin; \
    mkdir logs run; \
    cp conf/zeppelin-site.xml.template conf/zeppelin-site.xml; \
    sed -i 's#<value>127.0.0.1</value>#<value>0.0.0.0</value>#g' conf/zeppelin-site.xml; \
    sed -i 's#<value>auto</value>#<value>local</value>#g' conf/zeppelin-site.xml

WORKDIR /zeppelin
ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "bin/zeppelin.sh"]