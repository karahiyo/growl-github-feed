#!/usr/bin/env ruby
# encoding: utf-8

module GrowlGithubFeed
  class Config

    attr_reader :user, :pass, :token
    
    def initialize
      # set user parameters
      local_user = ENV["USER"]
      config = ParseConfig.new("/Users/#{local_user}/.gitconfig")
      @user = config['github']['user']
      @token= config['github']['token']
      @user = ask("Github user name: ") if @user.nil?
      @pass = ask("Github password: ") { |q| q.echo = false } if @token.nil?
    end
  end
end
