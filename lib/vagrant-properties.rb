require 'vagrant-properties/version'

module VagrantProperties
  class Plugin < Vagrant.plugin('2')
    name 'Vagrant Properties'

    config('properties') do
      require File.expand_path('../vagrant-properties/config', __FILE__)
      Config
    end
  end
end
