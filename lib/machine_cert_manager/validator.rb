module MachineCertManager
  # This class should validate that dependencies are installed (docker-machine).
  class Validator
    include Helpers::Error
    APPS = [
      'docker-machine'
    ]

    def validate
      APPS.each do |appname|
        validate_app appname
      end
    end

    private

      def validate_app appname
        return  if (available? appname)
        error(
          "`#{appname}' is not available.",
          "Please make sure you have it installed."
        )
      end

      def available? name
        return system("which #{name} &> /dev/null")
      end
  end
end
