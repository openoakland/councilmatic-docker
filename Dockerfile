FROM postgres:9.6.5
MAINTAINER Phil Chin <ekkus93@gmail.com>

RUN apt-get update \
 && apt-get install -y \
    # general system dependencies
    wget screen lsb-core \
    # editors for dev purposes
    emacs vim nano \
    # python and pip system dependencies
    gdal-bin binutils libproj-dev python3-pip \
    build-essential libssl-dev libffi-dev python3-dev \
    python3-lxml python3-matplotlib libpq-dev python-dev \
    python3-gdal libxml2-dev libxslt-dev \
    # postgresql extensions
    postgresql-9.6-postgis-2.4 \
 && rm -rf /var/lib/apt/lists

# upgrade setuptools first, see:
#   https://github.com/ansible/ansible/issues/31741#issuecomment-336889622
RUN pip3 install --upgrade setuptools \
 && pip3 install cffi cryptography==2.1.1 virtualenv

# home dir
RUN mkdir -p /home/postgres/scripts /home/postgres/work
RUN usermod -d /home/postgres postgres

# set bash shell
RUN chsh -s /bin/bash postgres

COPY ./setup_db.sh /home/postgres/scripts/setup_db.sh
COPY ./requirements.txt /home/postgres/scripts/requirements.txt
COPY ./setup_env.sh /home/postgres/scripts/setup_env.sh

RUN chown -R postgres /home/postgres

# postgres user set up
USER postgres

WORKDIR "/home/postgres/work"

# fix term
RUN echo "\nexport TERM=xterm\n" >> /home/postgres/.bashrc

# add alias for source
RUN echo "\nalias source_councilmatic='source /home/postgres/councilmatic/bin/activate'\n" >> /home/postgres/.bashrc

# set database connection
RUN echo "\nexport DATABASE_URL=postgresql:///opencivicdata\n" >> /home/postgres/.bashrc

RUN cd /home/postgres && virtualenv -p /usr/bin/python3 councilmatic 
RUN bash /home/postgres/scripts/setup_env.sh

USER root

VOLUME  ["/home/postgres/work"]

EXPOSE 5432 8888

COPY ./version.txt /tmp/version.txt
