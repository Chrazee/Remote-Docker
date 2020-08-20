# Remote-Docker
Setup [Remote](https://github.com/Chrazee/Remote) via Docker environment.  

# Start services
First, change the MySQL environment variables in the `.env` file, which is located in the root folder.

And run the following commands:
```shell script
docker-compose build
docker-compose up -d
```

# Log In
Host: http://127.0.0.1:80  
Default username: remote  
Default password: remote

# Troubleshooting
If something went wrong with the first start, re-run the helper service with the following command:
```shell script
docker-compose run --rm helper
```

# Extras
A thermometer device simulator
