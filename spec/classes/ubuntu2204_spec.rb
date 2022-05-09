# This test is only needed for the time that Ubuntu 22.04 is not included in facterdb
# https://github.com/voxpupuli/facterdb/

require 'spec_helper'
describe 'postfix' do
  describe 'on Ubuntu 22.04 with default values for parameters' do
    let(:facts) do
      {
        domain: 'example.com',
        fqdn: 'foo.example.com',
        hostname: 'foo',
        os: {
          family: 'Debian',
          name: 'Ubuntu',
          release: {
            major: '22.04',
          },
        },
      }
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_class('postfix') }

    it do
      is_expected.to contain_package('postfix').only_with(
        {
          'ensure' => 'installed',
          'before' => [ 'Service[postfix_service]', 'Package[sendmail]' ],
        },
      )
    end

    it do
      is_expected.to contain_service('postfix_service').only_with(
        {
          'ensure'     => 'running',
          'name'       => 'postfix',
          'enable'     => true,
          'hasrestart' => true,
          'hasstatus'  => true,
          'subscribe'  => [ 'File[postfix_main.cf]', 'File[postfix_virtual]', 'File[postfix_transport]' ],
        },
      )
    end

    content_fixture = File.read(fixtures('testing/Ubuntu-22.04_main.cf'))

    it do
      is_expected.to contain_file('postfix_main.cf').only_with(
        {
          'ensure'  => 'file',
          'path'    => '/etc/postfix/main.cf',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
          'content' => content_fixture,
        },
      )
    end

    it do
      is_expected.to contain_file('postfix_virtual').only_with(
        {
          'ensure' => 'absent',
          'path'   => '/etc/postfix/virtual',
        },
      )
    end

    it do
      is_expected.to contain_file('postfix_virtual_db').only_with(
        {
          'ensure' => 'absent',
          'path'   => '/etc/postfix/virtual.db',
        },
      )
    end

    it do
      is_expected.to contain_file('postfix_transport').only_with(
        {
          'ensure' => 'absent',
          'path'   => '/etc/postfix/transport',
        },
      )
    end

    it do
      is_expected.to contain_file('postfix_transport_db').only_with(
        {
          'ensure' => 'absent',
          'path'   => '/etc/postfix/transport.db',
        },
      )
    end

    it do
      is_expected.to contain_package('sendmail').only_with(
        {
          'ensure'  => 'absent',
          'require' => 'Package[sendmail-cf]',
        },
      )
    end

    it do
      is_expected.to contain_package('sendmail-cf').only_with(
        {
          'ensure' => 'absent',
        },
      )
    end
  end
end
