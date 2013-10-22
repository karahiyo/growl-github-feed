#!/usr/bin/env ruby
# encoding: utf-8

require "growl-github-feed/load"
require "growl-github-feed/master"
require "growl-github-feed/popupper"

GrowlGithubFeed::Master.new.run

