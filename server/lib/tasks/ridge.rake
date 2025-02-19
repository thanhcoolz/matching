# frozen_string_literal: true

namespace :ridge do
desc "Apply database schema allow drop table put ALLOW_DROP_TABLE or allow remove column put ALLOW_REMOVE_COLUMN"
task apply: :environment do
    ridgepole("--apply", "--file #{schema_file}")
    Rake::Task["db:schema:dump"].invoke
end

desc "Export database schema"
task export: :environment do
    ridgepole("--export", "--split --output #{schema_file}")
end

private

def schema_file
    Rails.root.join("db/schemas/Schemafile")
end

def config_file
    Rails.root.join("config/database.yml")
end

def ridgepole_output(*options)
    command = ["bundle exec ridgepole", "--config #{config_file}"]
    puts [command + env_option + options].join(" ")
    #{[command + env_option + options].join(" ")}
end

def ridgepole(*options)
    command = ["bundle exec ridgepole", "--config #{config_file}"]
    puts [command + env_option + options].join(" ")
    system [command + env_option + options].join(" ")
end

def env_option
    op = []
    op << "--env #{ENV['RAILS_ENV']}" if ENV["RAILS_ENV"].present?
    op
end
end