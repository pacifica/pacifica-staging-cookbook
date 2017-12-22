#
# Cookbook Name:: pacifica
# Spec:: pacifica_archiveinterface
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'unit::reporting' do
  before do
    stub_command("psql -c '\\l' | grep -q pacifica_metadata").and_return(true)
    stub_command("psql -c 'SELECT rolname FROM pg_roles;' | grep -q pacifica").and_return(true)
    stub_command("psql -c '\\l' | grep -q pacifica=").and_return(true)
    stub_command('curl localhost:8121/users | grep -q dmlb2001').and_return(true)
  end
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on an #{platform.capitalize}-#{version} box" do
        cached(:chef_run) do
          ChefSpec::ServerRunner.new(
            platform: platform, version: version, step_into: 'pacifica_reporting'
          ).converge(described_recipe)
        end

        it 'Converges successfully for default' do
          expect { chef_run }.to_not raise_error
        end

        it 'Installs git client' do
          expect(chef_run).to install_git_client('default')
        end

        it 'Creates prefix directory' do
          expect(chef_run).to create_directory('/var/www/default-pacifica-reporting')
        end

        it 'Creates git repository' do
          expect(chef_run).to sync_git('Clone Website for default')
        end

        it 'Installs package tar' do
          expect(chef_run).to install_package('tar')
        end

        it 'Deploys the code' do
          expect(chef_run).to run_bash('Deploy Code for default')
        end

        it 'Creates file for config' do
          expect(chef_run).to create_file('File default production config')
        end
        it 'Creates file for database' do
          expect(chef_run).to create_file('File default production database')
        end

      end
    end
  end
end
