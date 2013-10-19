#!/usr/bin/env ruby
# encoding: utf-8

require "growl-github-feed/load"
require "growl-github-feed/master"

module GrowlGithubFeed
  def run
    Master.new.start
  end
end

