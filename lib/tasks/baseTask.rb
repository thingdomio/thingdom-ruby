#
# A psuedo abstract class that provides common functionality for performing Thing tasks.
# These are: retrieving a thing, updating status and sending a feed.
#
class BaseTask

  #
  # Constructor method for base task.  Initialize web service and the thing for which
  # tasks will be performed.
  #
  # @param [WebService] webService A web service to be used by the task.
  # @param [Thing] thing The thing for which the task is being performed.
  # @param [boolean] isThingTask True if the task is retrieving or creating a thing.
  #
  def initialize( webService, thing, isThingTask )
    @web = webService
    @thing = thing
    @isThingTask = isThingTask
  end

  #
  # Perform the task.
  #
  def perform
    response = {}
    #
    # Make sure thing is valid (id and code exists) before doing any work.  The exception of course is if we
    # are creating or retrieving a thing, in which case, id and code will not exist.
    #
    if( (@thing.id.to_s.length > 0 && @thing.code.length > 0) || @isThingTask )
      #
      # Do the task work.  If token has expired, then reauthorize and try again.
      #
      begin
        response = do_task_work()
        if( response[:response] == 'token_expired')
          @web.get_authorization()
          response = do_task_work()
        end
      #
      # On any exception, return an error response with the exception description in the message.
      #
      rescue
        response[:response] = 'error'
        response[:msg] = "#{$!.class} - #{$!.message}"
        @thing.last_error = response[:msg]
      end
    #
    # Thing has not been created.  Return the appropriate error and message.
    #
    else
      response[:response] = 'error'
      response[:msg] = "Thing '#{@thing.name}' has not been created."
    end
    #
    # Return the response.
    #
    return response
  end

  #
  # This method should be overridden by the subclass and does the specific task work.
  #
  def do_task_work
    return { :response => 'error', :msg => 'Task work method not implemented.' }
  end

end