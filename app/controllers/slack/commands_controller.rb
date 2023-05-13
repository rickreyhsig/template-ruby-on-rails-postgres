class Slack::CommandsController < ApplicationController
  skip_before_action :verify_authenticity_token

=begin
  PGsql GITPOD |
  https://github.com/gitpod-samples/template-ruby-on-rails-postgres
=end


  def handle_incidents
    if params["text"] == 'declare'
      json = declare
    elsif params["text"] == 'resolve'
      json = resolve
    else
      json = { text: 'Invalid command!'}
      create
    end

    render json: json
  end

  def create_incident
    slack_client ||= Slack::Web::Client.new
    incident = Incident.new(
      title: title, description: description,
      severity: severity, creator: creator,
      status: 'open'
    )

    if incident.save
      channel_name = "incident_#{incident.id}"
      json = { text: 'Incident created!' + channel_name }
      response = slack_client.conversations_create(name:
        channel_name)
      render json: json
    else
      json = { text: 'Incident creation error!', status: :unprocessable_entity}
      render json: json
    end
  end

  private

  def json_payload
    JSON.parse(params['payload'])
  end

  def title
    nested_hash_value(json_payload,'title_input')['value']
  end

  def description
    nested_hash_value(json_payload,'description_input')['value']
  end

  def severity
    nested_hash_value(json_payload,'selected_option')['value']
  end

  def creator
    json_payload['user']['username']
  end

  def declare
    json = {
      "blocks": [
        {
          "type": "divider"
        },
        {
          "type": "input",
          "element": {
            "type": "plain_text_input",
            "action_id": "title_input"
          },
          "label": {
            "type": "plain_text",
            "text": "Title"
          }
        },
        {
          "type": "input",
          "element": {
            "type": "plain_text_input",
            "action_id": "description_input"
          },
          "label": {
            "type": "plain_text",
            "text": "Description"
          }
        },
        {
          "type": "input",
          "element": {
            "type": "static_select",
            "placeholder": {
              "type": "plain_text",
              "text": "Select an item",
              "emoji": true
            },
            "options": [
              {
                "text": {
                  "type": "plain_text",
                  "text": "sev0"
                },
                "value": "sev0"
              },
              {
                "text": {
                  "type": "plain_text",
                  "text": "sev1"
                },
                "value": "sev1"
              },
              {
                "text": {
                  "type": "plain_text",
                  "text": "sev2",
                  "emoji": true
                },
                "value": "sev2"
              }
            ],
            "action_id": "static_select-action"
          },
          "label": {
            "type": "plain_text",
            "text": "Severity",
            "emoji": true
          }
        }
      ]
    }
  end

  def nested_hash_value(obj,key)
    if obj.respond_to?(:key?) && obj.key?(key)
      obj[key]
    elsif obj.respond_to?(:each)
      r = nil
      obj.find{ |*a| r=nested_hash_value(a.last,key) }
      r
    end
  end

  def resolve
    incident_id = params['channel_name'].split('_').last
    incident = Incident.find_by_id(incident_id)

    if incident
      incident.update(status: 'closed')
      json = { text: "Incident #{incident_id} has been resolved!" }
    else
      message = "You are not in an incident channel.  "\
                "This incident channel cannot be resolved!"
      json = { text: message }
    end
  end
end