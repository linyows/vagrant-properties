Vagrant::Properties
===================

Management multiple machines.

Installation
------------

Add this line to your application's Gemfile:

```ruby
gem 'vagrant-properties'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install vagrant-properties

Usage
-----

Vagrantfile:

```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

unless Vagrant.has_plugin?('vagrant-properties', '~> 0.9')
  action = Vagrant.has_plugin?('vagrant-properties') ? 'update' : 'install'
  Dir.chdir(Dir.home) { system "vagrant plugin #{action} vagrant-properties" }
end

Vagrant.configure('2') do |config|
...
```

Contributing
------------

1. Fork it ( https://github.com/[my-github-username]/vagrant-properties/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
