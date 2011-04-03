meta :rvm do
  def rvm args
    shell "~/.rvm/bin/rvm #{args}", :log => args['install']
  end
end

dep 'rvm with rubies' do
  requires 'rvm',
           '1.8.7 installed.rvm',
           '1.9.2 installed.rvm',
           'ree installed.rvm',
           'macruby installed.rvm',
           'set default rvm ruby to 1.9.2'
end

dep 'set default rvm ruby to 1.9.2' do
  requires '1.9.2 installed.rvm'
  met? { login_shell('ruby --version')['ruby 1.9.2'] }
  meet { shell('~/.rvm/bin/rvm use 1.9.2 --default') }
end

dep '1.8.7 installed.rvm' do
  requires 'rvm'
  met? { rvm('list')['ruby-1.8.7-p334'] }
  meet { log("rvm install 1.8.7") { rvm 'install 1.8.7'} }
end

dep '1.9.2 installed.rvm' do
  requires 'rvm'
  met? { rvm('list')['ruby-1.9.2-p180'] }
  meet { log("rvm install 1.9.2") { rvm 'install 1.9.2'} }
end

dep 'ree installed.rvm' do
  requires 'rvm'
  met? { rvm('list')['ree-1.8.7-2011.03'] }
  meet { log("rvm install ree") { rvm 'install ree'} }
end

dep 'macruby installed.rvm' do
  requires 'rvm'
  met? { rvm('list')['macruby-0.10'] }
  meet { log("rvm install macruby") { rvm 'install macruby'} }
end


dep 'rvm' do
  met? { raw_which 'rvm', login_shell('which rvm') }
  meet {
    if confirm("Install rvm system-wide?", :default => 'n')
      log_shell "Installing rvm using rvm-install-system-wide", 'bash < <( curl -L http://bit.ly/rvm-install-system-wide )'
    else
      log_shell "Installing rvm using rvm-install-head", 'bash -c "`curl http://rvm.beginrescueend.com/releases/rvm-install-head`"'
    end
  }
end

meta :rvm_mirror do
  def urls
    shell("grep '_url=' ~/.rvm/config/db").split("\n").reject {|l|
      l['_repo_url']
    }.map {|l|
      l.sub(/^.*_url=/, '')
    }
  end
  template {
    requires 'rvm'
  }
end

dep 'mirrored.rvm_mirror' do
  define_var :rvm_vhost_root, :default => '/srv/http/rvm'
  def missing_urls
    urls.tap {|urls| log "#{urls.length} URLs in the rvm database." }.reject {|url|
      path = var(:rvm_vhost_root) / url.sub(/^[a-z]+:\/\/[^\/]+\//, '')
      path.exists? && !path.empty?
    }.tap {|urls| log "Of those, #{urls.length} aren't present locally." }
  end
  met? { missing_urls.empty? }
  meet {
    missing_urls.each {|url|
      in_dir(var(:rvm_vhost_root) / File.dirname(url.sub(/^[a-z]+:\/\/[^\/]+\//, '')), :create => true) do
        # begin
          Babushka::Resource.download url
        # rescue StandardError => ex
        #   log_error ex.inspect
        # end
      end
    }
  }
  after {
    log urls.map {|url|
      url.scan(/^[a-z]+:\/\/([^\/]+)\//).flatten.first
    }.uniq.reject {|url|
      url[/[:]/]
    }.join(' ')
    log "Those are the domains you should point at #{var(:rvm_vhost_root)}."
  }
end