# Encoding: utf-8
require 'spec_helper'

# Java 1.7
describe command('java -version') do
  its(:stderr) { should contain(/java version "1.7.\d+_\d+"/) }
end

# Logstash Instance
describe service('logstash_server') do
  it { should be_enabled } unless os[:family] == 'redhat' && os[:release].to_f >= 6.0
  it { should be_running }
end

describe user('logstash') do
  it { should exist }
end

# Logstash Config
describe file('/opt/logstash/server/etc/conf.d/input_syslog') do
  it { should be_file }
end

describe file('/opt/logstash/server/etc/conf.d/output_elasticsearch') do
  it { should be_file }
end

describe file('/opt/logstash/server/etc/conf.d/output_stdout') do
  it { should be_file }
end

sleep(10)
describe port(9300) do
  it { should be_listening }
end

describe port(5959) do
  it { should be_listening }
end

# Logstash Curator
# describe cron do
#   it { should have_entry("0 * * * * /usr/local/bin/curator --host 127.0.0.1 delete indices --older-than 31 --time-unit days --timestring '\%Y.\%m.\%d' --prefix logstash- &> /dev/null").with_user('logstash') }
# end
# broken on centos rn
