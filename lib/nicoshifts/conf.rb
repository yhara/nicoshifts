require 'pit'

module NicoShifts
  module Conf
    def self.get
      Pit.get("nicovideo.jp", :require => {
        "mail" => "default value",
        "password" => "default value"
      })
    end
  end
end

