# dev-container-base

A container with my basic dev tools running on Ubuntu. It does not have any languages or their specific tools installed. This could be used as a base image for developing in a specific language.

## Usage

The container exposes SSH and drops the authorized_keys file from the repository into the container. That's great for me, not so much for you. Unless you're me, or one of the other authorized persons in that file. Or if you've stolen their private key!

The point is, you can make the exposed SSH port accessible to the outside world and log in by having the correct key.

I start it like so:
```bash
docker run -d -p 0.0.0.0:31981:22 dpetersen/dev-container-base:latest
```

*You'll probably want to add some volume mounts to that command, so that your code isn't cloned inside of the container and potentially lost!*

Step 3, profit.

## Development

Since I build images roughly once per year, I need to remind myself how to do it. A few Top Tips below:

Building:
```bash
docker build .
```
*Did you update something that won't trigger a Dockerfile change, like push to your vimfiles? Use the `--no-cache` flag.*

Tagging:
```bash
docker tag <YOUR SHA HERE> dpetersen/dev-container-base:v1
```

Pushing:
```bash
docker push dpetersen/dev-container-base
```
