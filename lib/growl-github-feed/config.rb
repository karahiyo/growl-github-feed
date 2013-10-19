#!/usr/bin/env ruby
# encoding: utf-8

module GrowlGithubFeed
  class Config

    attr_reader :user,  :pass
    
    def initialize
      # set user parameters
      @user = ask("Github user name: ")
      @pass = ask("Github password: ") { |q| q.echo = false }
    end
  end
end
