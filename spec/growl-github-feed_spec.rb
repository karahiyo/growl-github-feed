require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "GrowlGithubFeed" do

  it "GrowlGithubFeed::PopUooer can pop-up to local Growl" do
    g = GrowlGithubFeed::PopUpper.new
    g.notify("GrowlGithubFeed",  "Hello World!!")
  end

  it "GrowlGithubFeed::Config" do
    conf = GrowlGithubFeed::Config.new
    conf.user.should_not == nil
    if conf.token == nil
      conf.pass.should_not == nil
    else
      conf.token.should_not == nil
    end
  end

  it "GrowlGithubFeed::Master can get data" do
    require 'growl-github-feed/event'
    master = GrowlGithubFeed::Master.new
    github = master.get_auth
    feeds = github.received_events("#{master.conf.user}")
    events = feeds.map{|r| GrowlGithubFeed::Event.new(r)}
    events.each do |event|
      title, msg, img = master.extract_event_info event
      master.growl.notify(title, msg, img)
    end
  end

  it "GrowlGithubFeed::Master can get data" do
    master = GrowlGithubFeed::Master.new
    github = master.get_auth
    feeds = github.public_events()
    events = feeds.map{|r| GrowlGithubFeed::Event.new(r)}
    events.each do |event|
      title, msg, img = master.extract_event_info event
      master.growl.notify(title, msg, img)
    end
  end

  it "GrowlGithubFeed::Master can get data" do
    master = GrowlGithubFeed::Master.new
    github = master.get_auth
    feeds = github.user_events("#{master.conf.user}")
    events = feeds.map{|r| GrowlGithubFeed::Event.new(r)}
    events.each do |event|
      title, msg, img = master.extract_event_info event
      master.growl.notify(title, msg, img)
    end
  end
end
