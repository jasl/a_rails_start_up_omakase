require 'renren'

class XiaoneiHandler
  def initialize(authorization)
    @client = Renren::Base.new(authorization.access_token)
  end

  def post_status(content)
    result = @client.call_method :method => "status.set", :status => content
    if result["result"] == 1
      :success
    else
      case result["error_code"]
        when 202 then :not_allowed
        else :unknown
      end
    end
  end

  def refresh_token
    # NYI
  end

  def verified?
    # NYI
  end
end
