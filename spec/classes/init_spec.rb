require 'spec_helper'
describe 'postfix' do

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
end
