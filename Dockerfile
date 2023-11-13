ARG PYTHON_VERSION=3.11.5-slim-bookworm

# define an alias for the specfic python version used in this file.
FROM python:${PYTHON_VERSION} as python

FROM python as python-build-stage

# Install apt packages
RUN apt-get update && apt-get install --no-install-recommends -y build-essential


# Requirements are installed here to ensure they will be cached.
COPY ./requirements.txt ./requirements-dev.txt /

# Create Python Dependency and Sub-Dependency Wheels
RUN pip wheel --wheel-dir /usr/src/app/wheels  \
  -r requirements.txt \
  -r requirements-dev.txt

FROM python as python-run-stage

ARG APP_HOME=/app

ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1
EXPOSE 8080

WORKDIR ${APP_HOME}

COPY --from=python-build-stage /usr/src/app/wheels /wheels/

# use wheels to install python dependencies
RUN pip install --no-cache-dir --no-index --find-links=/wheels/ /wheels/* \
	&& rm -rf /wheels/

COPY ./entrypoint /entrypoint
RUN sed -i 's/\r$//g' /entrypoint && chmod +x /entrypoint


FROM python-run-stage AS backend

# copy application code to WORKDIR
COPY . ${APP_HOME}

# RUN python demo/manage.py collectstatic --noinput
ENTRYPOINT [ "/entrypoint" ]
CMD ["gunicorn", "-c", "docker/gunicorn.py", "demo.demodesk.config.wsgi:application"]
