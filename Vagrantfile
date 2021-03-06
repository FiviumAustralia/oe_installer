# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 1.5"

PLUGINS = %w(vagrant-auto_network vagrant-vbguest vagrant-hostsupdater)

PLUGINS.reject! { |plugin| Vagrant.has_plugin? plugin }



module OS
    def OS.windows?
        (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
    end

    def OS.mac?
        (/darwin/ =~ RUBY_PLATFORM) != nil
    end

    def OS.unix?
        !OS.windows?
    end

    def OS.linux?
        OS.unix? and not OS.mac?
    end
end

unless PLUGINS.empty?
  print "The following plugins will be installed: #{PLUGINS.join ", "} "
#  unless ['no', 'n'].include? $stdin.gets.strip.downcase
    PLUGINS.each do |plugin|
	  # Exclude windows only plugins from unix hosts
	  if OS.unix? and "#{plugin}" == "vagrant-winnfsd"
	    break;
	  end
      system("vagrant plugin install #{plugin}")
      puts
    end
#  end

   puts "Please run again"
   exit 1
end


AutoNetwork.default_pool = "172.16.0.0/24"

$script = <<SCRIPT
cd /vagrant/install
bash install-system.sh
bash install-oe.sh -f -d --accept
SCRIPT

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.box_check_update = false

  config.vm.hostname = "openeyes.vm"


  config.vm.network :forwarded_port, host: 8888, guest: 80
  config.vm.network :forwarded_port, host: 3333, guest: 3306
  config.vm.network "private_network", :auto_network => true

  config.vm.synced_folder "./www/", "/var/www/", id: "vagrant-root" #, type: "smb", mount_options: ["vers=2.1"] #, type: 'nfs', create: true
  config.vm.synced_folder ".", "/vagrant", type: 'nfs' #, type: "smb", mount_options: ["vers=2.1"]  #, type: "nfs"

  # Prefer VMWare fusion before VirtualBox
  config.vm.provider "vmware_fusion"
  config.vm.provider "virtualbox"

	# Give VM 1/4 system memory or 768MB, whichever is greater
	if OS.mac?
		# sysctl returns Bytes and we need to convert to MB
		mem = `sysctl -n hw.memsize`.to_i / 1024
	elsif OS.linux?
		# meminfo shows KB and we need to convert to MB
		mem = `grep 'MemTotal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//'`.to_i
	elsif OS.windows?
		# Windows code via https://github.com/rdsubhas/vagrant-faster
		mem = `wmic computersystem Get TotalPhysicalMemory`.split[1].to_i / 1024
	end

	mem = mem / 1024 / 4

	if mem < 768
		mem = 768
	elsif mem > 2028
		mem = 2048
	end


  # VirtualBox
  config.vm.provider "virtualbox" do |v|
    v.memory = mem
    v.gui = true
	v.cpus = 1
	v.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 10000 ]

  end

  # VMWare Fusion
  config.vm.provider "vmware_fusion" do |v, override|
    override.vm.box = "puppetlabs/ubuntu-14.04-64-nocm"
    v.vmx["displayname"] = "Openeyes"
    v.vmx["memsize"] = mem.to_s
    v.vmx["numvcpus"] = "1"
  end

  # Hyper-V
  config.vm.provider "hyperv" do |h, override|
	override.vm.box = "karlatkinson/hyperv-ubuntu-14"

	# manual ip
	override.vm.provision "shell",
      run: "always",
      inline: "sudo ifconfig eth0 172.16.0.2 netmask 255.255.255.0 up"

	#override.vm.provision "shell",
    #  run: "always",
    #  inline: "sudo route add default gw 172.16.0.1"

	h.vmname = "OpenEyes"
	h.cpus = 2
	h.memory = 768
	h.maxmemory = mem
	h.ip_address_timeout = 200
  end

  config.vm.provision "shell", inline: $script, keep_color: true

  config.hostsupdater.remove_on_suspend = true

end
