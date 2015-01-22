#
# A class that does the work for updating the status for a thing.
#
require_relative( 'baseTask' )

class StatusTask < BaseTask

  #
  # Constructor method for status task.  Initialize status update array.
  #
  def initialize( webService, thing, *args )
    super( webService, thing, false )
    @web = webService
    @thing = thing
    @statusUpdates = statusArgsToArray( *args )
  end

  #
  # Do the work for the status task.
  #
  def do_task_work
    @web.add_status( @thing, @statusUpdates )
  end

  # ***************************************************************************
  # Helper methods.
  # ***************************************************************************
  private

  #
  # Convert status args into an array of hashes.
  #
  # @param [Array] *args The status args.
  #
  def statusArgsToArray( *args )
    dataArray = Array.new
    #
    # If only one argument, then assume its already an array.
    #
    if( args.size == 1 )
      dataArray = args[0]
      #
      # Otherwise, take the individual arguments, create a hash and insert into an array.
      #
    elsif( args.size >= 2 )
      data = { :name => args[0], :value => args[1] }
      if( args.size >= 3 )
        data[:unit] = args[2]
      end
      dataArray.push( data )
    end
    #
    # Return the result.
    #
    return dataArray
  end

end