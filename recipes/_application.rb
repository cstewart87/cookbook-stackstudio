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
  shell '/bin/bash'
  supports :manage_home => true
end

git node['stackstudio']['home'] do
  repository 'https://github.com/TranscendComputing/StackStudio.git'
  revision node['stackstudio']['git_revision']
  user 'stackstudio'
  group 'stackstudio'
  action :sync
end

directory "#{node['stackstudio']['home']}/log" do
  owner 'stackstudio'
  group 'stackstudio'
end

logrotate_app 'stackstudio' do
  cookbook 'logrotate'
  path "#{node['stackstudio']['home']}/log/grunt.log"
  frequency 'daily'
  rotate 5
  create '666 stackstudio stackstudio'
end

execute 'npm-install' do
  command 'npm install'
  cwd repo_home
  creates "#{node['stackstudio']['home']}/node_modules"
end

execute 'npm-grunt-install' do
  command 'npm install -g grunt-cli'
  cwd repo_home
end

backend = find_cloudmux(node['stackstudio']['cloudmux_endpoint'])

template "#{node['stackstudio']['home']}/backend.json" do
  owner 'stackstudio'
  group 'stackstudio'
  variables(
    :backend_endpoint => backend
  )
end
