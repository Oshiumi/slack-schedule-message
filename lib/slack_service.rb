require 'slack'
require 'dotenv'

class SlackService
  def initialize
    Dotenv.load
    Slack.configure do |config|
      config.token = ENV['SLACK_API_TOKEN']
    end

    @client = Slack::Web::Client.new
  end

  def post_message(channel: nil, text:)
    @client.chat_postMessage(channel: channel, text: text)
  end

  def dialog_open(dialog: nil, trigger_id: nil)
    return unless dialog
    return unless trigger_id
    res = @client.dialog_open(dialog: dialog.to_json, trigger_id: trigger_id)
    res["ok"]
  end
end
