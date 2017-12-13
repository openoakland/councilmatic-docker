FROM postgres:9.6.5
MAINTAINER Phil Chin <ekkus93@gmail.com>

RUN apt-get update && apt-get upgrade -y 
RUN apt-get install wget screen -y
RUN apt-get install lsb-core -y

#emacs
# update again otherwise emacs might fail to install
RUN apt-get update && apt-get upgrade -y 
RUN apt-get install emacs -y --fix-missing

# python
RUN apt-get remove --auto-remove gdal-bin -y
RUN apt-get install binutils libproj-dev gdal-bin -y

RUN apt-get install -y python3-pip
RUN pip3 install --upgrade setuptools
RUN apt-get install build-essential libssl-dev libffi-dev python3-dev
RUN pip3 install cffi
#RUN pip3 install Cython
RUN pip3 install cryptography==2.1.1
RUN pip3 install virtualenv
RUN apt-get install python3-lxml -y 

# postgis
RUN apt-get install postgresql-9.6-postgis-2.4 -y

# gdal
#RUN add-apt-repository ppa:ubuntugis/ubuntugis-unstable
RUN apt-get update
RUN apt-get install libpq-dev python-dev -y
RUN apt-get install gdal-bin python3-gdal -y

# xml stuff
RUN apt-get -y install libxml2-dev libxslt-dev

# text editors
RUN apt-get install vim nano -y

# home dir
RUN mkdir -p /home/postgres/scripts
RUN mkdir -p /home/postgres/work
RUN usermod -d /home/postgres postgres

# set bash shell
RUN chsh -s /bin/bash postgres

COPY ./setup_db.sh /home/postgres/scripts/setup_db.sh
COPY ./requirements.txt /home/postgres/scripts/requirements.txt
COPY ./setup_env.sh /home/postgres/scripts/setup_env.sh
RUN chown -R postgres /home/postgres

# postgres user set up
USER postgres

# fix term
RUN echo "\n\nexport TERM=xterm\n\n" >> /home/postgres/.bashrc

# set database connection
RUN echo "\n\nexport DATABASE_URL=postgresql:///opencivicdata\n\n" >> /home/postgres/.bashrc

RUN cd /home/postgres && virtualenv -p /usr/bin/python3 councilmatic 
RUN bash /home/postgres/scripts/setup_env.sh

USER root

VOLUME  ["/home/postgres/work"]

