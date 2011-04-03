dep '*' do
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
  requires 'dot-files',
           'TextMate.app',
           'homebrew',
           'zsh'
end

dep 'zsh' do
  requires 'wget.managed'
  requires 'zsh.managed'
  
  met? { "~/.oh-my-zsh".p.exists? }
  meet { login_shell('wget --no-check-certificate https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh') }
end

dep 'dot-files' do
  requires 'git'
  
  met? { ".ackrc".p.exists? }
  meet {
    shell('mkdir -p ~/Code/github/quamen')
    in_dir('~/Code/github/quamen') do
      shell('git clone git@github.com:quamen/dot-files.git')
    end
    in_dir('~/Code/github/quamen/dot-files') do
      shell('./clone_and_link.sh')
    end
  }
end