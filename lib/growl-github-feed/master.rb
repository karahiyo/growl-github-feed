#!/usr/bin/env ruby
# encoding: utf-8

require 'growl-github-feed/config'
require 'growl-github-feed/event'

module GrowlGithubFeed
  class Master

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
      github = get_auth
      (1..Float::INFINITY).each do |page|
        feeds = github.received_events("#{@conf.user}",  page: page)
        #feeds = self.get_feeds()
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
            break
          end
        end # /events.each{}
        timestamp = events[0].created_at
        @last_event_time = timestamp
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
      FileUtils.rm @pid_file_path
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

