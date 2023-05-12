class Slack::CommandsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    json = { text: 'Hello World!!' }
    render json: json
  end

  def handle_incidents
    Rails.logger.info '------'
    Rails.logger.info params
    if params["text"] == 'declare'
    json = declare
    Rails.logger.info '------'
    Rails.logger.info json

    elsif params["text"] == 'resolve'
      json = resolve
    else
      json = { text: 'Invalid command!'}
    end

    render json: json
  end

  def create_incident
    Rails.logger.info '---CREATE INCIDENT---'
    Rails.logger.info params
    Rails.logger.info params['payload']
    title = params['payload']['state']['title_input']['value']
    description = params['payload']['state']['description_input']['value']
    severity = params['payload']['actions'][0]['selected_option']['text']
    creator = params['payload']['user']['username']
    #Rails.logger.info payload
    Rails.logger.info title
    Rails.logger.info description
    Rails.logger.info severity
    Rails.logger.info creator
    # incident = Incident.new(incident_params)

    # respond_to do |format|
    #   if incident.save
    #     format.json { render json: incident, status: :created, location: incident }
    #   else
    #     format.json { render json: incident.errors, status: :unprocessable_entity }
    #   end
    # end 
  end

  private

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

  def resolve
    Rails.logger.info '---RESOLVE---'
    Rails.logger.info params
  end
end