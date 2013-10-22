require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "GrowlGithubFeed" do
  it "GrowlGithubFeed::Master can start" do
    GrowlGithubFeed::Master.new.execute
  end

  it "GrowlGithubFeed::PopUooer can pop-up to local Growl" do
    g = GrowlGithubFeed::PopUpper.new
    g.notify("test",  "hogehogehoge")
  end
end
