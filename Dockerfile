FROM python:3.10 as BASE
ENV VIRTUAL_ENV=/venv \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    POETRY_VERSION=1.1.13

COPY poetry.lock pyproject.toml ./

RUN pip install "poetry==$POETRY_VERSION"
RUN python3 -m venv $VIRTUAL_ENV

ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN poetry install --no-interaction --no-ansi --no-dev

FROM python:3.10.4-slim-buster

RUN apt-get update -y && apt-get upgrade -y
RUN apt install -y python3-dev \
    libpq-dev

ENV VIRTUAL_ENV=/venv \
    PYTHONUNBUFFERED=1

COPY --from=BASE /venv /venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

WORKDIR /usr/src/app

COPY Exchange/ Exchange/
COPY manage.py manage.py

CMD []
