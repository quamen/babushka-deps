dep "default-jre.managed" do
  provides ["java"]
end

dep "java-virtual-machine.managed" do
  requires 'default-jre.managed'
  provides ["java-virtual-machine"]
end