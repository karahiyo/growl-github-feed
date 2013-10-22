module GrowlGithubFeed 
  class Event
    attr_reader :content_hash
    private :content_hash

    def initialize(content_hash)
      @content_hash = content_hash
    end

    def id
      content_hash[:id]
    end

    def created_at
      content_hash[:created_at]
    end

    def type
      content_hash[:type]
    end

    def repo_id
      repo_part[:id]
    end

    def repo_name
      repo_part[:name]
    end

    private

    def repo_part
      content_hash[:repo]
    end

  end
end
