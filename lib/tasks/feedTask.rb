#
# A class that does the work for adding a feed to a thing.
#
require_relative( 'baseTask' )

class FeedTask < BaseTask

  #
  # Constructor method for feed task.  Initialize feed attributes.
  #
  def initialize( webService, thing, category, message, feedOptions )
    super( webService, thing, false )
    @web = webService
    @thing = thing
    @category = category
    @message = message
    @feedOptions = feedOptions
  end

  #
  # Do the work for the feed task.
  #
  def do_task_work
    @web.add_feed( @thing, @category, @message, @feedOptions )
  end

end