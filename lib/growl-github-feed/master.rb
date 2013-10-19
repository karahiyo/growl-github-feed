#!/usr/bin/env ruby
# encoding: utf-8

require 'growl-github-feed/config'

module GrowlGithubFeed
  class Master

    def initialize
      @conf = Config.new
    end

    def start
      user = Octokit::Client.new(:login => "#{@conf.user}", :password => "#{@conf.pass}")
      feeds =  user.public_events
    end
  end
end

