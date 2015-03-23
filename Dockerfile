FROM ubuntu:latest
MAINTAINER Don Petersen <don@donpetersen.net>

# Direnv install
ADD https://github.com/zimbatm/direnv/releases/download/v2.5.0/direnv.linux-amd64 /usr/local/bin/direnv
ADD authorized_keys /root/.ssh/authorized_keys

# Start by changing the apt output, as stolen from Discourse's Dockerfiles.
RUN echo "debconf debconf/frontend select Teletype" | debconf-set-selections &&\
# Probably a good idea
    apt-get update &&\

# Basic dev tools
    apt-get install -y openssh-client git build-essential vim ctags &&\

# My tmux plugins (which make my config less insane) require tmux 1.9, so....
    apt-get install -y python-software-properties software-properties-common &&\
    add-apt-repository -y ppa:pi-rho/dev &&\
# Update required because of the added PPA!
    apt-get update &&\
    apt-get install -y tmux=1.9a-1~ppa1~t &&\

# Set up for pairing with wemux.
    git clone git://github.com/zolrath/wemux.git /usr/local/share/wemux &&\
    ln -s /usr/local/share/wemux/wemux /usr/local/bin/wemux &&\
    cp /usr/local/share/wemux/wemux.conf.example /usr/local/etc/wemux.conf &&\
    echo "host_list=(root)" >> /usr/local/etc/wemux.conf &&\

# Set up The Editor of the Gods
    apt-get install -y ruby &&\
    gem install homesick --no-rdoc --no-ri &&\
    homesick clone dpetersen/vimfiles &&\
    homesick symlink vimfiles &&\
    
# Set up shell
    homesick clone dpetersen/zshfiles &&\
    homesick symlink zshfiles &&\
    apt-get install -y zsh &&\
    chsh -s /usr/bin/zsh root &&\

# Install a couple of helpful utilities
    apt-get install -y ack-grep &&\
    gem install git-duet --no-rdoc --no-ri &&\
    chmod 755 /usr/local/bin/direnv &&\

# Set up SSH. We copy in some known good keys (not exactly helping the
# reusability of this image, but greatly helping me get up and running
# quickly...), and setting up SSH forwarding so that transactions like git
# pushes from the container happen magically.
    apt-get install -y openssh-server &&\
    mkdir /var/run/sshd &&\
    echo "AllowAgentForwarding yes" >> /etc/ssh/sshd_config &&\
    chmod 600 /root/.ssh/authorized_keys &&\

# Fix for occasional errors in perl stuff (git, ack) saying that locale vars
# aren't set.
    locale-gen en_US en_US.UTF-8 && dpkg-reconfigure locales

# Expose the SSH port, and run the SSH server by default when this image is
# daemonized.
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
