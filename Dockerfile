FROM python:3.11-apline
LABEL maintainer='codeBuddha'

ENV PYTHONUNBUFFERED 1

RUN mkdir -p vol/web/media && \
	mkdir -p vol/web/static

COPY ./requirements.txt /tmp/requirements.txt
COPY . /app

WORKDIR /app

EXPOSE 8000

RUN apk add --no-cache \
	postgres-client \
	jpeg-dev \
	gcc \
	linux-headers \
	postgresql-dev \
	build-base && \
	python -m venv /py && \
	py/bin/pip install --upgrade pip && \
	py/bin/pip install -r /tmp.requirements.txt && \
	# add user
	adduser \
	--disabled-password \
	--no-create-home \
	dev && \
	# then create dirs and set permissions
	cp ./static/default-placeholder.jpg /vol/web/static/default-placeholder.jpg && \
	chown -R dev:dev /vol && \
	chmod -R 755 /vol && \
	apk del gcc musl-dev libc-dev linux-headers build-base && \
	rm -rf /tmp

ENV PATH="/py/bin:$PATH"

USER dev

CMD ["sh", "run.sh"]
