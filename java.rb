dep "default-jre.managed" do
  provides ["java"]
end

dep "java-virtual-machine.managed" do
  require 'java'
  provides ["java-virtual-machine"]
end