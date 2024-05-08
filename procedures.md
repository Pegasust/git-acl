# reproduce

```sh
mkdir -p def
# yank def/naming.yaml from github:aerleon/aerleon
mkdir -p policies/pol
# yank https://github.com/aerleon/aerleon/blob/33d462864e500e4bcad1719c97384eef549cd547/policies/pol/sample_nokia_srl_lab.pol onto `policies/pol/sample_nokia_srl_lab.pol` onto `policies/pol/srl.pol`

nix run gh:pegasust/aerleon-with-nix/master#aclgen

# for now
scp ./srl.srl_acl dev1:tmp/

ssh dev1 

gnmic --address clab-srl-generic-leaf4 --username admin --password 'NokiaSrl1!' set --update-path '/acl' --update-file ~/tmp/srl.srl_acl --skip-verify -e JSON_IETF


nix github:nixos/nixpkgs/nixos-unstable#gnmic -- --address clab-srl-generic-leaf4 --username admin --password 'NokiaSrl1!' set --update-path '/acl' --update-file ~/tmp/srl.srl_acl --skip-verify -e JSON_IETF

ssh admin@clab-srl-generic-leaf4
```


## gnmic via nix

set-update
```sh
nix github:nixos/nixpkgs/nixos-unstable#gnmic -- --address clab-srl-generic-leaf4 --username admin --password 'NokiaSrl1!' set --update-path '/acl' --update-file ~/tmp/srl.srl_acl --skip-verify -e JSON_IETF
```

get

```sh
nix github:nixos/nixpkgs/nixos-unstable#gnmic -- --address clab-srl-generic-leaf4 --username admin --password 'NokiaSrl1!' get --path '/acl' --skip-verify -e JSON_IETF
```

## Generate identity keys

This is accordingly to our practice of using GitHub env for identities, and
`sops`

```sh
# SSH key
ssh-keygen -t ed25519 -f gh-prod
# generates github-prod-virt-acl{,.pub}
SSH_PRIV="$(cat gh-prod)"
SSH_PUB="$(cat gh-prod.pub)"

# Age counterpart
# use https://github.com/Mic92/ssh-to-age/blob/main/README.md

# Generate age private
AGE_PRIV="$(nix run nixpkgs\#ssh-to-age -- --private-key -i gh-prod)"
# Generate age pubkey
AGE_PUB="$(nix run nixpkgs\#ssh-to-age -- -i gh-prod.pub)"
```

Decrypt

