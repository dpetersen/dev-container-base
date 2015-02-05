FROM ubuntu:latest

# Install a few dependencies
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y openssh-client vim git

# Set up for pairing with wemux
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y tmux
RUN sudo git clone git://github.com/zolrath/wemux.git /usr/local/share/wemux && \
  sudo ln -s /usr/local/share/wemux/wemux /usr/local/bin/wemux && \
  sudo cp /usr/local/share/wemux/wemux.conf.example /usr/local/etc/wemux.conf && \
  echo "host_list=(root)" >> /usr/local/etc/wemux.conf

# So, like, make sure you can't SSH into this container from outside. I'm SSH'ing
# into the docker host and then into the container. P.S. I should figure something
# else out there.
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y openssh-server && \
  mkdir /var/run/sshd && \
  echo 'root:notquitesecure' | chpasswd && \
  sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN echo "AllowAgentForwarding yes" >> /etc/ssh/sshd_config

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

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
