dep 'hudson' do

  requires 'daemon.managed'

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