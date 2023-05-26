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
# @param main_compatibility_level
#   A safety net that causes Postfix to run with backwards-compatible default
#   settings after an upgrade to a newer Postfix version.
#   With backwards compatibility turned on (the main.cf compatibility_level
#   value is less than the Postfix built-in value), Postfix looks for settings
#   that are left at their implicit default value, and logs a message when a
#   backwards-compatible default setting is required. 
#
# @param main_custom
#   Hash of custom parameters and values to be added to Postfix configuration
#   file main.cf.
#   Each key-value pair will add one line in the given order. Example:
#   ```{'param' => 'value'}``` will add this line to main.cf:
#   ```param = value```
#   Multiline parameters can be added by using an array for the values.
#   ```{'param' => ['value1', 'value2']}``` will add these lines to main.cf:
#   ```param =
#       value1
#       value2```
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
# @param main_debug_peer_level
#  The increment in verbose logging level when a nexthop destination, remote
#  client or server name or network address matches a pattern given with the
#  debug_peer_list parameter.
#  Per-nexthop debug logging is available in Postfix 3.6 and later.
#
# @param main_html_directory
#   The location of Postfix HTML files that describe how to build, configure
#   or operate a specific Postfix subsystem or feature.
#
# @param main_inet_interfaces
#   Array of network interface addresses that this mail system receives mail on.
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
# @param main_manpage_directory
#   Where the Postfix manual pages are installed.
#
# @param main_mailbox_size_limit
#   The maximal size of any local(8) individual mailbox or maildir file, or
#   zero (no limit). In fact, this limits the size of any file that is written
#   to upon local delivery, including files written by external commands that
#   are executed by the local(8) delivery agent.
#   Note: This limit must not be smaller than the message size limit.
#
# @param main_mailq_path
#   Sendmail compatibility feature that specifies where the Postfix mailq(1)
#   command is installed. This command can be used to list the Postfix mail
#   queue.
#
# @param main_mail_owner
#   The UNIX system account that owns the Postfix queue and most Postfix daemon
#   processes. Specify the name of an unprivileged user account that does not
#   share a user or group ID with other accounts, and that owns no other files
#   or processes on the system. In particular, do not specify nobody or daemon.
#   PLEASE USE A DEDICATED USER ID AND GROUP ID.
#
#   When this parameter value is changed you need to re-run
#   "postfix set-permissions" (with Postfix version 2.0 and earlier:
#   "/etc/postfix/post-install set-permissions".
#
# @param main_meta_directory
#  The location of non-executable files that are shared among multiple Postfix
#  instances, such as postfix-files, dynamicmaps.cf, and the multi-instance
#  template files main.cf.proto and master.cf.proto. This directory should
#  contain only Postfix-related files. Typically, the meta_directory parameter
#  has the same default as the config_directory parameter (/etc/postfix or
#  /usr/local/etc/postfix). 
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
#   Array of the list of "trusted" remote SMTP clients that have more privileges
#   than "strangers". In particular, "trusted" SMTP clients are allowed to relay
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
# @param main_newaliases_path
#  Sendmail compatibility feature that specifies the location of the
#  newaliases(1) command. This command can be used to rebuild the local(8)
#  aliases(5) database.
#
# @param main_queue_directory
#   The location of the Postfix top-level queue directory. This is the root
#   directory of Postfix daemon processes that run chrooted.
#
# @param main_readme_directory
#   The location of Postfix README files that describe how to build, configure
#   or operate a specific Postfix subsystem or feature. 
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
#   The next-hop destination of non-local mail; overrides non-local domains
#   in recipient addresses. This information is overruled with relay_transport,
#   sender_dependent_default_transport_maps, default_transport,
#   sender_dependent_relayhost_maps and with the transport(5) table.
#   In the case of SMTP, specify a domain name, hostname, hostname:port,
#   [hostname]:port, [hostaddress] or [hostaddress]:port. The form [hostname]
#   turns off MX lookups.
#
# @param main_relayhost_port
#   The next-hop destination of non-local mail; overrides non-local domains
#   in recipient addresses. This information is overruled with relay_transport,
#   sender_dependent_default_transport_maps, default_transport,
#   sender_dependent_relayhost_maps and with the transport(5) table.
#   In the case of SMTP, specify a domain name, hostname, hostname:port,
#   [hostname]:port, [hostaddress] or [hostaddress]:port. The form [hostname]
#   turns off MX lookups.
#
# @param main_sample_directory
#  The name of the directory with example Postfix configuration files. Starting
#  with Postfix 2.1, these files have been replaced with the postconf(5) manual
#  page.
#
# @param main_sendmail_path
#   A Sendmail compatibility feature that specifies the location of the Postfix
#   sendmail(1) command. This command can be used to submit mail into the Postfix
#   queue.
#
# @param main_setgid_group
#   The group ownership of set-gid Postfix commands and of group-writable
#   Postfix directories. When this parameter value is changed you need to re-run
#   "postfix set-permissions" (with Postfix version 2.0 and earlier:
#   "/etc/postfix/post-install set-permissions".
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
# @param main_smtpd_relay_restrictions
#   Access restrictions for mail relay control that the Postfix SMTP server
#   applies in the context of the RCPT TO command, before
#   smtpd_recipient_restrictions.
#   Read more in man pages.
#
# @param main_shlib_directory
#  The location of Postfix dynamically-linked libraries (libpostfix-*.so), and
#  the default location of Postfix database plugins (postfix-*.so) that have a
#  relative pathname in the dynamicmaps.cf file. The shlib_directory parameter
#  defaults to "no" when Postfix dynamically-linked libraries and database
#  plugins are disabled at compile time, otherwise it typically defaults to
#  /usr/lib/postfix or /usr/local/lib/postfix.
#
# @param main_smtpd_tls_cert_file
#   File with the Postfix SMTP server RSA certificate in PEM format. This file
#   may also contain the Postfix SMTP server private RSA key.
#
# @param main_smtpd_tls_key_file
#   File with the Postfix SMTP server RSA private key in PEM format.
#
# @param main_smtpd_tls_mandatory_protocols
#   List of SSL/TLS protocols that the Postfix SMTP server will use with mandatory
#   TLS encryption. An empty value means allow all protocols. The valid protocol
#   names, are "SSLv2", "SSLv3" and "TLSv1". The default value is "!SSLv2, !SSLv3"
#   for Postfix releases after the middle of 2015, "!SSLv2" for older releases.
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
# @param main_smtpd_banner
#   The text that follows the 220 status code in the  SMTP  greeting banner.
#
# @param main_smtp_tls_cafile
#   A file containing CA certificates of root CAs trusted to sign either remote
#   SMTP server certificates or intermediate CA certificates. These are loaded
#   into memory before the smtp(8) client enters the chroot jail. If the number
#   of trusted roots is large, consider using smtp_tls_CApath instead, but note
#   that the latter directory must be present in the chroot jail if the smtp(8)
#   client is chrooted. This file may also be used to augment the client
#   certificate trust chain, but it is best to include all the required
#   certificates directly in $smtp_tls_cert_file
#   (or, Postfix >= 3.4 $smtp_tls_chain_files).
#   Specify "smtp_tls_CAfile = /path/to/system_CA_file" to use ONLY the system-
#   supplied default Certification Authority certificates.
#   Specify "tls_append_default_CA = no" to prevent Postfix from appending the
#   system-supplied default CAs and trusting third-party certificates. 
#
# @param main_smtp_tls_capath
#   Directory with PEM format Certification Authority certificates that the
#   Postfix SMTP client uses to verify a remote SMTP server certificate. Do not
#   forget to create the necessary "hash" links with, for example,
#   "$OPENSSL_HOME/bin/c_rehash /etc/postfix/certs".
#   To use this option in chroot mode, this directory (or a copy) must be inside
#   the chroot jail. 
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
# @param main_smtp_tls_security_level
#   The default SMTP TLS security level for the Postfix SMTP client. Specify
#   one of the following security levels: none, may, encrypt, dane, dane-only,
#   fingerprint, verify, secure.
#
# @param main_transport_maps
#   Optional lookup tables with mappings from recipient address to (message
#   delivery transport, next-hop destination). See transport(5) for details.
#   This parameter can be used to specify a file not managed by this puppet module
#   to provide alternative lookup sources. For example ldap, nis, mysql, pcre, etc.
#   For more information see the man pages for postmap(1), transport(5)
#
# @param main_virtual_alias_domains
#   Postfix is final destination for the specified list of virtual alias domains,
#   that is, domains for which all addresses are aliased to addresses in other
#   local or remote domains. The SMTP server validates recipient addresses with
#   $virtual_alias_maps and rejects non-existent recipients. See also the virtual
#   alias domain class in the ADDRESS_CLASS_README file.
#
# @param main_virtual_alias_maps
#   Optional lookup tables that alias specific mail addresses or domains to other
#   local or remote address. The table format and lookups are documented in
#   virtual(5). For an overview of Postfix address manipulations see the
#   ADDRESS_REWRITING_README document.
#   This feature is available in Postfix 2.0 and later.
#
#
# @param main_message_size_limit
#   The maximal size in bytes of a message, including envelope information. The
#   value cannot exceed LONG_MAX (typically, a 32-bit or 64-bit signed integer).
#
# @param main_canonical_maps
#   Optional address mapping lookup tables for message headers and envelopes.
#   The mapping is applied to both sender and recipient addresses, in both
#   envelopes and in headers, as controlled with the canonical_classes parameter.
#   This is typically used to clean up dirty addresses from legacy mail systems,
#   or to replace login names by Firstname.Lastname. The table format and lookups
#   are documented in canonical(5). For an overview of Postfix address
#   manipulations see the ADDRESS_REWRITING_README document.
#   Specify zero or more "type:name" lookup tables, separated by whitespace or
#   comma. Tables will be searched in the specified order until a match is found.
#   Note: these lookups are recursive.
#
# @param main_relocated_maps
#   Optional lookup tables with new contact information for users or domains that
#   no longer exist. The table format and lookups are documented in relocated(5).
#   Specify zero or more "type:name" lookup tables, separated by whitespace or
#   comma. Tables will be searched in the specified order until a match is found.
#
# @param main_smtpd_sender_restrictions
#   Optional restrictions that the Postfix SMTP server applies in the context of
#   a client MAIL FROM command. See SMTPD_ACCESS_README, section "Delayed
#   evaluation of SMTP access restriction lists" for a discussion of evaluation
#   context and time.
#   The default is to permit everything.
#   Specify a list of restrictions, separated by commas and/or whitespace.
#   Continue long lines by starting the next line with whitespace. Restrictions
#   are applied in the order as specified; the first restriction that matches wins.
#   The following restrictions are specific to the sender address received with
#   the MAIL FROM command.
#
# @param main_debugger_command
#   The external command to execute when a Postfix daemon program is invoked with
#   the -D option.
#   Use "command .. & sleep 5" so that the debugger can attach before the process
#   marches on. If you use an X-based debugger, be sure to set up your XAUTHORITY
#   environment variable before starting Postfix.
#   Note: the command is subject to $name expansion, before it is passed to the
#   default command interpreter. Specify "$$" to produce a single "$" character.
#
# @param main_smtpd_delay_reject
#   Wait until the RCPT TO command before evaluating $smtpd_client_restrictions,
#   $smtpd_helo_restrictions and $smtpd_sender_restrictions, or wait until the
#   ETRN command before evaluating $smtpd_client_restrictions and
#   $smtpd_helo_restrictions.
#   This feature is turned on by default because some clients apparently
#   mis-behave when the Postfix SMTP server rejects commands before RCPT TO.
#   The default setting has one major benefit: it allows Postfix to log recipient
#   address information when rejecting a client name/address or sender address,
#   so that it is possible to find out whose mail is being rejected.
#
# @param main_smtpd_sasl_auth_enable
#   Enable SASL authentication in the Postfix SMTP server. By default, the Postfix
#   SMTP server does not use authentication.
#
# @param main_smtpd_tls_ask_ccert
#   Ask a remote SMTP client for a client certificate. This information is needed
#   for certificate based mail relaying with, for example, the
#   permit_tls_clientcerts feature.
#   Some clients such as Netscape will either complain if no certificate is
#   available (for the list of CAs in $smtpd_tls_CAfile) or will offer multiple
#   client certificates to choose from. This may be annoying, so this option is
#   "off" by default.
#   This feature is available in Postfix 2.2 and later.
#
# @param main_smtpd_tls_received_header
#   Request that the Postfix SMTP server produces Received: message headers that
#   include information about the protocol and cipher used, as well as the remote
#   SMTP client CommonName and client certificate issuer CommonName. This is
#   disabled by default, as the information may be modified in transit through
#   other mail servers. Only information that was recorded by the final
#   destination can be trusted.
#   This feature is available in Postfix 2.2 and later.
#
# @param main_smtpd_use_tls
#   Opportunistic TLS: announce STARTTLS support to remote SMTP clients, but do
#   not require that clients use TLS encryption.
#   This feature is available in Postfix 2.2 and later. With Postfix 2.3 and later
#   use smtpd_tls_security_level instead.
#
# @param main_smtp_enforce_tls
#   Enforcement mode: require that remote SMTP servers use TLS encryption, and
#   never send mail in the clear. This also requires that the remote SMTP server
#   hostname matches the information in the remote server certificate, and that
#   the remote SMTP server certificate was issued by a CA that is trusted by the
#   Postfix SMTP client. If the certificate doesn't verify or the hostname
#   doesn't match, delivery is deferred and mail stays in the queue.
#   The server hostname is matched against all names provided as dNSNames in the
#   SubjectAlternativeName. If no dNSNames are specified, the CommonName is
#   checked. The behavior may be changed with the smtp_tls_enforce_peername option.
#   This option is useful only if you are definitely sure that you will only
#   connect to servers that support RFC 2487 _and_ that provide valid server
#   certificates. Typical use is for clients that send all their email to a
#   dedicated mailhub.
#   This feature is available in Postfix 2.2 and later. With Postfix 2.3 and later
#   use smtp_tls_security_level instead.
#
# @param main_smtp_sasl_auth_enable
#   Enable SASL authentication in the Postfix SMTP client. By default, the
#   Postfix SMTP client uses no authentication.
#
# @param main_smtp_use_tls
#   Opportunistic mode: use TLS when a remote SMTP server announces STARTTLS
#   support, otherwise send the mail in the clear. Beware: some SMTP servers
#   offer STARTTLS even if it is not configured. With Postfix < 2.3, if the
#   TLS handshake fails, and no other server is available, delivery is deferred
#   and mail stays in the queue. If this is a concern for you, use the
#   smtp_tls_per_site feature instead.
#   This feature is available in Postfix 2.2 and later. With Postfix 2.3 and
#   later use smtp_tls_security_level instead.
#
# @param main_strict_8bitmime
#   Enable both strict_7bit_headers and strict_8bitmime_body.
#   This feature should not be enabled on a general purpose mail server,
#   because it is likely to reject legitimate email.
#   This feature is available in Postfix 2.0 and later.
#
# @param main_strict_rfc821_envelopes
#   Require that addresses received in SMTP MAIL FROM and RCPT TO commands are
#   enclosed with <>, and that those addresses do not contain RFC 822 style
#   comments or phrases. This stops mail from poorly written software.
#   By default, the Postfix SMTP server accepts RFC 822 syntax in MAIL FROM and
#   RCPT TO addresses.
#
# @param packages
#   Array of package names used for installation.
#
# @param service_enable
#   Whether a service should be enabled to start at boot.
#   Valid values are true, false.
#
# @param service_ensure
#   Whether a service should be running. Valid values are 'stopped' or 'running'.
#
# @param service_hasrestart
#   Specify that an init script has a restart command. If this is false and you do
#   not specify a command in the restart attribute, the init scripts stop and
#   start commands will be used. Defaults to false. Valid values are 'true' or
#   'false'.
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
# @param transport_maps_external
#   Use a non-puppet managed source for the transport_maps, for example nis: or
#   ldap:. This parameter will cause the value of main_transport_maps to be
#   added despite the transport_map parameter beeing undefined.
#
# @param transport_maps
#   Hash of entries to add to transport_maps file defined by
#   $main_transport_maps. The value must be a string.
#
# @param canonical_maps
#   Hash of entries to add to canonical maps file defined by $main_canonical_maps.
#
# @param relocated_maps
#   Hash of entries to add to relocated maps file defined by $main_relocated_maps.
#
# @param main_unknown_local_recipient_reject_code
#   The numerical Postfix SMTP server response code when a recipient address is
#   local, and $local_recipient_maps specifies a list of lookup tables that does
#   not match the recipient. A recipient address is local when its domain matches
#   $mydestination, $proxy_interfaces or $inet_interfaces.
#   The default setting is 550 (reject mail) but it is safer to initially use 450
#   (try again later) so you have time to find out if your local_recipient_maps 
#   settings are OK.
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
# @param canonical_db_type
#  String of the database type that should be used for the canonical database.
#  See https://www.postfix.org/DATABASE_README.html for more information about
#  the possible database types.
#
# @param canonical_custom
#  Array of custom line that should be added to the canonical map.
#  These lines will be printed before the content of $canonical_maps.
#
# @param relocated_db_type
#  String of the database type that should be used for the relocated database.
#  See https://www.postfix.org/DATABASE_README.html for more information about
#  the possible database types.
#
# @param relocated_custom
#  Array of custom line that should be added to the relocation map.
#  These lines will be printed before the content of $relocated_maps.
#
# @param virtual_db_type
#  String of the database type that should be used for the virtual database.
#  See https://www.postfix.org/DATABASE_README.html for more information about
#  the possible database types.
#
# @param virtual_custom
#  Array of custom line that should be added to the virtual map.
#  These lines will be printed before the content of $virtual_aliases.
#
# @param transport_db_type
#  String of the database type that should be used for the transport database.
#  See https://www.postfix.org/DATABASE_README.html for more information about
#  the possible database types.
#
# @param transport_custom
#  Array of custom line that should be added to the transport map.
#  These lines will be printed before the content of $transport_maps.
#
# @param no_postmap_db_types
#   Array of DB types that do not require postmap to create the Postfix lookup
#   tables.
#
class postfix (
  Optional[String[1]] $main_alias_database                          = undef,
  Optional[String[1]] $main_alias_maps                              = undef,
  Optional[Enum['yes', 'no']] $main_append_dot_mydomain             = undef,
  Optional[Enum['yes', 'no']] $main_biff                            = undef,
  Optional[Stdlib::Absolutepath] $main_command_directory            = undef,
  Optional[String[1]] $main_compatibility_level                     = undef,
  Hash $main_custom                                                 = {},
  Optional[Stdlib::Absolutepath] $main_daemon_directory             = undef,
  Optional[Stdlib::Absolutepath] $main_data_directory               = undef,
  Optional[String[1]] $main_debug_peer_level                        = undef,
  Optional[String[1]] $main_html_directory                          = undef,
  Array[Postfix::Main_inet_interfaces] $main_inet_interfaces        = [],
  Optional[String[1]] $main_inet_protocols                          = undef,
  Optional[String[1]] $main_mailbox_command                         = undef,
  Optional[Stdlib::Absolutepath] $main_manpage_directory            = undef,
  Optional[Integer[0]] $main_mailbox_size_limit                     = undef,
  Optional[Stdlib::Absolutepath] $main_mailq_path                   = undef,
  Optional[String[1]] $main_mail_owner                              = undef,
  Optional[Stdlib::Absolutepath] $main_meta_directory               = undef,
  Optional[String[1]] $main_mydestination                           = undef,
  Optional[Stdlib::Host] $main_mydomain                             = undef,
  Optional[Stdlib::Host] $main_myhostname                           = undef,
  Array $main_mynetworks                                            = [],
  Optional[String[1]] $main_myorigin                                = undef,
  Optional[Stdlib::Absolutepath] $main_newaliases_path              = undef,
  Optional[Stdlib::Absolutepath] $main_queue_directory              = undef,
  Optional[String[1]] $main_readme_directory                        = undef,
  Optional[String[1]] $main_recipient_delimiter                     = undef,
  Optional[String[1]] $main_relay_domains                           = undef,
  Optional[Stdlib::Absolutepath] $main_sample_directory             = undef,
  Optional[Stdlib::Absolutepath] $main_sendmail_path                = undef,
  Optional[Stdlib::Host] $main_relayhost                            = undef,
  Integer[0] $main_relayhost_port                                   = 25,
  Optional[String[1]] $main_setgid_group                            = undef,
  Optional[Enum['yes', 'no']] $main_smtpd_helo_required             = undef,
  Optional[Array[String[1]]] $main_smtpd_helo_restrictions          = undef,
  Optional[Array[String[1]]] $main_smtpd_recipient_restrictions     = undef,
  Optional[String[1]] $main_smtpd_relay_restrictions                = undef,
  Optional[Stdlib::Absolutepath] $main_shlib_directory              = undef,
  Optional[String[1]] $main_smtpd_banner                            = undef,
  Optional[Stdlib::Absolutepath] $main_smtpd_tls_cert_file          = undef,
  Optional[Stdlib::Absolutepath] $main_smtpd_tls_key_file           = undef,
  Optional[String[1]] $main_smtpd_tls_mandatory_protocols           = undef,
  Optional[String[1]] $main_smtpd_tls_protocols                     = undef,
  Optional[String[1]] $main_smtpd_tls_security_level                = undef,
  Optional[Stdlib::Absolutepath] $main_smtp_tls_cafile              = undef,
  Optional[Stdlib::Absolutepath] $main_smtp_tls_capath              = undef,
  Optional[String[1]] $main_smtp_tls_mandatory_protocols            = undef,
  Optional[String[1]] $main_smtp_tls_protocols                      = undef,
  Optional[String[1]] $main_smtp_tls_security_level                 = undef,
  Optional[String[1]] $main_virtual_alias_domains                   = undef,
  Optional[Integer[0]] $main_message_size_limit                     = undef,
  Stdlib::Absolutepath $main_transport_maps                         = '/etc/postfix/transport',
  Stdlib::Absolutepath $main_virtual_alias_maps                     = '/etc/postfix/virtual',
  Stdlib::Absolutepath $main_canonical_maps                         = '/etc/postfix/canonical',
  Stdlib::Absolutepath $main_relocated_maps                         = '/etc/postfix/relocated',
  Optional[String[1]] $main_smtpd_sender_restrictions               = undef,
  Optional[String[1]] $main_debugger_command                        = undef,
  Optional[Enum['yes', 'no']] $main_smtpd_delay_reject              = undef,
  Optional[Enum['yes', 'no']] $main_smtpd_sasl_auth_enable          = undef,
  Optional[Enum['yes', 'no']] $main_smtpd_tls_ask_ccert             = undef,
  Optional[Enum['yes', 'no']] $main_smtpd_tls_received_header       = undef,
  Optional[Enum['yes', 'no']] $main_smtpd_use_tls                   = undef,
  Optional[Enum['yes', 'no']] $main_smtp_enforce_tls                = undef,
  Optional[Enum['yes', 'no']] $main_smtp_sasl_auth_enable           = undef,
  Optional[Enum['yes', 'no']] $main_smtp_use_tls                    = undef,
  Optional[Enum['yes', 'no']] $main_strict_8bitmime                 = undef,
  Optional[Enum['yes', 'no']] $main_strict_rfc821_envelopes         = undef,
  Array[String[1]] $packages                                        = ['postfix'],
  Variant[Boolean, Enum['true', 'false']] $service_enable           = true,
  Stdlib::Ensure::Service $service_ensure                           = 'running',
  Boolean $service_hasrestart                                       = true,
  Boolean $service_hasstatus                                        = true,
  Optional[String[1]] $service_name                                 = undef,
  Boolean $transport_maps_external                                  = false,
  Optional[Integer[0]] $main_unknown_local_recipient_reject_code    = undef,
  Boolean $virtual_aliases_external                                 = false,
  String[1] $canonical_db_type                                      = 'hash',
  Array $canonical_custom                                           = [],
  Hash $canonical_maps                                              = {},
  String[1] $relocated_db_type                                      = 'hash',
  Array $relocated_custom                                           = [],
  Hash $relocated_maps                                              = {},
  String[1] $virtual_db_type                                        = 'hash',
  Array $virtual_custom                                             = [],
  Hash $virtual_aliases                                             = {},
  String[1] $transport_db_type                                      = 'hash',
  Array $transport_custom                                           = [],
  Hash $transport_maps                                              = {},
  Array $no_postmap_db_types                                        = ['regexp'],
) {
  # <Install & Config>
  package { $packages:
    ensure => installed,
    before => [Service['postfix_service'], Package['sendmail'],],
  }

  service { 'postfix_service' :
    ensure     => $service_ensure,
    name       => $service_name,
    enable     => $service_enable,
    hasrestart => $service_hasrestart,
    hasstatus  => $service_hasstatus,
    subscribe  => File['postfix_main.cf'],
  }

  file { 'postfix_main.cf' :
    ensure  => file,
    path    => '/etc/postfix/main.cf',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp('postfix/main.cf.epp',
      {
        main_alias_database                      => $main_alias_database,
        main_alias_maps                          => $main_alias_maps,
        main_append_dot_mydomain                 => $main_append_dot_mydomain,
        main_biff                                => $main_biff,
        main_command_directory                   => $main_command_directory,
        main_daemon_directory                    => $main_daemon_directory,
        main_data_directory                      => $main_data_directory,
        main_inet_interfaces                     => $main_inet_interfaces,
        main_inet_protocols                      => $main_inet_protocols,
        main_smtp_tls_mandatory_protocols        => $main_smtp_tls_mandatory_protocols,
        main_smtp_tls_cafile                     => $main_smtp_tls_cafile,
        main_smtp_tls_capath                     => $main_smtp_tls_capath,
        main_smtp_tls_protocols                  => $main_smtp_tls_protocols,
        main_smtp_tls_security_level             => $main_smtp_tls_security_level,
        main_smtpd_banner                        => $main_smtpd_banner,
        main_smtpd_helo_required                 => $main_smtpd_helo_required,
        main_smtpd_helo_restrictions             => $main_smtpd_helo_restrictions,
        main_smtpd_recipient_restrictions        => $main_smtpd_recipient_restrictions,
        main_smtpd_tls_mandatory_protocols       => $main_smtpd_tls_mandatory_protocols,
        main_smtpd_tls_protocols                 => $main_smtpd_tls_protocols,
        main_smtpd_tls_security_level            => $main_smtpd_tls_security_level,
        main_smtpd_tls_key_file                  => $main_smtpd_tls_key_file,
        main_smtpd_tls_cert_file                 => $main_smtpd_tls_cert_file,
        main_compatibility_level                 => $main_compatibility_level,
        main_debug_peer_level                    => $main_debug_peer_level,
        main_html_directory                      => $main_html_directory,
        main_mailbox_command                     => $main_mailbox_command,
        main_mailbox_size_limit                  => $main_mailbox_size_limit,
        main_mailq_path                          => $main_mailq_path,
        main_mail_owner                          => $main_mail_owner,
        main_manpage_directory                   => $main_manpage_directory,
        main_meta_directory                      => $main_meta_directory,
        main_mydestination                       => $main_mydestination,
        main_mydomain                            => $main_mydomain,
        main_myhostname                          => $main_myhostname,
        main_mynetworks                          => $main_mynetworks,
        main_myorigin                            => $main_myorigin,
        main_newaliases_path                     => $main_newaliases_path,
        main_queue_directory                     => $main_queue_directory,
        main_readme_directory                    => $main_readme_directory,
        main_recipient_delimiter                 => $main_recipient_delimiter,
        main_sample_directory                    => $main_sample_directory,
        main_sendmail_path                       => $main_sendmail_path,
        main_relayhost                           => $main_relayhost,
        main_relayhost_port                      => $main_relayhost_port,
        main_relay_domains                       => $main_relay_domains,
        main_setgid_group                        => $main_setgid_group,
        main_shlib_directory                     => $main_shlib_directory,
        main_smtpd_relay_restrictions            => $main_smtpd_relay_restrictions,
        main_unknown_local_recipient_reject_code => $main_unknown_local_recipient_reject_code,
        main_virtual_alias_domains               => $main_virtual_alias_domains,
        main_virtual_alias_maps                  => $main_virtual_alias_maps,
        virtual_aliases                          => $virtual_aliases,
        virtual_custom                           => $virtual_custom,
        virtual_aliases_external                 => $virtual_aliases_external,
        main_transport_maps                      => $main_transport_maps,
        transport_maps                           => $transport_maps,
        transport_custom                         => $transport_custom,
        transport_maps_external                  => $transport_maps_external,
        main_custom                              => $main_custom,
        main_message_size_limit                  => $main_message_size_limit,
        main_canonical_maps                      => $main_canonical_maps,
        canonical_maps                           => $canonical_maps,
        canonical_custom                         => $canonical_custom,
        main_relocated_maps                      => $main_relocated_maps,
        relocated_maps                           => $relocated_maps,
        relocated_custom                         => $relocated_custom,
        main_smtpd_sender_restrictions           => $main_smtpd_sender_restrictions,
        main_debugger_command                    => $main_debugger_command,
        main_smtpd_delay_reject                  => $main_smtpd_delay_reject,
        main_smtpd_sasl_auth_enable              => $main_smtpd_sasl_auth_enable,
        main_smtpd_tls_ask_ccert                 => $main_smtpd_tls_ask_ccert,
        main_smtpd_tls_received_header           => $main_smtpd_tls_received_header,
        main_smtpd_use_tls                       => $main_smtpd_use_tls,
        main_smtp_enforce_tls                    => $main_smtp_enforce_tls,
        main_smtp_sasl_auth_enable               => $main_smtp_sasl_auth_enable,
        main_smtp_use_tls                        => $main_smtp_use_tls,
        main_strict_8bitmime                     => $main_strict_8bitmime,
        main_strict_rfc821_envelopes             => $main_strict_rfc821_envelopes,
        canonical_db_type                        => $canonical_db_type,
        relocated_db_type                        => $relocated_db_type,
        virtual_db_type                          => $virtual_db_type,
        transport_db_type                        => $transport_db_type,
      }
    ),
  }

  if $canonical_maps != {} or $canonical_custom != [] {
    file { 'postfix_canonical_maps':
      ensure  => file,
      path    => $main_canonical_maps,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => epp('postfix/maps.epp',
        {
          custom_data => $canonical_custom,
          maps_data   => $canonical_maps,
        }
      ),
    }

    unless $canonical_db_type in $no_postmap_db_types {
      exec { 'postfix_rebuild_canonical_maps':
        command     => "${main_command_directory}/postmap ${canonical_db_type}:${main_canonical_maps}",
        refreshonly => true,
        subscribe   => File['postfix_canonical_maps'],
        notify      => Service['postfix_service'],
      }
    }
  } else {
    file { 'postfix_canonical_maps':
      ensure => absent,
      path   => $main_canonical_maps,
    }
    file { 'postfix_canonical_maps_db':
      ensure => absent,
      path   => "${main_canonical_maps}.db",
      notify => Service['postfix_service'],
    }
  }

  if $relocated_maps != {} or $relocated_custom != [] {
    file { 'postfix_relocated_maps':
      ensure  => file,
      path    => $main_relocated_maps,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => epp('postfix/maps.epp',
        {
          custom_data => $relocated_custom,
          maps_data   => $relocated_maps,
        }
      ),
    }
    unless $relocated_db_type in $no_postmap_db_types {
      exec { 'postfix_rebuild_relocated_maps':
        command     => "${main_command_directory}/postmap ${relocated_db_type}:${main_relocated_maps}",
        refreshonly => true,
        subscribe   => File['postfix_relocated_maps'],
        notify      => Service['postfix_service'],
      }
    }
  } else {
    file { 'postfix_relocated_maps':
      ensure => absent,
      path   => $main_relocated_maps,
    }
    file { 'postfix_relocated_maps_db':
      ensure => absent,
      path   => "${main_relocated_maps}.db",
      notify => Service['postfix_service'],
    }
  }

  if $virtual_aliases != {} or $virtual_custom != [] {
    file { 'postfix_virtual':
      ensure  => file,
      path    => $main_virtual_alias_maps,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => epp('postfix/maps.epp',
        {
          custom_data => $virtual_custom,
          maps_data   => $virtual_aliases,
        }
      ),
    }
    unless $virtual_db_type in $no_postmap_db_types {
      exec { 'postfix_rebuild_virtual':
        command     => "${main_command_directory}/postmap ${virtual_db_type}:${main_virtual_alias_maps}",
        refreshonly => true,
        subscribe   => File['postfix_virtual'],
        notify      => Service['postfix_service'],
      }
    }
  }
  else {
    file { 'postfix_virtual':
      ensure => absent,
      path   => $main_virtual_alias_maps,
    }
    file { 'postfix_virtual_db':
      ensure => absent,
      path   => "${main_virtual_alias_maps}.db",
      notify => Service['postfix_service'],
    }
  }

  if $transport_maps != {} or $transport_custom != [] {
    file { 'postfix_transport':
      ensure  => file,
      path    => $main_transport_maps,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => epp('postfix/maps.epp',
        {
          custom_data => $transport_custom,
          maps_data   => $transport_maps,
        }
      ),
    }
    unless $transport_db_type in $no_postmap_db_types {
      exec { 'postfix_rebuild_transport':
        command     => "${main_command_directory}/postmap ${transport_db_type}:${main_transport_maps}",
        refreshonly => true,
        subscribe   => File['postfix_transport'],
        notify      => Service['postfix_service'],
      }
    }
  }
  else {
    file { 'postfix_transport':
      ensure => absent,
      path   => $main_transport_maps,
    }
    file { 'postfix_transport_db':
      ensure => absent,
      path   => "${main_transport_maps}.db",
      notify => Service['postfix_service'],
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
