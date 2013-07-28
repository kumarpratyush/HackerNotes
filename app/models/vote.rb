module Vote
  def assign_vote(direction, user)
    username = user.nickname

    if first_vote?(username)
      cast_first_vote(direction, username)
    else
      vote_up(username) if direction == 'up'
      vote_down(username) if direction == 'down'
    end

    self.save
  end

  def first_vote?(username)
    self.votes[username].blank?
  end

  def cast_first_vote(direction, username)
    if direction == 'up'
      self.votes[username] = { points: 1, time: Time.zone.now }
    elsif direction == 'down'
      self.votes[username] = { points: -1, time: Time.zone.now }
    end
  end

  def vote_up(username)
    return if self.votes[username]['points'] == 1

    points = self.votes[username]['points'] + 1
    self.votes[username] = { points: points, time: Time.zone.now }
  end

  def vote_down(username)
    return if self.votes[username]['points'] == -1

    points = self.votes[username]['points'] - 1
    self.votes[username] = { points: points, time: Time.zone.now }
  end

  def votes_count
    self.votes.values.each { |vote| vote['points'] }.reduce(:+)
  end

  def update_votes_count
    self.votes_counter = self.votes_count if self.votes_changed?
  end

end
