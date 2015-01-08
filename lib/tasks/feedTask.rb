require_relative( 'baseTask' )

class FeedTask < BaseTask

  def initialize( webService, thing, category, message, feedOptions )
    super( webService, thing )
    @web = webService
    @thing = thing
    @category = category
    @message = message
    @feedOptions = feedOptions
  end

  def do_task_work
    @web.add_feed( @thing, @category, @message, @feedOptions )
  end

end