dep "default-jre.managed" do
  provides ["java"]
end

dep "gcj-jre-headless.managed" do
  requires 'default-jre.managed'
  provides ["gcj-jre-headless"]
end