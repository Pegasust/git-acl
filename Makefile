# CI/CD tasks

.DEFAULT_GOAL := help

.PHONY: help deploy-clab-ci destroy-clab-ci run-tests dist

TESTS := $(shell find test/ci -name '*.py')

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

deploy-clab-ci: ## Deploy "ci" test topology
	sudo clab deploy -t ci-topology.yml --reconfigure

destroy-clab-ci: ## Destroy "ci" test topology
	sudo clab destroy -t ci-topology.yml --cleanup

run-tests: $(TESTS) ## Run all CI tests under test/ci
	 bash -c "diff <(gnmic --address clab-acl-git-srl --username admin --password 'NokiaSrl1!' get --path '/acl' --skip-verify -e JSON_IETF | jq --sort-keys) ./srl.srl_acl"

push-prod:
	# ...
