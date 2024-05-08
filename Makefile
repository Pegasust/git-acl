# CI/CD tasks

.DEFAULT_GOAL := help

.PHONY: help deploy-clab-ci destroy-clab-ci run-tests dist

TESTS := $(shell find test/ci -name '*.py')

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

deploy-clab-ci: ## Deploy "ci" test topology
	cd .clab && sudo clab deploy -t ci-topology.yml --reconfigure

destroy-clab-ci: ## Destroy "ci" test topology
	cd .clab && sudo clab destroy -t ci-topology.yml --cleanup

run-tests: $(TESTS) ## Run all CI tests under test/ci
	echo "done"

dist: ## This creates a ./dist directory with wheel package
	python3 -m pip install --upgrade build
	python3 -m build

release: dist ## release to PyPi
	python3 -m pip install --upgrade twine
	# --repository testpypi
	python3 -m twine upload dist/*
