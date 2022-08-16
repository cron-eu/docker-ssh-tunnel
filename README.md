# Docker SSH Tunnel

This Docker creates a simple SSH tunnel over a server. It is very useful when your container needs
to access to an external protected resource. In this case this container might behave like a proxy
to outer space inside your Docker network.

Configured completely via ENV variables

## Configuration

Copy `.env.example` to `.env.docker` or use these settings in your `docker-compose.yaml`:

* `SSH_CONFIG`: The whole content of the `.ssh/config` file
* `SSH_KNOWN_HOSTS`: The whole content of the `.ssh/known_hosts` file
* `SSH_PRIVATE_KEY`: The SSH private key (in PEM format)
* `TUNNEL_HOST`: A ssh host with the configured tunnel specification, configured in the SSH_CONFIG

## Setup for a tunnel

You configure the whole tunnel setup in your `SSH_CONFIG` (you can also use multiple
hops, etc):
```
SSH_CONFIG="
Host mysql-tunnel
	HostName tunnel-hop.tld
	User tunnel-user
	LocalForward 3306 tunneled-sql.corporate.internal.tld:3306

	#LogLevel VERBOSE
	#StrictHostKeyChecking no
	ExitOnForwardFailure yes
	ForwardAgent yes
	TCPKeepAlive yes
	ConnectTimeout 5
	ServerAliveCountMax 10
	ServerAliveInterval 15
"
```

## Using with `docker-compose.yml`

```yaml
  version: '2'
  services:
    mysql:
      image: cron-eu/ssh-tunnel
      env_file:
        - .env.docker
      environment:
        TUNNEL_HOST: mysql-tunnel
```

After you start up docker containers, any container in the same network will be able to access to
tunneled mysql instance using ```tcp://mysql:3306```. Of course you can also expose port 3306 to
be able to access to tunneled resource from your host machine.
