#
# Nginx, with Python and j2cli to evaluate Jinja2 templates.
#

FROM nginx

RUN apt-get update && \
    apt-get install -y python-setuptools && \
    easy_install j2cli && \
    apt-get purge -y --auto-remove && rm -rf /var/lib/apt/lists/*

# Templates for config files
RUN mkdir /templates
COPY nginx.conf.j2 /templates/
COPY ./docker-entrypoint.sh /

EXPOSE 80 443
CMD ["nginx"]
ENTRYPOINT ["/docker-entrypoint.sh"]
