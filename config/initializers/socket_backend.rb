class TopicDemo::SocketBackend
  KEEPALIVE_TIME = 15

  @clients = {}
  @clients[:articles] = Hash.new { |h, d| h[d] = [] }
  @clients[:discussions] = Hash.new { |h, d| h[d] = [] }
  def self.clients
    @clients
  end

  def initialize(app)
    @app = app
  end

  def call(env)
    if Faye::WebSocket.websocket?(env)
      env["PATH_INFO"].match(/(?<controller>\w+)\/(?<id>\d+)/) do |path|
        controller = path[:controller].to_sym
        id = path[:id]
        ws = Faye::WebSocket.new(env, nil, {ping: KEEPALIVE_TIME})

        ws.on :open do |event|
          p [:open, ws.object_id]
          # Still need to find a good cleanup method to delete
          # closed websockets from the hashes
          self.class.clients[controller][id].compact!
          self.class.clients[controller][id] << ws
        end

        ws.on :message do |event|
          p [:message, event.data]
        end

        ws.on :close do |event|
          p [:close, ws.object_id]
          ws = nil
        end

        ws.rack_response
      end
    else
      @app.call(env)
    end
  end
end
