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
            'subscribe'  => ['File[postfix_main.cf]', 'File[postfix_virtual]'],
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
        it { should_not contain_file('postfix_main.cf').with_content(/^virtual_alias_maps = hash:\/etc\/postfix\/virtual$/) }


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


  describe 'with virtual_aliases set' do
    platforms.sort.each do |k,v|
      context "where osfamily is <#{v[:osfamily]}>" do

        let :facts do
          {
            :osfamily => v[:osfamily],
          }
        end

        let :params do
          {
            :virtual_aliases => { 'test1@test.void' => 'destination1', 'test2@test.void' => [ 'destination2', 'destination3' ] },
          }
        end

        # file { 'postfix_virtual': }
        it {
          should contain_file('postfix_virtual').with({
            'ensure'     => 'file',
            'path'       => '/etc/postfix/virtual',
            'owner'      => 'root',
            'group'      => 'root',
            'mode'       => '0644',
            'require'    => "Package[#{v[:packages_default]}]",
          })
        }
        it { should contain_file('postfix_virtual').with_content(/^test1@test.void\t\tdestination1$/) }
        it { should contain_file('postfix_virtual').with_content(/^test2@test.void\t\tdestination2,destination3$/) }

        # exec { 'postfix_rebuild_virtual': }
        it {
          should contain_exec('postfix_rebuild_virtual').with({
            'command'     => "#{v[:main_command_directory_default]}/postmap hash:/etc/postfix/virtual",
            'refreshonly' => 'true',
            'subscribe'   => 'File[postfix_virtual]',
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
        it { should contain_file('postfix_main.cf').with_content(/^virtual_alias_maps = hash:\/etc\/postfix\/virtual$/) }

      end
    end
  end

  describe 'validating variables on valid osfamily RedHat' do
    let(:facts) { { 'osfamily' => 'Redhat' } }

    describe 'with empty main_alias_database' do
      let(:params) { { 'main_alias_database' => '' } }

      it do
        expect {
          should contain_class('postfix')
        }.to raise_error(Puppet::Error, /^main_alias_database must contain a valid value and is set to <>/)
      end
    end

    describe 'with empty main_alias_maps' do
      let(:params) { { 'main_alias_maps' => '' } }

      it do
        expect {
          should contain_class('postfix')
        }.to raise_error(Puppet::Error, /^main_alias_maps must contain a valid value and is set to <>/)
      end
    end

    describe 'with main_append_dot_mydomain set to invalid <true>' do
      let(:params) { { 'main_append_dot_mydomain' => true } }

      it do
        expect {
          should contain_class('postfix')
        }.to raise_error(Puppet::Error, /^main_append_dot_mydomain may be either 'yes' or 'no' and is set to <true>/)
      end
    end

    describe 'with main_biff set to invalid <false>' do
      let(:params) { { 'main_biff' => false } }

      it do
        expect {
          should contain_class('postfix')
        }.to raise_error(Puppet::Error, /^main_biff may be either 'yes' or 'no' and is set to <false>/)
      end
    end

    describe 'with main_command_directory set to invalid <../tmp>' do
      let(:params) { { 'main_command_directory' => '../tmp' } }

      it do
        expect {
          should contain_class('postfix')
        }.to raise_error(Puppet::Error, /^"..\/tmp" is not an absolute path./)
      end
    end

    describe 'with main_daemon_directory set to invalid <../bin>' do
      let(:params) { { 'main_daemon_directory' => '../bin' } }

      it do
        expect {
          should contain_class('postfix')
        }.to raise_error(Puppet::Error, /^"..\/bin" is not an absolute path./)
      end
    end

    describe 'with main_data_directory set to invalid <../var>' do
      let(:params) { { 'main_data_directory' => '../var' } }

      it do
        expect {
          should contain_class('postfix')
        }.to raise_error(Puppet::Error, /^"..\/var" is not an absolute path./)
      end
    end

    describe 'with empty main_inet_interfaces' do
      let(:params) { { 'main_inet_interfaces' => '' } }

      it do
        expect {
          should contain_class('postfix')
        }.to raise_error(Puppet::Error, /^main_inet_interfaces must contain a valid value and is set to <>/)
      end
    end

    describe 'with empty main_inet_protocols' do
      let(:params) { { 'main_inet_protocols' => '' } }

      it do
        expect {
          should contain_class('postfix')
        }.to raise_error(Puppet::Error, /^main_inet_protocols must contain a valid value and is set to <>/)
      end
    end

    describe 'with main_mailbox_size_limit set to invalid <noninteger>' do
      let(:params) { { 'main_mailbox_size_limit' => 'noninteger' } }

      it do
        expect {
          should contain_class('postfix')
        }.to raise_error(Puppet::Error, /^main_mailbox_size_limit must be an integer and is set to <noninteger>/)
      end
    end

    describe 'with main_mailbox_size_limit set to invalid <-1>' do
      let(:params) { { 'main_mailbox_size_limit' => '-1' } }

      it do
        expect {
          should contain_class('postfix')
        }.to raise_error(Puppet::Error, /^main_mailbox_size_limit needs a minimum value of 0 and is set to <-1>/)
      end
    end

    describe 'with main_mydestination set to invalid <[\'i\', \'hate\', \'arrays\']>' do
      let(:params) { { 'main_mydestination' => [ 'i', 'hate', 'arrays'] } }

      it do
        expect {
          should contain_class('postfix')
        }.to raise_error(Puppet::Error, /^\["i", "hate", "arrays"\] is not a string.  It looks to be a Array/)
      end
    end

    describe 'with main_myhostname set to invalid <invalid_domain.name>' do
      let(:params) { { 'main_myhostname' => 'invalid_domain.name' } }

      it do
        expect {
          should contain_class('postfix')
        }.to raise_error(Puppet::Error, /^main_myhostname must be a domain name and is set to <invalid_domain.name>/)
      end
    end

    describe 'with empty main_mynetworks' do
      let(:params) { { 'main_mynetworks' => '' } }

      it do
        expect {
          should contain_class('postfix')
        }.to raise_error(Puppet::Error, /^main_mynetworks must contain a valid value and is set to <>/)
      end
    end

    describe 'with empty main_myorigin' do
      let(:params) { { 'main_myorigin' => '' } }

      it do
        expect {
          should contain_class('postfix')
        }.to raise_error(Puppet::Error, /^main_myorigin must contain a valid value and is set to <>/)
      end
    end

    describe 'with main_queue_directory set to invalid <../var/spool>' do
      let(:params) { { 'main_queue_directory' => '../var/spool' } }

      it do
        expect {
          should contain_class('postfix')
        }.to raise_error(Puppet::Error, /^"..\/var\/spool" is not an absolute path./)
      end
    end

    describe 'with main_relayhost set to invalid <invalid_domain.name>' do
      let(:params) { { 'main_relayhost' => 'invalid_domain.name' } }

      it do
        expect {
          should contain_class('postfix')
        }.to raise_error(Puppet::Error, /^main_relayhost must be a domain name and is set to <invalid_domain.name>/)
      end
    end

    describe 'with main_relayhost_port set to invalid <noninteger>' do
      let(:params) { { 'main_relayhost_port' => 'noninteger' } }

      it do
        expect {
          should contain_class('postfix')
        }.to raise_error(Puppet::Error, /^main_relayhost_port must be an integer and is set to <noninteger>/)
      end
    end

    describe 'with empty main_setgid_group' do
      let(:params) { { 'main_setgid_group' => '' } }

      it do
        expect {
          should contain_class('postfix')
        }.to raise_error(Puppet::Error, /^main_setgid_group must contain a valid value and is set to <>/)
      end
    end

    describe 'with empty main_virtual_alias_maps' do
      let(:params) { { 'main_virtual_alias_maps' => '' } }

      it do
        expect {
          should contain_class('postfix')
        }.to raise_error(Puppet::Error, /^main_virtual_alias_maps must contain a valid value and is set to <>/)
      end
    end

    describe 'with empty packages' do
      let(:params) { { 'packages' => '' } }

      it do
        expect {
          should contain_class('postfix')
        }.to raise_error(Puppet::Error, /^packages must contain a valid value and is set to <>/)
      end
    end

    describe 'with service_enable set to invalid <automatic>' do
      let(:params) { { 'service_enable' => 'automatic' } }

      it do
        expect {
          should contain_class('postfix')
        }.to raise_error(Puppet::Error, /^service_enable may be either 'true', 'false' or 'manual' and is set to <automatic>/)
      end
    end

    describe 'with service_ensure set to invalid <paused>' do
      let(:params) { { 'service_ensure' => 'paused' } }

      it do
        expect {
          should contain_class('postfix')
        }.to raise_error(Puppet::Error, /^service_ensure may be either 'running' or 'stopped' and is set to <paused>/)
      end
    end

    describe 'with service_hasrestart set to invalid <maybe>' do
      let(:params) { { 'service_hasrestart' => 'maybe' } }

      it do
        expect {
          should contain_class('postfix')
        }.to raise_error(Puppet::Error, /^str2bool\(\): Unknown type of boolean given at/)
      end
    end

    describe 'with service_hasstatus set to invalid <mostly>' do
      let(:params) { { 'service_hasstatus' => 'mostly' } }

      it do
        expect {
          should contain_class('postfix')
        }.to raise_error(Puppet::Error, /^str2bool\(\): Unknown type of boolean given at/)
      end
    end

    describe 'with empty service_name' do
      let(:params) { { 'service_name' => '' } }

      it do
        expect {
          should contain_class('postfix')
        }.to raise_error(Puppet::Error, /^service_name must contain a valid value and is set to <>/)
      end
    end

    describe 'with empty template_main_cf' do
      let(:params) { { 'template_main_cf' => '' } }

      it do
        expect {
          should contain_class('postfix')
        }.to raise_error(Puppet::Error, /^template_main_cf must contain a valid value and is set to <>/)
      end
    end

    describe 'with virtual_aliases set to invalid <test1@test.void>' do
      let(:params) { { 'virtual_aliases' => 'test1@test.void' } }

      it do
        expect {
          should contain_class('postfix')
        }.to raise_error(Puppet::Error, /^"test1@test.void" is not a Hash.  It looks to be a String at/)
      end
    end

  end
end
