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