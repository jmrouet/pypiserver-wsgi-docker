############################################################
# Dockerfile to build pypiserver App
# Based on
############################################################

# Set the base image
FROM debian:bullseye-slim

# File Author / Maintainer
# LABEL image.author="jm.rouet"

RUN apt-get update && apt-get install -y apache2 \
    libapache2-mod-wsgi-py3 \
    python3 \
    python3-pip \
    python3-venv \
    && apt-get clean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

# create pip-repo user
RUN adduser --disabled-password pip-repo 

# Copy over and install the requirements
COPY ./requirements.txt /home/pip-repo/requirements.txt
RUN su - pip-repo -c "python3 -m venv /home/pip-repo/venv && /home/pip-repo/venv/bin/python3 -m pip install -r /home/pip-repo/requirements.txt"

# Create the package directory
RUN su - pip-repo -c "mkdir /home/pip-repo/packages"

# Copy over the apache configuration file and enable the site
COPY ./apache-pypiserver.conf /etc/apache2/sites-available/apache-pypiserver.conf
# Copy over the wsgi file, run.py and the app
COPY ./pypiserver-wsgi.py /var/www/apache-pypiserver/

RUN a2dissite 000-default.conf
RUN a2ensite apache-pypiserver.conf
RUN a2enmod headers

# LINK apache config to docker logs.
RUN ln -sf /proc/self/fd/1 /var/log/apache2/access.log && \
    ln -sf /proc/self/fd/1 /var/log/apache2/error.log

EXPOSE 80

WORKDIR /var/www/apache-pypiserver

CMD  /usr/sbin/apache2ctl -D FOREGROUND
