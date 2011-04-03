dep '*' do
  requires 'osx essential applications'
end

dep 'osx essential applications' do
  requires '1Password.app',
           'Caffeine.app',
           'Dropbox.app',
           'Google Chrome.app',
           'LaunchBar.app',
           'SizeUp.app'
end
