# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'postfix with transport_maps set' do
  pp = <<-MANIFEST
    # AlmaLinux 8 and CentOS 9 containers have problems with ipv6, so we use ipv4 only for testing
    if "${facts['os']['name']}-${facts['os']['release']['major']}" in ['AlmaLinux-8', 'CentOS-9'] {
      class { 'postfix':
        main_inet_protocols => 'ipv4',
        main_transport_maps => 'hash:/etc/postfix/transport', # needed for OS flavours without given default value
        transport_maps => {
          'test@test.ing' => 'test.ing',
        },
      }
    } else {
      class { 'postfix':
        main_transport_maps => 'hash:/etc/postfix/transport', # needed for OS flavours without given default value
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
