dep 'github' do
  requires 'git user.name',
           'git user.email',
           'git github.user',
           'git github.token'
end

dep 'git user.name' do
  met? { shell('git config --global --get user.name') == "#{var(:name)}" }
  meet { shell("git config --global user.name '#{var(:name)}'") }
end

dep 'git user.email' do
  met? { shell('git config --global --get user.email') == "#{var(:email)}" }
  meet { shell("git config --global user.email '#{var(:email)}'") }
end

dep 'git github.user' do
  met? { shell('git config --global --get github.user') == "#{var(:github_user)}" }
  meet { shell("git config --global github.user '#{var(:github_user)}'") }
end

dep 'git github.token' do
  met? { shell('git config --global --get github.token') == "#{var(:github_token)}" }
  meet { shell("git config --global github.token '#{var(:github_token)}'") }
end