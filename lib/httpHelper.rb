#
# A class that handles all HTTP communication with Thingdom.
#
require 'rubygems'
require 'net/https'
require 'uri'
require 'json'

class HttpHelper

  # 
  # Constructor method for HttpHelper.  Initialize local data.
  # 
  def initialize()
    @uri = URI.parse 'https://api.thingdom.io'
    @path = '/1.1'
    @request_counter = 0;
  end

  #
  # Perform a HTTP GET request.
  #
  # @param [String] requestPath Contains path and optional query parameters (e.g. path/to/somewhere?param1=1&param2=2)
  # @return [Hash] The request response.
  #
  def get_data( requestPath )
    do_request( requestPath )
  end

  #
  # Perform a HTTP Post request.
  #
  # @param [String] requestPath Contains path to where data will be posted (e.g. path/to/post/endpoint)
  # @param [Hash] data The data to be posted.
  # @return [Hash] The request response.
  #
  def post_data( requestPath, data )
    @request_counter += 1
    data[:counter] = @request_counter
    data[:time] = Time.now.strftime( '%Y/%m/%d %H:%M:%S' )
    do_request( requestPath, data )
  end

  # ***************************************************************************
  # Helper Methods
  # ***************************************************************************
  private

  #
  # Convert JSON string to a hash where all keys are Symbols.
  #
  # @param [String] jsonString The JSON string.
  # @return [Hash] A hash table representation of the JSON string.
  #
  def json_to_hash( jsonString )
    jsonHash = JSON.parse( jsonString )
    jsonHash = Hash[jsonHash.map{ |k, v| [k.to_sym, v] }]
    return jsonHash
  end

  #
  # Perform HTTP request.
  #
  # @param [String] requestPath Contains path to where data will be retrieved or posted (e.g. path/to/post-or-get/endpoint)
  # @param [Hash] data The data to be posted.
  # @return [Hash] The request response.
  #
  def do_request( requestPath, data = nil )
    #
    # Build request and parse JSON response into a hash
    #
    http = Net::HTTP.new( @uri.host, @uri.port )
    if( data.nil? )
      request = Net::HTTP::Get.new( @path + '/' + requestPath )
    else
      request = Net::HTTP::Post.new( @path + '/' + requestPath )
      request.initialize_http_header( {'Content-Type' => 'application/json'} )
      request.body = data.to_json
    end
    #
    # Send request and convert JSON response into a hash.
    #
    response = http.request( request )
    jsonHash = json_to_hash( response.body )
  end

end

