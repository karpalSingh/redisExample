## redisExample
Backend Example using Redis for SpringBoot

## Goals:
1) Set up a springboot project to access redis
2) Preform CRUD operations in the redis cache

## Executions:
Unit Test: mvn clean test  
Unit Test with reports: mvn clean test surefire-report:report  
Build Jar: mvn clean package -DskipTests  
Build Docker Image for local testing: docker build -t redisexample:0.1 .  
Run Docker Image locally for testing: docker run -d --name redisEx -p 8080:8281 redisexample:0.1

## Points to note:
BuildKit has issues to logs more than 1Mib:
Solution: Refer to https://iamsulavshrestha.wordpress.com/2021/06/20/docker-image-build-output-clipped-log-limit-1mib-reached/
1) Go to /lib/systemd/system/docker.service
2) Add under [Service], Environment="BUILDKIT_STEP_LOG_MAX_SIZE=10000000"
3) Add under [Service], Environment="BUILDKIT_STEP_LOG_MAX_SPEED=10000000"
