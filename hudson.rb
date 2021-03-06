dep 'hudson' do
  requires 'gcj-jdk.managed', 'daemon.managed'

  met? do
    result = shell('dpkg -s hudson')
    result && result['Status: install ok installed']
  end

  meet do
    shell('wget -O /tmp/hudson-apt-key http://hudson-ci.org/debian/hudson-ci.org.key')
    sudo('apt-key add /tmp/hudson-apt-key')
    shell('wget -O /tmp/hudson.dep http://hudson-ci.org/latest/debian/hudson.deb')
    sudo('dpkg --install /tmp/hudson.dep')
  end
end

dep 'hudson plugins for rails' do
  requires 'hudson', 'hudson cli', 'hudson git plugin', 'hudson github plugin', 'hudson ruby plugin', 'hudson rake plugin', 'hudson has been restarted'
end

dep 'hudson has been restarted' do
  met? do
    if "/tmp/hudson.kick".p.exists?
      shell('rm /tmp/hudson.kick')
      true
    else
      false
    end
  end
  
  meet do
    sudo('/etc/init.d/hudson stop')
    30.times do
      response = sudo('/etc/init.d/hudson start')
      if response && !response.include?("The selected http port (8080) seems to be in use by another program")
        shell('touch /tmp/hudson.kick')
        break
      else
        sleep 1
      end
    end
  end
end

dep 'hudson cli' do
  met? do
    "/usr/share/hudson/hudson-cli.jar".p.exists?
  end
  
  meet do
    in_dir('/usr/share/hudson') do
      sudo('jar -xf hudson.war WEB-INF/hudson-cli.jar')
      sudo('mv WEB-INF/hudson-cli.jar .')
      sudo('rmdir WEB-INF')
    end
  end
  
  after do
    in_dir('/usr/share/hudson') do
      30.times do
        response = shell('java -jar hudson-cli.jar -s http://localhost:8080/ version')
        break if response && response =~ /^\d+(\.\d+)*$/
        sleep 1
      end
    end
  end
end

dep 'hudson git plugin' do
  met? do
    "/var/lib/hudson/plugins/git.hpi".p.exists?
  end
  
  meet do
    in_dir('/usr/share/hudson') do
      shell('wget -O /tmp/git.hpi http://hudson-ci.org/latest/git.hpi')
      shell('java -jar hudson-cli.jar -s http://localhost:8080/ install-plugin /tmp/git.hpi')
    end
  end
end

dep 'hudson github plugin' do
  met? do
    "/var/lib/hudson/plugins/github.hpi".p.exists?
  end
  
  meet do
    in_dir('/usr/share/hudson') do
      shell('wget -O /tmp/github.hpi http://hudson-ci.org/latest/github.hpi')
      shell('java -jar hudson-cli.jar -s http://localhost:8080/ install-plugin /tmp/github.hpi')
    end
  end
end

dep 'hudson ruby plugin' do
  met? do
    "/var/lib/hudson/plugins/ruby.hpi".p.exists?
  end
  
  meet do
    in_dir('/usr/share/hudson') do
      shell('wget -O /tmp/ruby.hpi http://hudson-ci.org/latest/ruby.hpi')
      shell('java -jar hudson-cli.jar -s http://localhost:8080/ install-plugin /tmp/ruby.hpi')
    end
  end
end

dep 'hudson rake plugin' do
  met? do
    "/var/lib/hudson/plugins/rake.hpi".p.exists?
  end
  
  meet do
    in_dir('/usr/share/hudson') do
      shell('wget -O /tmp/rake.hpi http://hudson-ci.org/latest/rake.hpi')
      shell('java -jar hudson-cli.jar -s http://localhost:8080/ install-plugin /tmp/rake.hpi')
    end
  end
end