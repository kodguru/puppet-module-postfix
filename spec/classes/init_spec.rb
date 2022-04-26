require 'spec_helper'
describe 'postfix' do
  # define os specific defaults
  platforms = {
    'Debian' =>
      {
        operatingsystem:                  'Debian',
        operatingsystemrelease:           '8.0',
        osfamily:                         'Debian',
        main_command_directory_default:   '/usr/sbin',
        main_daemon_directory_default:    '/usr/lib/postfix',
        main_data_directory_default:      '/var/lib/postfix',
        main_mailbox_size_limit_default:  51_200_000,
        main_mydestination_default:       '$myhostname, localhost.$mydomain, localhost',
        main_queue_directory_default:     '/var/spool/postfix',
        main_recipient_delimiter_default: nil,
        main_setgid_group_default:        'postdrop',
        packages_default:                 'postfix',
      },
    'RedHat' =>
      {
        operatingsystem:                  'RedHat',
        operatingsystemrelease:           '7.0.1406',
        osfamily:                         'Redhat',
        main_command_directory_default:   '/usr/sbin',
        main_daemon_directory_default:    '/usr/libexec/postfix',
        main_data_directory_default:      '/var/lib/postfix',
        main_mailbox_size_limit_default:  51_200_000,
        main_mydestination_default:       '$myhostname, localhost.$mydomain, localhost',
        main_queue_directory_default:     '/var/spool/postfix',
        main_recipient_delimiter_default: nil,
        main_setgid_group_default:        'postdrop',
        packages_default:                 'postfix',
      },
    'Suse-10.4' =>
      {
        operatingsystem:                  'SLED',
        operatingsystemrelease:           '10.4',
        major:                            '10',
        minor:                            '4',
        osfamily:                         'Suse',
        main_command_directory_default:   '/usr/sbin',
        main_daemon_directory_default:    '/usr/lib/postfix',
        main_data_directory_default:      '/var/lib/postfix',
        main_mailbox_size_limit_default:  51_200_000,
        main_mydestination_default:       '$myhostname, localhost.$mydomain, localhost',
        main_queue_directory_default:     '/var/spool/postfix',
        main_recipient_delimiter_default: nil,
        main_setgid_group_default:        'maildrop',
        packages_default:                 'postfix',
      },
    'Suse-12.1' =>
      {
        operatingsystem:                  'SLES',
        operatingsystemrelease:           '12.1',
        major:                            '12',
        minor:                            '1',
        osfamily:                         'Suse',
        main_command_directory_default:   '/usr/sbin',
        main_daemon_directory_default:    '/usr/lib/postfix',
        main_data_directory_default:      '/var/lib/postfix',
        main_mailbox_size_limit_default:  51_200_000,
        main_mydestination_default:       '$myhostname, localhost.$mydomain, localhost',
        main_queue_directory_default:     '/var/spool/postfix',
        main_recipient_delimiter_default: nil,
        main_setgid_group_default:        'maildrop',
        packages_default:                 'postfix',
      },
    'Suse-12.3' =>
      {
        operatingsystem:                  'SLES',
        operatingsystemrelease:           '12.3',
        major:                            '12',
        minor:                            '3',
        osfamily:                         'Suse',
        main_command_directory_default:   '/usr/sbin',
        main_daemon_directory_default:    '/usr/lib/postfix/bin',
        main_data_directory_default:      '/var/lib/postfix',
        main_mailbox_size_limit_default:  51_200_000,
        main_mydestination_default:       '$myhostname, localhost.$mydomain, localhost',
        main_queue_directory_default:     '/var/spool/postfix',
        main_recipient_delimiter_default: nil,
        main_setgid_group_default:        'maildrop',
        packages_default:                 'postfix',
      },
    'Suse-15.0' =>
      {
        operatingsystem:                  'SLES',
        operatingsystemrelease:           '15.0',
        major:                            '15',
        minor:                            '0',
        osfamily:                         'Suse',
        main_command_directory_default:   '/usr/sbin',
        main_daemon_directory_default:    '/usr/lib/postfix/bin',
        main_data_directory_default:      '/var/lib/postfix',
        main_mailbox_size_limit_default:  51_200_000,
        main_mydestination_default:       '$myhostname, localhost.$mydomain, localhost',
        main_queue_directory_default:     '/var/spool/postfix',
        main_recipient_delimiter_default: nil,
        main_setgid_group_default:        'maildrop',
        packages_default:                 'postfix',
      },

    'Ubuntu-14.04' =>
      {
        operatingsystem:                  'Ubuntu',
        operatingsystemrelease:           '14.04',
        major:                            '14.04',
        osfamily:                         'Debian',
        main_command_directory_default:   '/usr/sbin',
        main_daemon_directory_default:    '/usr/lib/postfix',
        main_data_directory_default:      '/var/lib/postfix',
        main_mailbox_size_limit_default:  51_200_000,
        main_mydestination_default:       '$myhostname, localhost.$mydomain, localhost',
        main_queue_directory_default:     '/var/spool/postfix',
        main_recipient_delimiter_default: nil,
        main_setgid_group_default:        'postdrop',
        packages_default:                 'postfix',
      },
    'Ubuntu-16.04' =>
      {
        operatingsystem:                  'Ubuntu',
        operatingsystemrelease:           '16.04',
        major:                            '16.04',
        osfamily:                         'Debian',
        main_command_directory_default:   '/usr/sbin',
        main_daemon_directory_default:    '/usr/lib/postfix/sbin',
        main_data_directory_default:      '/var/lib/postfix',
        main_mailbox_size_limit_default:  51_200_000,
        main_mydestination_default:       '$myhostname, localhost.$mydomain, localhost',
        main_queue_directory_default:     '/var/spool/postfix',
        main_recipient_delimiter_default: nil,
        main_setgid_group_default:        'postdrop',
        packages_default:                 'postfix',
      },
    'Ubuntu-18.04' =>
      {
        operatingsystem:                  'Ubuntu',
        operatingsystemrelease:           '18.04',
        major:                            '18.04',
        osfamily:                         'Debian',
        main_command_directory_default:   '/usr/sbin',
        main_daemon_directory_default:    '/usr/lib/postfix/sbin',
        main_data_directory_default:      '/var/lib/postfix',
        main_mailbox_size_limit_default:  51_200_000,
        main_mydestination_default:       '$myhostname, localhost.$mydomain, localhost',
        main_queue_directory_default:     '/var/spool/postfix',
        main_recipient_delimiter_default: nil,
        main_setgid_group_default:        'postdrop',
        packages_default:                 'postfix',
      },
    'Ubuntu-20.04' =>
      {
        operatingsystem:                  'Ubuntu',
        operatingsystemrelease:           '20.04',
        major:                            '20.04',
        osfamily:                         'Debian',
        main_command_directory_default:   '/usr/sbin',
        main_daemon_directory_default:    '/usr/lib/postfix/sbin',
        main_data_directory_default:      '/var/lib/postfix',
        main_mailbox_size_limit_default:  51_200_000,
        main_mydestination_default:       '$myhostname, localhost.$mydomain, localhost',
        main_queue_directory_default:     '/var/spool/postfix',
        main_recipient_delimiter_default: nil,
        main_setgid_group_default:        'postdrop',
        packages_default:                 'postfix',
      },
  }

  describe 'with default values for parameters' do
    platforms.sort.each do |k, v|
      context "where OS is <#{k}>" do
        let :facts do
          {
            operatingsystem:        v[:operatingsystem],
            operatingsystemrelease: v[:operatingsystemrelease],
            osfamily:               v[:osfamily],
            domain:                 'test.local',
            fqdn:                   'dummy.test.local',
            os: {
              family: v[:osfamily],
              name:   v[:operatingsystem],
              release: {
                major: v[:major],
                minor: v[:minor],
              }
            }
          }
        end

        # package { $packages:}
        it {
          is_expected.to contain_package(v[:packages_default]).with(
            {
              'ensure' => 'installed',
              'before' => 'Package[sendmail]',
            },
          )
        }

        # service { 'postfix_service' :}
        it {
          is_expected.to contain_service('postfix_service').with(
            {
              'ensure'     => 'running',
              'name'       => v[:packages_default],
              'enable'     => 'true',
              'hasrestart' => 'true',
              'hasstatus'  => 'true',
              'require'    => "Package[#{v[:packages_default]}]",
              'subscribe'  => ['File[postfix_main.cf]', 'File[postfix_virtual]', 'File[postfix_transport]'],
            },
          )
        }

        # file { 'postfix_main.cf' :}
        it {
          is_expected.to contain_file('postfix_main.cf').with(
            {
              'ensure'     => 'file',
              'path'       => '/etc/postfix/main.cf',
              'owner'      => 'root',
              'group'      => 'root',
              'mode'       => '0644',
              'require'    => "Package[#{v[:packages_default]}]",
            },
          )
        }
        it { is_expected.to contain_file('postfix_main.cf').with_content(%r{^alias_database = hash:\/etc\/aliases$}) }
        it { is_expected.to contain_file('postfix_main.cf').with_content(%r{^alias_maps = hash:\/etc\/aliases$}) }
        it { is_expected.to contain_file('postfix_main.cf').with_content(%r{^append_dot_mydomain = no$}) }
        it { is_expected.to contain_file('postfix_main.cf').with_content(%r{^biff = no$}) }
        it { is_expected.to contain_file('postfix_main.cf').with_content(%r{^command_directory = #{v[:main_command_directory_default]}$}) }
        it { is_expected.to contain_file('postfix_main.cf').with_content(%r{^daemon_directory = #{v[:main_daemon_directory_default]}$}) }
        it { is_expected.to contain_file('postfix_main.cf').with_content(%r{^data_directory = #{v[:main_data_directory_default]}$}) }
        it { is_expected.to contain_file('postfix_main.cf').with_content(%r{^inet_interfaces = 127.0.0.1$}) }
        it { is_expected.to contain_file('postfix_main.cf').with_content(%r{^inet_protocols = ipv4$}) }
        it { is_expected.to contain_file('postfix_main.cf').with_content(%r{^mailbox_size_limit = 0$}) }
        it { is_expected.to contain_file('postfix_main.cf').with_content(%r{^mydestination = localhost$}) }
        it { is_expected.to contain_file('postfix_main.cf').with_content(%r{^myhostname = dummy.test.local$}) }
        it { is_expected.to contain_file('postfix_main.cf').with_content(%r{^mynetworks = 127.0.0.0\/8$}) }
        it { is_expected.to contain_file('postfix_main.cf').with_content(%r{^myorigin = \$myhostname$}) }
        it { is_expected.to contain_file('postfix_main.cf').with_content(%r{^queue_directory = #{v[:main_queue_directory_default]}$}) }
        it { is_expected.to contain_file('postfix_main.cf').with_content(%r{^recipient_delimiter = \+$}) }
        it { is_expected.to contain_file('postfix_main.cf').with_content(%r{^relayhost = mailhost.test.local:25$}) }
        it { is_expected.to contain_file('postfix_main.cf').with_content(%r{^setgid_group = #{v[:main_setgid_group_default]}$}) }
        it { is_expected.to contain_file('postfix_main.cf').without_content(%r{^virtual_alias_maps = hash:\/etc\/postfix\/virtual$}) }
        it { is_expected.to contain_file('postfix_main.cf').without_content(%r{^mailbox_command =}) }
        it { is_expected.to contain_file('postfix_main.cf').without_content(%r{^mydomain =}) }
        it { is_expected.to contain_file('postfix_main.cf').without_content(%r{^relay_domains =}) }
        it { is_expected.to contain_file('postfix_main.cf').without_content(%r{^smtpd_helo_required}) }
        it { is_expected.to contain_file('postfix_main.cf').without_content(%r{^smtpd_helo_restrictions}) }
        it { is_expected.to contain_file('postfix_main.cf').without_content(%r{^smtpd_recipient_restrictions}) }
        it { is_expected.to contain_file('postfix_main.cf').without_content(%r{^transport_maps}) }

        # file { 'postfix_virtual' :}
        it {
          is_expected.to contain_file('postfix_virtual').with(
            {
              'ensure'     => 'absent',
              'path'       => '/etc/postfix/virtual',
            },
          )
        }

        # file { 'postfix_virtual_db' :}
        it {
          is_expected.to contain_file('postfix_virtual_db').with(
            {
              'ensure'     => 'absent',
              'path'       => '/etc/postfix/virtual.db',
            },
          )
        }

        # package { 'sendmail' :}
        it {
          is_expected.to contain_package('sendmail').with(
            {
              'ensure'     => 'absent',
              'require'    => 'Package[sendmail-cf]',
            },
          )
        }

        # package { 'sendmail-cf' :}
        it { is_expected.to contain_package('sendmail-cf').with_ensure('absent') }
      end
    end
  end

  describe 'running on unkown OS, passing specific values for <USE_DEFAULTS>' do
    let(:facts) do
      {
        'osfamily' => 'UnknownOS',
        'domain'   => 'test.local',
        'fqdn'     => 'dummy.test.local',
      }
    end
    let(:params) do
      {
        'main_command_directory' => '/uOS/command',
        'main_daemon_directory'  => '/uOS/daemon',
        'main_data_directory'    => '/uOS/data',
        'main_queue_directory'   => '/uOS/queue',
        'main_setgid_group'      => 'uOSuser',
        'packages'               => 'uOSpostfix',
      }
    end

    # package { $packages_real:}
    it {
      is_expected.to contain_package('uOSpostfix').with(
        {
          'ensure' => 'installed',
          'before' => 'Package[sendmail]',
        },
      )
    }

    # service { 'postfix_service' :}
    it {
      is_expected.to contain_service('postfix_service').with(
        {
          'ensure'     => 'running',
          'name'       => 'postfix',
          'enable'     => 'true',
          'hasrestart' => 'true',
          'hasstatus'  => 'true',
          'require'    => 'Package[uOSpostfix]',
          'subscribe'  => ['File[postfix_main.cf]', 'File[postfix_virtual]', 'File[postfix_transport]'],
        },
      )
    }

    # file { 'postfix_main.cf' :}
    it {
      is_expected.to contain_file('postfix_main.cf').with(
        {
          'ensure'     => 'file',
          'path'       => '/etc/postfix/main.cf',
          'owner'      => 'root',
          'group'      => 'root',
          'mode'       => '0644',
          'require'    => 'Package[uOSpostfix]',
        },
      )
    }
    it { is_expected.to contain_file('postfix_main.cf').with_content(%r{^alias_database = hash:\/etc\/aliases$}) }
    it { is_expected.to contain_file('postfix_main.cf').with_content(%r{^alias_maps = hash:\/etc\/aliases$}) }
    it { is_expected.to contain_file('postfix_main.cf').with_content(%r{^append_dot_mydomain = no$}) }
    it { is_expected.to contain_file('postfix_main.cf').with_content(%r{^biff = no$}) }
    it { is_expected.to contain_file('postfix_main.cf').with_content(%r{^command_directory = \/uOS\/command$}) }
    it { is_expected.to contain_file('postfix_main.cf').with_content(%r{^daemon_directory = \/uOS\/daemon$}) }
    it { is_expected.to contain_file('postfix_main.cf').with_content(%r{^data_directory = \/uOS\/data$}) }
    it { is_expected.to contain_file('postfix_main.cf').with_content(%r{^inet_interfaces = 127.0.0.1$}) }
    it { is_expected.to contain_file('postfix_main.cf').with_content(%r{^inet_protocols = ipv4$}) }
    it { is_expected.to contain_file('postfix_main.cf').with_content(%r{^mailbox_size_limit = 0$}) }
    it { is_expected.to contain_file('postfix_main.cf').with_content(%r{^mydestination = localhost$}) }
    it { is_expected.to contain_file('postfix_main.cf').with_content(%r{^myhostname = dummy.test.local$}) }
    it { is_expected.to contain_file('postfix_main.cf').with_content(%r{^mynetworks = 127.0.0.0\/8$}) }
    it { is_expected.to contain_file('postfix_main.cf').with_content(%r{^myorigin = \$myhostname$}) }
    it { is_expected.to contain_file('postfix_main.cf').with_content(%r{^queue_directory = \/uOS\/queue$}) }
    it { is_expected.to contain_file('postfix_main.cf').with_content(%r{^recipient_delimiter = \+$}) }
    it { is_expected.to contain_file('postfix_main.cf').with_content(%r{^relayhost = mailhost.test.local:25$}) }
    it { is_expected.to contain_file('postfix_main.cf').with_content(%r{^setgid_group = uOSuser$}) }
    it { is_expected.to contain_file('postfix_main.cf').without_content(%r{^virtual_alias_maps = hash:\/etc\/postfix\/virtual$}) }
    it { is_expected.to contain_file('postfix_main.cf').without_content(%r{^mailbox_command =}) }
    it { is_expected.to contain_file('postfix_main.cf').without_content(%r{^mydomain =}) }
    it { is_expected.to contain_file('postfix_main.cf').without_content(%r{^relay_domains =}) }
    it { is_expected.to contain_file('postfix_main.cf').without_content(%r{^transport_maps}) }
    it { is_expected.to contain_file('postfix_main.cf').without_content(%r{^smtp_tls_mandatory_protocols}) }
    it { is_expected.to contain_file('postfix_main.cf').without_content(%r{^smtp_tls_protocols}) }
    it { is_expected.to contain_file('postfix_main.cf').without_content(%r{^smtp_tls_security_level}) }
    it { is_expected.to contain_file('postfix_main.cf').without_content(%r{^smtpd_helo_required}) }
    it { is_expected.to contain_file('postfix_main.cf').without_content(%r{^smtpd_helo_restrictions}) }
    it { is_expected.to contain_file('postfix_main.cf').without_content(%r{^smtpd_recipient_restrictions}) }
    it { is_expected.to contain_file('postfix_main.cf').without_content(%r{^smtpd_tls_mandatory_protocols}) }
    it { is_expected.to contain_file('postfix_main.cf').without_content(%r{^smtpd_tls_protocols}) }
    it { is_expected.to contain_file('postfix_main.cf').without_content(%r{^smtpd_tls_security_level}) }
    it { is_expected.to contain_file('postfix_main.cf').without_content(%r{^smtpd_tls_key_file}) }
    it { is_expected.to contain_file('postfix_main.cf').without_content(%r{^smtpd_tls_cert_file}) }

    # file { 'postfix_virtual' :}
    it {
      is_expected.to contain_file('postfix_virtual').with(
        {
          'ensure'     => 'absent',
          'path'       => '/etc/postfix/virtual',
        },
      )
    }

    # file { 'postfix_virtual_db' :}
    it {
      is_expected.to contain_file('postfix_virtual_db').with(
        {
          'ensure'     => 'absent',
          'path'       => '/etc/postfix/virtual.db',
        },
      )
    }

    # package { 'sendmail' :}
    it {
      is_expected.to contain_package('sendmail').with(
        {
          'ensure'     => 'absent',
          'require'    => 'Package[sendmail-cf]',
        },
      )
    }

    # package { 'sendmail-cf' :}
    it { is_expected.to contain_package('sendmail-cf').with_ensure('absent') }
  end

  describe 'running on unkown OS without passing specific values for <USE_DEFAULTS>' do
    let(:facts) do
      {
        'osfamily' => 'UnknownOS',
        'domain'   => 'test.local',
        'fqdn'     => 'dummy.test.local',
      }
    end

    it do
      expect {
        is_expected.to contain_class('postfix')
      }.to raise_error(Puppet::Error, %r{(Sorry, I don\'t know default values for UnknownOS yet :\( Please provide specific values to the postfix module\.|expects a String value)})
    end
  end

  describe 'validating variables on valid osfamily RedHat' do
    let(:facts) do
      {
        osfamily: 'Redhat',
        os: {
          family: 'RedHat',
        }
      }
    end

    # <testing free string variables for main.cf>
    ['main_alias_database', 'main_alias_maps', 'main_inet_interfaces', 'main_inet_protocols', 'main_mailbox_command',
     'main_mydestination', 'main_mynetworks', 'main_myorigin', 'main_relay_domains', 'main_setgid_group',
     'main_smtp_tls_mandatory_protocols', 'main_smtp_tls_protocols', 'main_smtp_tls_security_level',
     'main_smtpd_tls_mandatory_protocols', 'main_smtpd_tls_protocols', 'main_smtpd_tls_security_level',
     'main_transport_maps', 'main_virtual_alias_domains', 'main_virtual_alias_maps'].each do |variable|
      ['string1', 'string2'].each do |value|
        context "where #{variable} is set to valid #{value} (as #{value.class})" do
          let(:params) do
            {
              "#{variable}":            value,
              # needed for functionality tests
              transport_maps_external:  true,
              virtual_aliases_external: true,
            }
          end

          # remove 'main_' from the variable name to get the parameter name
          it { is_expected.to contain_file('postfix_main.cf').with_content(%r{^#{variable.sub('main_', '')} = #{value}$}) }
        end
      end
    end
    # </testing free string variables for main.cf>

    # <testing path type string variables for main.cf>
    ['main_command_directory', 'main_daemon_directory', 'main_data_directory', 'main_queue_directory', 'main_smtpd_tls_key_file', 'main_smtpd_tls_cert_file'].each do |variable|
      ['/path/1', '/path2'].each do |value|
        context "where #{variable} is set to valid #{value} (as #{value.class})" do
          let(:params) do
            {
              "#{variable}": value,
            }
          end

          # remove 'main_' from the variable name to get the parameter name
          it { is_expected.to contain_file('postfix_main.cf').with_content(%r{^#{variable.sub('main_', '')} = #{value}$}) }
        end
      end
    end
    # </testing path type string variables for main.cf>

    # <testing non empty string type variable for main.cf>
    ['alias_database', 'alias_maps', 'inet_interfaces', 'inet_protocols', 'mynetworks', 'myorigin', 'setgid_group', 'transport_maps', 'virtual_alias_maps'].each do |variable|
      context "where main_#{variable} is set to an invalid empty string" do
        let(:params) { { "main_#{variable}": '' } }

        it do
          expect {
            is_expected.to contain_class('postfix')
          }.to raise_error(Puppet::Error, %r{(main_#{Regexp.escape(variable)} must contain a valid value and is set to <>|expects a String|expects)})
        end
      end
    end
    # </testing variables for main.cf that is_expected.to not be empty>

    # <testing yes/no string type variables for main.cf>
    ['append_dot_mydomain', 'biff'].each do |variable|
      ['yes', 'no'].each do |value|
        context "where main_#{variable} is set to valid <#{value}> (as #{value.class})" do
          let(:params) { { "main_#{variable}": value } }

          it { is_expected.to contain_file('postfix_main.cf').with_content(%r{^#{Regexp.escape(variable)} = #{value}$}) }
        end
      end
    end
    # </testing yes/no string type variables for main.cf>

    context 'with main_mailbox_size_limit set to <51200000>' do
      let(:params) { { 'main_mailbox_size_limit' => 51_200_000 } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{^mailbox_size_limit = 51200000$}) }
    end

    [0, 242].each do |value|
      context "with main_mailbox_size_limit set to <#{value}>" do
        let(:params) { { main_mailbox_size_limit: value } }

        it { is_expected.to contain_file('postfix_main.cf').with_content(%r{^mailbox_size_limit = #{value}$}) }
      end
    end

    context 'with main_mailbox_size_limit set to invalid <-1>' do
      let(:params) { { 'main_mailbox_size_limit' => -1 } }

      it do
        expect {
          is_expected.to contain_class('postfix')
        }.to raise_error(Puppet::Error, %r{expects an Integer\[0\] value})
      end
    end

    context 'with main_relayhost set to <relayhost.valid.test>' do
      let(:params) { { 'main_relayhost' => 'relayhost.valid.test' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{^relayhost = relayhost.valid.test:25$}) }
    end

    context 'with main_relayhost_port set to <587>' do
      let(:params) do
        {
          'main_relayhost_port' => 587,
          # workaround to avoid needing to set the domain fact
          'main_relayhost' => 'relayhost.valid.test',
        }
      end

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{^relayhost = relayhost.valid.test:587$}) }
    end

    context 'with packages set to <postfix_alt>' do
      let(:params) { { packages: 'postfix_alt' } }

      it {
        is_expected.to contain_package('postfix_alt').with(
          {
            'ensure' => 'installed',
            'before' => 'Package[sendmail]',
          },
        )
      }
    end

    context "with main_smtpd_helo_required set to 'yes'" do
      let(:params) { { 'main_smtpd_helo_required' => 'yes' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{^smtpd_helo_required = yes}) }
    end

    describe 'with main_smtpd_restrictions' do
      context "set to [ 'permit_mynetworks' ]" do
        let(:params) { { 'main_smtpd_helo_restrictions' => [ 'permit_mynetworks'] } }

        it { is_expected.to contain_file('postfix_main.cf').with_content(%r{^smtpd_helo_restrictions = permit_mynetworks$}) }
      end

      context "set to [ 'permit_mynetworks', 'reject_invalid_helo_hostname' ]" do
        let(:params) { { 'main_smtpd_helo_restrictions' => [ 'permit_mynetworks', 'reject_invalid_helo_hostname'] } }

        it { is_expected.to contain_file('postfix_main.cf').with_content(%r{^smtpd_helo_restrictions = permit_mynetworks,\n    reject_invalid_helo_hostname}) }
      end
    end

    describe 'with main_smtpd_recipient_restrictions' do
      context "set to [ 'permit_mynetworks' ]" do
        let(:params) { { 'main_smtpd_recipient_restrictions' => [ 'permit_mynetworks'] } }

        it { is_expected.to contain_file('postfix_main.cf').with_content(%r{^smtpd_recipient_restrictions = permit_mynetworks$}) }
      end

      context "set to [ 'permit_mynetworks', 'permit_sasl_authenticated' ]" do
        let(:params) { { 'main_smtpd_recipient_restrictions' => [ 'permit_mynetworks', 'permit_sasl_authenticated'] } }

        it { is_expected.to contain_file('postfix_main.cf').with_content(%r{^smtpd_recipient_restrictions = permit_mynetworks,\n    permit_sasl_authenticated}) }
      end
    end

    context "with packages set to <['postfix', 'postfix-helper']>" do
      let(:params) { { packages: ['postfix', 'postfix-helper'] } }

      it {
        is_expected.to contain_package('postfix').with(
          {
            'ensure' => 'installed',
            'before' => 'Package[sendmail]',
          },
        )
      }

      it {
        is_expected.to contain_package('postfix-helper').with(
          {
            'ensure' => 'installed',
            'before' => 'Package[sendmail]',
          },
        )
      }
    end

    ['true', 'false', 'manual', true, false].each do |value|
      context "with service_enable set to <#{value}>" do
        let(:params) { { service_enable: value.to_s } }

        it {
          is_expected.to contain_service('postfix_service').with(
            {
              'ensure'     => 'running',
              'name'       => 'postfix',
              'enable'     => value.to_s,
              'hasrestart' => 'true',
              'hasstatus'  => 'true',
              'require'    => 'Package[postfix]',
              'subscribe'  => ['File[postfix_main.cf]', 'File[postfix_virtual]', 'File[postfix_transport]'],
            },
          )
        }
      end
    end

    ['running', 'stopped'].each do |value|
      context "with service_ensure set to <#{value}>" do
        let(:params) { { service_ensure: value.to_s } }

        it {
          is_expected.to contain_service('postfix_service').with(
            {
              'ensure'     => value.to_s,
              'name'       => 'postfix',
              'enable'     => 'true',
              'hasrestart' => 'true',
              'hasstatus'  => 'true',
              'require'    => 'Package[postfix]',
              'subscribe'  => ['File[postfix_main.cf]', 'File[postfix_virtual]', 'File[postfix_transport]'],
            },
          )
        }
      end
    end

    [true, false].each do |value|
      context "with service_hasrestart set to <#{value}>" do
        let(:params) { { service_hasrestart: value } }

        it {
          is_expected.to contain_service('postfix_service').with(
            {
              'ensure'     => 'running',
              'name'       => 'postfix',
              'enable'     => 'true',
              'hasrestart' => value,
              'hasstatus'  => 'true',
              'require'    => 'Package[postfix]',
              'subscribe'  => ['File[postfix_main.cf]', 'File[postfix_virtual]', 'File[postfix_transport]'],
            },
          )
        }
      end
    end

    [true, false].each do |value|
      context "with service_hasstatus set to <#{value}>" do
        let(:params) { { service_hasstatus: value } }

        it {
          is_expected.to contain_service('postfix_service').with(
            {
              'ensure'     => 'running',
              'name'       => 'postfix',
              'enable'     => 'true',
              'hasrestart' => 'true',
              'hasstatus'  => value,
              'require'    => 'Package[postfix]',
              'subscribe'  => ['File[postfix_main.cf]', 'File[postfix_virtual]', 'File[postfix_transport]'],
            },
          )
        }
      end
    end

    context 'with service_name set to <postfixservice>' do
      let(:params) { { 'service_name' => 'postfixservice' } }

      it {
        is_expected.to contain_service('postfix_service').with(
          {
            'ensure'     => 'running',
            'name'       => 'postfixservice',
            'enable'     => 'true',
            'hasrestart' => 'true',
            'hasstatus'  => 'true',
            'require'    => 'Package[postfix]',
            'subscribe'  => ['File[postfix_main.cf]', 'File[postfix_virtual]', 'File[postfix_transport]'],
          },
        )
      }
    end

    context 'with empty template_main_cf' do
      let(:params) { { 'template_main_cf' => '' } }

      it do
        expect {
          is_expected.to contain_class('postfix')
        }.to raise_error(Puppet::Error, %r{expects a String\[1\] value})
      end
    end

    context "with virtual_aliases set to <{ 'test1@test.void' => 'destination1', 'test2@test.void' => [ 'destination2', 'destination3' ] }>" do
      let(:params) { { 'virtual_aliases' => { 'test1@test.void' => 'destination1', 'test2@test.void' => [ 'destination2', 'destination3' ] } } }

      it { is_expected.to contain_file('postfix_virtual').with_content(%r{^test1@test.void\t\tdestination1$}) }
      it { is_expected.to contain_file('postfix_virtual').with_content(%r{^test2@test.void\t\tdestination2,destination3$}) }

      # exec { 'postfix_rebuild_virtual': }
      it {
        is_expected.to contain_exec('postfix_rebuild_virtual').with(
          {
            'command'     => '/usr/sbin/postmap hash:/etc/postfix/virtual',
            'refreshonly' => 'true',
            'subscribe'   => 'File[postfix_virtual]',
          },
        )
      }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{^virtual_alias_maps = hash:\/etc\/postfix\/virtual$}) }
    end

    context "where transport_maps is set to valid <[ 'sub1.example.com  mail1.example.com', 'sub2.example.com  mail2.example.com' ]> (as Hash))" do
      let(:params) { { 'transport_maps' => { 'sub1.example.com' => 'mail1.example.com', 'sub2.example.com' => 'mail2.example.com' } } }

      it { is_expected.to contain_file('postfix_transport').with_content(%r{^sub1.example.com\t\tmail1.example.com$}) }
      it { is_expected.to contain_file('postfix_transport').with_content(%r{^sub2.example.com\t\tmail2.example.com$}) }

      # exec { 'postfix_rebuild_virtual': }
      it {
        is_expected.to contain_exec('postfix_rebuild_transport').with(
          {
            'command'     => '/usr/sbin/postmap hash:/etc/postfix/transport',
            'refreshonly' => 'true',
            'subscribe'   => 'File[postfix_transport]',
          },
        )
      }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{^transport_maps = hash:\/etc\/postfix\/transport$}) }
    end

    [true, false].each do |value|
      context "where virtual_aliases_external is set to valid #{value} (as #{value.class})" do
        let(:params) do
          {
            'virtual_aliases_external' => value,
            # needed for the functionality test:
            'main_virtual_alias_maps'  => 'hash:/etc/postfix/spec_testing',
          }
        end

        if value == true
          it { is_expected.to contain_file('postfix_main.cf').with_content(%r{^virtual_alias_maps = hash:\/etc\/postfix\/spec_testing$}) }
        else
          it { is_expected.to contain_file('postfix_main.cf').without_content(%r{virtual_alias_maps}) }
        end
      end
    end
  end

  describe 'variable type and content validations' do
    # set needed custom facts and variables
    let(:facts) do
      {
        osfamily: 'Redhat',
        os: {
          family: 'RedHat',
        }
      }
    end
    let(:mandatory_params) do
      {
        #:param => 'value',
      }
    end

    validations = {
      'array' => {
        name:    ['main_smtpd_helo_restrictions', 'main_smtpd_recipient_restrictions'],
        valid:   [['array'], ['array', 'array']],
        invalid: ['invalid', 3, 2.42, { 'ha' => 'sh' }, true, false],
        message: 'is not an Array',
      },
      'bool_stringified' => {
        name:    ['service_hasrestart', 'service_hasstatus', 'transport_maps_external', 'virtual_aliases_external'],
        valid:   [true, false],
        invalid: ['true', 'false', nil, 'invalid', 3, 2.42, ['array'], { 'ha' => 'sh' }],
        message: 'expects a Boolean',
      },
      'hash' => {
        name:    ['transport_maps', 'virtual_aliases'],
        valid:   [{ 'ha' => 'sh' }, { 'test1@test.void' => 'destination1', 'test2@test.void' => ['destination2', 'destination3'] }],
        invalid: [true, false, 'invalid', 3, 2.42, ['array']],
        message: 'is not a Hash',
      },
      'Integer[0]' => {
        name:    ['main_mailbox_size_limit', 'main_relayhost_port'],
        valid:   [0, 242, 51_200_000 ],
        invalid: [-1, 2.42, 'string', ['array'], { 'ha' => 'sh' }],
        message: '(expects an Integer value|expects an Integer\[0\] value)',
      },
      'not_empty_string/array' => {
        name:    ['packages'],
        valid:   ['valid', ['array']],
        invalid: ['', [], 3, 2.42, { 'ha' => 'sh' }],
        message: 'must contain a valid value',
      },
      'regex_running/stopped' => {
        name:    ['service_ensure'],
        valid:   ['running', 'stopped'],
        invalid: ['invalid', 3, 2.42, ['array'], { 'ha' => 'sh' }],
        message: 'validate_legacy',
      },
      'regex_true/false/manual' => {
        name:    ['service_enable'],
        valid:   [true, 'true', false, 'false', 'manual'],
        invalid: ['invalid', 3, 2.42, ['array'], { 'ha' => 'sh' }],
        message: 'validate_legacy',
      },
      'Enum[yes, no]' => {
        name:    ['main_append_dot_mydomain', 'main_biff'],
        valid:   ['yes', 'no'],
        invalid: [true, false, 'invalid', 3, 2.42, ['array'], { 'ha' => 'sh' }],
        message: 'expects a match for Enum',
      },
      'Optional[Enum[yes, no]]' => {
        name:    ['main_smtpd_helo_required'],
        valid:   ['yes', 'no'],
        invalid: [true, false, 'invalid', 3, 2.42, ['array'], { 'ha' => 'sh' }],
        message: 'expects an undef value or a match for Enum',
      },
      'Stdlib::Absolutepath & Optional[Stdlib::Absolutepath]' => {
        name:    ['main_command_directory', 'main_daemon_directory', 'main_data_directory', 'main_queue_directory', 'main_smtpd_tls_cert_file', 'main_smtpd_tls_key_file'],
        valid:   ['/absolute/filepath', '/absolute/directory/'], # cant test undef :(
        invalid: ['relative/path', 3, 2.42, ['array'], { 'ha' => 'sh' }],
        message: 'expects a Stdlib::Absolutepath',
      },
      'Stdlib::Host & Optional[Stdlib::Host]' => {
        name:    ['main_inet_interfaces', 'main_mydestination', 'main_mydomain', 'main_myhostname', 'main_mynetworks', 'main_relayhost'],
        valid:   ['127.0.0.1', 'localhost', 'v.al.id', 'val.id'],
        invalid: ['in valid', 3, 2.42, ['array'], { 'ha' => 'sh' }],
        message: 'expects a Stdlib::Host',
      },
      'String[1]' => {
        name:    ['main_alias_database', 'main_alias_maps', 'main_inet_protocols', 'main_myorigin', 'main_recipient_delimiter', 'main_setgid_group', 'main_transport_maps',
                  'main_virtual_alias_maps', 'service_name'],
        valid:   ['valid'],
        invalid: ['', 3, 2.42, ['array'], { 'ha' => 'sh' }],
        message: '(expects a String value|expects a String\[1\] value)',
      },
      'Optional[String[1]]' => {
        name:    ['main_mailbox_command', 'main_relay_domains', 'main_smtpd_tls_mandatory_protocols', 'main_smtpd_tls_protocols', 'main_smtpd_tls_security_level',
                  'main_smtp_tls_mandatory_protocols', 'main_smtp_tls_protocols', 'main_smtp_tls_security_level', 'main_virtual_alias_domains'],
        valid:   ['valid'],
        invalid: [['array'], { 'ha' => 'sh' }],
        message: 'expects a value of type Undef or String',
      },
    }

    validations.sort.each do |type, var|
      var[:name].each do |var_name|
        var[:params] = {} if var[:params].nil?
        var[:valid].each do |valid|
          context "when #{var_name} (#{type}) is set to valid #{valid} (as #{valid.class})" do
            let(:params) { [mandatory_params, var[:params], { "#{var_name}": valid, }].reduce(:merge) }

            it { is_expected.to compile }
          end
        end

        var[:invalid].each do |invalid|
          context "when #{var_name} (#{type}) is set to invalid #{invalid} (as #{invalid.class})" do
            let(:params) { [mandatory_params, var[:params], { "#{var_name}": invalid, }].reduce(:merge) }

            it 'fail' do
              expect { is_expected.to contain_class(:subject) }.to raise_error(Puppet::Error, %r{#{var[:message]}})
            end
          end
        end
      end # var[:name].each
    end # validations.sort.each
  end # describe 'variable type and content validations'
end
