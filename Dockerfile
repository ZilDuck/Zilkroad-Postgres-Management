FROM python:3.8-alpine

WORKDIR /postgres-management

# hadolint ignore=DL3018
RUN apk --no-cache add --update postgresql-dev gcc python3-dev musl-dev libressl-dev libffi-dev

COPY . .

RUN pip install --no-cache-dir -r requirements.txt

ENV POSTGRES_DSN=""
ENV FUNCTION=""
ENV DRY_RUN=""
ENV MANUAL_DEPLOY=""

ENTRYPOINT ["./application.py"]
