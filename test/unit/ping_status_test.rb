require 'test_helper'

class PingStatusTest < ActiveSupport::TestCase

  test 'status is unknown' do
    sorted_pings.expects(:empty?).returns(true)
    status = PingStatus.new(sorted_pings).call
    assert_equal 'unknown', status
  end

  test 'status is down' do
    sorted_pings.first.update status: 'down', critical: true
    status = PingStatus.new(sorted_pings).call
    assert_equal 'down', status
  end

  test 'status is partial' do
    sorted_pings.first.update status: 'down'
    status = PingStatus.new(sorted_pings).call
    assert_equal 'partial', status
  end

  test 'status is up' do
    sorted_pings.first.update status: 'up'
    sorted_pings.last.update status: 'up'
    status = PingStatus.new(sorted_pings).call
    assert_equal 'partial', status
  end

  private

  def sorted_pings
    Ping.sorted_by_service
  end

end
