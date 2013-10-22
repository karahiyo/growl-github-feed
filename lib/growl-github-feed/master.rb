#!/usr/bin/env ruby
# encoding: utf-8

require 'growl-github-feed/config'
require 'growl-github-feed/event'

module GrowlGithubFeed
  class Master

    def initialize
      @conf = Config.new
      @growl = GrowlGithubFeed::PopUpper.new
    end

    def start
      feeds = self.get_feeds
      return [] if feeds.empty?
      events = feeds.map{|r| Event.new(r)}
      events.each do |event|
        title, msg, img = self.extract_event_info event
        @growl.notify(title, msg, img)
      end
    end

    def extract_event_info(event)
      title = "#{event.user}"
      title += "@#{event.repo_name}"
      msg = "#{event.comment_body}\n"
      msg += "#{event.created_at}"
      img = event.user_avatar_id
      return title, msg, img
    end

    def get_feeds
      github = get_auth
      github.received_events("#{@conf.user}")
    end

    private

    def get_auth
      Octokit::Client.new(:login => "#{@conf.user}",  :password => "#{@conf.pass}")
    end

  end
end

