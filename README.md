# councilmatic-docker
Docker instance for councilmatic-scraper

## Quickstart

###  Make sure you have Docker installed for your OS
1. https://www.docker.com/

### Edit volumes docker-compose.yml for your local environment
1. Replace "<<local_db_data_dir>>" (Initially, this will be empty.)
2. Replace "<<local_councilmatic-scraper_git_repo_dir>>".
   a. https://github.com/openoakland/councilmatic-scraper

### Start docker instance with docker-compose
1. In directory with docker-compose.yml run:
```
docker-compose up
```

### Connect to your docker instance
1. Get the container id for your instance
```
docker ps
```
2. Log in as postgres
```
docker exec --it -u postgres <<container_id>> bash
```
3. Activate councilmatic-scraper virtualenv
```
source /home/postgres/councilmatic/bin/activate
```
4. cd into councilmatic-scraper repo directory
```
cd /home/postgres/councilmatic/work
```

### Initialize database (**Only run once**)
1. Run
```
cd /home/postgres/councilmatic/scripts
sh setup_db.sh
```

### Run pupa update (for Oakland)
1. Run
```
cd /home/postgres/councilmatic/work
pupa update oakland
```

