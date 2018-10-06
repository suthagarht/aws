# Builds and configures the PMC V3 Base AMI
#
# @summary provides basic package installation, cleanup & config of which is
# common among all V3 machines
#
# @example
#   include profile_base
class profile_base {
  # use deep merge strategy for common packages
  $common_packages = lookup('profile_base::common_packages', {merge => 'hash', default_value => {}})

  # epel-release package first
  package{'epel-release': ensure => present }

  # install common_packages
  create_resources(package, $common_packages, { require => Package['epel-release']})

  # only shred keys/history when not virtualbox
  if $::virtual != 'virtualbox' {
    # clean ssh_keys
    exec{'clean_ssh_keys':
      path    => '/bin:/sbin:/usr/bin:/usr/sbin',
      command => 'shred -u /etc/ssh/*_key /etc/ssh/*_key.pub || true'
    }

    # clean history
    exec{'clear_history':
      path    => '/bin:/sbin:/usr/bin:/usr/sbin',
      command => 'shred -u ~/.*history || true'
    }
  }
}
