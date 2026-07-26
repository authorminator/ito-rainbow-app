class RoundsController < ApplicationController
  THEMES = [
    "Scary things",
    "Delicious foods",
    "Strong animals",
    "Embarrassing moments",
    "Painful things",
    "Expensive things",
    "Smelly things",
    "Cute things"
  ].freeze

  def create
    room = Room.includes(:players).find_by!(code: params[:code])

    unless current_player&.id == room.host_player_id
      redirect_to room_path(room.code), alert: "Only the host can start the round." and return
    end

    if room.players.count < 2
      redirect_to room_path(room.code), alert: "At least 2 players are required." and return
    end

    total_cards = room.players.count * room.cards_per_player
    if total_cards > 8
      redirect_to room_path(room.code), alert: "Too many total cards for one round. Reduce cards per player." and return
    end

    ActiveRecord::Base.transaction do
      round = room.rounds.create!(
        theme: THEMES.sample,
        phase: :turn
      )

      secret_numbers = (1..100).to_a.sample(total_cards).shuffle
      turn_positions = (1..total_cards).to_a.shuffle

      assignments = []

      room.players.order(:created_at).each do |player|
        room.cards_per_player.times do
          assignments << {
            player: player,
            secret_number: secret_numbers.pop
          }
        end
      end

      assignments.shuffle!

      assignments.each_with_index do |assignment, index|
        round.round_assignments.create!(
          player: assignment[:player],
          secret_number: assignment[:secret_number],
          clue_text: nil,
          submitted: false,
          turn_position: turn_positions[index],
          display_order: index + 1
        )
      end

      room.update!(status: :in_round)
    end

    redirect_to room_path(room.code), notice: "Round started."
  end

  def submit_clue
  round = Round.find(params[:id])
  room = round.room
  assignment = round.current_assignment

    unless round.turn?
      redirect_to room_path(room.code), alert: "It is not clue submission time." and return
    end

    unless assignment && current_player&.id == assignment.player_id
      redirect_to room_path(room.code), alert: "It is not your turn." and return
    end

    clue_text = params[:clue_text].to_s.strip

    if clue_text.blank?
      redirect_to room_path(room.code), alert: "Clue cannot be blank." and return
    end

    assignment.update!(
      clue_text: clue_text,
      submitted: true
    )

    round.update!(phase: :arranging)

    redirect_to room_path(room.code), notice: "Clue submitted."
  end

  def go_later
    round = Round.find(params[:id])
    room = round.room
    assignment = round.current_assignment

    unless round.turn?
      redirect_to room_path(room.code), alert: "It is not clue submission time." and return
    end

    unless assignment && current_player&.id == assignment.player_id
      redirect_to room_path(room.code), alert: "It is not your turn." and return
    end

    max_position = round.round_assignments.maximum(:turn_position) || 0
    assignment.update!(turn_position: max_position + 1)

    redirect_to room_path(room.code), notice: "Your turn was moved to later."
  end

  def done_arranging
    round = Round.find(params[:id])
    room = round.room

    unless round.arranging?
      redirect_to room_path(room.code), alert: "It is not arranging time." and return
    end

    unless current_player&.id == room.host_player_id
      redirect_to room_path(room.code), alert: "Only the host can do that." and return
    end

    if round.current_assignment.present?
      round.update!(phase: :turn)
    else
      round.update!(phase: :revealed)
    end

    redirect_to room_path(room.code), notice: "Arrangement confirmed."
  end

  def update_order
    round = Round.find(params[:id])
    room = round.room

    unless round.arranging?
      head :unprocessable_entity and return
    end

    unless current_player&.id == room.host_player_id
      head :forbidden and return
    end

    ordered_ids = params[:ordered_ids] || []

    ActiveRecord::Base.transaction do
      ordered_ids.each_with_index do |assignment_id, index|
        round.round_assignments.find(assignment_id).update!(display_order: index + 1)
      end
    end

    head :ok
  end
end
