#!/usr/bin/env ruby
# encoding: utf-8

require 'growl-github-feed/config'
require 'growl-github-feed/event'

module GrowlGithubFeed
  class Master

    def initialize
      @conf = Config.new
    end

    def start
      github = get_auth
      #feeds =  github.organization_public_events("#{@conf.org}")
      feeds =  github.received_events("#{@conf.user}")
      return [] if feeds.empty?
      events = feeds.map{|r| Event.new(r)}
      events.each do |event|

        p "id: #{event.id}"
        p "time: #{event.created_at}"
        p "type: #{event.type}"
        p "repo_id: #{event.repo_id}"
        p "repo_name: #{event.repo_name}"
        p "user: #{event.user}"
        p "user_avatar_id: #{event.user_avatar_id}"
        p "\n"
      end
    end

    def get_auth
      Octokit::Client.new(:login => "#{@conf.user}",  :password => "#{@conf.pass}")
    end

  end
end

