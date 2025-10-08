# MySQL docker compose
`docker compose up -d mysql`

# MySQL (using your credentials)
`docker exec -it general_mysql mysql -u root -proot -D general`
# Or from host machine:
`mysql -u root -proot -h 127.0.0.1 -P 3306 general`

```aiignore
docker exec -it general_mysql mysql -u root -proot -h127.0.0.1 bank
docker exec -it general_mysql mysql -u root -p
source /home/scripts/check.sql
USE bank;
source /home/scripts/01_learning_mysql/chapter
docker exec -it general_mysql mysql -u root -proot -Dbank
```


# PostgreSQL
`docker exec -it general_postgres psql -U app_user -d general`
# Or from host machine:
`psql -U app_user -d bank -h 127.0.0.1 -p 5432`

# MongoDB
`docker exec -it general_mongodb mongosh -u root -p root --authenticationDatabase admin`
# Or from host machine:
`mongosh -u root -p root --authenticationDatabase admin --port 27017`

# Redis
`docker exec -it general_redis redis-cli -a redis_password`
# Or from host machine:
`redis-cli -h 127.0.0.1 -p 6379 -a redis_password`

```aiignore
#  # Connect to Redis using redis-cli
#   docker exec -it general_redis redis-cli -a redis_password

#  # Connect without auth (if no password)
#   docker exec -it general_redis redis-cli
#
#  # Monitor Redis in real-time
#   docker exec -it general_redis redis-cli -a redis_password monitor

#  # Check Redis info
#  docker exec -it general_redis redis-cli -a redis_password info

#  # Execute Redis script
#  docker exec -it general_redis redis-cli -a redis_password < /scripts/your_script.redis

```

### .env
```

# MariaDB environment variables
MARIADB_PORT=3306
# Database details
MARIADB_DATABASE=general
MARIADB_USER=user
MARIADB_PASSWORD=password
MARIADB_ROOT=root
MARIADB_ROOT_PASSWORD=root

# MySQL environment variables
MYSQL_PORT=3306
# Database details
MYSQL_DATABASE=general
MYSQL_USER=user
MYSQL_PASSWORD=password
MYSQL_ROOT=root
MYSQL_ROOT_PASSWORD=root

# PostgreSQL
POSTGRES_PORT=5432
POSTGRES_DB=general
POSTGRES_USER=app_user
POSTGRES_PASSWORD=app_password
POSTGRES_ROOT_PASSWORD=root

# MongoDB
MONGODB_PORT=27017
MONGODB_DATABASE=general
MONGODB_ROOT_USERNAME=root
MONGODB_ROOT_PASSWORD=root

# Redis
REDIS_PORT=6379
REDIS_PASSWORD=redis_password

MARIADB_PORT_EXTERN=3308
MYSQL_PORT_EXTERN=3307
POSTGRES_PORT_EXTERN=5433
MONGODB_PORT_EXTERN=27018
REDIS_PORT_EXTERN=6380
```
