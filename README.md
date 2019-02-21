# os-lts18
**os-lts18** is a os base image based on an Ubuntu LTS 18.04 system with systemd enabled (systemctl-replacement solution). It can be used as server image when simulating environments using docker (for example for developing/testing ansible playbooks).

# content
the following programs & tools are included and enabled by default:

### /sbin/init as default command
that allows us to run services via systemd like on normal servers

### preinstalled OS packages
the following packages have been explicitely installed:
- ansible
- curl
- git
- htop
- net-tools
- openssh-client
- openssh-server
- python2-pip
- rsync
- sudo


# usage

### example of use within a service
see `tests/docker-compose.yml` for an example compose file using this image as both **control** ans **target** servers.


### working with the test service
```bash
cd tests
#> docker-compose up -d
Creating network "tests_default" with the default driver
Creating server1 ... done
Creating ansible ... done

#> docker-compose ps
 Name      Command     State   Ports
-------------------------------------
ansible   /sbin/init   Up      22/tcp
server1   /sbin/init   Up      22/tcp

#> docker-compose exec ansible bash
[root@ansible /]#

[root@ansible /]# ansible -i server1, all -m ping
server1 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```
