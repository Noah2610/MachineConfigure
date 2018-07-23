module MachineConfigure
  module Helpers
    # This helper provides useful error methods,
    # which may abort the script with an error message
    # and a stack traceback.
    module Message
      MESSAGE_PADDING      = '  '
      STACK_TRACE_SIZE     = 20
      STACK_TRACE_PADDING  = 1
      @@_error_stack_trace = true

      class << self
        # Disable stack trace output on #error method.
        def error_no_stack_trace!
          @@_error_stack_trace = false
        end

        # Enable stack trace output on #error method,
        # if it was disabled.
        def error_yes_stack_trace!
          @@_error_stack_trace = true
        end
      end

      private

        def error *messages  #:doc:
          message = messages.flatten.join(?\n).gsub(/^/, MESSAGE_PADDING)
          output = [
            "#{_get_message_header} ERROR:",
            message,
            "#{MESSAGE_PADDING}Exiting."
          ]
          if (@@_error_stack_trace)
            stack_trace = caller[STACK_TRACE_PADDING ... (STACK_TRACE_SIZE + STACK_TRACE_PADDING)].map do |line|
              next "#{MESSAGE_PADDING}#{line}"
            end .reverse
            output.unshift([
              "Stack traceback (most recent call last):",
              stack_trace,
            ])
          end
          abort output.flatten.join(?\n)
        end

        def warning *messages  #:doc:
          message = _get_warning_message_from(*messages.flatten)
          puts message
        end

        def warning_print *messages  #:doc:
          message = _get_warning_message_from(*messages.flatten)
          print message
        end

        def message *messages  #:doc:
          message = messages.flatten.join(?\n).gsub(/^/, MESSAGE_PADDING)
          puts([
            "#{_get_message_header}",
            message
          ].flatten.join(?\n))
        end

        def _get_warning_message_from *messages
          message = messages.flatten.join(?\n).gsub(/^/, MESSAGE_PADDING)
          return [
            "#{_get_message_header} WARNING:",
            message
          ].flatten.join(?\n)
        end

        def _get_message_header
          return DIR[:caller].basename
        end
    end
  end
end
