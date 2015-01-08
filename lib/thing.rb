#
# A class that encapsulates a Thing
#
require_relative( './tasks/statusTask' )
require_relative( './tasks/feedTask' )
require_relative( './tasks/thingTask' )

class Thing
  #
  # Public Properties.
  #
  attr_accessor :id, :name, :product_type, :display_name, :code, :last_error

  #
  # Constructor method for Thing.
  #
  # @param [WebService] webService A web service used to communicate with Thingdom.
  # @param [String] name The name of the Thing.
  # @param [String] productType The product type the Thing belongs to.
  # @param [String] displayName A user friendly name for Thing.
  #
  def initialize( webService, name, productType = '', displayName = '' )
    @web = webService
    @id = ''
    @name = name
    @product_type = productType
    @display_name = displayName
    @code = ''
    #
    # Perform task to get thing.
    #
    thingTask = ThingTask.new( @web, self )
    response = thingTask.perform()
    #
    # If successful, then update the thing id and code.
    #
    if( response[:response] == 'success' )
      @id = response[:thing_id]
      @code = response[:code]
    end
  end

  #
  # Send a feed with additional feed options.
  #
  # @param [String] category A feed category that was defined during application registration.
  # @param [String] message The feed message.
  # @param [FeedOption] feedOptions Additional feed options: icon, progress bar, etc.
  #
  def feed( category, message, feedOptions = nil )
    feedTask = FeedTask.new( @web, self, category, message, feedOptions )
    feedTask.perform()
  end

  #
  # Add or update a status item for this Thing.
  #
  # @param [String] name The status item name.
  # @param [String] value The status item value.
  # @param [String] unit The status item unit.
  #
  def status( *args )
    statusTask = StatusTask.new( @web, self, *args )
    statusTask.perform()
  end


end