require 'spec_helper'
describe 'postfix' do

  # define os specific defaults
  platforms = {
    'Debian' =>
      {
        :osfamily                         => 'Debian',
        :main_command_directory_default   => '/usr/sbin',
        :main_daemon_directory_default    => '/usr/lib/postfix',
        :main_data_directory_default      => '/var/lib/postfix',
        :main_mailbox_size_limit_default  => '51200000',
        :main_mydestination_default       => '$myhostname, localhost.$mydomain, localhost',
        :main_queue_directory_default     => '/var/spool/postfix',
        :main_recipient_delimiter_default => '',
        :main_setgid_group_default        => 'postdrop',
        :packages_default                 => 'postfix',
      },
    'RedHat' =>
      {
        :osfamily                         => 'Redhat',
        :main_command_directory_default   => '/usr/sbin',
        :main_daemon_directory_default    => '/usr/libexec/postfix',
        :main_data_directory_default      => '/var/lib/postfix',
        :main_mailbox_size_limit_default  => '51200000',
        :main_mydestination_default       => '$myhostname, localhost.$mydomain, localhost',
        :main_queue_directory_default     => '/var/spool/postfix',
        :main_recipient_delimiter_default => '',
        :main_setgid_group_default        => 'postdrop',
        :packages_default                 => 'postfix',
      },
    'Suse' =>
      {
        :osfamily                         => 'Suse',
        :main_command_directory_default   => '/usr/sbin',
        :main_daemon_directory_default    => '/usr/lib/postfix',
        :main_data_directory_default      => '/var/lib/postfix',
        :main_mailbox_size_limit_default  => '51200000',
        :main_mydestination_default       => '$myhostname, localhost.$mydomain, localhost',
        :main_queue_directory_default     => '/var/spool/postfix',
        :main_recipient_delimiter_default => '',
        :main_setgid_group_default        => 'maildrop',
        :packages_default                 => 'postfix',
      },
  }

  describe 'with default values for parameters' do
    platforms.sort.each do |k,v|
      context "where osfamily is <#{v[:osfamily]}>" do

        let :facts do
          {
            :osfamily => v[:osfamily],
            :domain   => 'test.local',
            :fqdn     => 'dummy.test.local',
          }
        end

        # package { $packages_real:}
        it {
          should contain_package(v[:packages_default]).with({
            'ensure' => 'installed',
            'before' => 'Package[sendmail]',
          })
        }

        # service { 'postfix_service' :}
        it {
          should contain_service('postfix_service').with({
            'ensure'     => 'running',
            'name'       => v[:packages_default],
            'enable'     => 'true',
            'hasrestart' => 'true',
            'hasstatus'  => 'true',
            'require'    => "Package[#{v[:packages_default]}]",
            'subscribe'  => ['File[postfix_main.cf]', 'File[postfix_virtual]', 'File[postfix_transport]'],
          })
        }

        # file { 'postfix_main.cf' :}
        it {
          should contain_file('postfix_main.cf').with({
            'ensure'     => 'file',
            'path'       => '/etc/postfix/main.cf',
            'owner'      => 'root',
            'group'      => 'root',
            'mode'       => '0644',
            'require'    => "Package[#{v[:packages_default]}]",
          })
        }
        it { should contain_file('postfix_main.cf').with_content(/^alias_database = hash:\/etc\/aliases$/) }
        it { should contain_file('postfix_main.cf').with_content(/^alias_maps = hash:\/etc\/aliases$/) }
        it { should contain_file('postfix_main.cf').with_content(/^append_dot_mydomain = no$/) }
        it { should contain_file('postfix_main.cf').with_content(/^biff = no$/) }
        it { should contain_file('postfix_main.cf').with_content(/^command_directory = #{v[:main_command_directory_default]}$/) }
        it { should contain_file('postfix_main.cf').with_content(/^daemon_directory = #{v[:main_daemon_directory_default]}$/) }
        it { should contain_file('postfix_main.cf').with_content(/^data_directory = #{v[:main_data_directory_default]}$/) }
        it { should contain_file('postfix_main.cf').with_content(/^inet_interfaces = 127.0.0.1$/) }
        it { should contain_file('postfix_main.cf').with_content(/^inet_protocols = ipv4$/) }
        it { should contain_file('postfix_main.cf').with_content(/^mailbox_size_limit = 0$/) }
        it { should contain_file('postfix_main.cf').with_content(/^mydestination = localhost$/) }
        it { should contain_file('postfix_main.cf').with_content(/^myhostname = dummy.test.local$/) }
        it { should contain_file('postfix_main.cf').with_content(/^mynetworks = 127.0.0.0\/8$/) }
        it { should contain_file('postfix_main.cf').with_content(/^myorigin = \$myhostname$/) }
        it { should contain_file('postfix_main.cf').with_content(/^queue_directory = #{v[:main_queue_directory_default]}$/) }
        it { should contain_file('postfix_main.cf').with_content(/^recipient_delimiter = \+$/) }
        it { should contain_file('postfix_main.cf').with_content(/^relayhost = mailhost.test.local:25$/) }
        it { should contain_file('postfix_main.cf').with_content(/^setgid_group = #{v[:main_setgid_group_default]}$/) }
        it { should contain_file('postfix_main.cf').without_content(/^virtual_alias_maps = hash:\/etc\/postfix\/virtual$/) }
        it { should contain_file('postfix_main.cf').without_content(/^mailbox_command =/) }
        it { should contain_file('postfix_main.cf').without_content(/^relay_domains =/) }
        it { should contain_file('postfix_main.cf').without_content(/^transport_maps/) }


        # file { 'postfix_virtual' :}
        it {
          should contain_file('postfix_virtual').with({
            'ensure'     => 'absent',
            'path'       => '/etc/postfix/virtual',
          })
        }

        # file { 'postfix_virtual_db' :}
        it {
          should contain_file('postfix_virtual_db').with({
            'ensure'     => 'absent',
            'path'       => '/etc/postfix/virtual.db',
          })
        }

        # package { 'sendmail' :}
        it {
          should contain_package('sendmail').with({
            'ensure'     => 'absent',
            'require'    => 'Package[sendmail-cf]',
          })
        }

        # package { 'sendmail-cf' :}
        it {
          should contain_package('sendmail-cf').with({
            'ensure'     => 'absent',
          })
        }
      end
    end
  end


  describe 'running on unkown OS, passing specific values for <USE_DEFAULTS>' do
    let(:facts) { {
      'osfamily' => 'UnknownOS',
      'domain'   => 'test.local',
      'fqdn'     => 'dummy.test.local',
    } }

    let(:params) { {
      'main_command_directory' => '/uOS/command',
      'main_daemon_directory'  => '/uOS/daemon',
      'main_data_directory'    => '/uOS/data',
      'main_queue_directory'   => '/uOS/queue',
      'main_setgid_group'      => 'uOSuser',
      'packages'               => 'uOSpostfix',
    } }

    # package { $packages_real:}
    it {
      should contain_package('uOSpostfix').with({
        'ensure' => 'installed',
        'before' => 'Package[sendmail]',
      })
    }

    # service { 'postfix_service' :}
    it {
      should contain_service('postfix_service').with({
        'ensure'     => 'running',
        'name'       => 'postfix',
        'enable'     => 'true',
        'hasrestart' => 'true',
        'hasstatus'  => 'true',
        'require'    => 'Package[uOSpostfix]',
        'subscribe'  => ['File[postfix_main.cf]', 'File[postfix_virtual]', 'File[postfix_transport]'],
      })
    }

    # file { 'postfix_main.cf' :}
    it {
      should contain_file('postfix_main.cf').with({
        'ensure'     => 'file',
        'path'       => '/etc/postfix/main.cf',
        'owner'      => 'root',
        'group'      => 'root',
        'mode'       => '0644',
        'require'    => 'Package[uOSpostfix]',
      })
    }
    it { should contain_file('postfix_main.cf').with_content(/^alias_database = hash:\/etc\/aliases$/) }
    it { should contain_file('postfix_main.cf').with_content(/^alias_maps = hash:\/etc\/aliases$/) }
    it { should contain_file('postfix_main.cf').with_content(/^append_dot_mydomain = no$/) }
    it { should contain_file('postfix_main.cf').with_content(/^biff = no$/) }
    it { should contain_file('postfix_main.cf').with_content(/^command_directory = \/uOS\/command$/) }
    it { should contain_file('postfix_main.cf').with_content(/^daemon_directory = \/uOS\/daemon$/) }
    it { should contain_file('postfix_main.cf').with_content(/^data_directory = \/uOS\/data$/) }
    it { should contain_file('postfix_main.cf').with_content(/^inet_interfaces = 127.0.0.1$/) }
    it { should contain_file('postfix_main.cf').with_content(/^inet_protocols = ipv4$/) }
    it { should contain_file('postfix_main.cf').with_content(/^mailbox_size_limit = 0$/) }
    it { should contain_file('postfix_main.cf').with_content(/^mydestination = localhost$/) }
    it { should contain_file('postfix_main.cf').with_content(/^myhostname = dummy.test.local$/) }
    it { should contain_file('postfix_main.cf').with_content(/^mynetworks = 127.0.0.0\/8$/) }
    it { should contain_file('postfix_main.cf').with_content(/^myorigin = \$myhostname$/) }
    it { should contain_file('postfix_main.cf').with_content(/^queue_directory = \/uOS\/queue$/) }
    it { should contain_file('postfix_main.cf').with_content(/^recipient_delimiter = \+$/) }
    it { should contain_file('postfix_main.cf').with_content(/^relayhost = mailhost.test.local:25$/) }
    it { should contain_file('postfix_main.cf').with_content(/^setgid_group = uOSuser$/) }
    it { should contain_file('postfix_main.cf').without_content(/^virtual_alias_maps = hash:\/etc\/postfix\/virtual$/) }
    it { should contain_file('postfix_main.cf').without_content(/^mailbox_command =/) }
    it { should contain_file('postfix_main.cf').without_content(/^relay_domains =/) }
    it { should contain_file('postfix_main.cf').without_content(/^transport_maps/) }

    # file { 'postfix_virtual' :}
    it {
      should contain_file('postfix_virtual').with({
        'ensure'     => 'absent',
        'path'       => '/etc/postfix/virtual',
      })
    }

    # file { 'postfix_virtual_db' :}
    it {
      should contain_file('postfix_virtual_db').with({
        'ensure'     => 'absent',
        'path'       => '/etc/postfix/virtual.db',
      })
    }

    # package { 'sendmail' :}
    it {
      should contain_package('sendmail').with({
        'ensure'     => 'absent',
        'require'    => 'Package[sendmail-cf]',
      })
    }

    # package { 'sendmail-cf' :}
    it {
      should contain_package('sendmail-cf').with({
        'ensure'     => 'absent',
      })
    }
  end


  describe 'running on unkown OS without passing specific values for <USE_DEFAULTS>' do
    let(:facts) { {
      'osfamily' => 'UnknownOS',
      'domain'   => 'test.local',
      'fqdn'     => 'dummy.test.local',
    } }

    it do
      expect {
        should contain_class('postfix')
      }.to raise_error(Puppet::Error, /^Sorry, I don\'t know default values for UnknownOS yet :\( Please provide specific values to the postfix module./)
    end

  end


  describe 'validating variables on valid osfamily RedHat' do
    let(:facts) { { :osfamily => 'Redhat' } }

    #<testing free string variables for main.cf>
    ['alias_database','alias_maps','inet_interfaces','inet_protocols','mailbox_command','mydestination','mynetworks','myorigin','relay_domains','setgid_group','transport_maps','virtual_alias_maps','virtual_alias_domains',].each do |variable|
      ['string1','string2',].each do |value|
        context "where main_#{variable} is set to valid #{value} (as #{value.class})" do
          let(:params) { {
            :"main_#{variable}"       => value,
            # needed for functionality tests
            :transport_maps_external  => true,
            :virtual_aliases_external => true,
          } }

          it { should contain_file('postfix_main.cf').with_content(/^#{variable} = #{value}$/) }
        end
      end

      [['array'],a = { 'ha' => 'sh' },].each do |value|
        context "where main_#{variable} is set to invalid #{value} (as #{value.class})" do
          let(:params) { { :"main_#{variable}" => value } }

          it do
            expect {
              should contain_class('postfix')
          }.to raise_error(Puppet::Error, /is not a string/)
          end
        end
      end
    end
    #</testing free string variables for main.cf>

    #<testing path type string variables for main.cf>
    ['command_directory','daemon_directory','data_directory','queue_directory',].each do |variable|
      ['/path/1','/path2',].each do |value|
        context "where main_#{variable} is set to valid #{value} (as #{value.class})" do
          let(:params) { {
            :"main_#{variable}"       => value,
          } }

          it { should contain_file('postfix_main.cf').with_content(/^#{variable} = #{value}$/) }
        end
      end

      ['../invalid/path',['array'],a = { 'ha' => 'sh' },].each do |value|
        context "where main_#{variable} is set to invalid #{value} (as #{value.class})" do
          let(:params) { { :"main_#{variable}" => value } }

          it do
            expect {
              should contain_class('postfix')
          }.to raise_error(Puppet::Error, /is not an absolute path/)
          end
        end
      end
    end
    #</testing path type string variables for main.cf>

    #<testing non empty string type variable for main.cf>
    ['alias_database','alias_maps','inet_interfaces','inet_protocols','mynetworks','myorigin','setgid_group','transport_maps','virtual_alias_maps',].each do |variable|
      context "where main_#{variable} is set to an invalid empty string" do
        let(:params) { { :"main_#{variable}" => '' } }

        it do
          expect {
            should contain_class('postfix')
          }.to raise_error(Puppet::Error, /^main_#{Regexp.escape(variable)} must contain a valid value and is set to <>/)
        end
      end
    end
    #</testing variables for main.cf that should not be empty>

    #<testing yes/no string type variables for main.cf>
    ['append_dot_mydomain','biff',].each do |variable|
      ['yes','no'].each do |value|
        context "where main_#{variable} is set to valid <#{value}> (as #{value.class})" do
          let(:params) { { :"main_#{variable}" => value } }

          it { should contain_file('postfix_main.cf').with_content(/^#{Regexp.escape(variable)} = #{value}$/) }
        end
      end

      ['string',true,false,].each do |value|
        context "where main_#{variable} is set to invalid <#{value}> (as #{value.class})" do
          let(:params) { { :"main_#{variable}" => value } }

          it do
            expect {
              should contain_class('postfix')
            }.to raise_error(Puppet::Error, /^main_#{Regexp.escape(variable)} may be either 'yes' or 'no' and is set to <#{value}>/)
          end
        end
      end

    end
    #</testing yes/no string type variables for main.cf>

    context 'with main_mailbox_size_limit set to <USE_DEFAULTS>' do
      let(:params) { { 'main_mailbox_size_limit' => 'USE_DEFAULTS' } }

      it { should contain_file('postfix_main.cf').with_content(/^mailbox_size_limit = 51200000$/) }
    end

    ['0','242',0,242].each do |value|
      context "with main_mailbox_size_limit set to <#{value}>" do
        let(:params) { { :main_mailbox_size_limit => "#{value}" } }

        it { should contain_file('postfix_main.cf').with_content(/^mailbox_size_limit = #{value}$/) }
      end
    end

    context 'with main_mailbox_size_limit set to invalid <noninteger>' do
      let(:params) { { 'main_mailbox_size_limit' => 'noninteger' } }

      it do
        expect {
          should contain_class('postfix')
        }.to raise_error(Puppet::Error, /^main_mailbox_size_limit must be an integer and is set to <noninteger>/)
      end
    end

    context 'with main_mailbox_size_limit set to invalid <-1>' do
      let(:params) { { 'main_mailbox_size_limit' => '-1' } }

      it do
        expect {
          should contain_class('postfix')
        }.to raise_error(Puppet::Error, /^main_mailbox_size_limit needs a minimum value of 0 and is set to <-1>/)
      end
    end

    context 'with main_myhostname set to invalid <invalid_domain.name>' do
      let(:params) { { 'main_myhostname' => 'invalid_domain.name' } }

      it do
        expect {
          should contain_class('postfix')
        }.to raise_error(Puppet::Error, /^main_myhostname must be a domain name and is set to <invalid_domain.name>/)
      end
    end

    context 'with main_relayhost set to <relayhost.valid.test>' do
      let(:params) { { 'main_relayhost' => 'relayhost.valid.test' } }

      it { should contain_file('postfix_main.cf').with_content(/^relayhost = relayhost.valid.test:25$/) }
    end

    context 'with main_relayhost set to invalid <invalid_domain.name>' do
      let(:params) { { 'main_relayhost' => 'invalid_domain.name' } }

      it do
        expect {
          should contain_class('postfix')
        }.to raise_error(Puppet::Error, /^main_relayhost must be a domain name and is set to <invalid_domain.name>/)
      end
    end

    context 'with main_relayhost_port set to <587>' do
      let(:params) { {
        'main_relayhost_port' => '587',
        # workaround to avoid needing to set the domain fact
        'main_relayhost' => 'relayhost.valid.test',
      } }

      it { should contain_file('postfix_main.cf').with_content(/^relayhost = relayhost.valid.test:587$/) }
    end

    context 'with main_relayhost_port set to invalid <noninteger>' do
      let(:params) { { 'main_relayhost_port' => 'noninteger' } }

      it do
        expect {
          should contain_class('postfix')
        }.to raise_error(Puppet::Error, /^main_relayhost_port must be an integer and is set to <noninteger>/)
      end
    end

    context "with packages set to <postfix_alt>" do
      let(:params) { { :packages => 'postfix_alt' } }

      it {
        should contain_package('postfix_alt').with({
          'ensure' => 'installed',
          'before' => 'Package[sendmail]',
        })
      }
    end

    context "with packages set to <['postfix','postfix-helper']>" do
      let(:params) { { :packages => ['postfix','postfix-helper'] } }

      it {
        should contain_package('postfix').with({
          'ensure' => 'installed',
          'before' => 'Package[sendmail]',
        })
      }

      it {
        should contain_package('postfix-helper').with({
          'ensure' => 'installed',
          'before' => 'Package[sendmail]',
        })
      }
    end

    context 'with empty packages' do
      let(:params) { { 'packages' => '' } }

      it do
        expect {
          should contain_class('postfix')
        }.to raise_error(Puppet::Error, /^packages must contain a valid value and is set to <>/)
      end
    end

    ['true','false','manual',true,false].each do |value|
      context "with service_enable set to <#{value}>" do
        let(:params) { { :service_enable => "#{value}" } }

        it {
          should contain_service('postfix_service').with({
            'ensure'     => 'running',
            'name'       => 'postfix',
            'enable'     => "#{value}",
            'hasrestart' => 'true',
            'hasstatus'  => 'true',
            'require'    => "Package[postfix]",
            'subscribe'  => ['File[postfix_main.cf]', 'File[postfix_virtual]', 'File[postfix_transport]'],
          })
        }
      end
    end

    context 'with service_enable set to invalid <automatic>' do
      let(:params) { { 'service_enable' => 'automatic' } }

      it do
        expect {
          should contain_class('postfix')
        }.to raise_error(Puppet::Error, /^service_enable may be either 'true', 'false' or 'manual' and is set to <automatic>/)
      end
    end

    ['running','stopped'].each do |value|
      context "with service_ensure set to <#{value}>" do
        let(:params) { { :service_ensure => "#{value}" } }

        it {
          should contain_service('postfix_service').with({
            'ensure'     => "#{value}",
            'name'       => 'postfix',
            'enable'     => 'true',
            'hasrestart' => 'true',
            'hasstatus'  => 'true',
            'require'    => "Package[postfix]",
            'subscribe'  => ['File[postfix_main.cf]', 'File[postfix_virtual]', 'File[postfix_transport]'],
          })
        }
      end
    end

    context 'with service_ensure set to invalid <paused>' do
      let(:params) { { 'service_ensure' => 'paused' } }

      it do
        expect {
          should contain_class('postfix')
        }.to raise_error(Puppet::Error, /^service_ensure may be either 'running' or 'stopped' and is set to <paused>/)
      end
    end

    ['true','false',true,false].each do |value|
      context "with service_hasrestart set to <#{value}>" do
        let(:params) { { :service_hasrestart => "#{value}" } }

        it {
          should contain_service('postfix_service').with({
            'ensure'     => 'running',
            'name'       => 'postfix',
            'enable'     => 'true',
            'hasrestart' => "#{value}",
            'hasstatus'  => 'true',
            'require'    => "Package[postfix]",
            'subscribe'  => ['File[postfix_main.cf]', 'File[postfix_virtual]', 'File[postfix_transport]'],
          })
        }
      end
    end

    context 'with service_hasrestart set to invalid <maybe>' do
      let(:params) { { 'service_hasrestart' => 'maybe' } }

      it do
        expect {
          should contain_class('postfix')
        }.to raise_error(Puppet::Error, /^str2bool\(\): Unknown type of boolean given at/)
      end
    end

    ['true','false',true,false].each do |value|
      context "with service_hasstatus set to <#{value}>" do
        let(:params) { { :service_hasstatus => "#{value}" } }

        it {
          should contain_service('postfix_service').with({
            'ensure'     => 'running',
            'name'       => 'postfix',
            'enable'     => 'true',
            'hasrestart' => 'true',
            'hasstatus'  => "#{value}",
            'require'    => "Package[postfix]",
            'subscribe'  => ['File[postfix_main.cf]', 'File[postfix_virtual]', 'File[postfix_transport]'],
          })
        }
      end
    end

    context 'with service_hasstatus set to invalid <mostly>' do
      let(:params) { { 'service_hasstatus' => 'mostly' } }

      it do
        expect {
          should contain_class('postfix')
        }.to raise_error(Puppet::Error, /^str2bool\(\): Unknown type of boolean given at/)
      end
    end

    context 'with service_name set to <postfixservice>' do
      let(:params) { { 'service_name' => 'postfixservice' } }

      it {
        should contain_service('postfix_service').with({
          'ensure'     => 'running',
          'name'       => 'postfixservice',
          'enable'     => 'true',
          'hasrestart' => 'true',
          'hasstatus'  => 'true',
          'require'    => "Package[postfix]",
          'subscribe'  => ['File[postfix_main.cf]', 'File[postfix_virtual]', 'File[postfix_transport]'],
        })
      }
    end

    context 'with empty service_name' do
      let(:params) { { 'service_name' => '' } }

      it do
        expect {
          should contain_class('postfix')
        }.to raise_error(Puppet::Error, /^service_name must contain a valid value and is set to <>/)
      end
    end

    context 'with template_main_cf set to <postfix/main.cf_alternative.erb>' do
    # Dont know how to test different templates for content parameter :(
    # Anyone ?
    end

    context 'with empty template_main_cf' do
      let(:params) { { 'template_main_cf' => '' } }

      it do
        expect {
          should contain_class('postfix')
        }.to raise_error(Puppet::Error, /^template_main_cf must contain a valid value and is set to <>/)
      end
    end

    context "with virtual_aliases set to <{ 'test1@test.void' => 'destination1', 'test2@test.void' => [ 'destination2', 'destination3' ] }>" do
      let(:params) { { 'virtual_aliases' => { 'test1@test.void' => 'destination1', 'test2@test.void' => [ 'destination2', 'destination3' ] } } }

      it { should contain_file('postfix_virtual').with_content(/^test1@test.void\t\tdestination1$/) }
      it { should contain_file('postfix_virtual').with_content(/^test2@test.void\t\tdestination2,destination3$/) }

      # exec { 'postfix_rebuild_virtual': }
      it {
        should contain_exec('postfix_rebuild_virtual').with({
          'command'     => '/usr/sbin/postmap hash:/etc/postfix/virtual',
          'refreshonly' => 'true',
          'subscribe'   => 'File[postfix_virtual]',
        })
      }

      it { should contain_file('postfix_main.cf').with_content(/^virtual_alias_maps = hash:\/etc\/postfix\/virtual$/) }
    end

    context 'with virtual_aliases set to invalid <test1@test.void>' do
      let(:params) { { 'virtual_aliases' => 'test1@test.void' } }

      it do
        expect {
          should contain_class('postfix')
        }.to raise_error(Puppet::Error, /^"test1@test.void" is not a Hash.  It looks to be a String at/)
      end
    end

    context 'with virtual_aliases set to invalid <admin@example.com admin@example.org>' do
      let(:params) { { 'virtual_aliases' => 'admin@example.com admin@example.org' } }

      it do
        expect {
          should contain_class('postfix')
        }.to raise_error(Puppet::Error, /^"admin@example.com admin@example.org" is not a Hash.  It looks to be a String at/)
      end
    end

    context "where transport_maps is set to valid <[ 'sub1.example.com  mail1.example.com', 'sub2.example.com  mail2.example.com' ]> (as Hash))" do
      let(:params) { { 'transport_maps' => { 'sub1.example.com' => 'mail1.example.com', 'sub2.example.com' => 'mail2.example.com' } } }

      it { should contain_file('postfix_transport').with_content(/^sub1.example.com\t\tmail1.example.com$/) }
      it { should contain_file('postfix_transport').with_content(/^sub2.example.com\t\tmail2.example.com$/) }

      # exec { 'postfix_rebuild_virtual': }
      it {
        should contain_exec('postfix_rebuild_transport').with({
          'command'     => '/usr/sbin/postmap hash:/etc/postfix/transport',
          'refreshonly' => 'true',
          'subscribe'   => 'File[postfix_transport]',
        })
      }

      it { should contain_file('postfix_main.cf').with_content(/^transport_maps = hash:\/etc\/postfix\/transport$/) }
    end

    ['string',true,3,2.42,['array'],].each do |value|
      context "where transport_maps is set to invalid #{value} (as #{value.class})" do
        let(:params) { { 'transport_maps' => value } }

        it do
          expect {
            should contain_class('postfix')
          }.to raise_error(Puppet::Error, /is not a Hash/)
        end
      end
    end

    ['string',3,2.42,['array'],a = { 'ha' => 'sh' },].each do |value|
      context "where transport_maps_external is set to invalid #{value} (as #{value.class})" do
        let(:params) { { 'transport_maps_external' => value } }

        it do
          expect {
            should contain_class('postfix')
          }.to raise_error(Puppet::Error, /str2bool\(\)/)
        end
      end
    end

    [true,false,'true','false',].each do |value|
      context "where virtual_aliases_external is set to valid #{value} (as #{value.class})" do
        let(:params) { {
          'virtual_aliases_external' => value,
          # needed for the functionality test:
          'main_virtual_alias_maps'  => 'hash:/etc/postfix/spec_testing',
        } }

        if value.to_s == 'true'
          it { should contain_file('postfix_main.cf').with_content(/^virtual_alias_maps = hash:\/etc\/postfix\/spec_testing$/) }
        else
          it { should contain_file('postfix_main.cf').without_content(/virtual_alias_maps/) }
        end
      end
    end

    ['string',3,2.42,['array'],a = { 'ha' => 'sh' },].each do |value|
      context "where virtual_aliases_external is set to invalid #{value} (as #{value.class})" do
        let(:params) { { 'virtual_aliases_external' => value } }

        it do
          expect {
            should contain_class('postfix')
          }.to raise_error(Puppet::Error, /str2bool\(\)/)
        end
      end
    end
  end
end
