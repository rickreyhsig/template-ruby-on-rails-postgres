class Slack::CommandsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    json = { text: 'Hello World!!' }
    render json: json
  end

  def handle_incidents
    Rails.logger.info '---HANDLE INCIDENTS---'
    Rails.logger.info params
    if params["text"] == 'declare'
      declare
      return
    elsif params["text"] == 'resolve'
      resolve
      return
    else
      # json = { text: 'Invalid command!'}
      create
      return
    end
  end

  def create_incident
    incident = Incident.new(
      title: title, description: description,
      severity: severity, creator: creator
    )

    if incident.save
      json = { text: 'Incident created!' }
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

  # def incident_params
  #   params.require(:payload)
  #         .permit(:title, :description, :severity, :creator)
  #         .allow(severity: %w[sev0 sev1 sev2])

  # end

  def declare
    Rails.logger.info '---DECLARE---'
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
    Rails.logger.info '---RESOLVE---'
    Rails.logger.info params
  end
end