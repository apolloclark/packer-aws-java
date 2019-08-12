# spec/Dockerfile_spec.rb

require "serverspec"
require "docker"

Docker.validate_version!

describe "Dockerfile" do
  before(:all) do
    docker_username = ENV['DOCKER_USERNAME']
    package_name    = ENV['PACKAGE_NAME']
    package_version = ENV['PACKAGE_VERSION']
    image_name      = ENV['IMAGE_NAME']

    # check for package version major usage
    if package_version.match(/(\d+).x/)
        package_version = package_version.match(/(\d+).x/)[1]
    end

    image = Docker::Image.get(
      "#{docker_username}/#{package_name}:#{package_version}-#{image_name}"
    )

    # https://github.com/mizzy/specinfra
    # https://docs.docker.com/engine/api/v1.24/#31-containers
    # https://github.com/swipely/docker-api
    # https://serverspec.org/resource_types.html
    set :os, family: :debian
    set :backend, :docker
    set :docker_image, image.id
  end

  def os_version
    command("cat /etc/*-release").stdout
  end

  def sys_user
    command("whoami").stdout.strip
  end



  it "installs the right version of Ubuntu" do
    expect(os_version).to include("Debian")
    expect(os_version).to include("GNU/Linux 10")
  end

  it "runs as root" do
    expect(sys_user).to include("root")
  end

  it "installs required packages" do
    expect(package("openjdk-11-jdk-headless")).to be_installed
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
