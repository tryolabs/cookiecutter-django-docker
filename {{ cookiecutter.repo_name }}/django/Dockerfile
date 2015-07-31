FROM buildpack-deps

RUN apt-get update && \
    apt-get install -y netcat-openbsd python-dev python-pip vim && \
    apt-get purge -y --auto-remove && rm -rf /var/lib/apt/lists/*

ENV HOME /root
COPY ./bashrc /root/.bashrc

# Make sure we use latest pip
RUN pip install --upgrade pip

# Tiny tool to do variable substitution from env variables
RUN pip install j2cli

# Install requirements first, so Docker does not do it every time
# there are changes in . (uses cache)
COPY requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

# Add directory with the code of the Django app.
# In dev environments, directory will be included as a volume on runtime
# so this doesn't matter.
COPY . /django
WORKDIR /django

COPY ./gunicorn-entrypoint.sh /

# All the static files will be collected to this directory
ENV DJANGO_SETTINGS_STATIC_ROOT /static
VOLUME ["/static"]

ENTRYPOINT ["/gunicorn-entrypoint.sh"]
