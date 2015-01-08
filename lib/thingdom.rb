#
# The top level class that provides the Thingdom API.
#
require_relative 'webService'
require_relative 'thing'

class Thingdom

  def initialize( appSecret )
    #
    # Create the web service.
    #
    @webService = WebService.new( appSecret )
    @applicationToken = ''
    #
    # Authorize the application using the application secret.  If successful, save the application token that
    # is returned for all subsequent communications with Thingdom.  Otherwise, raise an exception using the
    # returned error message.
    #
    response = @webService.get_authorization()
    result = response[:response] != 'error' && !response[:application_token].nil? && response[:application_token].length > 0
    if( result )
      @applicationToken = response[:application_token]
    else
      raise response[:msg]
    end
  end

  def get_thing( name, productType = '', displayName = '' )
    thing = Thing.new( @webService, name, productType, displayName )
    return thing
  end

end
