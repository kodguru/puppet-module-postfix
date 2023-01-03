# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'fixes for CentOS 8/9' do
  pp = <<-MANIFEST
    # Fix for RedHad based OS flavours, needs to run first and once
    # ss used by serverspecs is missing in container, it is available in iproute package
    if "${facts['os']['name']}-${facts['os']['release']['major']}" in ['AlmaLinux-8', 'CentOS-8', 'CentOS-9', 'Rocky-8',] {
      package { 'iproute':
        ensure => installed,
      }
    }
  MANIFEST

  it 'applies the manifest twice with no stderr' do
    idempotent_apply(pp)
  end
end
