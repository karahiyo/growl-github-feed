#!/usr/bin/env ruby
# encoding: utf-8

module GrowlGithubFeed 
  class PopUpper

    def initialize
      @g = Growl.new 'localhost', 'GrowlGithubFeeds'
    end

    def notify(title, msg, img=Growl::RUBY_LOGO_PNG)
      app_name = "GrowlGithubFeed"
      require "ruby-growl/ruby_logo"
      @g.add_notification(app_name, "#{title}", "#{img}")
      @g.notify "#{app_name}",  "#{title}",  "#{msg}"
    end
  end

end
