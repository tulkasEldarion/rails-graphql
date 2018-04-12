class Error
    def initialize(code, message, reason = nil)
      @error = {
        code: code,
        message: message,
        errors: []
      }

      add_error(reason, message) if reason.present?
    end

    def add_error(reason, message)
      @error[:errors].push(reason: reason, message: message)
    end
  end
