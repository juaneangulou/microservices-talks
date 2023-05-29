FROM mcr.microsoft.com/mssql/server:latest

ARG SA_PASSWORD="Abc.123456"
ENV SA_PASSWORD=$SA_PASSWORD
ENV ACCEPT_EULA="Y"

EXPOSE 1433

RUN mkdir -p /usr/work
COPY ./scripts/*.sql /usr/work/

WORKDIR /usr/work

RUN ( /opt/mssql/bin/sqlservr & ) \
    | grep -q "Service Broker manager has started" \
    && /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P $SA_PASSWORD -i invoicer.sql \
    && pkill sqlservr
