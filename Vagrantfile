Vagrant.configure("2") do |config|

  config.vm.box = "hashicorp/precise64"
  config.vm.network :forwarded_port, host: 8888, guest: 80, auto_correct: true

  config.vm.define :nginx do |nginx|
    nginx.vm.provision "shell", path: "setup.sh"
  end

end
  