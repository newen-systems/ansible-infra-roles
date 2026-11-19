# Changelog

## 0.1.0

- First release as its own repository, split from the scratchpad repository with its history.
- Adds `freeipa.ansible_freeipa` and `containers.podman` to `collections/requirements.yml` and caps `community.vmware` below 6.0.0.
- Moves the pki default in `freeipa_signed_install.yml` and the repo-tree warning in `freeipa_server` to the new repo root.
- Gives the `freeipa_migrate_to_container.yml` play names a default so `ansible-lint` parses them.
- Adds CI: yamllint, ansible-lint, playbook syntax-check and pytest.
