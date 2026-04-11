# Ansible: ws.local

Shutdown:

```bash
cd ~/0lab/ansible
ansible-playbook shutdown_ws.local.yml
```

If `sudo` on the target needs a password:

```bash
ansible-playbook shutdown_ws.local.yml -K
```

If you do not have SSH keys set up and need a password prompt:

```bash
ansible-playbook shutdown_ws.local.yml --ask-pass -K
```

