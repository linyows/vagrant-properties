require 'vagrant-properties/version'

module VagrantProperties
  class << self
    def enable
      @enabled = true
    end

    def enabled?
      @enabled
    end
  end
end

module VagrantPlugins
  module Kernel_V2
    class Plugin < Vagrant.plugin('2')
      config('properties') do
        require File.expand_path('../vagrant-properties/config', __FILE__)
        Property::Config
      end
    end
  end
end
