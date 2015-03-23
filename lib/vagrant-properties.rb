require 'vagrant-properties/version'

module VagrantPlugins
  module Property
    class Plugin < Vagrant.plugin('2')
      config('properties') do
        require File.expand_path('../vagrant-properties/config', __FILE__)
        Property::Config
      end
    end
  end
end
