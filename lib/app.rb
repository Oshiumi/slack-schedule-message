require 'sinatra'
require 'sinatra/json'
require 'json'
require 'csv'
require 'redis'
require 'logger'

class ScheduledMessageBot < Sinatra::Base
  configure do
    set :environment, :production
  end

  def initialize
    Slack.configure do |config|
      config.token = ENV['SLACK_API_TOKEN']
    end

    @client = Slack::Web::CLient.new
  end

  post '/scheduled_message' do
    user_id = param[:user_id]
    trigger_id = param[:trigger_id]

    dialog = {
      "title" => "Schedule Message",
      "submit_label" => "Set",
      "callback_id" => "#{user_id}--scheduled-message",
      "elements" => [
        {
          "type" => "text",
          "label" => "Post Date",
          "name" => "post_date"
        },
        {
          "type" => "textarea",
          "label" => "text",
          "name" => "text"
        }
      ]
    }

    @client.dialog_open(dialog: dialog, trigger_id: trigger_id)
  end
end
