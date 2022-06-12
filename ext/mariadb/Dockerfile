#
# Dockerfile for mariadb
#

#
# Runtime stage
#
FROM mariadb:10.6.8
LABEL maintainer="haeho7 <i@aimoyu.cc>"
# See more: https://github.com/MariaDB/mariadb-docker/tree/master/10.6

RUN apt-get update \
  && apt-get install -y --no-install-recommends tzdata \
  && rm -rf /var/lib/apt/lists/*

COPY --chmod=777 mariadb.sh /usr/local/bin/
COPY mariadb-data/conf.d/mariadb.cnf /tmp

ENTRYPOINT ["mariadb.sh"] 
CMD ["mariadbd"]