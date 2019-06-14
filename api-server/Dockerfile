FROM python:3.7-alpine
MAINTAINER Neeraj Gupta

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /requirements.txt

RUN apk update
RUN apk add --update --no-cache postgresql-client jpeg-dev
RUN apk add --update --no-cache --virtual .tmp-build-deps \
        gcc libc-dev linux-headers postgresql-dev musl-dev \
        zlib zlib-dev

# For python pdftotext library
RUN apk add --update g++
RUN apk add --update poppler-dev

# Needed if we want command pdftotext to be available
# RUN apk add --update poppler-utils

RUN pip install -r /requirements.txt
RUN apk del .tmp-build-deps


RUN mkdir /app
WORKDIR /app
COPY ./app /app

RUN adduser -D user
USER user
