# == Class: postfix
#
# Manage Postfix to relay mail
#
class postfix (
  $main_alias_database      = 'hash:/etc/aliases',
  $main_alias_maps          = 'hash:/etc/aliases',
  $main_append_dot_mydomain = 'no',
  $main_biff                = 'no',
  $main_command_directory   = 'USE_DEFAULTS',
  $main_daemon_directory    = 'USE_DEFAULTS',
  $main_data_directory      = 'USE_DEFAULTS',
  $main_inet_interfaces     = '127.0.0.1',
  $main_mailbox_size_limit  = '0',
  $main_mydestination       = 'localhost',
  $main_myhostname          = $::fqdn,
  $main_mynetworks          = '127.0.0.0/8',
  $main_myorigin            = '$myhostname',
  $main_queue_directory     = 'USE_DEFAULTS',
  $main_recipient_delimiter = '+',
  $main_relayhost           = "mailhost.${::domain}",
  $main_setgid_group        = 'USE_DEFAULTS',
  $packages                 = 'USE_DEFAULTS',
  $service_enable           = 'true',
  $service_ensure           = 'running',
  $service_hasrestart       = 'true',
  $service_hasstatus        = 'true',
  $service_name             = 'postfix',
  $template_main_cf         = 'postfix/main.cf.erb',
) {

  # <define USE_DEFAULTS>
  case $::osfamily {
    'RedHat': {
      $default_main_command_directory   = '/usr/sbin'
      $default_main_daemon_directory    = '/usr/libexec/postfix'
      $default_main_data_directory      = '/var/lib/postfix'
      $default_main_mailbox_size_limit  = '51200000'
      $default_main_mydestination       = '$myhostname, localhost.$mydomain, localhost'
      $default_main_queue_directory     = '/var/spool/postfix'
      $default_main_recipient_delimiter = ''
      $default_main_setgid_group        = 'postdrop'
      $default_packages                 = 'postfix'
    }
    'Suse': {
      $default_main_command_directory   = '/usr/sbin'
      $default_main_daemon_directory    = '/usr/lib/postfix'
      $default_main_data_directory      = '/var/lib/postfix'
      $default_main_mailbox_size_limit  = '51200000'
      $default_main_mydestination       = '$myhostname, localhost.$mydomain, localhost'
      $default_main_queue_directory     = '/var/spool/postfix'
      $default_main_recipient_delimiter = ''
      $default_main_setgid_group        = 'maildrop'
      $default_packages                 = 'postfix'
    }
    default: {
      fail("postfix supports osfamilies RedHat and Suse. Detected osfamily is <${::osfamily}>.")
    }
  }
  # </define USE_DEFAULTS>


  # <USE_DEFAULTS ?>
  $main_alias_database_real      = $main_alias_database
  $main_alias_maps_real          = $main_alias_maps
  $main_append_dot_mydomain_real = $main_append_dot_mydomain
  $main_biff_real                = $main_biff

  $main_command_directory_real = $main_command_directory ? {
    'USE_DEFAULTS' => $default_main_command_directory,
    default        => $main_command_directory }

  $main_daemon_directory_real = $main_daemon_directory ? {
    'USE_DEFAULTS' => $default_main_daemon_directory,
    default        => $main_daemon_directory }

  $main_data_directory_real = $main_data_directory ? {
    'USE_DEFAULTS' => $default_main_data_directory,
    default        => $main_data_directory }

  $main_inet_interfaces_real = $main_inet_interfaces

  $main_mailbox_size_limit_real = $main_mailbox_size_limit ? {
    'USE_DEFAULTS' => $default_main_mailbox_size_limit,
    default        => $main_mailbox_size_limit }

  $main_mydestination_real = $main_mydestination ? {
    'USE_DEFAULTS' => $default_main_mydestination,
    default        => $main_mydestination }

  $main_myhostname_real = $main_myhostname
  $main_mynetworks_real = $main_mynetworks
  $main_myorigin_real   = $main_myorigin

  $main_queue_directory_real = $main_queue_directory ? {
    'USE_DEFAULTS' => $default_main_queue_directory,
    default        => $main_queue_directory }

  $main_recipient_delimiter_real = $main_recipient_delimiter ? {
    'USE_DEFAULTS' => $default_main_recipient_delimiter,
    default        => $main_recipient_delimiter }

  $main_relayhost_real  = $main_relayhost

  $main_setgid_group_real = $main_setgid_group ? {
    'USE_DEFAULTS' => $default_main_setgid_group,
    default        => $main_setgid_group }

  $packages_real = $packages ? {
    'USE_DEFAULTS' => $default_packages,
    default        => $packages }

  $service_enable_real     = $service_enable
  $service_ensure_real     = $service_ensure
  $service_hasrestart_real = $service_hasrestart
  $service_hasstatus_real  = $service_hasstatus
  $service_name_real       = $service_name
  $template_main_cf_real   = $template_main_cf
  # </USE_DEFAULTS ?>


  # <validating variables>
  if empty($main_alias_database_real) == true { fail("main_alias_database must contain a valid value and is set to <${main_alias_database_real}>") }
  if empty($main_alias_maps_real) == true { fail("main_alias_maps must contain a valid value and is set to <${main_alias_maps_real}>") }
  validate_re($main_append_dot_mydomain_real, '^(yes|no)$', "main_append_dot_mydomain may be either 'yes' or 'no' and is set to <${main_append_dot_mydomain_real}>")
  validate_re($main_biff_real, '^(yes|no)$', "main_biff may be either 'yes' or 'no' and is set to <${main_biff_real}>")
  validate_absolute_path($main_command_directory_real)
  validate_absolute_path($main_daemon_directory_real)
  validate_absolute_path($main_data_directory_real)
  if empty($main_inet_interfaces_real) == true { fail("main_inet_interfaces must contain a valid value and is set to <${main_inet_interfaces_real}>") }
  if is_integer($main_mailbox_size_limit_real) == false { fail("main_mailbox_size_limit must be an integer and is set to <${main_mailbox_size_limit_real}>") }
  if $main_mailbox_size_limit_real < 0 { fail("main_mailbox_size_limit needs a minimum value of 0 and is set to <${main_mailbox_size_limit_real}>") }
  if is_domain_name($main_mydestination_real) == false { fail("main_mydestination must be a domain name and is set to <${main_mydestination_real}>") }
  if is_domain_name($main_myhostname_real) == false { fail("main_myhostname must be a domain name and is set to <${main_myhostname_real}>") }
  if empty($main_mynetworks_real) == true { fail("main_mynetworks must contain a valid value and is set to <${main_mynetworks_real}>") }
  if empty($main_myorigin_real) == true { fail("main_myorigin must contain a valid value and is set to <${main_myorigin_real}>") }
  validate_absolute_path($main_queue_directory_real)
  # main_recipient_delimiter can not be checkek, it can contain nothing to everything
  if is_domain_name($main_relayhost_real) == false { fail("main_relayhost must be a domain name and is set to <${$main_relayhost_real}>") }
  if empty($main_setgid_group_real) == true { fail("main_setgid_group must contain a valid value and is set to <${main_setgid_group_real}>") }
  if empty($packages_real) == true { fail("packages must contain a valid value and is set to <${packages_real}>") }
  validate_re($service_enable_real, '^(true|false|manual)$', "service_enable may be either 'true', 'false' or 'manual' and is set to <${service_enable_real}>")
  validate_re($service_ensure_real, '^(running|stopped)$', "service_ensure may be either 'running' or 'stopped' and is set to <${service_ensure_real}>")
  validate_re($service_hasrestart_real, '^(true|false)$', "service_hasrestart may be either 'true' or 'false' and is set to '${service_hasrestart_real}'")
  validate_re($service_hasstatus_real, '^(true|false)$', "service_hasstatus may be either 'true' or 'false' and is set to '${service_hasstatus_real}'")
  if empty($service_name_real) == true { fail("service_name must contain a valid value and is set to <${service_name_real}>") }
  if empty($template_main_cf_real) == true { fail("template_main_cf must contain a valid value and is set to <${template_main_cf_real}>") }
  # </validating variables>


  # <Install & Config>
  package { 'postfix_packages':
    ensure => installed,
    name   => $packages_real,
  }

  service { 'postfix_service' :
    ensure     => $service_ensure_real,
    name       => $service_name_real,
    enable     => $service_enable_real,
    hasrestart => $service_hasrestart_real,
    hasstatus  => $service_hasstatus_real,
    subscribe  => File['postfix_main.cf'],
  }

  file  { 'postfix_main.cf' :
    ensure  => file,
    path    => '/etc/postfix/main.cf',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template($template_main_cf_real),
    require => Package['postfix_packages'],
  }
  # <Install & Config>

}

