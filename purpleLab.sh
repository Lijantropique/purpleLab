#!/bin/bash
# lijantropique
# Script based on: 
#   https://www.blackhillsinfosec.com/how-to-applied-purple-teaming-lab-build-on-azure-with-terraform/
# ===============================================================
echo "---------------------"
echo "Start Lab creation"
echo "Azure will provide a link and a numeric code for authentication"
echo "Then you need to select the account you want to use for the rest of the process"
az login > data.tmp
echo "Azure login sucessful!"
echo
echo "Parsing AZ information..."
subscription_id=$(cat data.tmp |grep id | awk '{ print $2}' | tr -d \",) 
az account set --subscription=$SubID
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/$SubID" > data.tmp
client_id=$(cat data.tmp | grep appId | awk '{ print $2}' | tr -d \",) 
client_secret=$(cat data.tmp | grep password | awk '{ print $2}' | tr -d \",) 
tenant_id=$(cat data.tmp | grep apptenant | awk '{ print $2}' | tr -d \",) 
echo
echo "Downloading Lab git..."
cd /opt
# git clone https://github.com/DefensiveOrigins/APT-Lab-Terraform.git
git clone https://github.com/Lijantropique/APT-Lab-Terraform.git
cd APT-Lab-Terraform
echo
echo "Updating lab scripts with AZ information..."
sed -i "s/subscription_id=\"\"/subscription_id=\"${subscription_id}\"/g" LabBuilder.py
sed -i "s/client_id=\"\"/client_id=\"${client_id}\"/g" LabBuilder.py
sed -i "s/client_secret=\"\"/client_secret=\"${client_secret}\"/g" LabBuilder.py
sed -i "s/tenant_id=\"\"/tenant_id=\"${tenant_id}\"/g" LabBuilder.py
python3 LabBuilder.py -m 99.244.23.218
echo "Lab Completed, verify IP for Remote Desktop!"
echo