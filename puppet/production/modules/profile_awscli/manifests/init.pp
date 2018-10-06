# Class: profile_awscli
#
#
class profile_awscli {
  package { 'python-pip':
    ensure  => 'installed',
    require => Package['epel-release']
  }

  # awscli installed via pip
  package{'awscli':
    ensure   => installed,
    provider => 'pip',
    require  => Package['python-pip']
  }
}
