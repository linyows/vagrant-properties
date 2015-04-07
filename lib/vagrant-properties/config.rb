require 'vagrant'
require 'yaml'

module VagrantPlugins
  module Properties
    class Config < Vagrant.plugin('2', :config)
      attr_writer :properties_path

      def named(key)
        self.class.properties[key.to_sym]
      end

      class << self
        def properties
          @properties ||= build_properties
        end

        def build_properties
          load_properties.each_with_object({}) do |(name, property), memo|
            unless property['repo'].empty?
              property['path'] = pull_project(property['repo'])
            end

            if !property['ip'].empty? && !property['hostname'].empty?
              write_to_hosts(property['ip'], property['hostname'])
            end

            keys = property.keys.inject([]) { |m, k| m << k.to_sym }
            memo[name.to_sym] = Struct.new(*keys).new(*property.values)
          end
        end

        def properties_path
          @properties_path ||= 'vagrant_properties.yml'
        end

        def load_properties
          YAML.load_file properties_path
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
            echo "#{ip} #{hostname}" | sudo tee -a /etc/hosts`
        end

        def path_matcher
          %r|([\w\-\.]*)[:/]([\w\-]*)/([\w\-]*)\.git|
        end

        def ghq_get(path, repo)
          `test ! -d #{path} && ghq get #{repo}`
        end

        def git_clone(path, repo)
          `test ! -d #{path} && git clone #{repo} #{path}`
        end

        def ghq?
          @ghq ||= `which ghq 1>/dev/null ; echo $?`.to_i == 0
        end
      end
    end
  end
end
