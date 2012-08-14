# /etc/postfix/main.cf
default['postfix']['dkim_socket'] = 'inet:localhost:8891' # Ubuntu default - listen on loopback on port 8891

# Enable dkim
default['postfix']['dkim_enabled'] = false 
