require 'weibo_2'

class WeiboHandler
  def initialize(authorization)
    @client = WeiboOAuth2::Client.new
    @client.get_token_from_hash :access_token => authorization.access_token, :expires_at => authorization.expires_at
  end

  def post_status(content)
    begin
      @client.statuses.update(content)
      :success
    rescue OAuth2::Error
      :error
    end
  end

  # Disabled this for unify interfaces, and there have other ways to goal
  # @param :screen_name <optional> weibo's nickname
  # @param :uid  <optional> weibo's uid
  #def follow(attributes = {})
  #  begin
  #    @client.friendships.create attributes
  #    :success
  #  rescue OAuth2::Error => err
  #    case err.response.parsed["error_code"]
  #      when 20003 then :not_exist
  #      when 20506  then :already_followed
  #      else :unknown
  #    end
  #  end
  #end

  def refresh_token
    # NYI
  end

  def verified?
    # NYI
  end
end
