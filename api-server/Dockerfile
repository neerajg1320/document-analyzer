FROM python:3.7-alpine
MAINTAINER Neeraj Gupta

ENV PYTHONUNBUFFERED 1

COPY ./requirements_working.txt /requirements_working.txt

RUN apk update
RUN apk add --update --no-cache postgresql-client jpeg-dev
RUN apk add --update --no-cache --virtual .tmp-build-deps \
        linux-headers postgresql-dev  \
        zlib zlib-dev

# For python pdftotext library
RUN apk add --update g++
RUN apk add --update poppler-dev

# Needed if we want command pdftotext to be available
RUN apk add --update poppler-utils

RUN pip install -r /requirements_working.txt
RUN apk del .tmp-build-deps


RUN mkdir /app
WORKDIR /app
COPY ./app /app

RUN adduser -D user
USER user
