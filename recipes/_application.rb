#
# Cookbook Name:: stackstudio
# Recipe:: _application
#
# Copyright (C) 2014 Transcend Computing
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

Chef::Recipe.send(:include, StackStudio::Helpers)

include_recipe 'stackstudio::_apt'

group 'stackstudio' do
  system true
end

user 'stackstudio' do
  gid 'stackstudio'
  home node['stackstudio']['home']
  comment 'StackStudio'
end

directory node['stackstudio']['home'] do
  owner 'stackstudio'
  group 'stackstudio'
  action :create
end

git node['stackstudio']['home'] do
  repository 'https://github.com/TranscendComputing/StackStudio.git'
  revision node['stackstudio']['git_revision']
  user 'stackstudio'
  group 'stackstudio'
end

execute 'npm-install' do
  command 'npm install'
  user 'stackstudio'
  group 'stackstudio'
  cwd node['stackstudio']['home']
  creates "#{node['stackstudio']['home']}/node_modules"
end

execute 'npm-grunt-install' do
  command 'npm install -g grunt-cli'
  cwd node['stackstudio']['home']
end

if Chef::Config[:solo]
  backend = node['stackstudio']['cloudmux_endpoint']
else
  cloudmux_node = search(:node, 'role:cloudmux').first
  backend = cloudmux_node.nil? ? node['ipaddress'] : cloudmux_node['ipaddress']
end

template "#{node['stackstudio']['home']}/config/backend.json" do
  owner 'stackstudio'
  group 'stackstudio'
  variables(
    :backend_endpoint => backend
  )
end
