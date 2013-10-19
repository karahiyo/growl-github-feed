require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "GrowlGithubFeed" do
  it "GrowlGithubFeed::Master can start" do
    GrowlGithubFeed::Master.new.start
  end
end
