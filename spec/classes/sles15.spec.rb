# For SLED/SLES we need individual tests for each affected minor release.
# Since this is not possible with rspec-puppet-facts, explicit tests are
# necessary here.

require 'spec_helper'
describe 'postfix' do
  describe 'with default values for parameters' do
    # add minor versions as they become supported
    # FIXME: need data for 15.0
    [1, 2, 3, 4, 5].each do |minor|
      context "running on SLES 15.#{minor}" do
        let :facts do
          {
            networking: {
              domain:   'example.com',
              fqdn:     'foo.example.com',
            },
            os: {
              name:    'SLES',
              release: {
                full:  "15.#{minor}",
                major: '15',
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
              'subscribe'  => 'File[postfix_main.cf]',
            },
          )
        end

        content_fixture = File.read(fixtures("testing/SLES-15.#{minor}_main.cf"))

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
          is_expected.to contain_file('postfix_virtual_alias_maps').only_with(
            {
              'ensure' => 'absent',
              'path'   => '/etc/postfix/virtual',
            },
          )
        end

        it do
          is_expected.to contain_file('postfix_virtual_alias_maps_db').only_with(
            {
              'ensure' => 'absent',
              'path'   => '/etc/postfix/virtual.db',
              'notify' => 'Service[postfix_service]',
            },
          )
        end

        it do
          is_expected.to contain_file('postfix_transport_maps').only_with(
            {
              'ensure' => 'absent',
              'path'   => '/etc/postfix/transport',
            },
          )
        end

        it do
          is_expected.to contain_file('postfix_transport_maps_db').only_with(
            {
              'ensure' => 'absent',
              'path'   => '/etc/postfix/transport.db',
              'notify' => 'Service[postfix_service]',
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
  end
end
