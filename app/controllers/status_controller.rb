class StatusController < ApplicationController
  def show
    @pings = Ping.sorted_by_service

    crit = @pings.any? { |x| x.down? and x.critical? }

    if @pings.empty?
      @status = "unknown"
    elsif crit
      @status = "down"
    else
      @status = @pings.any? { |x| x.down? } ? "partial" : "up"
    end
  end
end
