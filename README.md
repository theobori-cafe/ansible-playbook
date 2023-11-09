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

Some services are not restarted at runtime on purpose, because they need administrator configuration like `Uptime-Kuma` or `Nextcloud`. If you want to access them, you should do a SSH bridge with OpenSSH.

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

### Roles

- **`nickjj.docker`**: Setup and configure Docker + docker-compose
- **`weareinteractive.ufw`**: Setup the firewall and configure it
- **`base`**: Install basics needed packages for the other roles
- **`profile`**: Setup some default configuration for new users
- **`security`**: Setup system security tools/services like ssh, knockd, etc.
- **`shell`**: Setup a shell environment with fish + tmux
- **`services`**: Setup the Systemd services
- **`nginx`**: Setup NGINX for the differents services created from the **`services`** role
- **`tor`**: Setup a tor hidden service for every services
- **`magic`**: Setup the magic stuff, including shell scripts, cron jobs, etc. for backup and web server statistics reporting.

### Variables

#### SSH
- **`ssh_identity_key_path`**: SSH public key used to auth
- **`ssh_port`**: Change the default SSH port


#### Port knocking
- **`knockd_open_ssh_seq`**: Knockd open SSH (should be encrypted)
- **`knockd_close_ssh_seq`**: knockd close SSH (should be encrypted)
- **`knockd_tmp_open_ssh_seq`**: Temporary open SSH (should be encrypted)
- **`knockd_opts`**: knockd CLI arguments used by the service

#### Domain
- **`fqdn`**: The server FQDN, must be formatted as "domain.tld"

#### Etherpad
- **`etherpad_db_user`**: Etherpad database username (should be encrypted)
- **`etherpad_db_password`**: Etherpad database password (should be encrypted)
- **`etherpad_admin_password`**: Etherpad admin password (should be encrypted)

#### Tor
- **`tor_unix_socket`**: Tor UNIX socket path

#### LDAP
- **`ldap_admin_password`**: OpenLDAP administrator password (should be encrypted)
- **`ldap_auth_services_basedn`**: OpenLDAP base DN (should be encrypted)
- **`ldap_auth_services_binddn`**: OpenLDAP bind DN (should be encrypted)
- **`ldap_auth_services_bindpw`**: OpenLDAP bind password (should be encrypted)
- **`ldap_auth_services_login_attrib`**: OpenLDAP login attribute cn


#### Nextcloud
- **`nextcloud_db_user`**: Nextcloud database user (should be encrypted)
- **`nextcloud_db_password`**: Nextcloud database password (should be encrypted)
- **`nextcloud_db_root_password`**: Nextcloud database root password (should be encrypted)
- **`nextcloud_redis_password`**: Nextcloud Redis password (should be encrypted)

#### Tiny Tiny RSS
- **`ttrss_db_username`**: Tiny Tiny RSS database user (should be encrypted)
- **`ttrss_db_password`**: Tiny Tiny RSS database password (should be encrypted)

#### Gitea
- **`gitea_db_root_password`**: Gitea database root password (should be encrypted)
- **`gitea_db_user`**: Gitea database user (should be encrypted)
- **`gitea_db_password`**: Gitea database password (should be encrypted)
  
#### Mailer
- **`mailer_user`**: Mailer (SMTP) user (should be encrypted)
- **`mailer_password`**: Mailer (SMTP) password (should be encrypted)
- **`mailer_host`**: Mailer (SMTP) host (should be encrypted)
- **`mailer_from`**: Mailer (SMTP) source email address (should be encrypted)

#### Self Service Password
- **`ssp_secretkey`**: SSP secret key use to encrypt/decrypt the token (should be encrypted)

## 🎉 Tasks
- [ ] Tor HTTP response security (with NGINX)
- [x] Backup and web server statistics
