# spec/Dockerfile_spec.rb

require_relative "spec_helper"

describe "Dockerfile" do
  before(:all) do
    load_docker_image()
    set :os, family: :redhat
  end

  describe "Dockerfile#running" do
    it "runs the right version of RHEL" do
      expect(os_version).to include("Red Hat")
      expect(os_version).to include("release 7")
    end
    it "runs as root user" do
      expect(sys_user).to eql("root")
    end
  end

  describe package("java-11-openjdk-headless") do
    it { should be_installed }
  end

  describe command("java --version") do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/11(.*)/) }
  end

  describe command("javac --version") do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/11(.*)/) }
  end

  describe command("jshell --version") do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/11(.*)/) }
  end

  describe command('bash -l -c "echo $JAVA_HOME"') do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match("/usr/local/openjdk-11") }
  end

  describe command('bash -c "ls -lah $JAVA_HOME"') do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match("/usr/local/openjdk-11 ->") }
  end

  describe command('bash -c "ls $JAVA_HOME"') do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match("bin") }
    its(:stdout) { should match("conf") }
    its(:stdout) { should match("include") }
    its(:stdout) { should match("legal") }
    its(:stdout) { should match("lib") }
    its(:stdout) { should match("release") }
  end
end
