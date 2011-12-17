require 'rails'

ActiveRecord::Base.send(:include, MadeByMany::ActsAsRecommendable)


class MadeByMany::Railtie < ::Rails::Railtie

  rake_tasks do
    load File.join(File.dirname(__FILE__), 'tasks', 'acts_as_recommendable_tasks.rake')
    # require File.join(File.dirname(__FILE__), 'tasks', 'acts_as_recommendable_tasks.rake')
  end
end