# purpleLab
Terraform script to create DO droplet (https://github.com/DefensiveOrigins/APT-Lab-Terraform)

--Under development---

##### Install terraform
`./start -i` 

##### Create a new DO droplet and start the AZ terraform
It is required a DO account, Personal access tokens and a ssh key (no encrypted):
`cp sample_terraform.tfvars terraform.tfvars`
update both variables (do_token & pvt_key path)
`./start -d`

The APT-Lab repo used is https://github.com/Lijantropique/APT-Lab-Terraform.git, which also installs and deploys `Zeek`. If you want to use the original one uncomment line 23 `#git clone https://github.com/DefensiveOrigins/APT-Lab-Terraform.git` and comment line 24.

