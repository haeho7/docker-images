#
# Dockerfile for mariadb
#

FROM mariadb:10.6.10
LABEL maintainer="haeho7 <i@demo.com>"
# See more: https://github.com/MariaDB/mariadb-docker/tree/master/10.6

RUN apt-get update \
  && apt-get install -y --no-install-recommends tzdata \
  && rm -rf /var/lib/apt/lists/*

COPY mariadb-data/conf.d/mariadb.cnf /opt/
COPY --chmod=755 mariadb.sh /usr/local/bin/

ENTRYPOINT ["mariadb.sh"]
CMD ["mariadbd"]
