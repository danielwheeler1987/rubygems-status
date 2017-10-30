class StatusController < ApplicationController
  def show
    @pings = Ping.sorted_by_service
    @status = PingStatus.new(@pings).call
  end
end
