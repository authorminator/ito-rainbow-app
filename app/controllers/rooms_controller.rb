class RoomsController < ApplicationController
  PLAYER_COLORS = %w[blue green red purple orange teal pink yellow].freeze

  def show
    @room = Room.includes(:players, rounds: :round_assignments).find_by!(code: params[:code])
    @current_round = @room.rounds.order(created_at: :desc).first
  end

  def create
    nickname = params[:nickname].to_s.strip
    cards_per_player = params[:cards_per_player].to_i

    room = Room.new(
      code: generate_room_code,
      status: :lobby,
      cards_per_player: cards_per_player
    )

    redirect_to root_path, alert: "Nickname can't be blank." and return if nickname.blank?

    ActiveRecord::Base.transaction do
      room.save!

      player = room.players.create!(
        nickname: nickname,
        color: PLAYER_COLORS.first,
        session_token: SecureRandom.hex(16)
      )

      room.update!(host_player_id: player.id)

      set_current_player(player)
      redirect_to room_path(room.code), notice: 'Room created.'
    end
  rescue ActiveRecord::RecordInvalid
    redirect_to root_path, alert: 'Could not create room.'
  end

  def join
    room = Room.find_by(code: params[:code])

    redirect_to root_path, alert: 'Room not found.' and return unless room

    nickname = params[:nickname].to_s.strip

    redirect_to root_path, alert: "Nickname can't be blank." and return if nickname.blank?

    redirect_to room_path(room.code) and return if current_player && current_player.room_id == room.id

    next_color = next_available_color(room)

    redirect_to root_path, alert: 'Room is full.' and return if next_color.nil?

    player = room.players.create!(
      nickname: nickname,
      color: next_color,
      session_token: SecureRandom.hex(16)
    )

    set_current_player(player)
    redirect_to room_path(room.code), notice: 'Joined room.'
  rescue ActiveRecord::RecordInvalid
    redirect_to root_path, alert: 'Could not join room.'
  end

  private

  def generate_room_code
    loop do
      code = SecureRandom.alphanumeric(6).upcase
      break code unless Room.exists?(code: code)
    end
  end

  def next_available_color(room)
    used_colors = room.players.pluck(:color)
    PLAYER_COLORS.find { |color| !used_colors.include?(color) }
  end
end
