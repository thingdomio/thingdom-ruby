#
# A class that encapsulates the web services needed by the Ruby wrapper.
#
require_relative 'httpHelper'

class WebService

  #
  # Constructor method for WebService.
  #
  # @param [String] secret A secret identifier for an application obtained by the user during the registration process.
  #                        Without this, the app will not have access to Thingdom.
  #
  def initialize( secret )
    @httpHelper = HttpHelper.new()
    @apiSecret = secret
    @applicationToken = ''
    @deviceSecret = 'none'
  end

  #
  # Ping Thingdom.
  #
  def ping_server()
    @httpHelper.get_data( 'ping' )
  end

  #
  # Authorize this application by sending the application secret to Thingdom.  If valid, Thingdom will send back a token
  # which must be used in subsequent communications.
  #
  # @return [Hash] A hash containing the authorization response:
  #                  application_token - The token used in subsequent communications with Thingdom
  #                  expires_in - The number of seconds remaining before above token expires.
  #                  device_secret - A unique identifier for device running this application
  #                                 (always "none" for the Ruby wrapper)
  #
  def get_authorization()
    data = {
        api_secret: @apiSecret,
        device_secret: @deviceSecret
    }
    response = @httpHelper.post_data( 'token', data )
    response[:device_secret] ||= '';
    @applicationToken = response[:application_token]
    return response
  end

  #
  # Retrieve a thing.  If it doesn't exist, then add it.
  #
  # @param [Thing] thing The thing to get or add.
  #
  def add_thing( thing )
    data = {
               token: @applicationToken,
                name: thing.name,
        display_name: thing.display_name
    }
    if( thing.product_type.length > 0 )
      data[:product_type] = thing.product_type
    end

    @httpHelper.post_data( 'thing', data )
  end

  #
  # Add or update a status item for a thing.
  #
  # @param [Thing] thing The thing to which the status item is attached.
  # @param [Array] statusArray An array of status item updates (name, value, unit).
  #
  def add_status( thing, statusArray )
    data = {
               token: @applicationToken,
            thing_id: thing.id,
                  id: 'null',
        status_array: statusArray
    }
    @httpHelper.post_data( 'status', data )
  end

  #
  # Add a feed message to a thing.
  #
  # @param [Thing] thing The thing to which the feed message is applied.
  # @param [String] category The feed category.
  # @param [String] message The feed message.
  # @param [FeedOption] feedOptions Additional feed options (icon, progress bar, etc)
  #
  def add_feed( thing, category, message, feedOptions  )
    data = {
                token: @applicationToken,
             thing_id: thing.id,
        feed_category: category,
              message: message,
              options: feedOptions
    }
    @httpHelper.post_data( 'feed', data )
  end

end