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

```
