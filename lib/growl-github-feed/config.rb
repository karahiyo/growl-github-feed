#!/usr/bin/env ruby
# encoding: utf-8

module GrowlGithubFeed
  class Config

    attr_reader :user,  :pass,  :org
    
    def initialize
      # set user parameters
      @user = ENV["GITHUB_USER"]
      @pass = ENV["GITHUB_PASS"]
      @org  = ENV["GITHUB_ORG"]
      @user = ask("Github user name: ") if @user.nil?
      @pass = ask("Github password: ") { |q| q.echo = false } if @pass.nil?
      @org = ask("Your organization: ") if @org.nil?
    end
  end
end
