.ONESHELL:
	SHELL := /bin/bash

validate:
	@for i in $$(find -type f -name "*.tf" -exec dirname {} \;); do \
		terraform validate -var-file=../credentials.tfvars -var-file=global.tfvars "$$i"; \
		if [ $$? -ne 0 ]; then \
			echo "Failed Terraform file validation on file $${i}"; \
			echo; \
			exit 1; \
		fi; \
	done

init:
	@terraform init

update:
	@terraform get -update=true 1>/dev/null

show: init update
	@terraform show \
		-module-depth=-1

plan: init update
	@terraform plan \
	  -input=false \
		-var-file=../credentials.tfvars \
		-var-file=global.tfvars

apply: init update
	@terraform apply \
	  -input=false \
		-var-file=../credentials.tfvars \
		-var-file=global.tfvars

destroy: init update
	@terraform destroy \
	  -input=false \
		-var-file=../credentials.tfvars \
		-var-file=global.tfvars
