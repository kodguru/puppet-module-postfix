# @summary Manage Postfix to relay mail
#
# @param main_alias_database
#   The alias databases for local(8) delivery that are updated with "newaliases"
#   or with "sendmail -bi".
#
# @param main_alias_maps
#   The alias databases that are used for local(8) delivery. See aliases(5) for
#   syntax details. The default list is system dependent. On systems with NIS,
#   the default is to search the local alias database, then the NIS alias
#   database. If you change the alias database, run "postalias /etc/aliases"
#   (or wherever your system stores the mail alias file), or simply run
#   "newaliases" to build the necessary DBM or DB file.
#
# @param main_append_dot_mydomain
#   With locally submitted mail, append the string ".$mydomain" to addresses
#   that have no ".domain" information. With remotely submitted mail, append the
#   string ".$remote_header_rewrite_domain" instead. Note: this feature is
#   enabled by default. If disabled, users will not be able to send mail to
#   "user@partialdomainname" but will have to specify full domain names instead.
#
# @param main_biff
#   Whether or not to use the local biff service. This service sends "new mail"
#   notifications to users who have requested new mail notification with the
#   UNIX command "biff y". For compatibility reasons this feature is on by
#   default. On systems with lots of interactive users, the biff service can
#   be a performance drain. Specify "biff = no" in main.cf to disable.
#
# @param main_command_directory
#   The location of all postfix administrative commands.
#
# @param main_daemon_directory
#   The directory with Postfix support programs and daemon programs. These should
#   not be invoked directly by humans. The directory must be owned by root.
#
# @param main_data_directory
#   The directory with Postfix-writable data files (for example: caches,
#   pseudo-random numbers). This directory must be owned by the mail_owner
#   account, and must not be shared with non-Postfix software. This feature
#   is available in Postfix 2.5 and later.
#
# @param main_inet_interfaces
#   The network interface addresses that this mail system receives mail on.
#   Specify "all" to receive mail on all network interfaces (default), and
#   "loopback-only" to receive mail on loopback network interfaces only
#   (Postfix version 2.2 and later). The parameter also controls delivery
#   of mail to user@[ip.address].
#   Note 1: you need to stop and start Postfix when this parameter changes.
#   Note 2: address information may be enclosed inside [], but this form is
#           not required here.
#   When inet_interfaces specifies just one IPv4 and/or IPv6 address that
#   is not a loopback address, the Postfix SMTP client will use this address
#   as the IP source address for outbound mail. Support for IPv6 is available
#   in Postfix version 2.2 and later.
#
# @param main_inet_protocols
#   The Internet protocols Postfix will attempt to use when making or accepting
#   connections. Specify one or more of "ipv4" or "ipv6", separated by
#   whitespace or commas. The form "all" is equivalent to "ipv4, ipv6" or "ipv4",
#   depending on whether the operating system implements IPv6.
#   With Postfix 2.8 and earlier the default is "ipv4". For backwards
#   compatibility with these releases, the Postfix 2.9 and later upgrade
#   procedure appends an explicit "inet_protocols = ipv4" setting to main.cf
#   when no explicit setting is present. This compatibility workaround will be
#   phased out as IPv6 deployment becomes more common.
#
# @param main_mailbox_command
#   Optional external command that the local(8) delivery agent should use for
#   mailbox delivery. The command is run with the user ID and the primary group
#   ID privileges of the recipient. Exception: command delivery for root
#   executes with $default_privs privileges. This is not a problem, because
#   1) mail for root should always be aliased to a real user and 2) do not log
#   in as root, use "su" instead.
#
# @param main_mailbox_size_limit
#   The maximal size of any local(8) individual mailbox or maildir file, or
#   zero (no limit). In fact, this limits the size of any file that is written
#   to upon local delivery, including files written by external commands that
#   are executed by the local(8) delivery agent.
#   Note: This limit must not be smaller than the message size limit.
#
# @param main_mydestination
#   The list of domains that are delivered via the $local_transport mail
#   delivery transport. By default this is the Postfix local(8) delivery
#   agent which looks up all recipients in /etc/passwd and /etc/aliases.
#   The SMTP server validates recipient addresses with $local_recipient_maps
#   and rejects non-existent recipients. See also the local domain class in
#   the ADDRESS_CLASS_README file.
#   The default mydestination value specifies names for the local machine only.
#   On a mail domain gateway, you should also include $mydomain.
#
# @param main_mydomain
#   The internet hostname of this mail system. The default is to use the
#   fully-qualified domain name (FQDN) from gethostname(), or to use the
#   non-FQDN result from gethostname() and append ".$mydomain". $myhostname is
#   used as a default value for many other configuration parameters.
#
# @param main_myhostname
#   The internet hostname of this mail system. The default is to use the
#   fully-qualified domain name (FQDN) from gethostname(), or to use the
#   non-FQDN result from gethostname() and append ".$mydomain". $myhostname
#   is used as a default value for many other configuration parameters.
#
# @param main_mynetworks
#   The list of "trusted" remote SMTP clients that have more privileges than
#   "strangers". In particular, "trusted" SMTP clients are allowed to relay
#   mail through Postfix. Specify a list of network addresses or
#   network/netmask patterns, separated by commas and/or whitespace.
#
# @param main_myorigin
#   The domain name that locally-posted mail appears to come from, and that
#   locally posted mail is delivered to. The default, $myhostname, is adequate
#   for small sites. If you run a domain with multiple machines, you should (1)
#   change this to $mydomain and (2) set up a domain-wide alias database that
#   aliases each user to user@that.users.mailhost.
#
# @param main_queue_directory
#   The location of the Postfix top-level queue directory. This is the root
#   directory of Postfix daemon processes that run chrooted.
#
# @param main_recipient_delimiter
#   The set of characters that can separate a user name from its address
#   extension (user+foo). See canonical(5), local(8), relocated(5) and virtual(5)
#   for the effects this has on aliases, canonical, virtual, and relocated
#   lookups. Basically, the software tries user+foo and .forward+foo before
#   trying user and .forward.
#
# @param main_relay_domains
#   What destination domains (and subdomains thereof) this system will relay
#   mail to. For details about how the relay_domains value is used, see the
#   description of the permit_auth_destination and reject_unauth_destination
#   SMTP recipient restrictions.
#
# @param main_relayhost
#  The next-hop destination of non-local mail; overrides non-local domains
#  in recipient addresses. This information is overruled with relay_transport,
#  sender_dependent_default_transport_maps, default_transport,
#  sender_dependent_relayhost_maps and with the transport(5) table.
#  In the case of SMTP, specify a domain name, hostname, hostname:port,
#  [hostname]:port, [hostaddress] or [hostaddress]:port. The form [hostname]
#  turns off MX lookups.
#
# @param main_relayhost_port
#  The next-hop destination of non-local mail; overrides non-local domains
#  in recipient addresses. This information is overruled with relay_transport,
#  sender_dependent_default_transport_maps, default_transport,
#  sender_dependent_relayhost_maps and with the transport(5) table.
#  In the case of SMTP, specify a domain name, hostname, hostname:port,
#  [hostname]:port, [hostaddress] or [hostaddress]:port. The form [hostname]
#  turns off MX lookups.
#
# @param main_setgid_group
#  The group ownership of set-gid Postfix commands and of group-writable
#  Postfix directories. When this parameter value is changed you need to re-run
#  "postfix set-permissions" (with Postfix version 2.0 and earlier:
#  "/etc/postfix/post-install set-permissions".
#
# @param main_smtpd_helo_required
#   Require that a remote SMTP client introduces itself with the HELO or EHLO
#   command before sending the MAIL command or other commands that require EHLO
#   negotiation.
#
# @param main_smtpd_helo_restrictions
#   Optional restrictions that the Postfix SMTP server applies in the context of
#   a client HELO command. See SMTPD_ACCESS_README, section "Delayed evaluation
#   of SMTP access restriction lists" for a discussion of evaluation context and
#   time.
#   The default is to permit everything.
#   Note: specify  "smtpd_helo_required = yes" to fully enforce this restriction
#   (without "smtpd_helo_required = yes", a client can simply skip
#   smtpd_helo_restrictions by not sending HELO or EHLO).
#
# @param main_smtpd_recipient_restrictions
#   Optional restrictions that the Postfix SMTP server applies in the context of
#   a client RCPT TO command, after smtpd_relay_restrictions. See
#   SMTPD_ACCESS_README, section "Delayed evaluation of SMTP access restriction
#   lists" for a discussion of evaluation context and time. With Postfix versions
#   before 2.10, the rules for relay permission and spam blocking were combined
#   under smtpd_recipient_restrictions, resulting in error-prone configuration.
#   As of Postfix 2.10, relay permission rules are preferably implemented with
#   smtpd_relay_restrictions, so that a permissive spam blocking policy under
#   smtpd_recipient_restrictions will no longer result in a permissive mail relay
#   policy.
#   Read more in man pages.
#
# @param main_smtpd_tls_cert_file
#   File with the Postfix SMTP server RSA certificate in PEM format. This file
#   may also contain the Postfix SMTP server private RSA key.
#
# @param main_smtpd_tls_key_file
#   File with the Postfix SMTP server RSA private key in PEM format.
#
# @param main_smtpd_tls_mandatory_protocols
#  List of SSL/TLS protocols that the Postfix SMTP server will use with mandatory
#  TLS encryption. An empty value means allow all protocols. The valid protocol
#  names, are "SSLv2", "SSLv3" and "TLSv1". The default value is "!SSLv2, !SSLv3"
#  for Postfix releases after the middle of 2015, "!SSLv2" for older releases.
#
# @param main_smtpd_tls_protocols
#   TLS protocols accepted by the Postfix SMTP server with opportunistic TLS
#   encryption. If the list is empty, the server supports all available TLS
#   protocol versions. A non-empty value is a list of protocol names to include
#   or exclude, separated by whitespace, commas or colons.
#   The valid protocol names (see SSL_get_version(3)) are "SSLv2", "SSLv3",
#   "TLSv1", "TLSv1.1", "TLSv1.2" and "TLSv1.3". Starting with Postfix 3.6,
#   the default value is ">=TLSv1", which sets TLS 1.0 as the lowest supported
#   TLS protocol version (see below). Older releases use the "!" exclusion
#   syntax, also described below.
#   As of Postfix 3.6, the preferred way to limit the range of acceptable
#   protocols is to set the lowest acceptable TLS protocol version and/or the
#   highest acceptable TLS protocol version. To set the lower bound include an
#   element of the form: ">=version" where version is a either one of the TLS
#   protocol names listed above, or a hexadecimal number corresponding to the
#   desired TLS protocol version (0301 for TLS 1.0, 0302 for TLS 1.1, etc.).
#   For the upper bound, use "<=version". There must be no whitespace between
#   the ">=" or "<=" symbols and the protocol name or number. 
#   Read more in man pages.
#
# @param main_smtpd_tls_security_level
#   The SMTP TLS security level for the Postfix SMTP server. Specify one of the
#   following security levels: none, may, encrypt.
#
# @param main_smtp_tls_mandatory_protocols
#   List of SSL/TLS protocols that the Postfix SMTP client will use with
#   mandatory TLS encryption. An empty value means allow all protocols. The
#   valid protocol names, (see SSL_get_version(3)), are "SSLv2", "SSLv3" and
#   "TLSv1". The default value is "!SSLv2, !SSLv3" for Postfix releases after
#   the middle of 2015, "!SSLv2" for older releases.
#
# @param main_smtp_tls_protocols
#   List of TLS protocols that the Postfix SMTP client will exclude or include
#   with opportunistic TLS encryption. The default value is "!SSLv2, !SSLv3" for
#   Postfix releases after the middle of 2015, "!SSLv2" for older releases.
#   Before Postfix 2.6, the Postfix SMTP client would use all protocols with
#   opportunistic TLS.
#
# @parm main_smtp_tls_security_level
#   The default SMTP TLS security level for the Postfix SMTP client. Specify
#   one of the following security levels: none, may, encrypt, dane, dane-only,
#   fingerprint, verify, secure.
#
# @param main_transport_maps
#  Optional lookup tables with mappings from recipient address to (message
#  delivery transport, next-hop destination). See transport(5) for details.
#  This parameter can be used to specify a file not managed by this puppet module
#  to provide alternative lookup sources. For example ldap, nis, mysql, pcre, etc.
#  For more information see the man pages for postmap(1), transport(5)
#
# @param main_virtual_alias_domains
#  Postfix is final destination for the specified list of virtual alias domains,
#  that is, domains for which all addresses are aliased to addresses in other
#  local or remote domains. The SMTP server validates recipient addresses with
#  $virtual_alias_maps and rejects non-existent recipients. See also the virtual
#  alias domain class in the ADDRESS_CLASS_README file.
#
# @param main_virtual_alias_maps
#   Optional lookup tables that alias specific mail addresses or domains to other
#   local or remote address. The table format and lookups are documented in
#   virtual(5). For an overview of Postfix address manipulations see the
#   ADDRESS_REWRITING_README document.
#   This feature is available in Postfix 2.0 and later.
#
# @param packages
#   Array of package names used for installation.
#
# @param service_enable
#   Whether a service should be enabled to start at boot.
#   Valid values are 'true', 'false' and 'manual'.
#
# @param service_ensure
#   Whether a service should be running. Valid values are 'stopped' or 'running'.
#
# @param service_hasrestart
#  Specify that an init script has a restart command. If this is false and you do
#  not specify a command in the restart attribute, the init scripts stop and
#  start commands will be used. Defaults to false. Valid values are 'true' or
#  'false'.
#
# @param service_hasstatus
#   Declare whether the services init script has a functional status command;
#   defaults to true. This attributes default value changed in Puppet 2.7.0.
#   Valid values are 'true' or 'false'.
#
# @param service_name
#   The name of the service to run. This name is used to find the service; on
#   platforms where services have short system names and long display names,
#   this should be the short name.
#
# @param template_main_cf
#   The name of the template file to use for main.cf.
#
# @param transport_maps_external
#   Use a non-puppet managed source for the transport_maps, for example nis: or
#   ldap:. This parameter will cause the value of main_transport_maps to be
#   added despite the transport_map parameter beeing undefined.
#
# @param transport_maps
#   Hash of entries to add to transport_maps file defined by
#   $main_transport_maps. The value must be a string.
#
# @param virtual_aliases_external
#   Use a non-puppet managed source for the virtual_aliases parameter, for
#   example nis: or ldap:. This parameter will cause the value of
#   main_virtual_alias_maps to be added despite the virtual_aliases parameter
#   beeing undefined.
#
# @param virtual_aliases
#   Hash of entries to add to virtual_alias_maps file defined by
#   $main_virtual_alias_maps.
#
class postfix (
  String[1] $main_alias_database                                    = 'hash:/etc/aliases',
  String[1] $main_alias_maps                                        = 'hash:/etc/aliases',
  Enum['yes', 'no'] $main_append_dot_mydomain                       = 'no',
  Enum['yes', 'no'] $main_biff                                      = 'no',
  Stdlib::Absolutepath $main_command_directory                      = '/usr/sbin',
  Optional[Stdlib::Absolutepath] $main_daemon_directory             = undef,
  Stdlib::Absolutepath $main_data_directory                         = '/var/lib/postfix',
  Stdlib::Host $main_inet_interfaces                                = '127.0.0.1',
  String[1] $main_inet_protocols                                    = 'ipv4',
  Optional[String[1]] $main_mailbox_command                         = undef,
  Integer[0] $main_mailbox_size_limit                               = 0,
  Stdlib::Host $main_mydestination                                  = 'localhost',
  Optional[Stdlib::Host] $main_mydomain                             = undef,
  Stdlib::Host $main_myhostname                                     = $::fqdn,
  Stdlib::Host $main_mynetworks                                     = '127.0.0.0/8',
  String[1] $main_myorigin                                          = '$myhostname',
  Stdlib::Absolutepath $main_queue_directory                        = '/var/spool/postfix',
  String[1] $main_recipient_delimiter                               = '+',
  Optional[String[1]] $main_relay_domains                           = undef,
  Stdlib::Host $main_relayhost                                      = "mailhost.${::domain}",
  Integer[0] $main_relayhost_port                                   = 25,
  String[1] $main_setgid_group                                      = undef,
  Optional[Enum['yes', 'no']] $main_smtpd_helo_required             = undef,
  Optional[Array[String[1]]] $main_smtpd_helo_restrictions          = undef,
  Optional[Array[String[1]]] $main_smtpd_recipient_restrictions     = undef,
  Optional[Stdlib::Absolutepath] $main_smtpd_tls_cert_file          = undef,
  Optional[Stdlib::Absolutepath] $main_smtpd_tls_key_file           = undef,
  Optional[String[1]] $main_smtpd_tls_mandatory_protocols           = undef,
  Optional[String[1]] $main_smtpd_tls_protocols                     = undef,
  Optional[String[1]] $main_smtpd_tls_security_level                = undef,
  Optional[String[1]] $main_smtp_tls_mandatory_protocols            = undef,
  Optional[String[1]] $main_smtp_tls_protocols                      = undef,
  Optional[String[1]] $main_smtp_tls_security_level                 = undef,
  String[1] $main_transport_maps                                    = 'hash:/etc/postfix/transport',
  Optional[String[1]] $main_virtual_alias_domains                   = undef,
  String[1] $main_virtual_alias_maps                                = 'hash:/etc/postfix/virtual',
  Array[String[1]] $packages                                        = ['postfix'],
  Variant[Boolean, Enum['true', 'false', 'manual']] $service_enable = true,
  Stdlib::Ensure::Service $service_ensure                           = 'running',
  Boolean $service_hasrestart                                       = true,
  Boolean $service_hasstatus                                        = true,
  String[1] $service_name                                           = 'postfix',
  String[1] $template_main_cf                                       = 'postfix/main.cf.erb',
  Boolean $transport_maps_external                                  = false,
  Optional[Hash] $transport_maps                                    = undef,
  Boolean $virtual_aliases_external                                 = false,
  Optional[Hash] $virtual_aliases                                   = undef,
) {

  # <Install & Config>
  package { $packages:
    ensure => installed,
    before => Package['sendmail'],
  }

  service { 'postfix_service' :
    ensure     => $service_ensure,
    name       => $service_name,
    enable     => $service_enable,
    hasrestart => $service_hasrestart,
    hasstatus  => $service_hasstatus,
    require    => Package[$packages],
    subscribe  => [ File['postfix_main.cf'], File['postfix_virtual'], File['postfix_transport'], ],
  }

  file  { 'postfix_main.cf' :
    ensure  => file,
    path    => '/etc/postfix/main.cf',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template($template_main_cf),
    require => Package[$packages],
  }

  if $virtual_aliases != undef {
    file { 'postfix_virtual':
      ensure  => file,
      path    => '/etc/postfix/virtual',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('postfix/virtual.erb'),
      require => Package[$packages],
    }
    exec { 'postfix_rebuild_virtual':
      command     => "${main_command_directory}/postmap ${main_virtual_alias_maps}",
      refreshonly => true,
      subscribe   => File['postfix_virtual'],
    }
  }
  else {
    file { 'postfix_virtual':
      ensure => absent,
      path   => '/etc/postfix/virtual',
    }
    file { 'postfix_virtual_db':
      ensure => absent,
      path   => '/etc/postfix/virtual.db',
    }
  }
  if $transport_maps != undef {
    file { 'postfix_transport':
      ensure  => file,
      path    => '/etc/postfix/transport',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('postfix/transport.erb'),
      require => Package[$packages],
    }
    exec { 'postfix_rebuild_transport':
      command     => "${main_command_directory}/postmap hash:/etc/postfix/transport",
      refreshonly => true,
      subscribe   => File['postfix_transport'],
    }
  }
  else {
    file { 'postfix_transport':
      ensure => absent,
      path   => '/etc/postfix/transport',
    }
    file { 'postfix_transport_db':
      ensure => absent,
      path   => '/etc/postfix/transport.db',
    }
  }
  # </Install & Config>

  # <Remove Sendmail>
  package { 'sendmail':
    ensure  => absent,
    require => Package['sendmail-cf'],
  }
  package { 'sendmail-cf':
    ensure => absent,
  }
  # </Remove Sendmail>

}
