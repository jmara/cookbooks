
# List all packages that you want to install on your base system
default[:defaults][:packages] = %w{ 
  openssh-server build-essential heirloom-mailx vim traceroute python-software-properties
  automake autoconf sysstat bc htop rcconf git-core screen rrdtool curl ntp
}