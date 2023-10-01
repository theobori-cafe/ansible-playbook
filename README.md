# ☕ ansible-playbook

An Ansible playbook used to deploy theobori.cafe on a Debian system

## 📖 How to build and run ?

1. Install the dependencies 
   - ansible
   - ansible galaxy dependencies

```sh
ansible-galaxy install -r requirements.yml
```

2. Configure a vault password (a filepass is better)
3. Configure an inventory
4. Configure a playbook
   1. Inventory (if needed)
   2. Replace variables
   3. Encrypt the needed ones
5. Run the playbook

```sh
ansible-playbook \
   -i inventory.yml \
   --vault-password-file .vault_pass \
   main.yml
```

Some services are not restarted at runtime on purpose, because they need administrator configuration like `Uptime-Kuma` or `Joplin`. If you want to access them, you should do a SSH bridge with OpenSSH.

```sh
ssh \
   -L ssh_local_port:127.0.0.1:ssh_remote_port -N \
   -f ssh_user@ssh_server
```

## ⚠️ knockd risks

In this configuration, we are using `knockd` to manage the openSSH firewall (`ufw`) rules. It can be very risky. If you want to be safe you can exclude the `knockd` task by commenting the following line in [roles/security/tasks/main.yml](roles/security/tasks/main.yml):

```sh
- include_tasks: knockd.yml
```

And then add a rule for `ufw` that allow you SSH connections.

## ℹ️ Roles and variables

Roles:

- **`nickjj.docker`**: Setup and configure Docker + docker-compose
- **`weareinteractive.ufw`**: Setup the firewall and configure it
- **`base`**: Install basics needed packages for the other roles
- **`profile`**: Setup some default configuration for new users
- **`security`**: Setup system security tools/services like ssh, knockd, etc.
- **`shell`**: Setup a shell environment with fish + tmux
- **`services`**: Setup the Linux services
- **`nginx`**: Setup NGINX for the differents services created from the **`services`** role
- **`tor`**: Setup a tor hidden service for every services

Variables:
- **`ssh_identity_key_path`**: SSH public key used to auth
- **`ssh_port`**: Change the default SSH port
- **`knockd_open_ssh_seq`**: Knockd open SSH (should be encrypted)
- **`knockd_close_ssh_seq`**: knockd close SSH (should be encrypted)
- **`knockd_tmp_open_ssh_seq`**: Temporary open SSH (should be encrypted)
- **`knockd_opts`**: knockd CLI arguments used by the service
- **`docker_hub_username`**: Docker Hub username
- **`docker_hub_password`**: Docker Hub password
- **`fqdn`**: The server FQDN
- **`etherpad_db_user`**: Etherpad database username
- **`etherpad_db_password`**: Etherpad database password
- **`etherpad_admin_password`**: Etherpad admin password
- **`joplin_db_user`**: Joplin database username
- **`joplin_db_password`**: Joplin database password
- **`joplin_mailer_host`**: SMTP host
- **`joplin_mailer_user`**: Joplin mail service username
- **`joplin_mailer_password`**: Joplin mail service password
- **`tor_unix_socket`**: Tor UNIX socket path