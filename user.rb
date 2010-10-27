dep 'user set up from root', :on => :linux do
  setup { set :home_dir_base, "/home" }
  requires 'user exists with password', 'authorized key present for user'
end

dep 'authorized key present for user' do
  requires 'benhoskings:user exists'
  helper(:ssh_dir) { "#{var(:home_dir_base) / var(:username)}/.ssh" }
  met? { sudo "grep '#{var(:your_ssh_public_key)}' '#{ssh_dir}/authorized_keys'" }
  before { sudo "mkdir -p '#{ssh_dir}'; chmod 700 '#{ssh_dir}'" }
  meet { append_to_file var(:your_ssh_public_key), "#{ssh_dir}/authorized_keys", :sudo => true }
  after { sudo "chown -R #{var(:username)}:#{var(:username)} '#{ssh_dir}'; chmod 600 '#{ssh_dir}/authorized_keys'" }
end

dep 'user exists with password' do
  requires 'user exists'
  on :linux do
    met? { grep(/^#{var(:username)}:[^\*!]/, '/etc/shadow') }
    meet {
      sudo "echo -e '#{var(:password)}\n#{var(:password)}' | passwd #{var(:username)}"
    }
  end
end

dep 'user exists with global git config' do
  requires 'user exists with password'
  on :linux do
    met? do
      email = shell("git config --global user.email")
      name = shell("git config --global user.name")
      
      (email == "#{var(:email)}") && (name == "#{var(:name)}")
    end
    
    meet do
      shell("git config --global user.email #{var(:email)}")
      shell("git config --global user.name #{var(:name)}")
    end
  end
end

dep 'user exists' do
  setup {
    define_var :home_dir_base, :default => L{
      var(:username)['.'] ? '/srv/http' : '/home'
    }
  }
  on :osx do
    met? { !shell("dscl . -list /Users").split("\n").grep(var(:username)).empty? }
    meet {
      homedir = var(:home_dir_base) / var(:username)
      {
        'Password' => '*',
        'UniqueID' => (501...1024).detect {|i| (Etc.getpwuid i rescue nil).nil? },
        'PrimaryGroupID' => 'admin',
        'RealName' => var(:username),
        'NFSHomeDirectory' => homedir,
        'UserShell' => '/dev/null'
      }.each_pair {|k,v|
        # /Users/... here is a dscl path, not a filesystem path.
        sudo "dscl . -create #{'/Users' / var(:username)} #{k} '#{v}'"
      }
      sudo "mkdir -p '#{homedir}'"
      sudo "chown #{var(:username)}:admin '#{homedir}'"
      sudo "chmod 701 '#{homedir}'"
    }
  end
  on :linux do
    met? { grep(/^#{var(:username)}:/, '/etc/passwd') }
    meet {
      sudo "mkdir -p #{var :home_dir_base}" and
      sudo "useradd -m -s /bin/bash -b #{var :home_dir_base} -G admin #{var(:username)}" and
      sudo "chmod 701 #{var(:home_dir_base) / var(:username)}"
    }
  end
end