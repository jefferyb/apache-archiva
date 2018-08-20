#
# Apache Archiva Standalone
# ref: Separating the base from the installation @ http://archiva.apache.org/docs/1.4-M4/adminguide/standalone.html
#      https://docs.okd.io/latest/creating_images/guidelines.html#openshift-specific-guidelines
#
######## HOW TO DEPLOY TO OPENSHIFT
#
# $ oc new-app --name=apache-archiva --file=https://raw.githubusercontent.com/jefferyb/apache-archiva/master/openshift-templates/apache-archiva-openshift-template.yaml -p APPLICATION_URL=archiva.example.com
#
######## HOW TO RUN IT USING DOCKER
#
# $ docker run -itd --name apache-archiva -p 8080:8080 jefferyb/apache-archiva
#
####### </ Jeffery Bagirimvano >

FROM openjdk:8-jdk

ENV ARCHIVA_VERSION=2.2.3

LABEL name="jefferyb/apache-archiva" \
      maintainer="Jeffery Bagirimvano <jefferyb@uark.edu>" \
      version="${ARCHIVA_VERSION}" \
      url="https://github.com/jefferyb/apache-archiva" \
      run='docker run -itd --name apache-archiva -p 8080:8080 jefferyb/apache-archiva' \
      summary="Apache Archiva Openshift Image, based on openjdk using openshift specific guidelines" \
      io.k8s.display-name="Apache Archiva" \
      io.k8s.description="Apache Archiva™ is an extensible repository management software that helps taking care of your own personal or enterprise-wide build artifact repository." \
      io.openshift.expose-services="8080/tcp" \
      io.openshift.tags="jefferyb,apache,archiva,artifact,repository,openshift,kubernetes"

### Setup user for build execution and application runtime
ENV APP_ROOT=/opt/app-root
ENV PATH=${APP_ROOT}/bin:${PATH} HOME=${APP_ROOT} ARCHIVA_BASE=${APP_ROOT}/archiva-base

RUN mkdir -p ${APP_ROOT} \
      && wget -q http://www-eu.apache.org/dist/archiva/${ARCHIVA_VERSION}/binaries/apache-archiva-${ARCHIVA_VERSION}-bin.zip \
      && unzip -q apache-archiva-${ARCHIVA_VERSION}-bin.zip -d /tmp \
      && cp -frp /tmp/apache-archiva*/* ${APP_ROOT}/ \
      && rm -fr /tmp/apache-archiva* apache-archiva-${ARCHIVA_VERSION}-bin.zip \
      && mkdir -p ${ARCHIVA_BASE}/logs ${ARCHIVA_BASE}/data ${ARCHIVA_BASE}/temp ${ARCHIVA_BASE}/repositories \
      && cp -frp ${APP_ROOT}/conf ${ARCHIVA_BASE}/

COPY bin/ ${APP_ROOT}/bin/
RUN chmod -R u+x ${APP_ROOT}/bin && \
    chgrp -R 0 ${APP_ROOT} && \
    chmod -R g=u ${APP_ROOT} /etc/passwd

### Containers should NOT run as root as a good practice
USER 10001
WORKDIR ${ARCHIVA_BASE}

### user name recognition at runtime w/ an arbitrary uid - for OpenShift deployments
ENTRYPOINT [ "uid_entrypoint" ]
VOLUME ${ARCHIVA_BASE}
EXPOSE 8080
CMD start-archiva
