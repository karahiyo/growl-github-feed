
module GrowlGithubFeed 
  class PopUpper

    def initialize
      @g = Growl.new 'localhost', 'GrowlGithubFeeds'
    end

    def notify(title, msg, img=Growl::RUBY_LOGO_PNG)
      require "ruby-growl/ruby_logo"
      @g.add_notification("GrowlGithubFeed Notification",  
                         title, 
                         img)
      @g.notify "GrowlGithubFeed Notification",  "#{title}",  "#{msg}"
    end
  end

end
