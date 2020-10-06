FROM ubuntu:18.04 AS tracing_dependencies

RUN set -x \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y curl xsltproc

ARG php_version
ARG arch=x64
ARG download_key
ARG extension

ENV PHP_VERSION=${php_version}
ENV EXTENSION=${extension}
ENV ARCH=${arch}
ENV INSTANA_DOWNLOAD_KEY=${download_key}

ADD extract_latest_version.xslt extract_latest_version.xslt

RUN php_path=$(echo "${PHP_VERSION}" | sed -e 's#\.#/#g') && \
    curl --silent -k --fail --user "_:${INSTANA_DOWNLOAD_KEY}" "https://artifact-public.instana.io/artifactory/shared/com/instana/php/${php_path}/instana-${ARCH}${EXTENSION}/maven-metadata.xml" -o maven-metadata.xml && \
    xsltproc extract_latest_version.xslt maven-metadata.xml > versions && \
    LATEST_VERSION=$(cat versions | grep -v -e '^$' | grep -v 'dev' | grep -v 'RC' | tail -1) && \
    echo "The latest version of the Instana PHP extension is: ${LATEST_VERSION}" && \
    mkdir -p /opt/instana/instrumentation/php && \
    curl --silent -k --fail --user "_:${INSTANA_DOWNLOAD_KEY}" "https://artifact-public.instana.io/artifactory/shared/com/instana/php/${php_path}/instana-${ARCH}${EXTENSION}/${LATEST_VERSION}/instana-${arch}${EXTENSION}-${LATEST_VERSION}.so" -o /opt/instana/instrumentation/php/instana.so

FROM scratch

COPY --from=tracing_dependencies /opt/instana /opt/instana