require 'spec_helper'

describe 'hadoop::hadoop_mapreduce_tasktracker' do
  context 'on Centos 6.5 with CDH' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: 6.5) do |node|
        node.automatic['domain'] = 'example.com'
        node.override['hadoop']['distribution'] = 'cdh'
        stub_command('update-alternatives --display hadoop-conf | grep best | awk \'{print $5}\' | grep /etc/hadoop/conf.chef').and_return(false)
      end.converge(described_recipe)
    end

    it 'installs hadoop-0.20-mapreduce-tasktracker package' do
      expect(chef_run).to install_package('hadoop-0.20-mapreduce-tasktracker')
    end

    it 'creates hadoop-0.20-mapreduce-tasktracker service resource, but does not run it' do
      expect(chef_run).to_not start_service('hadoop-0.20-mapreduce-tasktracker')
    end
  end

  context 'on Centos 6.5 with HDP' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: 6.5) do |node|
        node.automatic['domain'] = 'example.com'
        stub_command('update-alternatives --display hadoop-conf | grep best | awk \'{print $5}\' | grep /etc/hadoop/conf.chef').and_return(false)
      end.converge(described_recipe)
    end

    it 'does not install hadoop-0.20-mapreduce-tasktracker package' do
      expect(chef_run).not_to install_package('hadoop-0.20-mapreduce-tasktracker')
    end
  end
end
