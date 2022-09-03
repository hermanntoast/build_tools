ARG product_version=7.1.1

FROM ubuntu:16.04 as build-stage

ENV TZ=Etc/UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get -y update && \
    apt-get -y install python \
                       python3 \
                       sudo
RUN rm /usr/bin/python && ln -s /usr/bin/python2 /usr/bin/python
ADD . /build_tools

RUN cd /build_tools/tools/linux && \
    python3 ./automate.py server

FROM onlyoffice/documentserver:${product_version}

COPY --from=build-stage /build_tools/out/linux_64/onlyoffice  /var/www/onlyoffice
COPY ../buildfiles/certs /etc/ssl/webserver
