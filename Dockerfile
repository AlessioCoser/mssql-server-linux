FROM microsoft/mssql-server-linux:latest

WORKDIR /opt

COPY ./entrypoint.sh /opt/

RUN chmod +x /opt/entrypoint.sh

CMD ["/bin/sh", "/opt/entrypoint.sh"]