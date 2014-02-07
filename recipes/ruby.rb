#
# Cookbook Name:: rackspace_mysql
# Recipe:: ruby
#
# Author:: Jesse Howarth (<him@jessehowarth.com>)
# Author:: Jamie Winsor (<jamie@vialstudios.com>)
# Author:: Matthew Thode (<matt.thode@rackspace.com>)
#
# Copyright 2008-2013, Opscode, Inc.
# Copyright 2014, Rackspace, US Inc.
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

node.set['rackspace_build_essential']['compiletime'] = true
include_recipe 'rackspace_build_essential::default'
include_recipe 'rackspace_mysql::client'

loaded_recipes = if run_context.respond_to?(:loaded_recipes)
                   run_context.loaded_recipes
                 else
                   node.run_state[:seen_recipes]
                 end

if loaded_recipes.include?('rackspace_mysql::percona_repo')
  case node['platform_family']
  when 'debian'
    resources('rackspace_apt_repository[percona]').run_action(:add)
  when 'rhel'
    resources('rackspace_yum_key[RPM-GPG-KEY-percona]').run_action(:add)
    resources('rackspace_yum_repository[percona]').run_action(:add)
  end
end

node['rackspace_mysql']['client']['packages'].each do |name|
  resources("package[#{name}]").run_action(:install)
end

chef_gem 'mysql'
