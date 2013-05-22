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



#  config.vm.define :gdash do |gdash_config|
#    gdash_config.vm.box = "Centos6"
#    gdash_config.vm.network  :hostonly, "10.42.42.14"
#    gdash_config.ssh.max_tries = 100
#    gdash_config.vm.host_name = "gdash"
#    gdash_config.vm.provision :puppet do |gdash_puppet|
#      gdash_puppet.pp_path = "/tmp/vagrant-puppet"
#      gdash_puppet.manifests_path = "manifests"
#      gdash_puppet.module_path = "modules"
#      gdash_puppet.manifest_file = "site.pp"
#    end
#  end

  config.vm.define :dashing do |dashing_config|
    dashing_config.vm.box = "Centos6"
    dashing_config.vm.network  :hostonly, "10.42.42.19"
    dashing_config.ssh.max_tries = 100
    dashing_config.vm.host_name = "dashing"
    dashing_config.vm.provision :puppet do |dashing_puppet|
      dashing_puppet.pp_path = "/tmp/vagrant-puppet"
      dashing_puppet.manifests_path = "manifests"
      dashing_puppet.module_path = "modules"
      dashing_puppet.manifest_file = "site.pp"
    end
  end

 config.vm.define :teamdash do |teamdash_config|
    teamdash_config.vm.box = "Centos6"
    teamdash_config.vm.network  :hostonly, "10.42.42.21"
    teamdash_config.ssh.max_tries = 100
    teamdash_config.vm.host_name = "teamdash"
    teamdash_config.vm.provision :puppet do |teamdash_puppet|
      teamdash_puppet.pp_path = "/tmp/vagrant-puppet"
      teamdash_puppet.manifests_path = "manifests"
      teamdash_puppet.module_path = "modules"
      teamdash_puppet.manifest_file = "site.pp"
    end
  end


end

