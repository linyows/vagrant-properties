require 'vagrant'
require 'yaml'

module VagrantPlugins
  module Property
    class Config < Vagrant.plugin('2', :config)
      attr_accessor :properties

      def initialize
        @properties = self.class.properties if VagrantProperties.enabled?
      end

      class << self
        def properties
          @properties ||= build_properties
        end

        def build_properties
          load_properties.each do |k, v|
            v['path'] = pull_project(v['repo'])
            write_to_hosts v['ip'], v['hostname']
          end
        end

        def load_properties
          YAML.load_file('vagrant_properties.yml')
        end

        def pull_project(repo)
          matched = repo.match(path_matcher)

          if ghq?
            path = "#{`ghq root`.chop}/#{matched[1..3].join('/')}"
            ghq_get path, repo
          else
            path = "../#{matched[3]}"
            git_clone path, repo
          end

          path
        end

        def write_to_hosts(ip, hostname)
          `test 0 -ne $(cat /etc/hosts | grep -q #{ip} ; echo $?) && \
            echo "#{ip} #{hostname}" | tee -a /etc/hosts`
        end

        def path_matcher
          %r|([\w\-\.]*)[:/]([\w\-]*)/([\w\-]*)\.git|
        end

        def ghq_get(path, repo)
          `test ! -d #{path} && ghq get #{repo}`
        end

        def git_clone(path, repo)
          `test ! -d #{path} && git clone #{value['repo']} #{path}`
        end

        def ghq?
          @ghq ||= `which ghq 1>/dev/null ; echo $?`.to_i == 0
        end
      end
    end
  end
end
