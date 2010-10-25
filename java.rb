dep "default-jre.managed" do
  provides ["java"]
end

dep "gcj-jdk" do
  requires 'default-jre.managed'
  
  met? do
    result = shell('dpkg -s gcj-jdk')
    result && result['Status: install ok installed']
  end
  
  meet do
    sudo('apt-get install gcj-jdk')
  end
end