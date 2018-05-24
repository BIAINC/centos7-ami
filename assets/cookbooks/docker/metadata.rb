name 'docker'
maintainer 'The Authors'
maintainer_email 'you@example.com'
license 'All Rights Reserved'
description 'Installs/Configures docker'
long_description 'Installs/Configures docker'
version '0.1.0'
chef_version '>= 12.1' if respond_to?(:chef_version)

depends          'filesystem'
