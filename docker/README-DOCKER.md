# Running unit tests

In this directory, run 

```
docker build -t flutterdocker .
```

## Run tests again
```
docker build --build-arg CACHEBUST="git rev-parse v1.0.0_M2" --progress=plain -t flutterdocker .
```