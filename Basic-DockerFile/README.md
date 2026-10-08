# Basic Dockerfile

I wrote a Dockerfile based on `alpine:latest` that prints a greeting to the console when run, with an optional build-time argument to customize the name.

Project URL: https://roadmap.sh/projects/basic-dockerfile

## Dockerfile

```dockerfile
FROM alpine:latest
ARG NAME=Captain
ENV NAME=$NAME
CMD echo "Hello, $NAME!"
```

- `FROM alpine:latest` — uses the required base image
- `ARG NAME=Captain` — accepts an optional name at build time, defaulting to "Captain"
- `ENV NAME=$NAME` — carries the build-time argument into the container's runtime environment
- `CMD echo "Hello, $NAME!"` — prints the greeting when the container runs, then exits

## Steps

### 1. Install Docker

```bash
sudo apt update
sudo apt install docker.io -y
sudo systemctl enable --now docker
```

### 2. Build the image (default)

```bash
docker build -t basic-dockerfile .
```

### 3. Run it

```bash
docker run basic-dockerfile
```

Output:
```
Hello, Captain!
```

### 4. Build with a custom name (stretch goal)

```bash
docker build --build-arg NAME=Dishant -t basic-dockerfile .
docker run basic-dockerfile
```

Output:
```
Hello, Dishant!
```
