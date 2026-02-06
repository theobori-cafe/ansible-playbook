# My Debian deployment with Ansible playbook

[![ansible-lint](https://github.com/theobori-cafe/ansible-playbook/actions/workflows/ansible-lint.yml/badge.svg)](https://github.com/theobori-cafe/ansible-playbook/actions/workflows/ansible-lint.yml)

This GitHub repository contains Ansible resources to deploy all of my services on a Debian system.

## Getting started

To use this Ansible playbook, you will need the Ansible roles, which can be downloaded from Ansible Galaxy. You can run the following command line.

```sh
ansible-galaxy install -r requirements.yml
```

We recommend setting up an inventory and replacing the variables available in the files in [group_vars/all](/group_vars/all). Below is an example of launching the Ansible playbook from the project root with certain tags selected.

```sh
ansible-playbook \
   -i inventory.yml \
   -e @my_variables.yml \
   -t gitea,searxng main.yml
```

Some services are not restarted at runtime on purpose, because they need administrator configuration like `Uptime-Kuma` or `Nextcloud`. If you want to access them, you should do a SSH bridge with OpenSSH like below.

```sh
ssh \
   -L ssh_local_port:127.0.0.1:ssh_remote_port \
   -N -f ssh_user@ssh_server
```

## The knockd risks

In this configuration, we are using `knockd` to manage the openSSH firewall (`ufw`) rules. It can be very risky. If you want to be safe you can exclude the `knockd` task by commenting the following line in [roles/security/tasks/main.yml](roles/security/tasks/main.yml):

```sh
- include_tasks: knockd.yml
```

And then add a rule for `ufw` that allow you SSH connections.

## Roles and variables

Below is an overview of the roles available in the Ansible playbook.
- **`nickjj.docker`**: Setup and configure Docker + docker-compose.
- **`weareinteractive.ufw`**: Setup the firewall and configure it.
- **`base`**: Install basics needed packages for the other roles.
- **`profile`**: Setup some default configuration for new users.
- **`security`**: Setup system security tools/services like ssh, knockd, etc.
- **`shell`**: Setup a shell environment with fish + tmux.
- **`meta_service`**: Meta role to setup a service.
- **`nginx`**: Setup NGINX for the differents services created from the **`services`** role.
- **`tor`**: Setup a tor hidden service for every services.
- **`magic`**: Setup the magic stuff, including shell scripts, cron jobs, etc. for backup and web server statistics reporting.
- **`service roles`**: Each service role like **`gitea`** is based on the **`service`** role.
- **`monitoring`**: Setup the monitoring stack based on Prometheus and Grafana.


## Potential improvements

One potential improvement is to upload my customized Docker images to public container image registries so that they can be retrieved from the Debian system.
