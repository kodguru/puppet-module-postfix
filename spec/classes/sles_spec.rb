# This test is for SLES systems where each minor release contains different
# default configuration. Tests contents of  main.cf specifically.
# https://github.com/voxpupuli/facterdb/

require 'spec_helper'

# To make this automatic, use hiera files for SLES as source
yaml_files = Dir['data/os/SLES/*.yaml']
os_release = []
yaml_files.each do |file|
  os_release << File.basename(file, File.extname(file))
end

describe 'postfix' do
  os_release.each do |release|
    describe "on SLES #{release} with default values for parameters" do
      major = release.split('.')[0]
      minor = release.split('.')[1]
      let(:facts) do
        {
          hostname: 'foo',
          networking: {
            domain: 'example.com',
            fqdn: 'foo.example.com',
          },
          os: {
            family: 'Suse',
            name: 'SLES',
            release: {
              full: release,
              major: major,
              minor: minor,
            },
          },
        }
      end

      content_fixture = if File.exist?(fixtures("testing/SLES-#{release}_main.cf"))
                          File.read(fixtures("testing/SLES-#{release}_main.cf"))
                        else
                          File.read(fixtures("testing/SLES-#{major}_main.cf"))
                        end

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
    end
  end
end
