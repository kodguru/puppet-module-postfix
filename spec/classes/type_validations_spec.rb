require 'spec_helper'
describe 'postfix' do
  # The following tests are OS independent, so we only test one
  redhat = {
    supported_os: [
      {
        'operatingsystem'        => 'RedHat',
        'operatingsystemrelease' => ['8'],
      },
    ],
  }

  on_supported_os(redhat).sort.each do |_os, os_facts|
    describe 'variable type and content validations' do
      let(:facts) { os_facts }

      validations = {
        'Array[String[1]]' => {
          name:    ['packages'],
          valid:   [['testing'], ['test', 'ing']],
          invalid: ['', 'invalid', [1], [[1]], [{ 'ha' => 'sh' }], 3, 2.42, { 'ha' => 'sh' }, true, false],
          message: '(expects an Array value|index \d+ expects a String value)',
        },
        'Boolean' => {
          name:    ['service_hasrestart', 'service_hasstatus', 'transport_maps_external', 'virtual_aliases_external'],
          valid:   [true, false],
          invalid: ['true', 'false', nil, 'invalid', 3, 2.42, ['array'], { 'ha' => 'sh' }],
          message: 'expects a Boolean',
        },
        'Enum[yes, no]' => {
          name:    ['main_append_dot_mydomain', 'main_biff'],
          valid:   ['yes', 'no'],
          invalid: [true, false, 'invalid', 3, 2.42, ['array'], { 'ha' => 'sh' }],
          message: 'expects a match for Enum',
        },
        'Integer[0]' => {
          name:    ['main_mailbox_size_limit', 'main_relayhost_port'],
          valid:   [0, 242, 51_200_000 ],
          invalid: [-1, 2.42, 'string', ['array'], { 'ha' => 'sh' }],
          message: '(expects an Integer value|expects an Integer\[0\] value)',
        },
        'Optional[Array[String[1]]]' => {
          name:    ['main_smtpd_helo_restrictions', 'main_smtpd_recipient_restrictions'],
          valid:   [['array'], ['array', 'array']],
          invalid: ['invalid', [1], [[1]], [{ 'ha' => 'sh' }], 3, 2.42, { 'ha' => 'sh' }, true, false],
          message: '(expects a value of type Undef or Array|index \d+ expects a String value)',
        },
        'Optional[Enum[yes, no]]' => {
          name:    ['main_smtpd_helo_required'],
          valid:   ['yes', 'no'],
          invalid: [true, false, 'invalid', 3, 2.42, ['array'], { 'ha' => 'sh' }],
          message: 'expects an undef value or a match for Enum',
        },
        'Optional[Integer[0]]' => {
          name:    ['main_unknown_local_recipient_reject_code'],
          valid:   [0, 242, 51_200_000 ],
          invalid: [-1, 2.42, 'string', ['array'], { 'ha' => 'sh' }],
          message: '(value of type Undef or Integer)',
        },
        'Optional[Hash]' => {
          name:    ['transport_maps', 'virtual_aliases'],
          valid:   [{ 'ha' => 'sh' }, { 'test1@test.void' => 'destination1', 'test2@test.void' => ['destination2', 'destination3'] }],
          invalid: [true, false, 'invalid', 3, 2.42, ['array']],
          message: 'expects a value of type Undef or Hash',
        },
        'Optional[String[1]]' => {
          name:    ['main_compatibility_level', 'main_debug_peer_level', 'main_mailbox_command', 'main_mail_owner', 'main_readme_directory',
                    'main_relay_domains', 'main_smtpd_banner', 'main_smtpd_relay_restrictions', 'main_smtpd_tls_mandatory_protocols',
                    'main_smtpd_tls_protocols', 'main_smtpd_tls_security_level', 'main_smtp_tls_mandatory_protocols', 'main_smtp_tls_protocols',
                    'main_smtp_tls_security_level', 'main_virtual_alias_domains'],
          valid:   ['valid'],
          invalid: [['array'], { 'ha' => 'sh' }],
          message: 'expects a value of type Undef or String',
        },
        'Stdlib::Absolutepath & Optional[Stdlib::Absolutepath]' => {
          name:    ['main_command_directory', 'main_daemon_directory', 'main_data_directory', 'main_html_directory', 'main_manpage_directory',
                    'main_mailq_path', 'main_meta_directory', 'main_newaliases_path', 'main_sample_directory', 'main_sendmail_path',
                    'main_shlib_directory', 'main_smtp_tls_cafile', 'main_queue_directory', 'main_smtpd_tls_cert_file', 'main_smtpd_tls_key_file',
                    'main_smtp_tls_capath'],
          valid:   ['/absolute/filepath', '/absolute/directory/'], # cant test undef :(
          invalid: ['relative/path', 3, 2.42, ['array'], { 'ha' => 'sh' }],
          message: 'expects a Stdlib::Absolutepath',
        },
        'Stdlib::Ensure::Service' => {
          name:    ['service_ensure'],
          valid:   ['running', 'stopped'],
          invalid: ['invalid', 3, 2.42, ['array'], { 'ha' => 'sh' }],
          message: 'Enum\[\'running\', \'stopped\'\]',
        },
        'Stdlib::Host & Optional[Stdlib::Host]' => {
          name:    ['main_inet_interfaces', 'main_mydestination', 'main_mydomain', 'main_myhostname', 'main_mynetworks', 'main_relayhost'],
          valid:   ['127.0.0.1', 'localhost', 'v.al.id', 'val.id'],
          invalid: ['in valid', 3, 2.42, ['array'], { 'ha' => 'sh' }],
          message: 'expects a Stdlib::Host',
        },
        'String[1]' => {
          name:    ['main_alias_database', 'main_alias_maps', 'main_inet_protocols', 'main_myorigin', 'main_recipient_delimiter', 'main_setgid_group', 'main_transport_maps',
                    'main_virtual_alias_maps', 'service_name'],
          valid:   ['valid'],
          invalid: ['', 3, 2.42, ['array'], { 'ha' => 'sh' }],
          message: '(expects a String value|expects a String\[1\] value)',
        },
        'Variant[Boolean, Enum[\'true\', \'false\', \'manual\']]' => {
          name:    ['service_enable'],
          valid:   [true, false, 'true', 'false', 'manual'],
          invalid: ['invalid', 3, 2.42, ['array'], { 'ha' => 'sh' }],
          message: 'value of type Boolean or Enum',
        },
      }

      validations.sort.each do |type, var|
        var[:name].each do |var_name|
          mandatory_params = {} if mandatory_params.nil?
          var[:params] = {} if var[:params].nil?
          var[:valid].each do |valid|
            context "when #{var_name} (#{type}) is set to valid #{valid} (as #{valid.class})" do
              let(:params) { [mandatory_params, var[:params], { "#{var_name}": valid, }].reduce(:merge) }

              it { is_expected.to compile }
            end
          end

          var[:invalid].each do |invalid|
            context "when #{var_name} (#{type}) is set to invalid #{invalid} (as #{invalid.class})" do
              let(:params) { [mandatory_params, var[:params], { "#{var_name}": invalid, }].reduce(:merge) }

              it 'fail' do
                expect { is_expected.to contain_class(:subject) }.to raise_error(Puppet::Error, %r{#{var[:message]}})
              end
            end
          end
        end
      end # var[:name].each
    end # validations.sort.each
  end # describe 'variable type and content validations'
end
