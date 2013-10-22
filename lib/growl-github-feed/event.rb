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

    def user
      content_hash[:actor][:login]
    end

    def user_avatar_id
      content_hash[:actor][:gravatar_id]
    end

    def comment_body
      h = content_hash.attrs
      return nil unless h.key? :payload
      h = h[:payload].attrs
      return nil unless h.key? :comment
      h = h[:comment].attrs
      h[:body]
    end

    private

    def repo_part
      content_hash[:repo]
    end

  end
end
