# councilmatic-docker
Docker instance for councilmatic-scraper.  

[//]: # (Image References)

[image1]: ./imgs/psequel.png "PSequel - New Window"
[image2]: ./imgs/docker_control.png "Docker Control"
[image3]: ./imgs/docker_app.png "Docker App"

## Initial Setup

First, make sure you have Docker installed.  If you do not have Docker installed, download and install it from [here](https://www.docker.com/community-edition).

Once you have Docker installed, you will need to create the following directories and clone the following repos:

1. Base councilmatic directory
2. Councilmatic scraper docker repo (this repo)
3. Postgres data directory
4. Councilmatic scraper 

### 1. Create base Councilmatic directory

Create directory:

```
mkdir -p ~/work/councilmatic
```

### 2. Clone Councilematic scraper docker repo

```
cd ~/work/councilmatic && git clone git@github.com:openoakland/councilmatic-docker.git
```

### 3. Make Postgres data directory

```
mkdir -p ~/work/councilmatic/councilmatic-scraper-data
```

### 4. Clone Councilematic scraper repo

```
cd ~/work/councilmatic && git clone git@github.com:openoakland/councilmatic-scraper.git
```

### Start docker instance with docker-compose
In directory with docker-compose.yml, run:
```
docker-compose up -d
```
**_To force downloading the latest version of the docker container:_**
```
docker-compose pull && docker-compose up -d
```

### 4. Connect to your docker instance

1. Log into the container
```
docker exec -it -u postgres `docker ps | grep councilmatic_scraper | cut -f1 -d ' '` bash
```
2. Activate councilmatic-scraper virtualenv
```
source_councilmatic
```

### 5. Initialize database (**Only run once**)

1. If you are not already in the councilmatic-scraper virtualenv, run the following command:
```
source /home/postgres/councilmatic/bin/activate
```
2. Run the initialize script.
```
cd /home/postgres/scripts && sh setup_db.sh
```
This will create the opencivicdata database for you and init it for US.  You do not have to run "createdb opencivicdata" or "pupa dbinit us".  It probably won't do any harm but it will give you errors.

After you have initialized your database, files should appear in your local db data directory. 

Shutdown the container
```
cd ~/work/councilmatic/councilmatic-docker && docker-compose down
```

Copy this postgres config file (See https://github.com/openoakland/councilmatic-docker/commit/a910f468afd0f7fac4bd479c6467d420da36b02c):
```
cp ~/work/councilmatic/councilmatic-docker/postgresql.conf ~/work/councilmatic-scraper-data
```

## Run pupa update (for Oakland)

1. Log into the container
```
docker exec -it -u postgres `docker ps | grep councilmatic_scraper | cut -f1 -d ' '` bash
```
2. Activate councilmatic-scraper virtualenv
```
source_councilmatic
```
3. Run pupa update
```
pupa update oakland
```

### Running Jupyter Notebook

1. Inside the container, start councilmatic-scraper virtualenv:
```
source_councilmatic
```
2. cd to your working directory (i.e. /home/postgres/work)
3. Run the following command:
```
jupyter notebook --no-browser --ip=0.0.0.0
```
4. You should see something like:
```
(councilmatic) postgres@dc9cd4f71cee:~/work$ jupyter notebook --no-browser --ip=0.0.0.0
[I 08:55:05.065 NotebookApp] Serving notebooks from local directory: /home/postgres/work
[I 08:55:05.066 NotebookApp] 0 active kernels
[I 08:55:05.066 NotebookApp] The Jupyter Notebook is running at:
[I 08:55:05.067 NotebookApp] http://0.0.0.0:8888/?token=2842b15e3c8460139a9d1d3ad2ce04cb53953e673da79fb2
[I 08:55:05.068 NotebookApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
[C 08:55:05.070 NotebookApp] 
    
    Copy/paste this URL into your browser when you connect for the first time,
    to login with a token:
        http://0.0.0.0:8888/?token=2842b15e3c8460139a9d1d3ad2ce04cb53953e673da79fb2
```
5. Copy url with token and replace "0.0.0.0" with "127.0.0.1".  Open the url with a web browser from your host.

### Shut down your docker instance
```
cd ~/work/councilmatic/councilmatic-docker && docker-compose down
```

You should do this to shut down the docker instance and release the volume mounts cleanly.  Don't just do "docker stop..."

### Clearing out your Postgres database

There might be some instances where you would want to clear out your database.  For instance, you might want to run pupa on a clean database for testing.  Here are the steps to do that:

1. First make sure that all of the docker instances are shutdown.  To see all of the docker instances which are currently running, do:
```
docker ps
```
2. If there are any instances running, cd into your councilmatic-docker directory and run:
```
cd ~/work/councilmatic/councilmatic-docker && docker-compose down
```
3. cd into your Postgres data directory and delete all of the files:
Go to the directory where your Postgres data directory is and do:
```
rm -rf ~/work/councilmatic/councilmatic-scraper-data && mkdir ~/work/councilmatic/councilmatic-scraper-data
```
_Replace "<<your Postgres data directory>>" with the name of your Postgres data directory.
4. cd into your councilmatic-docker directory and run the following command to start up the docker instances:
```
docker-compose pull && docker-compose up -d
```
5. The docker instances should be up and running at this point.  Follow the "Connect to your docker instance" instructions from above to connect to your database.
6. The database is uninitialized.  Follw the "Initialize database" instructions from above to initialize the database.
7. Shutdown container
```
cd ~/work/councilmatic/councilmatic-docker && docker-compose down
```
8. Copy this postgres config file (See https://github.com/openoakland/councilmatic-docker/commit/a910f468afd0f7fac4bd479c6467d420da36b02c):
```
cp ~/work/councilmatic/councilmatic-docker/postgresql.conf ~/work/councilmatic-scraper-data
```

### Connecting to Postgres remotely

*This is optional.*

If you're using a Mac, you can download the following app,
[PSequel](http://www.psequel.com/).

When you go to "File/New Window", you should see something like this:
![PSequel - New Window][image1]

To log in remotely to the Postgres database, use the following settings:

Name | Value 
-----|---------------
Host | 127.0.0.1 
Port | 7432
User | postgres  
Password | str0ng*p4ssw0rd 
Database | opencivicdata 

If you want to set a different password, you can change it in the docker-compose.yml file.

If you restarted your webserver environment and cannot connect to the database port, 6432, from your host, try restarting Docker.  See the "Gotchas" section below. 

# Gotchas

On Mac OS, Docker Compose has this bug where sometimes it doesn't release the mapped ports after you do "docker-compose down". 

1. Quit Docker from the menu bar:

![Docker Control][image2]

2. Restart it from Applications:

![Docker app][image3]

Docker might take a little while to restart.

3. Try starting up your webserver environment again
