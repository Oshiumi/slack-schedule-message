require 'sinatra/base'
require 'dotenv'
require 'slack-ruby-client'
require 'json'
require 'time'

class ScheduleMessageBot < Sinatra::Base
  configure do
    set :environment, :production
  end

  def initialize
    Dotenv.load

    Slack.configure do |config|
      config.token = ENV['SLACK_API_TOKEN']
    end

    @client = Slack::Web::Client.new
  end

  post '/schedule_message' do
    p params
    user_id = params[:user_id]
    trigger_id = params[:trigger_id]

    dialog = {
      "title" => "Schedule Message",
      "submit_label" => "Set",
      "callback_id" => "#{user_id}--scheduled-message",
      "elements" => [
        {
          "type" => "select",
          "label" => "Channel",
          "name" => "channel",
          "data_source" => "channels"
        },
        {
          "type" => "text",
          "label" => "Date",
          "name" => "post_date",
          "hint" => "YYYY/MM/DD hh:mm:ss"
        },
        {
          "type" => "textarea",
          "label" => "Text",
          "name" => "text"
        }
      ]
    }

    puts dialog, trigger_id
    ok = @client.dialog_open(dialog: dialog.to_json, trigger_id: trigger_id)

    if ok
      ""
    else
      "Oops...\n Schedule message is failed.\n Please contact Schedule Message maintainer."
    end
  end

  post '/result' do
    p params
    p json = JSON.parse(params[:payload])["submission"]
    channel_id = json["channel"]
    date = Time.parse(json["post_date"]).strftime("%H:%M %m%d%Y")
    text = json["text"]
    `echo 'bundle ex ruby -e "require \"./lib/slack_service.rb\";SlackService.new.post_message(channel: \"#{channel_id}\", text: \"#{text}\")"' | at #{date}`
    "ok"
  end

  get '/' do
    'hello'
  end
end
