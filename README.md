# dev-container-base

[![Docker Hub](https://img.shields.io/badge/docker-ready-blue.svg)](https://registry.hub.docker.com/u/dpetersen/dev-container-base/)
[![](https://badge.imagelayers.io/dpetersen/dev-container-base.svg)](https://imagelayers.io/?images=dpetersen/dev-container-base:latest 'Get your own badge on imagelayers.io')

A container with my basic dev tools running on Ubuntu. It does not have any languages or their specific tools installed. This could be used as a base image for developing in a specific language. Access is via SSH with the account `dev`, which has sudo.

## Starting

The container exposes SSH and uses [GitHub's public key API](https://developer.github.com/v3/users/keys/) to add the keys for authorized users to `~/.ssh/authorized_keys` for the `dev` account. You must specify all of the allowed GitHub usernames as the `AUTHORIZED_GH_USERS` environment variable during `docker run`. Here's an example:

I start it like so:
```bash
docker run -d \
  -e AUTHORIZED_GH_USERS="dpetersen,otherperson" \
  -p 0.0.0.0:31981:22 \
  dpetersen/dev-container-base:latest
```

If the GitHub API is down or the user doesn't exist / has no keys, you'll get an error.

*You'll probably want to add some volume mounts to that command, so that your code isn't cloned inside of the container and potentially lost!*

Step 3: profit.

## Connecting

You have the running container, and now it's time to pair. Except you keep forgetting the IP address and the port and the username, and you're sick of having to copy your SSH private key over to the server. Do what the pros do and set up an alias! In `~/.ssh/config`, add something like this:

```
Host devbox
  HostName <YOUR IP OR HOSTNAME>
  Port <YOUR MAPPED SSH PORT FROM ABOVE>
  User dev
  ForwardAgent true
# Feel free to leave this out if you find it unsafe. I tear down
# my dev box frequently and am sick of the warnings about the 
# changed host.
  StrictHostKeyChecking no
  UserKnownHostsFile=/dev/null
```

And now can:

```bash
ssh devbox
```

And everything is magically handled for you! You may have to configure your SSH client to allow SSH forwarding, but it will allow you to `git push` to private repositories without having to authenticate every time, and without copying your key to the server (where it can be lost if the container stops).

## Development

Since I build images roughly once per year, I need to remind myself how to do it. A few Top Tips below:

#### Building

```bash
docker build .
```
*Did you update something that won't trigger a Dockerfile change, like push to your vimfiles? Use the `--no-cache` flag.*

#### Tagging

```bash
docker tag <YOUR SHA HERE> dpetersen/dev-container-base:v1
```

*Don't forget to tag `latest`! It's a manual process, not magic!*

#### Pushing

```bash
docker push dpetersen/dev-container-base
```
