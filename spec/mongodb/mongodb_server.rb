require "sinatra/base"
require "sinatra/json"
require 'yajl'
require 'rack/session/cookie'

class MongodbServer < Sinatra::Base
  helpers Sinatra::JSON  
# register Sinatra::Synchrony
  use Rack::Session::Cookie, :secret => 'mongodb_session'

  set :json_encoder, Yajl::Encoder

  get "/" do
    Mongoid::Organizational::Sessions.switch_organization(:apple)
    json :order => Order.create(:total => rand(1000))
  end

  post "/organizational/:name" do |name|
    Mongoid::Organizational::Sessions.switch_organization(name)
    puts  "Thread ID: 0x%X" % [Thread.current.object_id]
    sleep rand
    attributes = Order.create(:total => params[:total]).attributes
    hash = attributes.to_hash
    hash.merge!(:database => Order.mongo_session.options[:database], :index => params[:index])
    json :order => hash
  end

  post "orders" do
    params[]
  end

  def self.start_server(queue, retry_count = 3)
    Thread.start do 
      begin
        port = 3100 + rand(1000)
        i ||= 0; i += 1
        queue << port
        puts "try start server with PORT #{port}."
        server = Rack::Server.new(:app => MongodbServer, :Port => port)
        server.start do |s|
          s.threaded = true
        end
      rescue RuntimeError
        retry if i < retry_count
        raise
      end
    end
    sleep 3
  end
end





