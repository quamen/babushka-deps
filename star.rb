dep 'star' do
  requires 'osx essential applications',
           'development tools',
           'rvm with rubies'
end

dep 'osx essential applications' do
  requires '1Password.app',
           'Caffeine.app',
           'Dropbox.app',
           'Google Chrome.app',
           'LaunchBar.app',
           'SizeUp.app'
end

dep 'development tools' do
  requires 'public keys',
           'github',
           'TextMate.app',
           'homebrew',
           'oh-my-zsh',
           'dot-files'
           
           
end

dep 'zsh' do
  requires 'zsh.managed'
  met? { sudo('echo \$SHELL', :as => var(:username), :su => true) == '/bin/zsh' }
  meet { sudo("chsh -s '/bin/zsh' #{var(:username)}") }
end

dep 'oh-my-zsh' do
  requires 'wget.managed'
  requires 'zsh'
  
  met? { "~/.oh-my-zsh".p.exists? }
  meet { login_shell('wget --no-check-certificate https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh') }
end

dep 'dot-files' do
  requires 'git'
  
  met? { "~/Code/github/quamen/dot-files".p.exists? }
  meet {
    login_shell('mkdir -p ~/Code/github/quamen') unless ' ~/Code/github/quamen'.p.exists?
    git 'git@github.com:quamen/dot-files.git', :to => '~/Code/github/quamen/dot-files'
    in_dir('~/Code/github/quamen/dot-files') do
      shell('./clone_and_link.sh')
    end
  }
end

dep 'public keys' do
  met? { "~/.ssh/id_rsa.pub".p.exists? }
  meet {
    shell("echo '\n' | ssh-keygen -t rsa -C '#{var(:email)}' -N '#{var(:phrase)}'")
  }
end