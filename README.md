# ansible-infra-roles

An Ansible project tree of portable infrastructure roles, playbooks and plugins that you copy into your own Ansible repo: `rsync -a --exclude .git ansible-infra-roles/ my-ansible/`

## Requirements

- ansible-core 2.19 or newer, Python 3.12 or newer on the control node.
- The collections in `collections/requirements.yml`: `ansible-galaxy collection install -r collections/requirements.yml -p collections`.
- `community.vmware` is capped below 6.0.0: 6.0 removed `vmware_cluster` and 7.0 removed the `vmware_vm_inventory` plugin.

## Contents

- `roles/`: 39 roles with plain names (`baseline`, `storage`, `freeipa_server`). Each has its own README with variables and examples.
  - Identity and trust: `freeipa_server`, `freeipa_server_docker`, `freeipa_client`, `certificate_authority`, `vault_pki`, `ssh_agent_key`.
  - Secrets and registries: `hashicorp_vault`, `hashicorp_vault_container`, `harbor`, `nexus`, `artifactory`, `dependency_track`, `os_sbom`.
  - Hosts: `baseline`, `storage`, `firewalld`, `docker`, `docker_swarm`, `swarm_stack`, `mattermost_swarm`, `nfs_server`, `nfs_client`, `node_exporter`, `clamav`, `yum_repos`, `velociraptor`, `semaphore`.
  - Hypervisor: `vsphere_vm`, `vcenter`, `vcenter_svc_accounts`.
  - Logging and network: `audit_logging`, `splunk_config`, `splunk_forwarder`, `stroom_agent`, `network_facts`, `network_views`.
  - Helpers: `common` (task library, use `include_role` with `tasks_from`), `facts`, `model_archive`.
- `playbooks/`: entry-point playbooks, `group_vars/all/` (domain, naming, network catalog) and `_fragments/`.
- `inventories/`: copy `example/` once per environment, see `inventories/README.md`. `vmware/` holds dynamic-inventory configs.
- `plugins/`: the `network_catalog` and `network_views` filters and the `get_cli_args` action plugin.
- `collections/requirements.yml`: third-party collections the roles call. Nothing is vendored.
- `files/`, `offline-ca/`, `scripts/`: fapolicyd rule templates, an offline CA toolkit, shell helpers.
- `docs/`: design principles and long-form guides. `tests/unit/`: pytest suite.
- `ansible.cfg`: `roles_path`, `collections_path`, plugin paths and output settings.

## Usage

```bash
rsync -a --exclude .git ansible-infra-roles/ my-ansible/
cd my-ansible
ansible-galaxy collection install -r collections/requirements.yml -p collections
cp -a inventories/example inventories/lab          # edit hosts.yml and group_vars/all/
ansible-playbook -i inventories/lab playbooks/facts.yml
```

Merge into an existing repo by copying only `roles/<name>` and the collections it lists in its README.

## Preconditions

- Run `ansible-playbook` from the repo root so `ansible.cfg` loads. Playbooks read their `group_vars` from `playbooks/group_vars/`.
- Roles that read secrets expect `community.hashi_vault` and a reachable Vault.

## Expected result

`ansible-playbook -i inventories/example/hosts.yml --syntax-check playbooks/facts.yml` prints `playbook: playbooks/facts.yml`.
