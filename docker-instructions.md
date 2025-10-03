# MySQL (using your credentials)
docker exec -it learning_mysql mysql -u root -proot -D bank
# Or from host machine:
mysql -u root -proot -h 127.0.0.1 -P 3306 bank

```aiignore
docker exec -it learning_mysql mysql -u root -proot -h127.0.0.1 bank
docker exec -it learning_mysql mysql -u root -p
source /home/scripts/check.sql
USE bank;
source /home/scripts/01_learning_mysql/chapter
docker exec -it learning_mysql mysql -u root -proot -Dbank
```


# PostgreSQL
docker exec -it learning_postgres psql -U app_user -d bank
# Or from host machine:
psql -U app_user -d bank -h 127.0.0.1 -p 5432

# MongoDB
docker exec -it learning_mongodb mongosh -u root -p root --authenticationDatabase admin
# Or from host machine:
mongosh -u root -p root --authenticationDatabase admin --port 27017

# Redis
docker exec -it learning_redis redis-cli -a redis_password
# Or from host machine:
redis-cli -h 127.0.0.1 -p 6379 -a redis_password

```aiignore
#  # Connect to Redis using redis-cli
#   docker exec -it learning_redis redis-cli -a redis_password

#  # Connect without auth (if no password)
#   docker exec -it learning_redis redis-cli
#
#  # Monitor Redis in real-time
#   docker exec -it learning_redis redis-cli -a redis_password monitor

#  # Check Redis info
#  docker exec -it learning_redis redis-cli -a redis_password info

#  # Execute Redis script
#  docker exec -it learning_redis redis-cli -a redis_password < /scripts/your_script.redis

```

