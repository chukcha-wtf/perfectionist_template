# Rails Startup template

This is a template used for new Ruby on Rails application in [Perfectionist][http://perfectionist.media] team

## How to Use

```bash
rails new [app_name] -m https://raw.github.com/chukcha-wtf/perfectionist_template/master/template.rb
```

## What it does

1. Adds the following gems:
  - [Devise](https://github.com/plataformatec/devise): Devise is a flexible authentication solution for Rails based on Warden.
  - (Optional) [CanCan](https://github.com/ryanb/cancan): CanCan is an authorization library for Ruby on Rails which restricts what resources a given user is allowed to access.
  - (Optional) uuidtools: To generate UUIDs.
  - [rspec-rails](https://github.com/rspec/rspec-rails): Rspec is a testing tool for test-driven and behavior-driven development. It makes writing specs more enjoyable.
  - [guard-rspec](https://github.com/guard/guard-rspec): Guard for automatically launching your specs when files are modified.
  - (test environment) [capybara](https://github.com/jnicklas/capybara): I use Capybara to write integration tests and simulate user behavior.
  - (test environment) [factory_girl_rails](https://github.com/thoughtbot/factory_girl): FactoryGirl provdes a flexible alternative to Rails fixtures. 

2. Optionally installs [AdminLTE template](https://github.com/chukcha-wtf/adminlte).

3. Initializes a new git repository with an initial commit.

4. Optionally create a github repository.
