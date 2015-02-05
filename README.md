# dev-container-base

A container with my basic dev tools running on Ubuntu. It does not have any languages or their specific tools installed. This could be used as a base image for developing in a specific language.

## Usage

The container exposes SSH, but using a password that is completely insecure and also in the source of the Dockerfile. I'll, uh, deal with that later. The point is, you shouldn't make this container's SSH server reachable from the outside world.

I start it like so:
```bash
docker run -d -p 127.0.0.1:31981:22 dpetersen/dev-container-base:latest
```

*You'll probably want to add some volume mounts to that command, so that your code isn't cloned inside of the container and potentially lost!*

And then access it by first SSHing to the Docker host, and then running something like:
```bash
ssh -A -o "StrictHostKeyChecking no" -o "UserKnownHostsFile /dev/null" -o "PasswordAuthentication yes" root@localhost -p 31981
```

Step 3, profit.

## Development

Since I build images roughly once per year, I need to remind myself how to do it. A few Top Tips below:

Building:
```bash
docker build .
```

Tagging:
```bash
docker tag <YOUR SHA HERE> dpetersen/dev-container-base:v1
```

Pushing:
```bash
docker push dpetersen/dev-container-base
```
