terraform-init:
	terraform init
terraform-plan:
	terraform plan -var "do_token=${DO_PAT}" -var "pvt_key=${HOME}/.ssh/id_rsa"
terraform-apply:
	terraform apply -var "do_token=${DO_PAT}" -var "pvt_key=${HOME}/.ssh/id_rsa"
terraform-show:
	terraform show terraform.tfstate
terraform-destroy:
	terraform plan -destroy -out=terraform.tfplan -var "do_token=${DO_PAT}" -var "pvt_key=${HOME}/.ssh/id_rsa" && terraform apply terraform.tfplan
ssh:
	ssh root@68.183.211.114