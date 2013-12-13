class TopicDemo::SocketBackend
  KEEPALIVE_TIME = 15

  @clients = []
  def self.clients
    @clients
  end

  def initialize(app)
    @app = app
  end

  def call(env)
    if Faye::WebSocket.websocket?(env)
      ws = Faye::WebSocket.new(env, nil, {ping: KEEPALIVE_TIME})

      ws.on :open do |event|
        p [:open, ws.object_id]
        self.class.clients << ws
      end

      ws.on :message do |event|

      end

      ws.on :close do |event|
        p [:close, ws.object_id]
        self.class.clients.delete(ws)
        ws = nil
      end

      ws.rack_response
    else
      @app.call(env)
    end
  end
end
