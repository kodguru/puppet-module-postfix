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
            'subscribe'  => [ 'File[postfix_main.cf]', 'File[postfix_virtual]', 'File[postfix_transport]' ],
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

    context "on #{os} with main_command_directory set to valid yes when virtual_aliases and transport_maps are set to valid value" do
      let(:params) { { main_command_directory: '/test/ing', virtual_aliases: { 'test@test.ing' => 'test1' }, transport_maps: { 'test@test.ing' => 'test' } } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{command_directory = /test/ing}) }
      it { is_expected.to contain_exec('postfix_rebuild_virtual').with_command('/test/ing/postmap hash:/etc/postfix/virtual') }
      it { is_expected.to contain_exec('postfix_rebuild_transport').with_command('/test/ing/postmap hash:/etc/postfix/transport') }
    end

    context "on #{os} with main_daemon_directory set to valid /test/ing" do
      let(:params) { { main_daemon_directory: '/test/ing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{daemon_directory = /test/ing}) }
    end

    context "on #{os} with main_compatibility_level set to valid /test/ing" do
      let(:params) { { main_compatibility_level: '/test/ing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{compatibility_level = /test/ing}) }
    end

    context "on #{os} with main_data_directory set to valid /test/ing" do
      let(:params) { { main_data_directory: '/test/ing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{data_directory = /test/ing}) }
    end

    context "on #{os} with main_debug_peer_level set to valid /test/ing" do
      let(:params) { { main_debug_peer_level: 'testing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{debug_peer_level = testing}) }
    end

    context "on #{os} with main_inet_interfaces set to valid [test.ing]" do
      let(:params) { { main_inet_interfaces: ['test.ing'] } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{inet_interfaces = test.ing}) }
    end

    context "on #{os} with main_inet_interfaces set to valid [test.ing, testi.ng]" do
      let(:params) { { main_inet_interfaces: ['test.ing', 'testi.ng'] } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{inet_interfaces = test.ing, testi.ng}) }
    end

    context "on #{os} with main_html_directory set to valid /test/ing" do
      let(:params) { { main_html_directory: '/test/ing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{html_directory = /test/ing}) }
    end

    context "on #{os} with main_inet_protocols set to valid ipv6" do
      let(:params) { { main_inet_protocols: 'ipv6' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{inet_protocols = ipv6}) }
    end

    context "on #{os} with main_mailbox_command set to valid ipv6" do
      let(:params) { { main_mailbox_command: '/test/ing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{mailbox_command = /test/ing}) }
    end

    context "on #{os} with main_mailbox_command set to valid ipv6" do
      let(:params) { { main_mailbox_command: '/test/ing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{mailbox_command = /test/ing}) }
    end

    context "on #{os} with main_manpage_directory set to valid /test/ing" do
      let(:params) { { main_manpage_directory: '/test/ing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{manpage_directory = /test/ing}) }
    end

    context "on #{os} with main_mailbox_size_limit set to valid 242" do
      let(:params) { { main_mailbox_size_limit: 242 } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{mailbox_size_limit = 242}) }
    end

    context "on #{os} with main_mail_owner set to valid testing" do
      let(:params) { { main_mail_owner: 'testing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{mail_owner = testing}) }
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

    context "on #{os} with main_sample_directory set to valid /test/ing" do
      let(:params) { { main_sample_directory: '/test/ing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{sample_directory = /test/ing}) }
    end

    context "on #{os} with main_sendmail_path set to valid /test/ing" do
      let(:params) { { main_sendmail_path: '/test/ing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{sendmail_path = /test/ing}) }
    end

    context "on #{os} with main_relayhost set to valid test.ing" do
      let(:params) { { main_relayhost: 'test.ing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{relayhost = test.ing:25}) }
    end

    context "on #{os} with main_relayhost_port set to valid 242" do
      let(:params) { { main_relayhost_port: 242 } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{relayhost = mailhost.example.com:242}) }
    end

    context "on #{os} with main_setgid_group set to valid testing" do
      let(:params) { { main_setgid_group: 'testing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{setgid_group = testing}) }
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

    context "on #{os} with main_shlib_directory set to valid /test/ing" do
      let(:params) { { main_shlib_directory: '/test/ing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{shlib_directory = /test/ing}) }
    end

    context "on #{os} with main_smtpd_banner set to valid testing]" do
      let(:params) { { main_smtpd_banner: 'testing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{smtpd_banner = testing}) }
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

    context "on #{os} with main_smtpd_tls_security_level set to valid testing" do
      let(:params) { { main_smtpd_tls_security_level: 'testing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{smtpd_tls_security_level = testing}) }
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

    context "on #{os} with main_transport_maps set to valid hash:/test/ing" do
      let(:params) { { main_transport_maps: 'hash:/test/ing' } }

      it { is_expected.to contain_file('postfix_main.cf').without_content(%r{transport_maps =}) }
    end

    context "on #{os} with main_unknown_local_recipient_reject_code set to valid 242" do
      let(:params) { { main_unknown_local_recipient_reject_code: 242 } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{unknown_local_recipient_reject_code = 242}) }
    end

    context "on #{os} with main_transport_maps set to valid hash:/test/ing when transport_maps is set to valid value" do
      let(:params) { { main_transport_maps: 'hash:/test/ing', transport_maps: { 'test@test.ing' => 'test' } } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{transport_maps = hash:/test/ing}) }
      it { is_expected.to contain_exec('postfix_rebuild_transport').with_command('/usr/sbin/postmap hash:/test/ing') }
    end

    context "on #{os} with main_transport_maps set to valid hash:/test/ing when transport_maps_external is set to valid value" do
      let(:params) { { main_transport_maps: 'hash:/test/ing', transport_maps_external: true } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{transport_maps = hash:/test/ing}) }
    end

    context "on #{os} with main_virtual_alias_domains set to valid test.ing" do
      let(:params) { { main_virtual_alias_domains: 'test.ing' } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{virtual_alias_domains = test.ing}) }
    end

    context "on #{os} with main_virtual_alias_maps set to valid hash:/test/ing" do
      let(:params) { { main_virtual_alias_maps: 'hash:/test/ing' } }

      it { is_expected.to contain_file('postfix_main.cf').without_content(%r{virtual_alias_maps =}) }
    end

    context "on #{os} with main_virtual_alias_maps set to valid hash:/test/ing when virtual_aliases is set to valid value" do
      let(:params) { { main_virtual_alias_maps: 'hash:/test/ing', virtual_aliases: { 'test@test.ing' => 'test' } } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{virtual_alias_maps = hash:/test/ing}) }
      it { is_expected.to contain_exec('postfix_rebuild_virtual').with_command('/usr/sbin/postmap hash:/test/ing') }
    end

    context "on #{os} with main_virtual_alias_maps set to valid hash:/test/ing when virtual_aliases_external is set to valid value" do
      let(:params) { { main_virtual_alias_maps: 'hash:/test/ing', virtual_aliases_external: true } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{virtual_alias_maps = hash:/test/ing}) }
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

    context "on #{os} with transport_maps_external set to valid true" do
      let(:params) { { transport_maps_external: true } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{transport_maps = hash:/etc/postfix/transport}) }
    end

    context "on #{os} with transport_maps set to valid {test@test.ing => test}" do
      let(:params) { { transport_maps: { 'test@test.ing' => 'test.ing' } } }

      content = <<-END.gsub(%r{^\s+\|}, '')
        |# This file is being maintained by Puppet.
        |# DO NOT EDIT
        |
        |test@test.ing		test.ing
      END

      it do
        is_expected.to contain_file('postfix_transport').only_with(
          {
            'ensure'  => 'file',
            'path'    => '/etc/postfix/transport',
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0644',
            'content' => content,
          },
        )
      end

      it do
        is_expected.to contain_exec('postfix_rebuild_transport').only_with(
          {
            'command'     => '/usr/sbin/postmap hash:/etc/postfix/transport',
            'refreshonly' => true,
            'subscribe'   => 'File[postfix_transport]',
          },
        )
      end
    end

    context "on #{os} with transport_maps set to valid {test1@test.ing => test1.ing, test2@test.ing => test2.ing}" do
      let(:params) { { transport_maps: { 'test1@test.ing' => 'test1.ing', 'test2@test.ing' => 'test2.ing' } } }

      content = <<-END.gsub(%r{^\s+\|}, '')
        |# This file is being maintained by Puppet.
        |# DO NOT EDIT
        |
        |test1@test.ing		test1.ing
        |test2@test.ing		test2.ing
      END

      it { is_expected.to contain_file('postfix_transport').with_content(content) }
    end

    context "on #{os} with virtual_aliases_external set to valid true" do
      let(:params) { { virtual_aliases_external: true } }

      it { is_expected.to contain_file('postfix_main.cf').with_content(%r{virtual_alias_maps = hash:/etc/postfix/virtual}) }
    end

    context "on #{os} with virtual_aliases set to valid {test@test.ing => test}" do
      let(:params) { { virtual_aliases: { 'test@test.ing' => 'test.ing' } } }

      content = <<-END.gsub(%r{^\s+\|}, '')
        |# This file is being maintained by Puppet.
        |# DO NOT EDIT
        |
        |test@test.ing		test.ing
      END

      it do
        is_expected.to contain_file('postfix_virtual').only_with(
          {
            'ensure'  => 'file',
            'path'    => '/etc/postfix/virtual',
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0644',
            'content' => content,
          },
        )
      end

      it do
        is_expected.to contain_exec('postfix_rebuild_virtual').only_with(
          {
            'command'     => '/usr/sbin/postmap hash:/etc/postfix/virtual',
            'refreshonly' => true,
            'subscribe'   => 'File[postfix_virtual]',
          },
        )
      end
    end

    context "on #{os} with virtual_aliases set to valid {test1@test.ing => test1.ing, test2@test.ing => test2.ing}" do
      let(:params) { { virtual_aliases: { 'test1@test.ing' => 'test1.ing', 'test2@test.ing' => ['test21.ing', 'test22.ing'] } } }

      content = <<-END.gsub(%r{^\s+\|}, '')
        |# This file is being maintained by Puppet.
        |# DO NOT EDIT
        |
        |test1@test.ing		test1.ing
        |test2@test.ing		test21.ing,test22.ing
      END

      it { is_expected.to contain_file('postfix_virtual').with_content(content) }
    end
  end
end
