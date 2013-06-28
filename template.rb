def template_file path
  template_path = File.expand_path("../templates/#{path}", __FILE__)
  if template_path =~ /https:/
    template_path = template_path.scan(/https:.*/).first if template_path =~ /https:/
    template_path.sub!(/https:/, 'https:/') # workaround to add missing slash for https:// 
  end
  file path, open(template_path).read
end

generate('devise:install')
generate('devise', 'user')
generate('devise:views:locale', 'zh-CN')
generate('cancan:ability')

generate('kaminari:config')
generate('kaminari:views', 'bootstrap -e erb')

generate('bootstrap:install', 'less')
#generate('bootstrap:layout', 'application fixed')
#generate('bootstrap:layout', 'application fluid')
#generate('bootstrap:themed Posts')

generate('simple_form:install', '--bootstrap')
generate('client_side_validations:install')
generate('rspec:install')

generate('ckeditor:install', '--orm=active_record --backend=carrierwave')

append_file 'app/assets/javascripts/application.js', <<-CODE, verbose: false
//= require rails.validations
//= require rails.validations.simple_form
//= require ckeditor/init
CODE

append_file 'app/assets/stylesheets/application.css', <<-CODE, verbose: false
body {padding-top: 60px;}
CODE

run 'guard init livereload'

run 'rm -rf app/views/layouts/application.html.erb' # use generated slim version instead
run "rm -rf public/index.html"

environment do
<<-CODE
    config.time_zone = 'Beijing'
    config.i18n.default_locale = 'zh-CN'
    config.generators do |g|
      g.fixture_replacement :factory_girl
    end
CODE
end

environment env: 'development' do
  config.middleware.insert_before(
    ActionDispatch::Static, Rack::LiveReload,
    :min_delay => 500,
    :max_delay => 10000
  )
end

template_file 'app/views/common/_menu.html.slim'
template_file 'app/views/common/_search_form.html.slim'
template_file 'app/views/common/_user_nav.html.slim'
template_file 'app/views/layouts/application.html.slim'
template_file 'app/assets/javascripts/ckeditor/config.js'

generate(:controller, "home index")
route "root :to => 'home#index'"
rake("db:migrate")

git :init
git :add => "."
git :commit => "-a -m 'Initial commit'"
