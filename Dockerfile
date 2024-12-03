ARG product_version=8.2.2

FROM ubuntu:22.04 as build-stage

ENV TZ=Etc/UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get -y update && \
    apt-get -y install python3 \
                       sudo
ADD . /build_tools

RUN cd /build_tools/tools/linux && \
    python3 ./automate.py server

FROM onlyoffice/documentserver:${product_version}

COPY --from=build-stage /build_tools/out/linux_64/onlyoffice  /var/www/onlyoffice
COPY ./buildfiles/certs /etc/ssl/webserver
