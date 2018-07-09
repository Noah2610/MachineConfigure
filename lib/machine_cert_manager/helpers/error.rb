module MachineCertManager
  module Helpers
    # This helper provides useful error methods,
    # which may abort the script with an error message
    # and a stack traceback.
    module Error
      ERROR_PADDING       = '  '
      STACK_TRACE_SIZE    = 20
      STACK_TRACE_PADDING = 1
      private
        def error *messages
          message = messages.flatten.join(?\n).gsub(/^/, ERROR_PADDING)
          stack_trace = caller[STACK_TRACE_PADDING ... (STACK_TRACE_SIZE + STACK_TRACE_PADDING)].map do |line|
            next "#{ERROR_PADDING}#{line}"
          end .reverse
          abort([
            "#{entry_file.to_path} ERROR:",
            message,
            "#{ERROR_PADDING}Exiting.",
            "Stack traceback (most recent call last):",
            stack_trace
          ].flatten.join(?\n))
        end
    end
  end
end
