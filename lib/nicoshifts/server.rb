require 'hashie/mash'
require 'sinatra/base'

module NicoShifts
  class Server < Sinatra::Base
    configure :development do
      require 'sinatra/reloader'
    end

    set :views, File.expand_path("views", File.dirname(__FILE__))

    get '/' do
      data = Hashie::Mash.new(JSON.parse(File.read(settings.data_path)))
      coms = data.communities

      tag = params[:tag]
      if tag
        coms.select!{|comm|
          comm.tags.include? tag
        }
      end
               
      @lives = coms.map{|comm|
        $nv.live_archives(comm.co) || []
      }.flatten.sort_by{|live| live.started_at}

      slim :index
    end
  end
end
