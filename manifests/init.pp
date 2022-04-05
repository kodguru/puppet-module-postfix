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
#   FIXME: Add description
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
#  not specify a command in the restart attribute, the init script’s stop and
#  start commands will be used. Defaults to false. Valid values are 'true' or
#  'false'.
#
# @param service_hasstatus
#   Declare whether the service’s init script has a functional status command;
#   defaults to true. This attribute’s default value changed in Puppet 2.7.0.
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
  $main_alias_database                = 'hash:/etc/aliases',
  $main_alias_maps                    = 'hash:/etc/aliases',
  $main_append_dot_mydomain           = 'no',
  $main_biff                          = 'no',
  $main_command_directory             = 'USE_DEFAULTS',
  $main_daemon_directory              = 'USE_DEFAULTS',
  $main_data_directory                = 'USE_DEFAULTS',
  $main_inet_interfaces               = '127.0.0.1',
  $main_inet_protocols                = 'ipv4',
  $main_mailbox_command               = undef,
  $main_mailbox_size_limit            = '0',
  $main_mydestination                 = 'localhost',
  $main_mydomain                      = undef,
  $main_myhostname                    = $::fqdn,
  $main_mynetworks                    = '127.0.0.0/8',
  $main_myorigin                      = '$myhostname',
  $main_queue_directory               = 'USE_DEFAULTS',
  $main_recipient_delimiter           = '+',
  $main_relay_domains                 = undef,
  $main_relayhost                     = "mailhost.${::domain}",
  $main_relayhost_port                = '25',
  $main_setgid_group                  = 'USE_DEFAULTS',
  $main_smtpd_helo_required           = undef,
  $main_smtpd_helo_restrictions       = undef,
  $main_smtpd_recipient_restrictions  = undef,
  $main_smtpd_tls_cert_file           = undef,
  $main_smtpd_tls_key_file            = undef,
  $main_smtpd_tls_mandatory_protocols = undef,
  $main_smtpd_tls_protocols           = undef,
  $main_smtpd_tls_security_level      = undef,
  $main_smtp_tls_mandatory_protocols  = undef,
  $main_smtp_tls_protocols            = undef,
  $main_smtp_tls_security_level       = undef,
  $main_transport_maps                = 'hash:/etc/postfix/transport',
  $main_virtual_alias_domains         = undef,
  $main_virtual_alias_maps            = 'hash:/etc/postfix/virtual',
  $packages                           = 'USE_DEFAULTS',
  $service_enable                     = true,
  $service_ensure                     = 'running',
  $service_hasrestart                 = true,
  $service_hasstatus                  = true,
  $service_name                       = 'postfix',
  $template_main_cf                   = 'postfix/main.cf.erb',
  $transport_maps_external            = false,
  $transport_maps                     = undef,
  $virtual_aliases_external           = false,
  $virtual_aliases                    = undef,
) {

  # <provide os default values>
  # Set $os_defaults_missing to true for unspecified osfamilies
  case $::osfamily {
    'Debian': {
      $main_command_directory_default   = '/usr/sbin'
      $main_data_directory_default      = '/var/lib/postfix'
      $main_mailbox_size_limit_default  = 51200000
      $main_mydestination_default       = '$myhostname, localhost.$mydomain, localhost'
      $main_queue_directory_default     = '/var/spool/postfix'
      $main_recipient_delimiter_default = undef
      $main_setgid_group_default        = 'postdrop'
      $packages_default                 = 'postfix'
      $os_defaults_missing              = false
      $main_daemon_directory_default = "${::operatingsystem}-${::operatingsystemrelease}" ? {
        'Ubuntu-16.04' => '/usr/lib/postfix/sbin',
        'Ubuntu-18.04' => '/usr/lib/postfix/sbin',
        'Ubuntu-20.04' => '/usr/lib/postfix/sbin',
        default        => '/usr/lib/postfix',
      }
    }
    'RedHat': {
      $main_command_directory_default   = '/usr/sbin'
      $main_daemon_directory_default    = '/usr/libexec/postfix'
      $main_data_directory_default      = '/var/lib/postfix'
      $main_mailbox_size_limit_default  = 51200000
      $main_mydestination_default       = '$myhostname, localhost.$mydomain, localhost'
      $main_queue_directory_default     = '/var/spool/postfix'
      $main_recipient_delimiter_default = undef
      $main_setgid_group_default        = 'postdrop'
      $packages_default                 = 'postfix'
      $os_defaults_missing              = false
    }
    'Suse': {
      $main_command_directory_default   = '/usr/sbin'
      $main_data_directory_default      = '/var/lib/postfix'
      $main_mailbox_size_limit_default  = 51200000
      $main_mydestination_default       = '$myhostname, localhost.$mydomain, localhost'
      $main_queue_directory_default     = '/var/spool/postfix'
      $main_recipient_delimiter_default = undef
      $main_setgid_group_default        = 'maildrop'
      $packages_default                 = 'postfix'
      $os_defaults_missing              = false
      $main_daemon_directory_default    = "${::operatingsystem}-${::operatingsystemrelease}" ? {
        /SLE[DS]-(1[01]\.|12\.[012])/ => '/usr/lib/postfix', # SLE[DS] 10, 11 and 12 up to 12.2
        default                       => '/usr/lib/postfix/bin',
      }
    }
    default: {
      $os_defaults_missing = true
    }
  }
  # </provide os default values>

  # <USE_DEFAULT vs OS defaults>
  # Check if 'USE_DEFAULTS' is used anywhere without having OS default value
  if $os_defaults_missing == true and (
    ($main_command_directory == 'USE_DEFAULTS') or
    ($main_daemon_directory  == 'USE_DEFAULTS') or
    ($main_data_directory    == 'USE_DEFAULTS') or
    ($main_queue_directory   == 'USE_DEFAULTS') or
    ($main_setgid_group      == 'USE_DEFAULTS') or
    ($packages               == 'USE_DEFAULTS')
  ) {
      fail("Sorry, I don't know default values for ${::osfamily} yet :( Please provide specific values to the postfix module.")
  }
  # </USE_DEFAULT vs OS defaults>

  # <USE_DEFAULTS ?>

  $main_command_directory_real = $main_command_directory ? {
    'USE_DEFAULTS' => $main_command_directory_default,
    default        => $main_command_directory }

  $main_daemon_directory_real = $main_daemon_directory ? {
    'USE_DEFAULTS' => $main_daemon_directory_default,
    default        => $main_daemon_directory }

  $main_data_directory_real = $main_data_directory ? {
    'USE_DEFAULTS' => $main_data_directory_default,
    default        => $main_data_directory }

  $main_mailbox_size_limit_real = $main_mailbox_size_limit ? {
    'USE_DEFAULTS' => $main_mailbox_size_limit_default,
    default        => $main_mailbox_size_limit }

  $main_mydestination_real = $main_mydestination ? {
    'USE_DEFAULTS' => $main_mydestination_default,
    default        => $main_mydestination }

  $main_queue_directory_real = $main_queue_directory ? {
    'USE_DEFAULTS' => $main_queue_directory_default,
    default        => $main_queue_directory }

  $main_recipient_delimiter_real = $main_recipient_delimiter ? {
    'USE_DEFAULTS' => $main_recipient_delimiter_default,
    default        => $main_recipient_delimiter }

  $main_setgid_group_real = $main_setgid_group ? {
    'USE_DEFAULTS' => $main_setgid_group_default,
    default        => $main_setgid_group }

  $packages_real = $packages ? {
    'USE_DEFAULTS' => $packages_default,
    default        => $packages }

  $main_alias_database_real        = $main_alias_database
  $main_alias_maps_real            = $main_alias_maps
  $main_append_dot_mydomain_real   = $main_append_dot_mydomain
  $main_biff_real                  = $main_biff
  $main_inet_interfaces_real       = $main_inet_interfaces
  $main_inet_protocols_real        = $main_inet_protocols
  $main_myhostname_real            = $main_myhostname
  $main_mynetworks_real            = $main_mynetworks
  $main_myorigin_real              = $main_myorigin
  $main_relayhost_port_real        = $main_relayhost_port
  $main_relayhost_real             = $main_relayhost
  $main_transport_maps_real        = $main_transport_maps
  $main_virtual_alias_domains_real = $main_virtual_alias_domains
  $main_virtual_alias_maps_real    = $main_virtual_alias_maps
  $service_enable_real             = $service_enable
  $service_ensure_real             = $service_ensure
  $service_name_real               = $service_name
  $template_main_cf_real           = $template_main_cf
  $transport_maps_real             = $transport_maps
  $virtual_aliases_real            = $virtual_aliases

  if is_bool($service_hasrestart) == true {
    $service_hasrestart_real = $service_hasrestart
  } else {
    $service_hasrestart_real = str2bool($service_hasrestart)
  }

  if is_bool($service_hasstatus) == true {
    $service_hasstatus_real = $service_hasstatus
  } else {
    $service_hasstatus_real = str2bool($service_hasstatus)
  }

  if is_bool($transport_maps_external) == true {
    $transport_maps_external_real = $transport_maps_external
  } else {
    $transport_maps_external_real = str2bool($transport_maps_external)
  }

  if is_bool($virtual_aliases_external) == true {
    $virtual_aliases_external_real = $virtual_aliases_external
  } else {
    $virtual_aliases_external_real = str2bool($virtual_aliases_external)
  }
  # </USE_DEFAULTS ?>

  # <validating variables>
  if empty($main_alias_database_real) == true { fail("main_alias_database must contain a valid value and is set to <${main_alias_database_real}>") } #lint:ignore:140chars
  validate_string($main_alias_database_real)
  if empty($main_alias_maps_real) == true { fail("main_alias_maps must contain a valid value and is set to <${main_alias_maps_real}>") }
  validate_string($main_alias_maps_real)
  validate_re($main_append_dot_mydomain_real, '^(yes|no)$', "main_append_dot_mydomain may be either 'yes' or 'no' and is set to <${main_append_dot_mydomain_real}>") #lint:ignore:140chars
  validate_re($main_biff_real, '^(yes|no)$', "main_biff may be either 'yes' or 'no' and is set to <${main_biff_real}>")
  validate_absolute_path($main_command_directory_real)
  validate_absolute_path($main_daemon_directory_real)
  validate_absolute_path($main_data_directory_real)
  if empty($main_inet_interfaces_real) == true { fail("main_inet_interfaces must contain a valid value and is set to <${main_inet_interfaces_real}>") } #lint:ignore:140chars
  validate_string($main_inet_interfaces_real)
  if empty($main_inet_protocols_real) == true { fail("main_inet_protocols must contain a valid value and is set to <${main_inet_protocols_real}>") } #lint:ignore:140chars
  validate_string($main_inet_protocols_real)
  if $main_mailbox_command { validate_string($main_mailbox_command) }
  if is_integer($main_mailbox_size_limit_real) == false { fail("main_mailbox_size_limit must be an integer and is set to <${main_mailbox_size_limit_real}>") } #lint:ignore:140chars
  if $main_mailbox_size_limit_real + 0 < 0 { fail("main_mailbox_size_limit needs a minimum value of 0 and is set to <${main_mailbox_size_limit_real}>") } #lint:ignore:140chars
  validate_string($main_mydestination_real)
  if $main_mydomain != undef and is_domain_name($main_mydomain) == false { fail("main_mydomain must be a domain name and is set to <${main_mydomain}>") } #lint:ignore:140chars
  if is_domain_name($main_myhostname_real) == false { fail("main_myhostname must be a domain name and is set to <${main_myhostname_real}>") } #lint:ignore:140chars
  if empty($main_mynetworks_real) == true { fail("main_mynetworks must contain a valid value and is set to <${main_mynetworks_real}>") }
  validate_string($main_mynetworks_real)
  if empty($main_myorigin_real) == true { fail("main_myorigin must contain a valid value and is set to <${main_myorigin_real}>") }
  validate_string($main_myorigin_real)
  validate_absolute_path($main_queue_directory_real)
  # main_recipient_delimiter can not be checkek, it can contain nothing to everything
  if $main_relay_domains { validate_string($main_relay_domains) }
  if is_domain_name($main_relayhost_real) == false { fail("main_relayhost must be a domain name and is set to <${$main_relayhost_real}>") }
  if is_integer($main_relayhost_port_real) == false { fail("main_relayhost_port must be an integer and is set to <${$main_relayhost_port_real}>") } #lint:ignore:140chars
  if empty($main_setgid_group_real) == true { fail("main_setgid_group must contain a valid value and is set to <${main_setgid_group_real}>") } #lint:ignore:140chars
  validate_string($main_setgid_group_real)
  if empty($main_transport_maps_real) == true { fail("main_transport_maps must contain a valid value and is set to <${main_transport_maps_real}>") } #lint:ignore:140chars
  validate_string($main_transport_maps_real)
  if empty($main_virtual_alias_maps_real) == true { fail("main_virtual_alias_maps must contain a valid value and is set to <${main_virtual_alias_maps_real}>") } #lint:ignore:140chars
  validate_string($main_virtual_alias_maps_real)
  if $main_virtual_alias_domains_real { validate_string($main_virtual_alias_domains_real) }
  case type3x($packages_real) {
    'string','array': {
      if empty($packages_real) == true { fail("packages must contain a valid value and is set to <${packages_real}>") }
    }
    default: {
      fail("packages must contain a valid value and is set to <${packages_real}>")
    }
  }
  if !is_bool($service_enable_real) { validate_re($service_enable_real, '^(true|false|manual)$', "service_enable may be either 'true', 'false' or 'manual' and is set to <${service_enable_real}>") } #lint:ignore:140chars
  validate_re($service_ensure_real, '^(running|stopped)$', "service_ensure may be either 'running' or 'stopped' and is set to <${service_ensure_real}>") #lint:ignore:140chars
  validate_bool($service_hasrestart_real)
  validate_bool($service_hasstatus_real)
  if empty($service_name_real) == true { fail("service_name must contain a valid value and is set to <${service_name_real}>") }
  validate_string($service_name_real)
  if empty($template_main_cf_real) == true { fail("template_main_cf must contain a valid value and is set to <${template_main_cf_real}>") }
  validate_string($template_main_cf_real)
  if $transport_maps_real != undef { validate_hash($transport_maps_real) }
  validate_bool($transport_maps_external_real)
  if $virtual_aliases_real != undef { validate_hash($virtual_aliases_real) }
  validate_bool($virtual_aliases_external_real)
  validate_string($main_smtp_tls_mandatory_protocols)
  validate_string($main_smtp_tls_protocols)
  validate_string($main_smtp_tls_security_level)
  validate_string($main_smtpd_tls_mandatory_protocols)
  validate_string($main_smtpd_tls_protocols)
  validate_string($main_smtpd_tls_security_level)
  if $main_smtpd_tls_key_file != undef { validate_absolute_path($main_smtpd_tls_key_file) }
  if $main_smtpd_tls_cert_file != undef { validate_absolute_path($main_smtpd_tls_cert_file) }
  if $main_smtpd_helo_required != undef { validate_re($main_smtpd_helo_required, '^(yes|no)$', "main_smtpd_helo_required may be either 'yes' or 'no' and is set to <${main_smtpd_helo_required}>") } #lint:ignore:140chars
  if $main_smtpd_helo_restrictions != undef { validate_array($main_smtpd_helo_restrictions) }
  if $main_smtpd_recipient_restrictions != undef { validate_array($main_smtpd_recipient_restrictions) }
  # </validating variables>

  # <Install & Config>
  package { $packages_real:
    ensure => installed,
    before => Package['sendmail'],
  }

  service { 'postfix_service' :
    ensure     => $service_ensure_real,
    name       => $service_name_real,
    enable     => $service_enable_real,
    hasrestart => $service_hasrestart_real,
    hasstatus  => $service_hasstatus_real,
    require    => Package[$packages_real],
    subscribe  => [ File['postfix_main.cf'], File['postfix_virtual'], File['postfix_transport'], ],
  }

  file  { 'postfix_main.cf' :
    ensure  => file,
    path    => '/etc/postfix/main.cf',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template($template_main_cf_real),
    require => Package[$packages_real],
  }

  if $virtual_aliases != undef {
    file { 'postfix_virtual':
      ensure  => file,
      path    => '/etc/postfix/virtual',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('postfix/virtual.erb'),
      require => Package[$packages_real],
    }
    exec { 'postfix_rebuild_virtual':
      command     => "${main_command_directory_real}/postmap ${main_virtual_alias_maps_real}",
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
      require => Package[$packages_real],
    }
    exec { 'postfix_rebuild_transport':
      command     => "${main_command_directory_real}/postmap hash:/etc/postfix/transport",
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
