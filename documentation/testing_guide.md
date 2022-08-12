## Testing with docker

Prerequisites: Docker is [installed](https://docs.docker.com/get-docker/).

```
cd docker
docker build -t flutterdocker .
```

Note: The docker build also runs the unit tests, and fails if the unit tests fail.

The docker build can be run repeatedly - the results are cached, but the cache is invalidated any time there's an update to the code repository so if there is new code, the tests run again. 
