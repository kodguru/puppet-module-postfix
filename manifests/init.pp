# == Class: postfix
#
# Manage Postfix to relay mail

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
  $main_myhostname                    = $::fqdn,
  $main_mynetworks                    = '127.0.0.0/8',
  $main_myorigin                      = '$myhostname',
  $main_queue_directory               = 'USE_DEFAULTS',
  $main_recipient_delimiter           = '+',
  $main_relay_domains                 = undef,
  $main_relayhost                     = "mailhost.${::domain}",
  $main_relayhost_port                = '25',
  $main_setgid_group                  = 'USE_DEFAULTS',
  $main_transport_maps                = 'hash:/etc/postfix/transport',
  $main_virtual_alias_domains         = undef,
  $main_virtual_alias_maps            = 'hash:/etc/postfix/virtual',
  $main_smtp_tls_mandatory_protocols  = undef,
  $main_smtp_tls_protocols            = undef,
  $main_smtp_tls_security_level       = undef,
  $main_smtpd_tls_mandatory_protocols = undef,
  $main_smtpd_tls_protocols           = undef,
  $main_smtpd_tls_security_level      = undef,
  $main_smtpd_tls_key_file            = undef,
  $main_smtpd_tls_cert_file           = undef,
  $packages                           = 'USE_DEFAULTS',
  $service_enable                     = true,
  $service_ensure                     = 'running',
  $service_hasrestart                 = true,
  $service_hasstatus                  = true,
  $service_name                       = 'postfix',
  $template_main_cf                   = 'postfix/main.cf.erb',
  $transport_maps                     = undef,
  $transport_maps_external            = false,
  $virtual_aliases                    = undef,
  $virtual_aliases_external           = false,
) {

  # <provide os default values>
  # Set $os_defaults_missing to true for unspecified osfamilies
  case $::osfamily {
    'Debian': {
      $main_command_directory_default   = '/usr/sbin'
      $main_daemon_directory_default    = '/usr/lib/postfix'
      $main_data_directory_default      = '/var/lib/postfix'
      $main_mailbox_size_limit_default  = 51200000
      $main_mydestination_default       = '$myhostname, localhost.$mydomain, localhost'
      $main_queue_directory_default     = '/var/spool/postfix'
      $main_recipient_delimiter_default = ''
      $main_setgid_group_default        = 'postdrop'
      $packages_default                 = 'postfix'
    }
    'RedHat': {
      $main_command_directory_default   = '/usr/sbin'
      $main_daemon_directory_default    = '/usr/libexec/postfix'
      $main_data_directory_default      = '/var/lib/postfix'
      $main_mailbox_size_limit_default  = 51200000
      $main_mydestination_default       = '$myhostname, localhost.$mydomain, localhost'
      $main_queue_directory_default     = '/var/spool/postfix'
      $main_recipient_delimiter_default = ''
      $main_setgid_group_default        = 'postdrop'
      $packages_default                 = 'postfix'
    }
    'Suse': {
      $main_command_directory_default   = '/usr/sbin'
      $main_daemon_directory_default    = '/usr/lib/postfix'
      $main_data_directory_default      = '/var/lib/postfix'
      $main_mailbox_size_limit_default  = 51200000
      $main_mydestination_default       = '$myhostname, localhost.$mydomain, localhost'
      $main_queue_directory_default     = '/var/spool/postfix'
      $main_recipient_delimiter_default = ''
      $main_setgid_group_default        = 'maildrop'
      $packages_default                 = 'postfix'
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
  if empty($main_alias_database_real) == true { fail("main_alias_database must contain a valid value and is set to <${main_alias_database_real}>") }
  validate_string($main_alias_database_real)
  if empty($main_alias_maps_real) == true { fail("main_alias_maps must contain a valid value and is set to <${main_alias_maps_real}>") }
  validate_string($main_alias_maps_real)
  validate_re($main_append_dot_mydomain_real, '^(yes|no)$', "main_append_dot_mydomain may be either 'yes' or 'no' and is set to <${main_append_dot_mydomain_real}>")
  validate_re($main_biff_real, '^(yes|no)$', "main_biff may be either 'yes' or 'no' and is set to <${main_biff_real}>")
  validate_absolute_path($main_command_directory_real)
  validate_absolute_path($main_daemon_directory_real)
  validate_absolute_path($main_data_directory_real)
  if empty($main_inet_interfaces_real) == true { fail("main_inet_interfaces must contain a valid value and is set to <${main_inet_interfaces_real}>") }
  validate_string($main_inet_interfaces_real)
  if empty($main_inet_protocols_real) == true { fail("main_inet_protocols must contain a valid value and is set to <${main_inet_protocols_real}>") }
  validate_string($main_inet_protocols_real)
  if $main_mailbox_command { validate_string($main_mailbox_command) }
  if is_integer($main_mailbox_size_limit_real) == false { fail("main_mailbox_size_limit must be an integer and is set to <${main_mailbox_size_limit_real}>") }
  if $main_mailbox_size_limit_real < 0 { fail("main_mailbox_size_limit needs a minimum value of 0 and is set to <${main_mailbox_size_limit_real}>") }
  validate_string($main_mydestination_real)
  if is_domain_name($main_myhostname_real) == false { fail("main_myhostname must be a domain name and is set to <${main_myhostname_real}>") }
  if empty($main_mynetworks_real) == true { fail("main_mynetworks must contain a valid value and is set to <${main_mynetworks_real}>") }
  validate_string($main_mynetworks_real)
  if empty($main_myorigin_real) == true { fail("main_myorigin must contain a valid value and is set to <${main_myorigin_real}>") }
  validate_string($main_myorigin_real)
  validate_absolute_path($main_queue_directory_real)
  # main_recipient_delimiter can not be checkek, it can contain nothing to everything
  if $main_relay_domains { validate_string($main_relay_domains) }
  if is_domain_name($main_relayhost_real) == false { fail("main_relayhost must be a domain name and is set to <${$main_relayhost_real}>") }
  if is_integer($main_relayhost_port_real) == false { fail("main_relayhost_port must be an integer and is set to <${$main_relayhost_port_real}>") }
  if empty($main_setgid_group_real) == true { fail("main_setgid_group must contain a valid value and is set to <${main_setgid_group_real}>") }
  validate_string($main_setgid_group_real)
  if empty($main_transport_maps_real) == true { fail("main_transport_maps must contain a valid value and is set to <${main_transport_maps_real}>") }
  validate_string($main_transport_maps_real)
  if empty($main_virtual_alias_maps_real) == true { fail("main_virtual_alias_maps must contain a valid value and is set to <${main_virtual_alias_maps_real}>") }
  validate_string($main_virtual_alias_maps_real)
  if $main_virtual_alias_domains_real { validate_string($main_virtual_alias_domains_real) }
  if empty($packages_real) == true { fail("packages must contain a valid value and is set to <${packages_real}>") }
  if !is_bool($service_enable_real) { validate_re($service_enable_real, '^(true|false|manual)$', "service_enable may be either 'true', 'false' or 'manual' and is set to <${service_enable_real}>") }
  validate_re($service_ensure_real, '^(running|stopped)$', "service_ensure may be either 'running' or 'stopped' and is set to <${service_ensure_real}>")
  validate_bool($service_hasrestart_real)
  validate_bool($service_hasstatus_real)
  if empty($service_name_real) == true { fail("service_name must contain a valid value and is set to <${service_name_real}>") }
  validate_string($service_name_real)
  if empty($template_main_cf_real) == true { fail("template_main_cf must contain a valid value and is set to <${template_main_cf_real}>") }
  validate_string($template_main_cf_real)
  if $transport_maps_real { validate_hash($transport_maps_real) }
  validate_bool($transport_maps_external_real)
  if $virtual_aliases_real { validate_hash($virtual_aliases_real) }
  validate_bool($virtual_aliases_external_real)
  validate_string($main_smtp_tls_mandatory_protocols)
  validate_string($main_smtp_tls_protocols)
  validate_string($main_smtp_tls_security_level)
  validate_string($main_smtpd_tls_mandatory_protocols)
  validate_string($main_smtpd_tls_protocols)
  validate_string($main_smtpd_tls_security_level)
  if empty($main_smtpd_tls_key_file) == false { validate_absolute_path($main_smtpd_tls_key_file) }
  if empty($main_smtpd_tls_cert_file) == false { validate_absolute_path($main_smtpd_tls_cert_file) }
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
    subscribe  => [ File['postfix_main.cf'], File['postfix_virtual'], File['postfix_transport'], ]
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
