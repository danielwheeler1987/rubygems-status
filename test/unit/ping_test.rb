require 'test_helper'

class PingTest < ActiveSupport::TestCase
  test "sorted_by_service" do
    Ping.first.update service: "Dependency API"
    Ping.last.update service: "Application"
    sorted_service_results = ['Application', 'Dependency API']
    assert_equal Ping::sorted_by_service.map(&:service), sorted_service_results
  end

  test "unknown?" do
    ping = Ping.new

    assert(ping.unknown?, "should be unknown if last_seen is nil")

    ping.last_seen = Time.now
    assert_equal(ping.unknown?, false, "should be known if last_seen is not nil")
  end

  test "state" do
    ping = Ping.new

    ping.expects(:unknown?).returns(true)
    assert_equal(ping.state, "unknown", "state should be `unknown` when unknown?")

    ping.status = "foo"
    ping.expects(:unknown?).returns(false)
    assert_equal(ping.state, "foo", "state should return status when ping is known")
  end

  test "down?" do
    a = Ping.new
    a.expects(:unknown?).returns(true)
    assert(a.down?, "should be down if unknown?")

    b = Ping.new
    b.expects(:unknown?).returns(false)
    b.expects(:status).returns("down")
    assert(b.down?, "should be down if status is either is true")
  end

  test "up?" do
    a = Ping.new
    a.expects(:unknown?).returns(true)
    assert_equal(a.up?, false, "should be false if not unknown?")

    b = Ping.new
    b.expects(:unknown?).returns(false)
    b.expects(:status).returns(nil)
    assert_equal(b.up?, false, "should be false if status is not up")

    c = Ping.new
    c.expects(:unknown?).returns(false)
    c.expects(:status).returns("up")
    assert(c.up?, "should be true when known and status is `up`")
  end

  test "seconds_ago" do
    time = Time.now
    time_change = 10
    ping = Ping.new

    Timecop.freeze(time) do
      ping.last_seen = Time.now
    end

    Timecop.travel(time + time_change) do
      assert_equal(ping.seconds_ago, time_change, "true")
    end
  end
end
