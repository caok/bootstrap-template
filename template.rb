def template_file path
  template_path = File.expand_path("../templates/#{path}", __FILE__)
  if template_path =~ /https:/
    template_path = template_path.scan(/https:.*/).first if template_path =~ /https:/
    template_path.sub!(/https:/, 'https:/') # workaround to add missing slash for https:// 
  end
  file path, open(template_path).read
end

gem 'mysql2'
gem 'slim-rails'
gem 'twitter-bootstrap-rails'
gem 'kaminari'
#gem 'nokogiri'
#gem 'newrelic_rpm'

gem 'simple_form'
gem 'client_side_validations'
gem 'client_side_validations-simple_form'

gem 'devise'
gem 'cancan'

gem 'rails-i18n'
gem 'devise-i18n'

gem_group :development, :test do
  gem 'rspec-rails'
  gem 'capybara'
  gem 'factory_girl_rails'
end

gem_group :assets do
  gem 'turbo-sprockets-rails3'
  gem 'therubyracer'
end

gem_group :development do
  gem 'capistrano'
  gem 'quiet_assets'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
end

run 'bundle install'

generate('devise:install')
generate('devise', 'user')
generate('cancan:ability')
generate('devise:views')
#run "gem install hpricot ruby_parser haml2slim"
#run "for i in `find app/views/devise -name '*.erb'` ; do html2haml -e $i ${i%erb}haml ; rm $i ; done"
#run "for i in `find app/views/devise -name '*.haml'` ; do haml2slim $i ${i%haml}slim ; rm $i ; done"

generate('kaminari:config')
generate('kaminari:views', 'bootstrap')
#generate('kaminari:views', 'bootstrap -e haml')
#run "for i in `find app/views/kaminari -name '*.haml'` ; do haml2slim $i ${i%haml}slim ; rm $i ; done"

generate('bootstrap:install', 'less')
#generate('bootstrap:layout', 'application fixed')
#generate('bootstrap:layout', 'application fluid')
#generate('bootstrap:themed Posts')

generate('simple_form:install', '--bootstrap')
generate('client_side_validations:install')
generate('rspec:install')

append_file 'app/assets/javascripts/application.js', <<-CODE, verbose: false
//= require rails.validations
//= require rails.validations.simple_form
CODE

append_file 'app/assets/stylesheets/application.css', <<-CODE, verbose: false
body {padding-top: 60px;}
CODE

run 'rm -rf app/views/layouts/application.html.erb' # use generated slim version instead
run "rm -rf public/index.html"
run "rm -rf app/assets/images/rails.png"

environment do
<<-CODE
config.time_zone = 'Beijing'
    config.i18n.default_locale = 'zh-CN'
    config.generators do |g|
      g.fixture_replacement :factory_girl
      g.test_framework :rspec, :fixture => true
      g.stylesheets false
      g.javascripts false
      g.helper false
      g.helper_specs false
      g.view_specs false
    end
CODE
end

template_file 'app/views/common/_menu.html.slim'
template_file 'app/views/common/_search_form.html.slim'
template_file 'app/views/common/_user_nav.html.slim'
template_file 'app/views/layouts/application.html.slim'

generate(:controller, "home index")
route "root :to => 'home#index'"
#rake("db:migrate")

git :init
git :add => "."
git :commit => "-a -m 'Initial commit'"
