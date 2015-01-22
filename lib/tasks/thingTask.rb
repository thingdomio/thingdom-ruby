#
# A class that does the work for creating or retrieving a thing.
#
require_relative ( 'baseTask' )

class ThingTask < BaseTask

  #
  # The constructor method for thing task.
  #
  def initialize( webService, thing )
    super( webService, thing, true )
    @web = webService
    @thing = thing
  end

  #
  # Do the work for the thing task.
  #
  def do_task_work
    @web.add_thing( @thing )
  end

end