FROM python:3.6-alpine3.7

RUN apk update

WORKDIR /code

RUN apk add --no-cache postgresql-libs bash
RUN apk add --no-cache --virtual .build-deps git python-dev gcc musl-dev postgresql-dev libffi-dev libressl-dev

RUN pip install --upgrade pip
COPY ./requirements/base.txt requirements/base.txt
COPY ./requirements/production.txt requirements/production.txt
RUN pip install -r requirements/production.txt --no-cache-dir

ADD . /code

# Collecting static files
RUN ./scripts/run-collectstatic.sh

RUN apk del .build-deps

EXPOSE 8080
ENTRYPOINT ["bash", "/code/docker-entrypoint.sh"]

LABEL version="1.0.78"
