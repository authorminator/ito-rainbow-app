class PlayersController < ApplicationController
  def create
  end

  def destroy
    player = Player.find(params[:id])
    room = player.room

    unless current_player&.id == player.id
      redirect_to room_path(room.code), alert: 'You can only remove yourself.'
      return
    end

    was_host = room.host_player_id == player.id

    if room.in_round?
      current_round = room.rounds.order(created_at: :desc).first

      if current_round
        current_round.round_assignments
                     .where(player: player, submitted: false)
                     .destroy_all

        current_round.update!(phase: :revealed) if current_round.turn? && current_round.current_assignment.nil?
      end
    end

    player.update!(left_at: Time.current)

    if room.players.active.none?
      session.delete(:player_session_token)

      redirect_to root_path, notice: 'You left the room.'
      return
    end

    if was_host
      new_host = room.players.active.order(:created_at).first
      room.update!(host_player_id: new_host.id) if new_host
    end

    session.delete(:player_session_token)

    redirect_to root_path, notice: 'You left the room.'
  end
end
