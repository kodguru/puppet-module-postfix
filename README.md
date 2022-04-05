[![Build Status](https://travis-ci.org/kodguru/puppet-module-postfix.png?branch=master)](https://travis-ci.org/kodguru/puppet-module-postfix)

# puppet-module-postfix #
===

Puppet Module to manage Postfix for mail relaying

The module installs and configures Postfix MTA to relay local mail to a relayhost.

# Compatability #

This module has been tested to work on the following systems with Puppet
versions 5, 6 and 7 with the Ruby version associated with those releases.
This module aims to support the current and previous major Puppet versions.

This module provides OS default values for these OSfamilies:

 * Debian
 * RedHat
 * Suse
 * Ubuntu 14.04
 * Ubuntu 16.04
 * Ubuntu 18.04
 * Ubuntu 20.04

For other OSfamilies support, please specify all parameters which defaults to 'USE_DEFAULTS'.


# Version history #
* 1.6.5 2021-02-12 Restore support for Suse variant SLED
* 1.6.4 2020-08-13 add support for Ubuntu 20.04
* 1.6.3 2019-11-01 add support for SLES 15
* 1.6.2 2019-10-09 fix daemon directory for SLES 12.3, remove ruby 1.8.7 spec tests
* 1.6.1 2019-01-08 add support for Ubuntu 18.04
* 1.6.0 2018-12-11 add support for Ubuntu 16.04
* 1.5.2 2018-10-29 Support Puppet 6
* 1.5.1 2018-09-26 Support Puppet 5
* 1.5.0 2016-09-12 add parameters for main.cf: mydomain, smtpd_helo_required, smtpd_helo_restrictions, smtpd_recipient_restrictions and smtpd_tls_mandatory_protocols
* 1.4.0 2016-09-12 add parameters for main.cf: mydomain, smtpd_helo_required, smtpd_helo_restrictions, smtpd_recipient_restrictions and smtpd_tls_mandatory_protocols
* 1.3.1 2015-11-03 add possibility to specify TLS cert for smtpd, refactor spec tests
* 1.3.0 2015-08-26 add support for basic SSL/TLS configuration
* 1.2.1 2015-08-03 support newer versions of Puppet v3 as well as the future parser and Puppet v4
* 1.2.0 2015-06-10 add ability to configure transport maps
* 1.1.0 2015-04-14 add support for mailbox_command and relay_domains
* 1.0.2 2015-02-12 fix broken metadata.json
* 1.0.1 2015-02-11 deprecate type() as preparation for Puppet v4. Needs stdlib >= 4.2 now
* 1.0.0 2014-11-25 initial 1.0.0 release
