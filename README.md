Role Name
=========

Ansible Role for deploying and configuring a Wireguard VPN on a Ubuntu EC2 instance

Requirements
------------

An EC2 Ubuntu instance

Role Variables
--------------

SCRIPT_SRC - the path of configure-wireguard.sh, a bash script used to configure Wireguard ( as doing this from Ansible was too troublesome). The configuration is custom for my setup, so you will need to modify the PUBKEY on the configure-wireguard script and, if using another private IP range for the client modify interface address and allowed IPs as well.

Dependencies
------------
N/A

Example Playbook
----------------

    - hosts: servers
      roles:
         - j0rdan0.wireguard

License
-------

GPL-2.0-or-later

Author Information
------------------

https://github.com/j0rdan0

https://acidburn.me

@j0rdan0 ( Twitter)
