require 'sinatra/base'

module NicoShifts
  class Server < Sinatra::Base
    set :views, File.expand_path("views", File.dirname(__FILE__))

      COMS = {
        "co51402" => %w(puyo), # momoken/tom/squika
        "co15951" => %w(puyo), #plash
        "co238613" => %w(tetris), #beta
        "co1049147" => %w(tetris), #taikai
        "co68895" => %w(), #yuji
        "co163719" => %w(tetris), #benkyou
        "co209209" => %w(tetris), #hebo-mai
        "co534" => %w(), #ruby
        "co66365" => %w(puyo), #live
        "co53180" => %w(puyo), #zyu-den
        "co81436" => %w(puyo), #thomson
        "co238719" => %w(), #algorithmer
        "co150382" => %w(), # リツミサン
        "co426193" => %w(tetris), #ZAB
        "co261174" => %w(puyo), #permil
        "co581029" => %w(puyo), #stily
        "co342288" => %w(puyo), #hiro
        "co1086683" => %w(puyo), #sq-league 2011
        "co117064" => %w(puyo), #reoru
        "co329217" => %w(puyo), #kiu
        "co1059878" => %w(puyo), #saki
        "co1155144" => %w(music), #wan-nyan
        "co443379" => %w(music), #ao-totoro
      }

    get '/' do
      tag = params[:tag]
      if tag
        coms = COMS.keys.find_all{|key|
          COMS[key].include? tag
        }
      else
        coms = COMS.keys
      end
               
      @lives = coms.map{|co|
        $nv.live_archives(co) || []
      }.flatten.sort_by{|co| co.started_at}
      slim :index
    end
  end
end
