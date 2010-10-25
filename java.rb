dep "default-jre.managed" do
  provides ["java"]
end

dep "gcj-jdk.managed" do
  requires 'default-jre.managed'
  provides []
end