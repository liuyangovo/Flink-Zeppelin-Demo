FROM flink:1.11.1-scala_2.11

USER root
RUN apt update \
    && apt install -y software-properties-common automake autoconf  \
       file  curl g++ gcc gnupg  make cmake python3 python3-dev python3-pip vim \
    && pip3 install apache-flink  pyyml  

ARG FLINK_VERSION=1.11.1
RUN wget -P /opt/flink/lib/ https://repo.maven.apache.org/maven2/org/apache/flink/flink-csv/${FLINK_VERSION}/flink-csv-${FLINK_VERSION}.jar; \
    wget -P /opt/flink/lib/ https://repo.maven.apache.org/maven2/org/apache/flink/flink-connector-jdbc_2.11/${FLINK_VERSION}/flink-connector-jdbc_2.11-${FLINK_VERSION}.jar; \
    wget -P /opt/flink/lib/ https://repo.maven.apache.org/maven2/mysql/mysql-connector-java/8.0.19/mysql-connector-java-8.0.19.jar; \
    wget -P /opt/flink/lib/ https://repo.maven.apache.org/maven2/org/apache/flink/flink-sql-connector-kafka_2.11/${FLINK_VERSION}/flink-sql-connector-kafka_2.11-${FLINK_VERSION}.jar; \
    wget -P /opt/flink/lib/ https://repo.maven.apache.org/maven2/org/apache/flink/flink-sql-connector-elasticsearch6_2.11/${FLINK_VERSION}/flink-sql-connector-elasticsearch6_2.11-${FLINK_VERSION}.jar; \
    chown -R flink.flink /opt/flink/lib/; \
    ln -s /usr/bin/python3.7 /usr/bin/python; \
    ln -s /usr/bin/pip3 /usr/bin/pip

WORKDIR /opt/flink