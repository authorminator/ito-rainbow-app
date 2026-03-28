class ApplicationController < ActionController::Base
  helper_method :current_player

  private

  def current_player
    return nil unless session[:player_session_token]

    @current_player ||= Player.find_by(session_token: session[:player_session_token])
  end

  def set_current_player(player)
    session[:player_session_token] = player.session_token
  end
end
