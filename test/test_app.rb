ENV['RACK_ENV'] = 'test'
require 'minitest_helper'
require 'app'
require 'rack/test'
require 'json'

class TestScheduleMessageBot < MiniTest::Test
  include Rack::Test::Methods

  def app
    MockScheduleMessageBot
  end

  def test_schedule_message_status
    post '/schedule_message', {user_id: "test_user_id", trigger_id: "test_trigger_id"}
    assert last_response.ok?
  end

  def test_result
    post '/result'
    assert last_response.ok?
  end
end

class MockScheduleMessageBot < ScheduleMessageBot
  def initialize
    @client = MockSlackClient.new
  end

  class MockSlackClient
    def dialog_open(dialog: nil, trigger_id: nil)
      JSON.parse(dialog)
      trigger_id ? true : false
    end
  end
end

