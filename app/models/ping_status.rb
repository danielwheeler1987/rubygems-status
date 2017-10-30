class PingStatus
  def initialize(pings)
    @pings = pings
  end

  def call
    return 'unknown' if pings_empty?
    return 'down' if pings_critical?
    pings_down? ? 'partial' : 'up'
  end

  private

  attr_reader :pings

  def pings_empty?
    pings.empty?
  end

  def pings_critical?
    pings.any? { |p| p.down? and p.critical? }
  end

  def pings_down?
    pings.any? { |p| p.down? }
  end
end
