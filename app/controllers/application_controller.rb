class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def clients(options)
    controller = options.fetch(:controller, :discussions)
    id = options.fetch(:id)
    TopicDemo::SocketBackend.clients[controller][id]
  end
end
