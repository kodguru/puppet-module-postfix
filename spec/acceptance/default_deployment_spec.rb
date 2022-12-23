# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'postfix with default deployment' do
  pp = <<-MANIFEST
    # AlmaLinux 8 and CentOS 9 containers have problems with ipv6, so we use ipv4 only for testing
    if "${facts['os']['name']}-${facts['os']['release']['major']}" in ['AlmaLinux-8', 'CentOS-9'] {
      class { 'postfix':
        main_inet_protocols => 'ipv4',
      }
    } else {
      class { 'postfix': }
    }
  MANIFEST

  it 'applies the manifest twice with no stderr' do
    idempotent_apply(pp)
  end

  describe package('postfix') do
    it { is_expected.to be_installed }
  end

  describe package('sendmail') do
    it { is_expected.not_to be_installed }
  end

  describe package('sendmail-cf') do
    it { is_expected.not_to be_installed }
  end

  describe service('postfix') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe port(25) do
    it { is_expected.to be_listening.with('tcp') }
  end

  describe file('/etc/postfix/main.cf') do
    it { is_expected.to exist }
    it { is_expected.to be_file }
    it { is_expected.to be_mode 6_44 }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    its(:content) { is_expected.to match %r{# This file is being maintained by Puppet} }
  end

  describe file('/etc/postfix/virtual') do
    it { is_expected.not_to exist }
  end

  describe file('/etc/postfix/virtual.db') do
    it { is_expected.not_to exist }
  end

  describe file('/etc/postfix/transport') do
    it { is_expected.not_to exist }
  end

  describe file('/etc/postfix/transport.db') do
    it { is_expected.not_to exist }
  end
end
