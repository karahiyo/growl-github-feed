#!/usr/bin/env ruby
# encoding: utf-8

require 'growl-github-feed/config'
require 'growl-github-feed/event'

module GrowlGithubFeed
  class Master

    attr_reader :conf, :growl

    def initialize
      @conf = Config.new
      @growl = GrowlGithubFeed::PopUpper.new
      @last_event_time = Time.now - 24*60*60;

      # daemonize
      @term = false
      @logger = Logger.new("./growl-github-feed.log")
      @logger.info "GrowlGithubFeed daemon start .."
      @pid_file_path = './growl-github-feed.pid'
    end

    def execute
      github = self.get_auth
      loop do
        re_feeds = github.received_events("#{@conf.user}")
        pu_feeds = github.public_events()
        usr_feeds = github.user_events("#{@conf.user}")
        [re_feeds, pu_feeds, usr_feeds].each do |feeds|

          return [] if feeds.empty?
          events = feeds.map{|r| Event.new(r)}
          events.each do |event|
            timestamp = event.created_at
            if @last_event_time < timestamp
              title, msg, img = self.extract_event_info event
              @logger.info "[#{timestamp}]"
              @logger.info "title: #{title}"
              @logger.info "message: #{msg}"
              @growl.notify(title, msg, img)
            else
              next
            end
          end # /events.each{}
        end
        @last_event_time = events[0].created_at
        sleep 10
      end
    end


    ## daemon

    def run
      daemonize
      begin
        Signal.trap(:TERM) { shutdown }
        Signal.trap(:INT) { shutdown }
        execute 
      rescue => ex
        @logger.error ex
      end
    end

    def shutdown
      @term = true
      @logger.info "GrowlGithubFeed close.."
      @logger.close
      #FileUtils.rm @pid_file_path
    end

    def daemonize
      exit!(0) if Process.fork
      Process.setsid
      exit!(0) if Process.fork
      open_pid_file
    end

    def open_pid_file
      begin
        open( @pid_file_path,  'w' ) {|f| f << Process.pid } if @pid_file_path
      rescue => ex
        @logger.error "could not open pid file (#{@pid_file_path})"
        @logger.error "error: #{ex}"
        @logger.error ex.backtrace * "\n"
      end
    end


    ##  utils

    def extract_event_info(event)
      title = "#{event.user}"
      title += "@#{event.repo_name}"
      msg = "#{event.comment_body}\n"
      msg += "#{event.created_at}"
      avatar_id = "#{event.user_avatar_id}"
      img = self.get_img(avatar_id)
      return title, msg, img
    end

    def get_img(user_id)
      return File.open(__DIR__ + "/../appIcons.icns").read if user_id.nil?
      uri = URI("http://www.gravatar.com/avatar/#{user_id}.jpg")
      host = uri.host
      path = uri.path
      http = Net::HTTP.new(host)
      response = http.get(path)
      response.body.to_s.force_encoding("UTF-8")
    end

    def get_auth
      return Octokit::Client.new(:login => "#{@conf.user}",  
                                 :password => "#{@conf.pass}") if @conf.token.nil?

      Octokit::Client.new :access_token => "#{@conf.token}"
    end
  end
end

