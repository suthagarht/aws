# Class: profile_common
#
#
class profile_common {

  # Set down sysconfig/ environment file when a role is defined
  if defined('$::role') and $::role != '' {
    file{"/etc/sysconfig/${::role}":
      ensure => file,
      mode   => '0755'
    }
  }
}
