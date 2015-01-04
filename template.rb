# Methods
# ==================================================

# Creating README.md instead of README.rdoc
def rename_readme
  run "rm README.rdoc"
  run "touch README.md"
end

# Creating database
def create_database
  rake "db:create"
end

# 
def generate_basic_controller
  generate :controller, "Pages", "index"
  route "root 'pages#index'"
end

def add_kaminari
  gem "kaminari"
end

def add_redactor
  if yes? "Add redactor-rails?"
    gem 'redactor-rails', github: 'chukcha-wtf/redactor-rails'

    if yes? "Restrict uploading to logged in users?"
      generate "redactor:install --devise"
    else
      generate "redactor:install"
    end

    rake "db:migrate"
  end
end

# Authentication solution for Rails
def add_devise
  gem "devise"
  generate "devise:install"
  model_name = ask "What model name you will be using with Devise?"
  model_name ||= "user"
  generate :devise, "#{model_name.capitalize}"

  if yes? "Add role based authorization?"
    setup_cancan
  end
end

def setup_cancan
  gem "cancancan"
  generate "cancan:ability"
end

def add_adminlte
  if yes? "Add adminlte?"
    where_to = ask "For which layout? (default application)"
    where_to ||= "application"

    gem 'jquery-ui-rails'
    gem "adminlte"

    file "#{where_to}.js", <<-STRING
    //= require jquery-ui/core
    //= require adminlte/bootstrap
    //= require adminlte/app
    STRING

    file "#{where_to}.css", <<-STRING
    *= require AdminLTE
    STRING
  end
end

# Action Mailer mandrill configuration
def config_action_mailer(env)
  environment(nil, env: env) do
    "config.action_mailer.default_url_options = { :host => '#{env == 'production' ? '' : 'localhost:3000'}' }"
    "config.action_mailer.delivery_method = :smtp"
    "config.action_mailer.perform_deliveries = true"
    "config.action_mailer.raise_delivery_errors = #{env == 'production' ? 'false' : 'true'}"
    "config.action_mailer.smtp_settings = {
      :address => \"smtp.mandrillapp.com\" ,
      :port => 587,
      enable_starttls_auto: true,  
      :user_name => '',
      :password => '',
      :authentication => 'login',
      :domain => ''
    }"
  end
end

def create_admin_section
  if yes? "Create admin section?"
    section_name = ask "How would you call it?"
    section_name ||= "Admin"
    section_name = section_name.downcase

    run "cp app/views/layouts/application.html.erb app/views/layouts/#{section_name}.html.erb"
    run "cp app/assets/javascripts/application.js app/assets/javascripts/#{section_name}.js"
    run "cp app/assets/stylesheets/application.css app/assets/stylesheets/#{section_name}.css"
    
    environment(nil, env: "development") do
      "config.assets.paths << Rails.root.join(\"vendor\", \"assets\", \"javascripts\")"
      "config.assets.paths << Rails.root.join(\"vendor\", \"assets\", \"stylesheets\")"
      "config.assets.precompile += %w( #{section_name}.css #{section_name}.js )"
    end

    environment(nil, env: "production") do
      "config.assets.paths << Rails.root.join(\"vendor\", \"assets\", \"javascripts\")"
      "config.assets.paths << Rails.root.join(\"vendor\", \"assets\", \"stylesheets\")"
      "config.assets.precompile += %w( #{section_name}.css #{section_name}.js )"
    end

    generate :controller, "#{section_name}/pages", "index"

    route <<-STRING
    namespace :admin do
      root => 'pages#index'
    end
    STRING

  end
end

def setup_timezone_and_language
  if yes? "Setup timezone and language?"
    default_timezone = ask "Default timezone"
    default_timezone ||= 'Kyiv'
    application "config.time_zone = #{default_timezone}"

    default_locale = ask "Default locale"
    default_locale ||= :en
    application "config..i18n.default_locale = #{default_locale.to_sym}"
  end
end

def add_locales
  if yes? "Would you use ukrainian or russian language in app?"
    lang = ask "Which one will you use 'uk' or 'ru'? (empty for both)"

    case lang
    when 'uk'
      gem 'ukrainian', github: 'igorkasyanchuk/ukrainian'
      run "touch config/locales/uk.yml"
    when 'ru'
      gem 'russian'
      run "touch config/locales/ru.yml"
    else 
      gem 'ukrainian', github: 'igorkasyanchuk/ukrainian'
      gem 'russian'
      run "touch config/locales/uk.yml"
      run "touch config/locales/ru.yml"
    end
  end
end

def add_carrierwave
  if yes? "Add image/document uploader?"
    gem 'carrierwave'
    gem 'mini_magick'
  end
end

def add_gem_groups
  gem 'exception_notification'

  gem_group :development do
    # Rspec for tests (https://github.com/rspec/rspec-rails)
    gem "rspec-rails"
    # Guard for automatically launching your specs when files are modified. (https://github.com/guard/guard-rspec)
    gem "guard-rspec"
  end

  gem_group :test do
    gem "rspec-rails"
    # Capybara for integration testing (https://github.com/jnicklas/capybara)
    gem "capybara"
    gem "capybara-webkit"
    gem "launchy"
    # FactoryGirl instead of Rails fixtures (https://github.com/thoughtbot/factory_girl)
    gem "factory_girl_rails"
    gem "database_cleaner"
  end

  gem_group :production do
    gem "puma"
  end

  gem_group :development, :test do
    gem 'better_errors', '>= 0.2.0'
    gem 'binding_of_caller'
    gem 'meta_request'

    gem 'capistrano', '~> 3.1'
    gem 'capistrano-bundler', '~> 1.1.2'
    gem 'capistrano-rails', '~> 1.1'
    gem 'capistrano-rvm'
    gem 'capistrano-puma', require: false  
    gem 'annotate'
  end

  run "bundle exec cap install"
end

def add_supporting_gems
  gem 'auto_html'
  gem 'acts_as_list'
  gem 'acts-as-taggable-on', '~> 3.4'
  gem "uuidtools"
end

def update_gitignore
  run "cat << EOF >> .gitignore
  /.bundle
  /db/*.sqlite3
  /db/*.sqlite3-journal
  /log/*.log
  /tmp
  database.yml
  secrets.yml
  doc/
  *.swp
  *~
  .project
  .idea
  .secret
  .DS_Store
  /public/system
  /public/uploads
  " 
end

def commit_changes
  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }
end

# ================================================

# Running methods
rename_readme
create_database
generate_basic_controller
add_devise
config_action_mailer('development')
config_action_mailer('production')
add_kaminari
add_supporting_gems
create_admin_section
add_adminlte
setup_timezone_and_language
add_redactor
add_carrierwave
add_locales
add_gem_groups
update_gitignore
commit_changes
