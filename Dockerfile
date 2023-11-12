FROM mysql:5.7

ENV MYSQL_ROOT_PASSWORD=12345678

ADD ./ScriptBD.sql /docker-entrypoint-initdb.d/

EXPOSE 3306
