Role Name
=========

```docker-vms``` is an Ansible Role which can be used to create a set of Docker containers, running an ssh daemon, allowing them to be used to simulate virtual machines.

The role is intended to be used in Ansible trainings, working with pseudo-vms allowing fast creation/deletion to quickly get started on Ansible without the need for cloud/hypervisor setup or credentials, or the associated costs.

Requirements
------------

Docker must already be installed

Role Variables
--------------

#### Settable variables for this role.

**Defaults** are marked as ```[default]```:

- NUM_VMS [1]:       how many *vms* (containers) to create
- IP_START_IDX [10]: starting ip address suffix, e.g. 
- PREFIX ["host"]:   prefix to use on containers and network name
- SUBNET_PART ["172.32.0"]: 
- CIDR_LEN    [24]:

#### Example usage:

e.g.
   ``` ./run_play.sh -lab 3 5```

would run the play-docker-vms.yaml playbook as

    ```ansible-playbook -e PREFIX=lab3 -e NUM_VMS=5 -e SUBNET_PART="172.32.5" -i localhost, play-docker-vms.yaml```

This would create the following containers (*vms*):
- lab3-1 on ip 172.32.5.11
- lab3-2 on ip 172.32.5.12
- lab3-3 on ip 172.32.5.13
- lab3-4 on ip 172.32.5.14
- lab3-5 on ip 172.32.5.15

#### Variables, to leave as is (for now):

- IMAGE_NAME ["mjbright/ubuntu-sshd"]
- IMAGE_TAG  ["0.1"]

- SSH_KEY_FILE [~/.ssh/id_ed25519]
- SSH_USER     ["ansible"]
- EXTRA_OPTS   [""]
- RUN_OPTS:   [""]

<!--
Dependencies
------------

A list of other roles hosted on Galaxy should go here, plus any details in regards to parameters that may need to be set for other roles, or variables that are used from other roles.

-->

Example Playbook
----------------

```
---
# tasks file for docker-vms
- name: Configure docker-vms
  hosts: localhost
  connection: local
  become: no
  vars:
    clean: false
  roles:
    - docker-vms
```

**Note:** when used with ```-t clean -e clean=true``` this will delete all containers/networks corresponding to the PREFIX value

License
-------

BSD

<!--
Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).
-->


