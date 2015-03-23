require 'vagrant-properties/version'

module VagrantPlugins
  module Properties
    class << self
      def enable
        @enabled = true
      end

      def enabled?
        @enabled
      end
    end
  end

  module Kernel_V2
    class Plugin < Vagrant.plugin('2')
      config('properties') do
        require File.expand_path('../vagrant-properties/config', __FILE__)
        Properties::Config
      end if VagrantPlugins::Properties.enabled?
    end
  end
end
