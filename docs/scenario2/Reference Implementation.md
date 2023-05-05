## Reference Implementation - Scenario 2

This reference implementation shows how to integrate [ServiceNow](https://www.servicenow.com/) with an Azure automation system built on [Service Bus](https://learn.microsoft.com/en-us/azure/service-bus-messaging/service-bus-messaging-overview) and [Azure Functions](https://learn.microsoft.com/en-us/azure/azure-functions/functions-overview).

In this example, the team had an existing PowerShell script that would interact with their Teams environment via the [Teams cmdlets](). This was run manually each time a ServiceNow ticket was received. The team wanted to automate this process, so that the PowerShell script would be run automatically whenever a new ServiceNow ticket was received.

### Architecture

![architecture](./media/architecture.png)

Deploy this automation with 1 step.

[<img src="./media/deployToAzureButton.png" style="width:1.73958in;height:0.35417in"
alt="Image is a button that, when clicked, starts a Deploy to Azure process to deploy the templates to Azure." />](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FIntegration-Services-Landing-Zone-Accelerator%2Fmain%2Fsrc%2Finfra%2Fscenario2%2F/bicep/%2Fias.template.json)

### Design Principles

- **Automate everything** - The team wanted to automate the entire process, so that the PowerShell script would be run automatically whenever a new ServiceNow ticket was received.
- **Generic, repeatable frontend design** - The team wanted a generic design that could be used for other integrations in the future. ServiceNow has forms for many different IT processes and wanted a generic way to call backend automations written by different teams without having to re-invent the integration each time.
- **Generic, repeatable backend design** - The team(s) that build backend automations want a platform that can run their code using whatever language it is already written in (PowerShell, Python, C#, Java, etc) and a generic way to receive requests to execute their code & a generic way to respond to the frontend.
- **Secure** - The team wanted to ensure that the solution was secure, and that only authorized users could call the backend automations. They also wanted private networking wherever possible.
- **Cost effective** - The team wanted to ensure that the solution was cost effective, and that they were only paying for the resources they needed.

### Azure services

- [Functions](https://learn.microsoft.com/en-us/azure/azure-functions/functions-overview)
- [Service Bus](https://learn.microsoft.com/en-us/azure/service-bus-messaging/service-bus-messaging-overview)
- [Key Vault](https://learn.microsoft.com/en-us/azure/key-vault/key-vault-overview)
- [Log Analytics & App Insights](https://docs.microsoft.com/en-us/azure/azure-monitor/overview)
- [Storage Account](https://docs.microsoft.com/en-us/azure/storage/common/storage-account-overview)
- [Managed Identity](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/overview)
- [Azure DevOps YAML pipelines](https://docs.microsoft.com/en-us/azure/devops/pipelines/get-started/key-pipelines-concepts?view=azure-devops)

### Additional Considerations & reasons for Service Bus

ServiceNow, by default, expects a call to an external API to return within 30 seconds ([glide.http.outbound.max_timeout](https://docs.servicenow.com/bundle/tokyo-api-reference/page/integrate/web-services/reference/r_HTTPConnectionManagementProps.html)). In this example, some of the operations from the Teams API may take longer than 30 seconds to run (such as provisioning phone numbers in certain countries). Therefore, we need to ensure that there is a broker in between the ServiceNow frontend & the backend Azure Function. 

Therefore, ServiceNow will authenticate using an Azure AD [Service Principal](https://learn.microsoft.com/en-us/azure/active-directory/develop/app-objects-and-service-principals#service-principal-object) and send a message to a [Service Bus topic](https://learn.microsoft.com/en-us/azure/service-bus-messaging/service-bus-queues-topics-subscriptions#topics-and-subscriptions). The Azure Function will then run the PowerShell script, using the data passed in from ServiceNow in the message body.

We also need a way to generically respond to ServiceNow when a message is complete. In this example, the Azure Function that runs the PowerShell script will respond back ServiceNow using a different topic `callback`. Another Azure Function is listening to this topic, and will respond back to ServiceNow with the result of the operation (using the `clientCallback.uri` field received in the initial topic message. ServiceNow generates a [unique URI](https://docs.servicenow.com/bundle/utah-integrate-applications/page/administer/integrationhub-store-spokes/task/govnotify-wbhk.html) for each request, and expects the response to be sent back to this URI

### Azure Active Directory

When the script was being run locally, it used the identity of the person running it to call the Teams API. However, when the Function run in Azure, it needs its own identity. This identity is an Azure AD Service Principal. This identity will have a set of scopes (API permissions) assigned to it so that it can call the Teams API in a similar fashion to the original script.

In addition, while ServiceNow could authenticate with the Service Bus using a [SAS token](https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-sas#shared-access-signature-authentication), it is preferred to use AAD authentication to protect the Service Bus. Therefore, ServiceNow will need to use [OAuth 2.0 authentication](https://docs.servicenow.com/bundle/tokyo-api-reference/page/integrate/outbound-rest/task/t_ConfigureARESTMessageWithOAuth-1.html) in order to get an access token that is valid for the Service Bus. In addition, this service principal needs to be granted RBAC (role-based access control) permissions to the Service Bus so that Service Now (running as the service principal identity) can post messages.