#
# Cookbook Name:: stackstudio
# Library:: helpers
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

require 'chef/search/query'
require 'chef'

module StackStudio
  module Helpers
    def find_cloudmux(default_endpoint)
      if Chef::Config[:solo]
        return default_endpoint
      else
        cloudmux_node = Chef::Search::Query.new.search(:node, @search)[0].first
        cloudmux_node['ipaddress']
      end
    end
  end
end
