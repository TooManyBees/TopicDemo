class TopicDemo::SocketBackend
  KEEPALIVE_TIME = 15

  @clients_by_discussion = Hash.new { |h, d| h[d] = [] }
  def self.clients_by_discussion
    @clients_by_discussion
  end

  @clients = []
  def self.clients
    @clients
  end

  def initialize(app)
    @app = app
  end

  def call(env)
    if Faye::WebSocket.websocket?(env)
      # env["PATH_INFO"].match(/discussions\/(?<id>\d+)/) do |path|
        # discussion_id = path[:id]
        ws = Faye::WebSocket.new(env, nil, {ping: KEEPALIVE_TIME})

        ws.on :open do |event|
          p [:open, ws.object_id]
          self.class.clients << ws
          # self.class.clients_by_discussion[discussion_id] << ws
        end

        ws.on :message do |event|
          p [:message, event.data]
        end

        ws.on :close do |event|
          p [:close, ws.object_id]
          self.class.clients.delete(ws)
          ws = nil
        end

        ws.rack_response
      # end
    else
      @app.call(env)
    end
  end
end
