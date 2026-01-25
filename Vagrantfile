Vagrant.configure("2") do |config|
  # Lightweight but stable
  config.vm.box = "ubuntu/jammy64"

  # VM resources (enough for Docker + k3d)
  config.vm.provider "virtualbox" do |vb|
    vb.memory = 4096
    vb.cpus = 2
  end

  # VM identity
  config.vm.hostname = "cloud-1-vm"

  config.vm.network "private_network", ip: "192.168.56.10"

  config.vm.network "forwarded_port", guest: 443, host: 443, auto_correct: true
end
