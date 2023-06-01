resource "genesyscloud_integration_action" "action" {
    name           = var.action_name
    category       = var.action_category
    integration_id = var.integration_id
    secure         = var.secure_data_action
    
    contract_input  = jsonencode({
        "$schema": "http://json-schema.org/draft-04/schema#",
        "description": "Create a ticket in Zendesk.",
        "properties": {
            "body": {
                "description": "The comment body for the ticket",
                "type": "string"
            },
            "priority": {
                "description": "The priority of the ticket",
                "type": "string"
            },
            "subject": {
                "description": "The subject of the ticket",
                "type": "string"
            }
        },
        "required": [
            "subject",
            "body",
            "priority"
        ],
        "title": "POST TICKET",
        "type": "object"
    })
    contract_output = jsonencode({
        "$schema": "http://json-schema.org/draft-04/schema#",
        "description": "Created a Zendesk ticket",
        "properties": {
            "id": {
                "type": "integer"
            }
        },
        "title": "Ticket",
        "type": "object"
    })
    
    config_request {
        request_template     = "{\r\n  \"ticket\": {\r\n    \"subject\":  \"$${input.subject}\",\r\n    \"comment\":  { \"body\": \"$${input.body}\" },\r\n    \"priority\": \"$${input.priority}\"\r\n  }\r\n}"
        request_type         = "POST"
        request_url_template = "/api/v2/tickets.json"
        headers = {
			UserAgent = "PureCloudIntegrations/1.0"
			Content-Type = "application/json"
		}
    }

    config_response {
        success_template = "$${ticket}"
        translation_map = { 
			ticket = "$.ticket"
		}
    }
}