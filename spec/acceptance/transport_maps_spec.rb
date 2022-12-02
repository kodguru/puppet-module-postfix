# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'postfix with transport_maps set' do
  pp = <<-MANIFEST
    if $facts['os']['name'] == 'CentOS' and $facts['os']['release']['major'] == '9' {
      class { 'postfix':
        main_inet_protocols => 'ipv4', # bugfix for missing ipv6 in container
        transport_maps => {
          'test@test.ing' => 'test.ing',
        },
      }
    } else {
      class { 'postfix':
        transport_maps => {
          'test@test.ing' => 'test.ing',
        },
      }
    }
  MANIFEST

  it 'applies the manifest twice with no stderr' do
    idempotent_apply(pp)
  end

  describe service('postfix') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe port(25) do
    it { is_expected.to be_listening.with('tcp') }
  end

  describe file('/etc/postfix/transport') do
    it { is_expected.to exist }
    it { is_expected.to be_file }
    it { is_expected.to be_mode 6_44 }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    its(:content) { is_expected.to match %r{test@test.ing\s*test.ing} }
  end

  describe file('/etc/postfix/transport.db') do
    it { is_expected.to exist }
  end
end
