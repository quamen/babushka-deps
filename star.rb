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
  requires 'TextMate.app',
           'homebrew'
end