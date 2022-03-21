PostgreSQL Master/Slave
=========

PostgreSQL 12 on one or two RHEL/Centos boxes.

Requirements
------------
Internet. RedHat Linux 7 or 8, or Centos 7 or 8.

This role wast tested with molecule:


Role Variables
--------------
The first three vars you must set, the others are optional.


1. `base_postgres_mip`  # This is the ip address of the primary/master database
1. `base_postgres_user` # This is your user
1. `base_postgres_pass` # This is your password
 
1. `base_postgres_net`  # 192.168.20.0/24 This is the subnet granted access
1. `base_postgres_role` # With 2 hosts the one is primary, the other replica
1. `base_postgres_sip`  # The ip address of the replica when you use 2 databases


Dependencies
------------
RedHat-like Linux

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables
passed in as parameters) is always nice for users too:

# Inventory
[dataservers]
data1 role=primary
data2 role=replica

# Example playbook for dbserver tier

---yaml
- name: 'dbservers.yml'
  hosts: dbservers
  become: yes
  gather_facts: True
  
  vars_files:
    - dbservers/secrets.yml

  pre_tasks:
    - include: dbservers/pre_tasks.yml

  roles:
    - dockpack.base_postgres_role
    - rsyslog

  tasks: []

  post_tasks:
    - include: dbservers/post_tasks.yml
```
License
-------

BSD, MIT

Author Information
------------------
http://twitter.com/bbaassssiiee
https://github.com/dockpack/base_postgres_role.git

