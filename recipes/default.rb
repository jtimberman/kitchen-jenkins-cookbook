#
# Cookbook Name:: test-kitchen
# Recipe:: default
#
# Copyright 2013, Joshua Timberman
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "virtualbox"
include_recipe "vagrant"
include_recipe "jenkins::server"

jenkins_data = node['jenkins']['server']
jenkins_vagrant = ::File.join(jenkins_data[:home], ".vagrant.d")

# This works on Debian 7 and Ubuntu 12.04
[ "build-essential",
  "libxml2-dev",
  "libxslt-dev",
  "ruby1.9.1-full",
  "git-core" ].each do |pkg|
  package pkg
end

# This should use vagrant_plugin instead, but it doesn't yet support
# plugins for a user other than the EUID.
execute "vagrant-berkshelf plugin" do
  command "vagrant plugin install vagrant-berkshelf"
  user jenkins_data['user']
  environment({'HOME' => jenkins_data[:home]})
  not_if do
    if ::File.exists?(::File.join(jenkins_vagrant, "plugins.json"))
      plugins = JSON.parse(
        IO.read(::File.join(jenkins_vagrant, "plugins.json"))
      )
      plugins['installed'].include?('vagrant-berkshelf')
    else
      false
    end
  end
end

gem_package "test-kitchen" do
  options "--pre"
  version node['kitchen']['gem_version']
  gem_binary "/usr/bin/gem1.9.1"
end

%w{foodcritic kitchen-vagrant bundler rake}.each do |gem|

  gem_package gem do
    gem_binary "/usr/bin/gem1.9.1"
  end

end
