require_relative ( 'baseTask' )

class ThingTask < BaseTask

  def initialize( webService, thing )
    super( webService, thing, true )
    @web = webService
    @thing = @thing
  end

  def do_task_work
    @web.add_thing( @thing )
  end

end