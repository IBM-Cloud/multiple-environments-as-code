.ONESHELL:
	SHELL := /bin/bash

set-env:
	@if [ -z $(ENV) ]; then\
		echo "ENV was not set"; exit 10;\
	fi
	@if [ -d "terraform.tfstate.d/$(ENV)" ]; then\
		terraform workspace select $(ENV);\
	else \
		terraform workspace new $(ENV);\
	fi

validate: set-env
	@for i in $$(find . -type f -name "*.tf" -exec dirname {} \;); do \
		terraform validate -var-file=../credentials.tfvars -var-file=$(ENV).tfvars "$$i"; \
		if [ $$? -ne 0 ]; then \
			echo "Failed Terraform file validation on file $${i}"; \
			echo; \
			exit 1; \
		fi; \
	done

init: set-env
	@terraform init

update: set-env
	@terraform get -update=true 1>/dev/null

show: init update
	@terraform show \
		-module-depth=-1

plan: init update
	@terraform plan \
	  -input=false \
		-var-file=../credentials.tfvars \
		-var-file=$(ENV).tfvars

apply: init update
	@terraform apply \
	  -input=false \
		-var-file=../credentials.tfvars \
		-var-file=$(ENV).tfvars

destroy: init update
	@terraform destroy \
	  -input=false \
		-var-file=../credentials.tfvars \
		-var-file=$(ENV).tfvars
