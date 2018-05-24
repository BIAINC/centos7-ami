#
# Cookbook Name:: cis_benchmark
# Recipe:: default
#
# Copyright (C) 2017 Paul Morton
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

include_recipe 'cis_benchmark::kernel_modules'
include_recipe 'cis_benchmark::limits'
include_recipe 'cis_benchmark::packages'
include_recipe 'cis_benchmark::services'
include_recipe 'cis_benchmark::sysctl'
include_recipe 'cis_benchmark::configure_audit'
include_recipe 'cis_benchmark::configure_boot'
include_recipe 'cis_benchmark::configure_cron'
include_recipe 'cis_benchmark::configure_filesystems'
include_recipe 'cis_benchmark::configure_login'
include_recipe 'cis_benchmark::configure_motd'
include_recipe 'cis_benchmark::configure_ntp'
include_recipe 'cis_benchmark::configure_selinux'
include_recipe 'cis_benchmark::configure_ssh'
include_recipe 'cis_benchmark::configure_yum'
include_recipe 'cis_benchmark::configure_clamav'
# include_recipe 'cis_benchmark::configure_openscap'
include_recipe 'cis_benchmark::configure_logging'
include_recipe 'cis_benchmark::secure_files'
#include_recipe 'cis_benchmark::configure_aide'
