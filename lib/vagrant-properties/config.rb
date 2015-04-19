require 'vagrant'
require 'yaml'

module VagrantProperties
  class Config < Vagrant.plugin('2', :config)
    attr_writer :properties_path

    def named(key)
      self.class.properties[key.to_sym]
    end

    class << self
      def properties
        @properties ||= build_properties
      end

      def repo_valide?(repo)
        repo && repo.is_a?(String) && !repo.empty?
      end

      def domains_valid?(domains)
        domains && domains.is_a?(Array) && !domains.empty?
      end

      def hostname_valid?(hostname)
        hostname && hostname.is_a?(String) && !hostname.empty?
      end

      def ip_valid?(ip)
        ip && ip.is_a?(String) && !ip.empty?
      end

      def build_properties
        load_properties.each_with_object({}) do |(name, property), memo|
          if repo_valide?(property['repo'])
            property['path'] = pull_project(property['repo'])
          end

          if !domains_valid?(property['domains']) && hostname_valid?(property['hostname'])
            property['domains'] = [property['hostname']]
          end

          if ip_valid?(property['ip']) && domains_valid?(property['domains'])
            write_to_hosts(property['ip'], property['domains'])
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
          ghq_root = `ghq root`.chomp

          if ghq_root == "No help topic for 'root'"
            raise StandardError.new '"ghq root" not found. please update ghq'
          end

          path = "#{ghq_root}/#{matched[1..3].join('/')}"
          ghq_get path, repo
        else
          path = "../#{matched[3]}"
          git_clone path, repo
        end

        path
      end

      def write_to_hosts(ip, domains)
        `test 0 -ne $(cat /etc/hosts | grep -q #{ip} ; echo $?) && \
          echo "#{ip} #{domains.join(' ')}" | sudo tee -a /etc/hosts`
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
