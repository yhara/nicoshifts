require 'hashie/mash'
require 'mechanize'

require 'nicoshifts/conf.rb'
require 'nicoshifts/nicovideo.rb'
require 'nicoshifts/server.rb'

module NicoShifts
  class Live < Struct.new(:co, :co_name, :url, :started_at, :talker,
                          :title, :desc, :is_recorded)
    alias recorded? is_recorded
  end
end
