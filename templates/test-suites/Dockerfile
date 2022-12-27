FROM python:3.10-slim-buster
RUN apt-get update && apt-get install curl -y

ENV POETRY_HOME=/opt/poetry
ENV POETRY_VERSION=1.2.2

RUN python3 -m venv $POETRY_HOME
RUN $POETRY_HOME/bin/pip install poetry==$POETRY_VERSION
