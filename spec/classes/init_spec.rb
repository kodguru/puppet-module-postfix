require 'spec_helper'
describe 'postfix' do
  on_supported_os.sort.each do |os, os_facts|
    describe "on #{os} with default values for parameters" do
      let(:facts) { os_facts }

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

      content_fixture = File.read(fixtures("testing/#{os_facts[:os]['name']}-#{os_facts[:os]['release']['major']}_main.cf"))

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
        is_expected.to contain_file('postfix_canonical_maps').only_with(
          {
            'ensure' => 'absent',
            'path'   => '/etc/postfix/canonical',
          },
        )
      end

      it do
        is_expected.to contain_file('postfix_canonical_maps_db').only_with(
          {
            'ensure' => 'absent',
            'path'   => '/etc/postfix/canonical.db',
            'notify' => 'Service[postfix_service]',
          },
        )
      end

      it do
        is_expected.to contain_file('postfix_relocated_maps').only_with(
          {
            'ensure' => 'absent',
            'path'   => '/etc/postfix/relocated',
          },
        )
      end

      it do
        is_expected.to contain_file('postfix_relocated_maps_db').only_with(
          {
            'ensure' => 'absent',
            'path'   => '/etc/postfix/relocated.db',
            'notify' => 'Service[postfix_service]',
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

  # The following tests are OS independent, so we only test one
  redhat = {
    supported_os: [
      {
        'operatingsystem'        => 'RedHat',
        'operatingsystemrelease' => ['8'],
      },
    ],
  }

  on_supported_os(redhat).sort.each do |os, os_facts|
    let(:facts) { os_facts }

    context "on #{os} with main_alias_database set to valid hash:/test/ing" do
      let(:params) { { main_alias_database: 'hash:/test/ing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{alias_database = hash:/test/ing}) }
    end

    context "on #{os} with main_alias_maps set to valid hash:/test/ing" do
      let(:params) { { main_alias_maps: 'hash:/test/ing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{alias_maps = hash:/test/ing}) }
    end

    context "on #{os} with main_append_dot_mydomain set to valid yes" do
      let(:params) { { main_append_dot_mydomain: 'yes' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{append_dot_mydomain = yes}) }
    end

    context "on #{os} with main_biff set to valid yes" do
      let(:params) { { main_biff: 'yes' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{biff = yes}) }
    end

    context "on #{os} with main_command_directory set to valid value when virtual_alias_maps, transport_maps, canonical_maps and relocated_maps are set to valid values" do
      let(:params) do
        {
          main_command_directory: '/test/ing',
          virtual_alias_maps:     { 'test@test.ing' => 'test1' },
          transport_maps:         { 'test@test.ing' => 'test' },
          canonical_maps:         { 'test@test.ing' => 'test' },
          relocated_maps:         { 'test@test.ing' => 'test' },
        }
      end

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{command_directory = /test/ing}) }
      it { is_expected.to contain_exec('postfix_rebuild_virtual_alias_maps').with_command('/test/ing/postmap hash:/etc/postfix/virtual') }
      it { is_expected.to contain_exec('postfix_rebuild_transport_maps').with_command('/test/ing/postmap hash:/etc/postfix/transport') }
      it { is_expected.to contain_exec('postfix_rebuild_canonical_maps').with_command('/test/ing/postmap hash:/etc/postfix/canonical') }
      it { is_expected.to contain_exec('postfix_rebuild_relocated_maps').with_command('/test/ing/postmap hash:/etc/postfix/relocated') }
    end

    context "on #{os} with main_compatibility_level set to valid /test/ing" do
      let(:params) { { main_compatibility_level: '/test/ing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{compatibility_level = /test/ing}) }
    end

    context "on #{os} with main_custom set to valid {param1 => value1}" do
      let(:params) { { main_custom: { 'param1' => 'value1' } } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{param1 = value1}) }
    end

    context "on #{os} with main_custom set to valid {param1 => value1, param2 => value2}" do
      let(:params) { { main_custom: { 'param1' => 'value1', 'param2' => 'value2' } } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{param1 = value1\nparam2 = value2}) }
    end

    context "on #{os} with main_custom set to valid {multilineparam => [value1, value2]}" do
      let(:params) { { main_custom: { 'multilineparam' => ['value1', 'value2'] } } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{multilineparam =\n    value1\n    value2}) }
    end

    context "on #{os} with main_daemon_directory set to valid /test/ing" do
      let(:params) { { main_daemon_directory: '/test/ing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{daemon_directory = /test/ing}) }
    end

    context "on #{os} with main_data_directory set to valid /test/ing" do
      let(:params) { { main_data_directory: '/test/ing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{data_directory = /test/ing}) }
    end

    context "on #{os} with main_debugger_command set to valid value /bin/testing & sleep 5" do
      let(:params) { { main_debugger_command: '/bin/testing & sleep 5' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{debugger_command = /bin/testing & sleep 5}) }
    end

    context "on #{os} with main_debug_peer_level set to valid /test/ing" do
      let(:params) { { main_debug_peer_level: 'testing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{debug_peer_level = testing}) }
    end

    context "on #{os} with main_html_directory set to valid /test/ing" do
      let(:params) { { main_html_directory: '/test/ing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{html_directory = /test/ing}) }
    end

    context "on #{os} with main_inet_interfaces set to valid [test.ing]" do
      let(:params) { { main_inet_interfaces: ['test.ing'] } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{inet_interfaces = test.ing}) }
    end

    context "on #{os} with main_inet_interfaces set to valid [test.ing, testi.ng]" do
      let(:params) { { main_inet_interfaces: ['test.ing', 'testi.ng'] } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{inet_interfaces = test.ing, testi.ng}) }
    end

    context "on #{os} with main_inet_protocols set to valid ipv6" do
      let(:params) { { main_inet_protocols: 'ipv6' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{inet_protocols = ipv6}) }
    end

    context "on #{os} with main_mailbox_command set to valid ipv6" do
      let(:params) { { main_mailbox_command: '/test/ing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{mailbox_command = /test/ing}) }
    end

    context "on #{os} with main_mailbox_size_limit set to valid 242" do
      let(:params) { { main_mailbox_size_limit: 242 } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{mailbox_size_limit = 242}) }
    end

    context "on #{os} with main_mail_owner set to valid testing" do
      let(:params) { { main_mail_owner: 'testing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{mail_owner = testing}) }
    end

    context "on #{os} with main_mail_owner set to valid testing" do
      let(:params) { { main_mailq_path: '/test/ing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{mailq_path = /test/ing}) }
    end

    context "on #{os} with main_manpage_directory set to valid /test/ing" do
      let(:params) { { main_manpage_directory: '/test/ing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{manpage_directory = /test/ing}) }
    end

    context "on #{os} with main_message_size_limit set to valid value 242" do
      let(:params) { { main_message_size_limit: 242 } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{message_size_limit = 242}) }
    end

    context "on #{os} with main_meta_directory set to valid /test/ing" do
      let(:params) { { main_meta_directory: '/test/ing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{meta_directory = /test/ing}) }
    end

    context "on #{os} with main_mydestination set to valid 242" do
      let(:params) { { main_mydestination: 'test.ing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{mydestination = test.ing}) }
    end

    context "on #{os} with main_mydomain set to valid test.ing" do
      let(:params) { { main_mydomain: 'test.ing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{mydomain = test.ing}) }
    end

    context "on #{os} with main_myhostname set to valid test.ing" do
      let(:params) { { main_myhostname: 'test.ing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{myhostname = test.ing}) }
    end

    context "on #{os} with main_mynetworks set to valid [test.ing]" do
      let(:params) { { main_mynetworks: ['test.ing'] } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{mynetworks = test.ing}) }
    end

    context "on #{os} with main_mynetworks set to valid [test.ing, testi.ng]" do
      let(:params) { { main_mynetworks: ['test.ing', 'testi.ng'] } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{mynetworks = test.ing, testi.ng}) }
    end

    context "on #{os} with main_myorigin set to valid test.ing" do
      let(:params) { { main_myorigin: 'test.ing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{myorigin = test.ing}) }
    end

    context "on #{os} with main_newaliases_path set to valid /test/ing" do
      let(:params) { { main_newaliases_path: '/test/ing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{newaliases_path = /test/ing}) }
    end

    context "on #{os} with main_queue_directory set to valid /test/ing" do
      let(:params) { { main_queue_directory: '/test/ing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{queue_directory = /test/ing}) }
    end

    ['/test/ing', 'no'].each do |param|
      context "on #{os} with main_readme_directory set to valid #{param}" do
        let(:params) { { main_readme_directory: param } }

        it { is_expected.to contain_file('postfix_main.cf').with_content(%r{readme_directory = #{param}}) }
      end
    end

    context "on #{os} with main_recipient_delimiter set to valid -" do
      let(:params) { { main_recipient_delimiter: '-' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{recipient_delimiter = -}) }
    end

    context "on #{os} with main_relay_domains set to valid test.ing" do
      let(:params) { { main_relay_domains: 'test.ing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{relay_domains = test.ing}) }
    end

    context "on #{os} with main_relayhost set to valid test.ing" do
      let(:params) { { main_relayhost: 'test.ing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{relayhost = test.ing:25}) }
    end

    context "on #{os} with main_relayhost_port set to valid 242" do
      let(:params) { { main_relayhost_port: 242 } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{relayhost = mailhost.example.com:242}) }
    end

    context "on #{os} with main_sample_directory set to valid /test/ing" do
      let(:params) { { main_sample_directory: '/test/ing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{sample_directory = /test/ing}) }
    end

    context "on #{os} with main_sendmail_path set to valid /test/ing" do
      let(:params) { { main_sendmail_path: '/test/ing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{sendmail_path = /test/ing}) }
    end

    context "on #{os} with main_setgid_group set to valid testing" do
      let(:params) { { main_setgid_group: 'testing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{setgid_group = testing}) }
    end

    context "on #{os} with main_shlib_directory set to valid /test/ing" do
      let(:params) { { main_shlib_directory: '/test/ing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{shlib_directory = /test/ing}) }
    end

    context "on #{os} with main_smtpd_banner set to valid testing]" do
      let(:params) { { main_smtpd_banner: 'testing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{smtpd_banner = testing}) }
    end

    context "on #{os} with main_smtpd_delay_reject set to valid value yes" do
      let(:params) { { main_smtpd_delay_reject: 'yes' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{smtpd_delay_reject = yes}) }
    end

    ['yes', 'no'].each do |param|
      context "on #{os} with main_smtpd_helo_required set to valid #{param}" do
        let(:params) { { main_smtpd_helo_required: param } }

        it { is_expected.to contain_file('postfix_main.cf').with_content(%r{smtpd_helo_required = #{param}}) }
      end
    end

    context "on #{os} with main_smtpd_helo_restrictions set to valid [test, ing]" do
      let(:params) { { main_smtpd_helo_restrictions: ['test', 'ing'] } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{smtpd_helo_restrictions = test,\n    ing}) }
    end

    context "on #{os} with main_smtpd_recipient_restrictions set to valid [test, ing]" do
      let(:params) { { main_smtpd_recipient_restrictions: ['test', 'ing'] } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{smtpd_recipient_restrictions = test,\n    ing}) }
    end

    context "on #{os} with main_smtpd_relay_restrictions set to valid testing]" do
      let(:params) { { main_smtpd_relay_restrictions: 'testing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{smtpd_relay_restrictions = testing}) }
    end

    context "on #{os} with main_smtpd_sasl_auth_enable set to valid value yes" do
      let(:params) { { main_smtpd_sasl_auth_enable: 'yes' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{smtpd_sasl_auth_enable = yes}) }
    end

    context "on #{os} with main_smtpd_sender_restrictions set to valid value testing" do
      let(:params) { { main_smtpd_sender_restrictions: 'testing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{smtpd_sender_restrictions = testing}) }
    end

    context "on #{os} with main_smtpd_tls_ask_ccert set to valid value yes" do
      let(:params) { { main_smtpd_tls_ask_ccert: 'yes' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{smtpd_tls_ask_ccert = yes}) }
    end

    context "on #{os} with main_smtpd_tls_cert_file set to valid /test/ing" do
      let(:params) { { main_smtpd_tls_cert_file: '/test/ing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{smtpd_tls_cert_file = /test/ing}) }
    end

    context "on #{os} with main_smtpd_tls_key_file set to valid /test/ing" do
      let(:params) { { main_smtpd_tls_key_file: '/test/ing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{smtpd_tls_key_file = /test/ing}) }
    end

    context "on #{os} with main_smtpd_tls_mandatory_protocols set to valid testing" do
      let(:params) { { main_smtpd_tls_mandatory_protocols: 'testing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{smtpd_tls_mandatory_protocols = testing}) }
    end

    context "on #{os} with main_smtpd_tls_protocols set to valid testing" do
      let(:params) { { main_smtpd_tls_protocols: 'testing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{smtpd_tls_protocols = testing}) }
    end

    context "on #{os} with main_smtpd_tls_received_header set to valid value yes" do
      let(:params) { { main_smtpd_tls_received_header: 'yes' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{smtpd_tls_received_header = yes}) }
    end

    context "on #{os} with main_smtpd_tls_security_level set to valid testing" do
      let(:params) { { main_smtpd_tls_security_level: 'testing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{smtpd_tls_security_level = testing}) }
    end

    context "on #{os} with main_smtpd_use_tls set to valid value yes" do
      let(:params) { { main_smtpd_use_tls: 'yes' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{smtpd_use_tls = yes}) }
    end

    context "on #{os} with main_smtp_enforce_tls set to valid value yes" do
      let(:params) { { main_smtp_enforce_tls: 'yes' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{smtp_enforce_tls = yes}) }
    end

    context "on #{os} with main_smtp_sasl_auth_enable set to valid value yes" do
      let(:params) { { main_smtp_sasl_auth_enable: 'yes' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{smtp_sasl_auth_enable = yes}) }
    end

    context "on #{os} with main_smtp_tls_cafile set to valid /test/ing" do
      let(:params) { { main_smtp_tls_cafile: '/test/ing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{smtp_tls_CAfile = /test/ing}) }
    end

    context "on #{os} with main_smtp_tls_capath set to valid /test/ing" do
      let(:params) { { main_smtp_tls_capath: '/test/ing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{smtp_tls_CApath = /test/ing}) }
    end

    context "on #{os} with main_smtp_tls_mandatory_protocols set to valid /test/ing" do
      let(:params) { { main_smtp_tls_mandatory_protocols: 'testing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{smtp_tls_mandatory_protocols = testing}) }
    end

    context "on #{os} with main_smtp_tls_protocols set to valid /test/ing" do
      let(:params) { { main_smtp_tls_protocols: 'testing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{smtp_tls_protocols = testing}) }
    end

    context "on #{os} with main_smtp_tls_security_level set to valid /test/ing" do
      let(:params) { { main_smtp_tls_security_level: 'testing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{smtp_tls_security_level = testing}) }
    end

    context "on #{os} with main_smtp_use_tls set to valid value yes" do
      let(:params) { { main_smtp_use_tls: 'yes' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{smtp_use_tls = yes}) }
    end

    context "on #{os} with main_strict_8bitmime set to valid value yes" do
      let(:params) { { main_strict_8bitmime: 'yes' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{strict_8bitmime = yes}) }
    end

    context "on #{os} with main_strict_rfc821_envelopes set to valid value yes" do
      let(:params) { { main_strict_rfc821_envelopes: 'yes' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{strict_rfc821_envelopes = yes}) }
    end

    context "on #{os} with main_unknown_local_recipient_reject_code set to valid 242" do
      let(:params) { { main_unknown_local_recipient_reject_code: 242 } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{unknown_local_recipient_reject_code = 242}) }
    end

    context "on #{os} with main_virtual_alias_domains set to valid test.ing" do
      let(:params) { { main_virtual_alias_domains: 'test.ing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{virtual_alias_domains = test.ing}) }
    end

    context "on #{os} with no_postmap_db_types set array to containing hash when maps will be created" do
      let(:params) do
        {
          no_postmap_db_types:  ['hash'],
          canonical_maps:       { 'test@test.ing' => 'test.ing' },
          relocated_maps:       { 'test@test.ing' => 'test.ing' },
          transport_maps:       { 'test@test.ing' => 'test.ing' },
          virtual_alias_maps:   { 'test@test.ing' => 'test.ing' },
        }
      end

      it { is_expected.not_to contain_exec('postfix_rebuild_canonical_maps') }
      it { is_expected.not_to contain_exec('postfix_rebuild_relocated_maps') }
      it { is_expected.not_to contain_exec('postfix_rebuild_transport_maps') }
      it { is_expected.not_to contain_exec('postfix_rebuild_virtual_alias_maps') }
    end

    context "on #{os} with packages set to valid [testing]" do
      let(:params) { { packages: ['testing'] } }

      it { is_expected.to contain_package('testing') }
    end

    context "on #{os} with packages set to valid [test, ing]" do
      let(:params) { { packages: ['test', 'ing'] } }

      it { is_expected.to contain_package('test') }
      it { is_expected.to contain_package('ing') }
    end

    [true, false, 'true', 'false'].each do |param|
      context "on #{os} with service_enable set to valid #{param}" do
        let(:params) { { service_enable: param } }

        it { is_expected.to contain_service('postfix_service').with_enable(param) }
      end
    end

    context "on #{os} with service_ensure set to valid stopped" do
      let(:params) { { service_ensure: 'stopped' } }

      it { is_expected.to contain_service('postfix_service').with_ensure('stopped') }
    end

    context "on #{os} with service_hasrestart set to valid false" do
      let(:params) { { service_hasrestart: false } }

      it { is_expected.to contain_service('postfix_service').with_hasrestart(false) }
    end

    context "on #{os} with service_hasstatus set to valid false" do
      let(:params) { { service_hasstatus: false } }

      it { is_expected.to contain_service('postfix_service').with_hasstatus(false) }
    end

    context "on #{os} with service_name set to valid testing" do
      let(:params) { { service_name: 'testing' } }

      it { is_expected.to contain_service('postfix_service').with_name('testing') }
    end

    ['canonical', 'relocated', 'transport', 'virtual_alias'].each do |map|
      map_file = if map == 'virtual_alias'
                   'virtual'
                 else
                   map
                 end

      context "on #{os} with #{map}_custom set to valid array" do
        let(:params) { { "#{map}_custom": ['line1', 'line2'] } }

        content = <<-END.gsub(%r{^\s+\|}, '')
          |# This file is being maintained by Puppet.
          |# DO NOT EDIT
          |
          |line1
          |line2
        END

        it { is_expected.to contain_file("postfix_#{map}_maps").with_content(content) }
        it { is_expected.to contain_file('postfix_main.cf').with_content(%r{#{map}_maps = hash:/etc/postfix/#{map_file}}) }
      end

      context "on #{os} with #{map}_db_type set to valid lmdb when database has content" do
        let(:params) { { "#{map}_db_type": 'lmdb', "#{map}_maps": { 'user1' => 'user1@test.ing' } } }

        it { is_expected.to contain_exec("postfix_rebuild_#{map}_maps").with_command("/usr/sbin/postmap lmdb:/etc/postfix/#{map_file}") }
        it { is_expected.to contain_file('postfix_main.cf').with_content(%r{#{map}_maps = lmdb:/etc/postfix/#{map_file}}) }
      end

      context "on #{os} with #{map}_maps set to valid hash value" do
        let(:params) { { "#{map}_maps": { 'user1' => 'user1@test.ing', 'user2' => ['user2@test1.ing', 'user2@test2.ing'] } } }

        content = <<-END.gsub(%r{^\s+\|}, '')
          |# This file is being maintained by Puppet.
          |# DO NOT EDIT
          |
          |user1		user1@test.ing
          |user2		user2@test1.ing,user2@test2.ing
        END

        it do
          is_expected.to contain_file("postfix_#{map}_maps").only_with(
            {
              'ensure'  => 'file',
              'path'    => "/etc/postfix/#{map_file}",
              'owner'   => 'root',
              'group'   => 'root',
              'mode'    => '0644',
              'content' => content,
            },
          )
        end

        it do
          is_expected.to contain_exec("postfix_rebuild_#{map}_maps").only_with(
            {
              'command'     => "/usr/sbin/postmap hash:/etc/postfix/#{map_file}",
              'refreshonly' => true,
              'subscribe'   => "File[postfix_#{map}_maps]",
              'notify'      => 'Service[postfix_service]',
            },
          )
        end
        it { is_expected.to contain_file('postfix_main.cf').with_content(%r{#{map}_maps = hash:/etc/postfix/#{map_file}}) }
      end

      context "on #{os} with main_#{map}_maps set to valid value when database has content" do
        let(:params) do
          {
            "main_#{map}_maps": "/test/ing/#{map}",
            "#{map}_maps":      { 'test@test.ing' => 'test.ing' },
          }
        end

        it { is_expected.to contain_exec("postfix_rebuild_#{map}_maps").with_command("/usr/sbin/postmap hash:/test/ing/#{map}") }
        it { is_expected.to contain_file('postfix_main.cf').with_content(%r{#{map}_maps = hash:/test/ing/#{map_file}}) }
      end

      context "on #{os} with main_#{map}_maps set to valid hash:/test/ing when #{map}_maps_external is set to valid value" do
        # FIXME: is "main_#{map}_maps" needed ?
        let(:params) { { "main_#{map}_maps": '/test/ing', "#{map}_maps_external": true } }

        it { is_expected.to contain_file('postfix_main.cf').with_content(%r{#{map}_maps = hash:/test/ing}) }
      end

      context "on #{os} with #{map}_maps_external set to valid value" do
        let(:params) { { "#{map}_maps_external": true } }

        it { is_expected.to contain_file('postfix_main.cf').with_content(%r{#{map}_maps = hash:/etc/postfix/#{map_file}}) }
        # FIXME: external map should not be managed by puppet
        # it { is_expected.not_to contain_file("postfix_#{map}_maps") }
      end
    end
  end
end
