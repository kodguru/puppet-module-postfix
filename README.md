# puppet-module-postfix #
===

Puppet Module to manage Postfix for mail relaying

The module installs and configures Postfix MTA to relay local mail to a relayhost.

# Compatability #

This module has been tested to work on the following systems.

 * EL 6
 * SLES 11 (SLED should work, it just needs your testing and confirmation :)


# Parameters #

main_alias_database
-------------------
- *Default*: 'hash:/etc/aliases'


main_alias_maps
---------------
- *Default*: 'hash:/etc/aliases'


main_append_dot_mydomain
------------------------
- *Default*: 'no'


main_biff
---------
- *Default*: 'no'


main_cf
-------
- *Default*: 'USE_DEFAULTS'


main_command_directory
----------------------
- *Default*: 'USE_DEFAULTS'


main_daemon_directory
---------------------
- *Default*: 'USE_DEFAULTS'


main_data_directory
-------------------
- *Default*: 'USE_DEFAULTS'


main_inet_interfaces
--------------------
- *Default*: '127.0.0.1'


main_mailbox_size_limit
-----------------------
- *Default*: '0'


main_mydestination
------------------
- *Default*: 'localhost'


main_myhostname
---------------
- *Default*: $::fqdn


main_mynetworks
---------------
- *Default*: '127.0.0.0/8'


main_myorigin
-------------
- *Default*: '$myhostname'


main_queue_directory
--------------------
- *Default*: 'USE_DEFAULTS'


main_recipient_delimiter
------------------------
- *Default*: '+'


main_relayhost
--------------
- *Default*: "mailhost.${::domain}"


main_setgid_group
-----------------
- *Default*: 'USE_DEFAULTS'


packages
--------
- *Default*: 'USE_DEFAULTS'


service_enable
--------------
- *Default*: 'true'


service_ensure
--------------
- *Default*: 'running'


service_hasrestart
------------------
- *Default*: 'true'


service_hasstatus
-----------------
- *Default*: 'true'


service_name
------------
- *Default*: 'postfix'
