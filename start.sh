#!/bin/bash
# lijantropique
# Script based on: 
#   https://www.blackhillsinfosec.com/how-to-applied-purple-teaming-lab-build-on-azure-with-terraform/
# ===============================================================

function usage {
        echo "Usage: $(basename $0) [-abcd]" 2>&1
        echo '   -i   Install terraform & Create the droplet'
        echo '   -d   Create the droplet'
        echo '   -h   help'
 exit 1
}

function install {
    echo "Installing terraform..."
    wget https://releases.hashicorp.com/terraform/0.12.29/terraform_0.12.29_linux_amd64.zip
    unzip terraform*.zip
    mv terraform /usr/local/bin/
    whereis terraform
}

function droplet {
    echo "creating droplet..."
    pvt_key=$(cat terraform.tfvars | grep pvt_key | awk -F"=" '{ print $2}' | tr -d \")
    echo $pvt_key
    if [ ! -f "${pvt_key}" ]; then
        echo "[x] ssh private key path invalid"
        exit
    else
        echo "[-] ssh private key found"
        ipEXT=$(curl -4 -s icanhazip.com)
        echo "external IP: ${ipEXT}"
        cp 'template.sh' 'purpleLab.sh'
        sed -i "s/python3 LabBuilder.py -m ipEXT/python3 LabBuilder.py -m ${ipEXT}/g" purpleLab.sh
        terraform plan
        terraform apply -auto-approve
        ipDroplet=$(cat terraform.tfstate | grep '"ipv4_address"' | awk '{ print $2}' | tr -d \",)
        echo 
        echo
        echo "you should now connect to the droplet and execute the purpleLab.sh script"
        echo "/bin/bash /opt/purpleLab.sh"
        echo "ssh root@${ipDroplet} -i ${pvt_key}"
        # to do: send the command from this script
        ssh "root@${ipDroplet}" -i "${pvt_key}" '/bin/bash /opt/purpleLab.sh' && terraform destroy
    fi

}

if [[ ${#} -eq 0 ]]; then
   usage
fi

# Define list of arguments expected in the input
optstring=":hid"

while getopts ${optstring} arg; do
  case "${arg}" in
    h) usage ;;
    i) 
        install
        ;;
    d) droplet ;;
    ?)
      echo "Invalid option: -${OPTARG}."
      echo
      usage
      ;;
  esac
done
