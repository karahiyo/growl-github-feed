
module GrowlGithubFeed 
  class PopUpper

    def initialize
      @g = Growl.new 'localhost', 'ruby-growl'
    end

    def notify(main, msg)
      require "ruby-growl/ruby_logo"
      @g.add_notification("GrowlGithubFeed Notification",  
                         "main", 
                         Growl::RUBY_LOGO_PNG)
      @g.notify "GrowlGithubFeed Notification",  "#{main}",  "#{msg}"
    end
  end

end
