resource "digitalocean_droplet" "purpleLab" {
  image = "ubuntu-18-04-x64"
  name = "purpleLab"
  region = "tor1"
  size = "s-1vcpu-1gb"
  private_networking = true
  ssh_keys = [
    data.digitalocean_ssh_key.terraform.id
  ]
  connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
    private_key = file(var.pvt_key)
    timeout = "2m"
  }
  provisioner "file" {
    source      = "purpleLab.sh"
    destination = "/opt/purpleLab.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      # install Azure CLI
      "sudo apt-get update",
      "sudo apt-get -y install unzip",
      "sudo apt-get -y install git",
      "curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash",
      "cd /opt/",
      "wget https://releases.hashicorp.com/terraform/0.12.29/terraform_0.12.29_linux_amd64.zip",
      "unzip terraform_0.12.29_linux_amd64.zip",
      "mv terraform /usr/local/bin/",
      "rm terraform_0.12.29_linux_amd64.zip",
      "chmod u+x purpleLab.sh"
    ]
  }

}