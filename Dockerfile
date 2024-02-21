FROM python:3.10.13-slim-bookworm

RUN pip install --no-cache-dir poetry==1.7.1 keyrings.google-artifactregistry-auth==1.1.2

ARG APP=/app
ARG SRC_DIR=src
WORKDIR $APP
ADD $SRC_DIR/. $APP/$SRC_DIR/
ADD README.md $APP/
ADD pyproject.toml $APP/

ARG GOOGLE_APPLICATION_CREDENTIALS
ENV GOOGLE_APPLICATION_CREDENTIALS=${GOOGLE_APPLICATION_CREDENTIALS}

RUN poetry config virtualenvs.create false
RUN --mount=type=secret,id=credentials.json poetry lock && poetry install --no-root
