FROM centos:7

ARG PRESTO_VERSION=317
ARG PRESTO_BASE_URL=https://repo1.maven.org/maven2/io/prestosql/presto-server-rpm

ENV PRESTO_VAR_DIR=/var/presto \
    PRESTO_ETC_DIR=/etc/presto

RUN yum install -y \
        java-1.8.0-openjdk \
        "${PRESTO_BASE_URL}/${PRESTO_VERSION}/presto-server-rpm-${PRESTO_VERSION}.rpm" \
 && yum clean all \
 && rm -rf /var/cache/yum \
 && rm -rf /tmp/* \
 && mkdir -p ${PRESTO_VAR_DIR}/log \
 && mkdir -p ${PRESTO_VAR_DIR}/data \
 && mkdir -p ${PRESTO_ETC_DIR}/catalog \
 && rm ${PRESTO_ETC_DIR}/config.properties \
 && rm ${PRESTO_ETC_DIR}/node.properties

COPY ./scripts/entrypoint.sh ./scripts/start_presto.sh /usr/local/bin/

EXPOSE 8080

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]

CMD ["/usr/local/bin/start_presto.sh"]
