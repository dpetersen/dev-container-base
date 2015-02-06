FROM ubuntu:latest
MAINTAINER Don Petersen <don@donpetersen.net>

# Install a few dependencies
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y openssh-client vim git build-essential

# My tmux plugins (which make my config less insane) require tmux 1.9, so....
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y python-software-properties software-properties-common && \
  add-apt-repository -y ppa:pi-rho/dev && \
  apt-get update && \
  apt-get install -y tmux=1.9a-1~ppa1~t

# Set up for pairing with wemux. 
RUN sudo git clone git://github.com/zolrath/wemux.git /usr/local/share/wemux && \
  sudo ln -s /usr/local/share/wemux/wemux /usr/local/bin/wemux && \
  sudo cp /usr/local/share/wemux/wemux.conf.example /usr/local/etc/wemux.conf && \
  echo "host_list=(root)" >> /usr/local/etc/wemux.conf

# Set up The Editor of the Gods
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y ruby
RUN gem install homesick --no-rdoc --no-ri
RUN homesick clone dpetersen/vimfiles
RUN homesick symlink vimfiles

# Set up shell
RUN homesick clone dpetersen/zshfiles
RUN homesick symlink zshfiles
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y zsh
RUN chsh -s /usr/bin/zsh root

# Install a couple of helpful utilities
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y ack-grep
RUN gem install git-duet --no-rdoc --no-ri
ADD https://github.com/zimbatm/direnv/releases/download/v2.5.0/direnv.linux-amd64 /usr/local/bin/direnv
RUN chmod 755 /usr/local/bin/direnv

# Set up SSH. We copy in some known good keys (not exactly helping the
# reusability of this image, but greatly helping me get up and running
# quickly...), and setting up SSH forwarding so that transactions like git pushes
# from the container happen magically.
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y openssh-server && \
  mkdir /var/run/sshd && \
  echo "AllowAgentForwarding yes" >> /etc/ssh/sshd_config
ADD authorized_keys /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys

# Expose the SSH port, and run the SSH server by default when this image is
# daemonized.
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
