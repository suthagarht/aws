node default {
    # apply our profile::common to all roles without
    # declaration in each role
    class{'profile_common': }

    # switch on $::role custom FACT
    # do not fail if no role is specifically applied.
    # automatically apply specific role class if one is present
    if defined('$::role') {
        $role_class = regsubst($::role, '-', '_', 'G')
        if defined("role::${role_class}") {
            include "role::${role_class}"
        } else {
            warning("FACT role=${::role} passed, but no role module using (${role_class}) found.")
        }
    } else {
        warning('No role FACT present, no machine specific role will be applied to host.')
    }
}