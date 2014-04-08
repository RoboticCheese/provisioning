# Encoding: UTF-8
#
# Cookbook Name:: utilities-metal
# Recipe:: machines
#
# Copyright 2014, Jonathan Hartman
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'chef_metal'

with_provisioner_options(
  'bootstrap_options' => {
    image_name: 'Ubuntu 13.10 x64',
    flavor_name: '512MB',
    region_name: 'New York 2'
  }
)

machine 'test1.p4nt5.com' do
  normal_attributes(
    datadog: {api_key: ENV['DD_API_KEY']}
  )
  recipe 'datadog::dd-agent'
  recipe 'datadog::dd-handler'
  recipe 'datadog::dogstatsd-ruby'
  recipe 'docker'
  notifies :create, 'ruby_block[update_dns]'
end

ruby_block 'update_dns' do
  block do
    require 'ipaddr'
    require 'namecheap'
    require 'net/http'

    ip = search(:node, 'name:test1.p4nt5.com')[0]['ipaddress']
    Chef::Log.info("Creating DNS entry for test1.p4nt5.com => #{ip}")

    Namecheap.configure(
      user: ENV['NAMECHEAP_USER'],
      api_key: ENV['NAMECHEAP_API_KEY'],
      ip: IPAddr.new(Net::HTTP.get('icanhazip.com', '/').strip)
    )
  end
  action :nothing
end
