# dev-container-base

A container with my basic dev tools running on Ubuntu. It does not have any languages or their specific tools installed. This could be used as a base image for developing in a specific language.

## Starting

The container exposes SSH and drops the authorized_keys file from the repository into the container. That's great for me, not so much for you. Unless you're me, or one of the other authorized persons in that file. Or if you've stolen their private key!

The point is, you can make the exposed SSH port accessible to the outside world and log in by having the correct key.

I start it like so:
```bash
docker run -d -p 0.0.0.0:12345:22 dpetersen/dev-container-base:latest
```

*You'll probably want to add some volume mounts to that command, so that your code isn't cloned inside of the container and potentially lost!*

Step 3: profit.

## Connecting

You have the running container, and now it's time to pair. Except you keep forgetting the IP address and the port and the username, and you're sick of having to copy your SSH private key over to the server. Do what the pros do and set up an alias! In `~/.ssh/config`, add something like this:

```
Host devbox
  HostName <YOUR IP OR HOSTNAME>
  Port <YOUR MAPPED SSH PORT FROM ABOVE>
  User root
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
