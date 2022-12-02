# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'fixes for CentOS 8/9' do
  pp = <<-MANIFEST
    # Fix for CentOS 8/9, needs to run first
    # ss used by serverspecs is missing in container, it is available in iproute package
    if $facts['os']['name'] in ['CentOS'] and $facts['os']['release']['major'] in ['8', '9'] {
      package { 'iproute':
        ensure => installed,
      }
    }
  MANIFEST

  it 'applies the manifest twice with no stderr' do
    idempotent_apply(pp)
  end
end
