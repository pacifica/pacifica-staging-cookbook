#
# Cookbook Name:: pacifica
# Spec:: pacifica_archiveinterface
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'unit::uploader' do
  before do
    stub_command("psql -c '\\l' | grep -q pacifica_metadata").and_return(true)
    stub_command("psql -c 'SELECT rolname FROM pg_roles;' | grep -q pacifica").and_return(true)
    stub_command("psql -c '\\l' | grep -q pacifica=").and_return(true)
  end
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on an #{platform.capitalize}-#{version} box" do
        cached(:chef_run) do
          ChefSpec::ServerRunner.new(
            platform: platform, version: version, step_into: 'pacifica_uploaderfrontend'
          ).converge(described_recipe)
        end

        it 'Installs the sqlite packages' do
          expect(chef_run).to install_package('default_packages')
        end

        it 'Converges successfully for default' do
          expect { chef_run }.to_not raise_error
        end

        it 'Installs git client' do
          expect(chef_run).to install_git_client('default')
        end

        it 'Creates prefix directory' do
          expect(chef_run).to create_directory('/opt/default')
        end

        it 'Creates git repository' do
          expect(chef_run).to sync_git('/opt/default/default-pacifica-uploaderfrontend')
        end

        it 'Creates the bash script file' do
          expect(chef_run).to create_file('/opt/default/default-pacifica-uploaderfrontend.sh')
        end

        it 'Installs python runtime' do
          expect(chef_run).to install_python_runtime('default')
        end

        it 'Creates python virtual environment' do
          expect(chef_run).to create_python_virtualenv('/opt/default')
        end

        it 'Installs python requirements by python execute' do
          expect(chef_run).to run_python_execute('default_requirements')
        end

        it 'Creates template config' do
          expect(chef_run).to create_template('/opt/default/default-pacifica-uploaderfrontend/UploaderConfig.json')
        end

        it 'Creates poise service' do
          expect(chef_run).to enable_poise_service('default-pacifica-uploaderfrontend')
        end

        it 'Enables and starts the service' do
          expect(chef_run).to enable_service('default-pacifica-uploaderfrontend')
          expect(chef_run).to start_service('default-pacifica-uploaderfrontend')
        end
      end
    end
  end
end
