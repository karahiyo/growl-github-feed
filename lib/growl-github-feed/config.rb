#!/usr/bin/env ruby
# encoding: utf-8

module GrowlGithubFeed
  class Config

    attr_reader :user,  :pass
    
    def initialize
      # set user parameters
      @user = ENV["GITHUB_USER"]
      @pass = ENV["GITHUB_PASS"]
      @user = ask("Github user name: ") if @user.nil?
      @pass = ask("Github password: ") { |q| q.echo = false } if @pass.nil?
    end
  end
end
