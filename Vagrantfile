Vagrant::Config.run do |config|
# All Vagrant configuration is done here. The most common configuration
# options are documented and commented below. For a complete reference,
# please see the online documentation at vagrantup.com.

  config.vm.define :graphite do |graphite_config|
    graphite_config.vm.box = "Centos6"
    graphite_config.vm.network  :hostonly, "10.42.42.13"
    graphite_config.ssh.max_tries = 100
    graphite_config.vm.host_name = "graphite"
    graphite_config.vm.provision :puppet do |graphite_puppet|
      graphite_puppet.pp_path = "/tmp/vagrant-puppet"
      graphite_puppet.manifests_path = "manifests"
      graphite_puppet.module_path = "modules"
      graphite_puppet.manifest_file = "site.pp"
    end
  end



  config.vm.define :gdash do |gdash_config|
    gdash_config.vm.box = "Centos6"
    gdash_config.vm.network  :hostonly, "10.42.42.14"
    gdash_config.ssh.max_tries = 100
    gdash_config.vm.host_name = "gdash"
    gdash_config.vm.provision :puppet do |gdash_puppet|
      gdash_puppet.pp_path = "/tmp/vagrant-puppet"
      gdash_puppet.manifests_path = "manifests"
      gdash_puppet.module_path = "modules"
      gdash_puppet.manifest_file = "site.pp"
    end
  end

end

