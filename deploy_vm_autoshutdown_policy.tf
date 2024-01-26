resource "azurerm_policy_definition" "deploy_vm_auto_shutdown" {
  name         = "Deploy Virtual Machine Autoshutdown Schedule"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Deploy Virtual Machine Autoshutdown Schedule"

  metadata = <<METADATA
{
      "version": "1.0.0",
      "category": "Cost Management"
    }

METADATA


  policy_rule = <<POLICY_RULE
{
        "if": {
            "field": "type",
            "equals": "Microsoft.Compute/virtualMachines"
        },
        "then": {
            "effect": "deployIfNotExists",
            "details": {
                "type": "Microsoft.DevTestLab/schedules",
                "existenceCondition": {
                    "allOf": [
                        {
                            "field": "Microsoft.DevTestLab/schedules/taskType",
                            "equals": "ComputeVmShutdownTask"
                        },
                        {
                            "field": "Microsoft.DevTestLab/schedules/targetResourceId",
                            "equals": "[[concat(resourceGroup().id,'/providers/Microsoft.Compute/virtualMachines/',field('name'))]"
                        }
                    ]
                },
                "roleDefinitionIds": [
                    "/providers/microsoft.authorization/roleDefinitions/9980e02c-c2be-4d73-94e8-173b1dc7cf3c"
                ],
                "deployment": {
                    "properties": {
                        "mode": "incremental",
                        "template": {
                            "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
                            "contentVersion": "1.0.0.0",
                            "parameters": {
                                "vmName": {
                                    "type": "string"
                                },
                                "location": {
                                    "type": "string"
                                },
                                "time": {
                                    "type": "string",
                                    "defaultValue": "1900",
                                    "metadata": {
                                        "description": "Daily Scheduled shutdown time. i.e. 2300 = 11:00 PM"
                                    }
                                },
                                "timeZoneId": {
                                    "type": "string",
                                    "defaultValue": "Korea Standard Time",
                                    "metadata": {
                                        "description": "The time zone ID (e.g. Pacific Standard time)."
                                    }
                                },
                                "EnableNotification": {
                                    "type": "string",
                                    "defaultValue": "Enabled",
                                    "metadata": {
                                        "description": "If notifications are enabled for this schedule (i.e. Enabled, Disabled)."
                                    }
                                },
                                "NotificationEmailRecipient": {
                                    "type": "string",
                                    "defaultValue": "",
                                    "metadata": {
                                        "description": "Email address to be used for notification"
                                    }
                                },
                                "NotificationWebhookUrl": {
                                    "type": "string",
                                    "defaultValue": "",
                                    "metadata": {
                                        "description": "A notification will be posted to the specified webhook endpoint when the auto-shutdown is about to happen."
                                    }
                                }
                            },
                            "variables": {},
                            "resources": [
                                {
                                    "name": "[concat('shutdown-computevm-',parameters('vmName'))]",
                                    "type": "Microsoft.DevTestLab/schedules",
                                    "location": "[parameters('location')]",
                                    "apiVersion": "2018-09-15",
                                    "properties": {
                                        "status": "Enabled",
                                        "taskType": "ComputeVmShutdownTask",
                                        "dailyRecurrence": {
                                            "time": "[parameters('time')]"
                                        },
                                        "timeZoneId": "[parameters('timeZoneId')]",
                                        "notificationSettings": {
                                            "status": "[parameters('EnableNotification')]",
                                            "timeInMinutes": 30,
                                            "webhookUrl": "[parameters('NotificationWebhookUrl')]",
                                            "emailRecipient": "[parameters('NotificationEmailRecipient')]",
                                            "notificationvare": "en"
                                        },
                                        "targetResourceId": "[resourceId('Microsoft.Compute/virtualMachines', parameters('vmName'))]"
                                    }
                                }
                            ],
                            "outputs": {
                                "policy": {
                                    "type": "string",
                                    "value": "[concat('Autoshutdown configured for VM', parameters('vmName'))]"
                                }
                            }
                        },
                        "parameters": {
                            "vmName": {
                                "value": "[field('name')]"
                            },
                            "location": {
                                "value": "[field('location')]"
                            },
                            "time": {
                                "value": "[parameters('time')]"
                            },
                            "timeZoneId": {
                                "value": "[parameters('timeZoneId')]"
                            },
                            "EnableNotification": {
                                "value": "[parameters('EnableNotification')]"
                            },
                            "NotificationEmailRecipient": {
                                "value": "[parameters('NotificationEmailRecipient')]"
                            },
                            "NotificationWebhookUrl": {
                                "value": "[parameters('NotificationWebhookUrl')]"
                            }
                        }
                    }
                }
            }
        }
    }
POLICY_RULE


  parameters = <<PARAMETERS
{
        "time": {
            "type": "String",
            "metadata": {
                "displayName": "Scheduled Shutdown Time",
                "description": "Daily Scheduled shutdown time. i.e. 2300 = 11:00 PM"
            },
            "defaultValue": "1900"
        },
        "timeZoneId": {
            "type": "String",
            "defaultValue": "Korea Standard Time",
            "metadata": {
                "displayName": "Time zone",
                "description": "The time zone ID (e.g. Pacific Standard time)."
            }
        },
        "EnableNotification": {
            "type": "String",
            "defaultValue": "Disabled",
            "metadata": {
                "displayName": "Send Notification before auto-shutdown",
                "description": "If notifications are enabled for this schedule (i.e. Enabled, Disabled)."
            },
            "allowedValues": [
                "Disabled",
                "Enabled"
            ]
        },
        "NotificationEmailRecipient": {
            "type": "String",
            "defaultValue": "",
            "metadata": {
                "displayName": "Email Address",
                "description": "Email address to be used for notification"
            }
        },
        "NotificationWebhookUrl": {
            "type": "String",
            "defaultValue": "",
            "metadata": {
                "displayName": "Webhook URL",
                "description": "A notification will be posted to the specified webhook endpoint when the auto-shutdown is about to happen."
            }
        }
    }
PARAMETERS
}