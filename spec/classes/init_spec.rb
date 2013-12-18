require 'spec_helper'

describe 'postfix' do
  describe 'postfix_config' do
    let :facts do
      {
        :osfamily => 'Debian',
      }
    end

  context 'postfix with default params' do
    it {
      should contain_file('postfix_main.cf').with({
        'path'  => '/etc/postfix/main.cf',
        'owner' => 'root',
        'group' => 'root',
        'mode'  => '0644',
        'require' => 'Package[postfix_packages]',
      })
    }
  end
end
