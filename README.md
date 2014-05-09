[![Build Status](https://travis-ci.org/Phil-Friderici/puppet-module-postfix.png?branch=master)](https://travis-ci.org/Phil-Friderici/puppet-module-postfix)

# puppet-module-postfix #
===

Puppet Module to manage Postfix for mail relaying

The module installs and configures Postfix MTA to relay local mail to a relayhost.

# Compatability #

This module provides OS default values for these OSfamilies:

 * Debian
 * RedHat
 * Suse

For other OSfamilies support, please specify all parameters which defaults to 'USE_DEFAULTS'.


# Parameters #

main_alias_database (default: see "postconf -d" output)
-------------------------------------------------------
The alias databases for local(8) delivery that are updated with "newaliases" or with "sendmail -bi".

- *Module Default*: 'hash:/etc/aliases'


main_alias_maps (default: see "postconf -d" output)
---------------------------------------------------
The alias databases that are used for local(8) delivery. See aliases(5) for syntax details.
The default list is system dependent. On systems with NIS, the default is to search the local
alias database, then the NIS alias database.
If you change the alias database, run "postalias /etc/aliases" (or wherever your system stores
the mail alias file), or simply run "newaliases" to build the necessary DBM or DB file.

- *Module Default*: 'hash:/etc/aliases'


main_append_dot_mydomain (default: yes)
---------------------------------------
With locally submitted mail, append the string ".$mydomain" to addresses that have no ".domain"
information. With remotely submitted mail, append the string ".$remote_header_rewrite_domain" instead.
Note: this feature is enabled by default. If disabled, users will not be able to send mail to
"user@partialdomainname" but will have to specify full domain names instead.

- *Module Default*: 'no'


main_biff (default: yes)
------------------------
Whether or not to use the local biff service. This service sends "new mail" notifications to
users who have requested new mail notification with the UNIX command "biff y".
For compatibility reasons this feature is on by default. On systems with lots of interactive
users, the biff service can be a performance drain. Specify "biff = no" in main.cf to disable.

- *Module Default*: 'no'


main_command_directory (default: see "postconf -d" output)
----------------------------------------------------------
The location of all postfix administrative commands.
'USE_DEFAULTS' will choose the path based on the osfamily.

- *Module Default*: 'USE_DEFAULTS'


main_daemon_directory (default: see "postconf -d" output)
---------------------------------------------------------
The directory with Postfix support programs and daemon programs. These should not be invoked
directly by humans. The directory must be owned by root. 
'USE_DEFAULTS' will choose the path based on the osfamily.

- *Module Default*: 'USE_DEFAULTS'


main_data_directory (default: see "postconf -d" output)
-------------------------------------------------------
The directory with Postfix-writable data files (for example: caches, pseudo-random numbers).
This directory must be owned by the mail_owner account, and must not be shared with non-Postfix
software. This feature is available in Postfix 2.5 and later.
'USE_DEFAULTS' will choose the path based on the osfamily.

- *Module Default*: 'USE_DEFAULTS'


main_inet_interfaces (default: all)
-----------------------------------
The network interface addresses that this mail system receives mail on. Specify "all" to receive
mail on all network interfaces (default), and "loopback-only" to receive mail on loopback network
interfaces only (Postfix version 2.2 and later). The parameter also controls delivery of mail to
user@[ip.address].
Note 1: you need to stop and start Postfix when this parameter changes.
Note 2: address information may be enclosed inside [], but this form is not required here.
When inet_interfaces specifies just one IPv4 and/or IPv6 address that is not a loopback address,
the Postfix SMTP client will use this address as the IP source address for outbound mail. Support
for IPv6 is available in Postfix version 2.2 and later.

- *Module Default*: '127.0.0.1'


main_inet_protocols (default: all)
----------------------------------
The Internet protocols Postfix will attempt to use when making or accepting connections. Specify
one or more of "ipv4" or "ipv6", separated by whitespace or commas. The form "all" is equivalent
to "ipv4, ipv6" or "ipv4", depending on whether the operating system implements IPv6.
With Postfix 2.8 and earlier the default is "ipv4". For backwards compatibility with these releases,
the Postfix 2.9 and later upgrade procedure appends an explicit "inet_protocols = ipv4" setting to
main.cf when no explicit setting is present. This compatibility workaround will be phased out as
IPv6 deployment becomes more common. 

- *Module Default*: 'ipv4'


main_mailbox_size_limit (default: 51200000)
-------------------------------------------
The maximal size of any local(8) individual mailbox or maildir file, or zero (no limit). In fact,
this limits the size of any file that is written to upon local delivery, including files written
by external commands that are executed by the local(8) delivery agent.
Note: This limit must not be smaller than the message size limit.

- *Module Default*: '0'


main_mydestination (default: $myhostname, localhost.$mydomain, localhost)
-------------------------------------------------------------------------
The list of domains that are delivered via the $local_transport mail delivery transport.
By default this is the Postfix local(8) delivery agent which looks up all recipients in
/etc/passwd and /etc/aliases. The SMTP server validates recipient addresses with
$local_recipient_maps and rejects non-existent recipients. See also the local domain class in
the ADDRESS_CLASS_README file.
The default mydestination value specifies names for the local machine only.
On a mail domain gateway, you should also include $mydomain. 

- *Module Default*: 'localhost'


main_myhostname (default: see "postconf -d" output)
---------------------------------------------------
The internet hostname of this mail system. The default is to use the fully-qualified domain name
(FQDN) from gethostname(), or to use the non-FQDN result from gethostname() and append ".$mydomain".
$myhostname is used as a default value for many other configuration parameters.

- *Module Default*: $::fqdn


main_mynetworks (default: see "postconf -d" output)
---------------------------------------------------
The list of "trusted" remote SMTP clients that have more privileges than "strangers".
In particular, "trusted" SMTP clients are allowed to relay mail through Postfix.
Specify a list of network addresses or network/netmask patterns, separated by commas and/or whitespace.

- *Module Default*: '127.0.0.0/8'


main_myorigin (default: $myhostname)
------------------------------------
The domain name that locally-posted mail appears to come from, and that locally posted mail is
delivered to. The default, $myhostname, is adequate for small sites. If you run a domain with multiple
machines, you should (1) change this to $mydomain and (2) set up a domain-wide alias database that
aliases each user to user@that.users.mailhost.

- *Module Default*: '$myhostname'


main_queue_directory (default: see "postconf -d" output)
--------------------------------------------------------
The location of the Postfix top-level queue directory. This is the root directory of Postfix daemon
processes that run chrooted.

- *Module Default*: 'USE_DEFAULTS'


main_recipient_delimiter (default: empty)
-----------------------------------------
The set of characters that can separate a user name from its address extension (user+foo).
See canonical(5), local(8), relocated(5) and virtual(5) for the effects this has on aliases, canonical,
virtual, and relocated lookups. Basically, the software tries user+foo and .forward+foo before trying
user and .forward.

- *Module Default*: '+'


main_relayhost & main_relayhost_port (default: empty)
-------------------------------
The next-hop destination of non-local mail; overrides non-local domains in recipient addresses.
This information is overruled with relay_transport, sender_dependent_default_transport_maps,
default_transport, sender_dependent_relayhost_maps and with the transport(5) table.
In the case of SMTP, specify a domain name, hostname, hostname:port, [hostname]:port, [hostaddress]
or [hostaddress]:port. The form [hostname] turns off MX lookups.

- *Module Default* for host: "mailhost.${::domain}"
- *Module Default* for port: '25'


main_setgid_group (default: postdrop)
-------------------------------------
The group ownership of set-gid Postfix commands and of group-writable Postfix directories.
When this parameter value is changed you need to re-run "postfix set-permissions" (with Postfix
version 2.0 and earlier: "/etc/postfix/post-install set-permissions".
'USE_DEFAULTS' will choose the user based on the osfamily.

- *Module Default*: 'USE_DEFAULTS'


main_virtual_alias_maps (default: $virtual_maps)
------------------------------------------------
Optional lookup tables that alias specific mail addresses or domains to other local or
remote address. The table format and lookups are documented in virtual(5). For an
overview of Postfix address manipulations see the ADDRESS_REWRITING_README document.

This feature is available  in Postfix 2.0 and later.

- *Module Default*: 'hash:/etc/postfix/virtual'


packages
--------
Array of package names used for installation.
'USE_DEFAULTS' will choose the packages based on the osfamily.

- *Module Default*: 'USE_DEFAULTS'


service_enable
--------------
Whether a service should be enabled to start at boot.
Valid values are 'true', 'false' and 'manual'.

- *Module Default*: 'true'


service_ensure
--------------
Whether a service should be running. Valid values are 'stopped' or 'running'.

- *Module Default*: 'running'


service_hasrestart
------------------
Specify that an init script has a restart command. If this is false and you do not specify a
command in the restart attribute, the init script’s stop and start commands will be used.
Defaults to false. Valid values are 'true' or 'false'.

- *Module Default*: 'true'


service_hasstatus
-----------------
Declare whether the service’s init script has a functional status command; defaults to true.
This attribute’s default value changed in Puppet 2.7.0. Valid values are 'true' or 'false'.

- *Module Default*: 'true'


service_name
------------
The name of the service to run. This name is used to find the service; on platforms where
services have short system names and long display names, this should be the short name.

- *Module Default*: 'postfix'


template_main_cf
----------------
The name of the template file to use for main.cf.

- *Module Default*: 'postfix/main.cf.erb'


virtual_aliases (default: undef)
--------------------------------
Hash of entries to add to virtual_alias_maps file defined by $main_virtual_alias_maps.

- *Module Default*: undef

Example:
<pre>
postfix::virtual_aliases:
    test1@test.void: 'destination1'
    test2@test.void:
      - 'destination2'
      - 'destination3'
</pre>


# Testing #
You may verify that the host in question is correctly forwarding mail to your mail relay by
using the "mail" command. Example:

<pre>
echo "works if you read this" | mail -s "Testing mail forward on $(uname -n)" yourmail@yourmail.domain
</pre>
