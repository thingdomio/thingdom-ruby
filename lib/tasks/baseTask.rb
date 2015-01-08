
class BaseTask

  def initialize( webService, thing )
    @web = webService
    @thing = thing
  end

  #
  # Perform the task.
  #
  def perform
    response = {}
    #
    # Make sure thing is valid (id and code exists) before doing any work.
    #
    if( @thing.id.length > 0 && @thing.code.length > 0 )
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