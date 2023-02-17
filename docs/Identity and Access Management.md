# Identity and access management (IAM)

This article builds on a number of considerations and recommendations
defined in the Azure landing zone article [<u>Azure landing zone design
area for identity and access
management</u>](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access).
Following the guidance in this article will help you to identify design
considerations and recommendations that relate to identity and access
management specific to the deployment of Azure Integration Services
(AIS). If AIS is deployed to support mission-critical platforms, the
guidance on the Azure landing zone design areas should also be included
in your design.

## IAM Overview

Within the context of this article, Identity and Access Management (IAM)
refers to the authentication and authorization options available for
deploying or maintaining resources within Azure. That is, which
identities have permission to create, update, delete and manage
resources either via the Azure Portal, or via the Resource Manager API
(whether that be via a CLI, or a Deployment engine such as Azure DevOps
or Terraform).

This is separate from endpoint security, which defines which identities
can call into and access your services. Endpoint security is covered in
the separate Security article in this guidance.

It’s important to note that sometimes the two options overlap: for some
services in Azure, access to the endpoint is configured via the same
RBAC controls used to manage access to the resources.

## Design Considerations

- Determine the Azure resource administration boundaries for the
  resources you deploy, considering separation of duties and operational
  efficiency.

- Review the Azure administration and management activities you require
  your teams to perform. Consider the AIS resources you will deploy and
  how you will use them. Determine the best possible distribution of
  responsibilities within your organization.

## Design Recommendations

- Consider what roles you will need to manage and maintain your AIS
  applications – question to ask:

  - Who will need to view log files (*Application Insights*, *Log
    Analytics*, *Storage Accounts*)?

  - Does anyone need to view original request data (including sensitive
    data)?

  - Where can this be viewed from e.g., only from corporate network?

  - Who can view run history for a workflow?

  - Who can resubmit a failed run?

  - Who needs access to API Management subscription keys?

  - Who can view contents of a Service Bus Topic or Subscription, or see
    queue/topic metrics?

  - Who needs to be able to administer Key Vault?

  - Who needs to be able to add, edit, or delete keys, secrets and
    certificates in Key Vault?

  - Who needs to be able to view and read keys, secrets or certificates
    in Key Vault?

  - Will the existing built-in Azure AD roles and groups cover the
    above?

  - Should you create custom roles to either limit access, or to provide
    more granularity over permissions? E.g. to access the Callback URL
    for a Logic App requires a single permission, but there is no
    built-in role for those, other than “Contributor” or “Owner” which
    are too broad.

- Work with the principle of least-privilege (PoLP) and build custom
  roles to limit the permission a given identity has to a resource if no
  built-in role suffices. For example, if an identity should have
  permission to get a Logic App Callback URL, but not to view a Logic
  App, a custom role can be created for this.

- Look at using Azure Policy to restrict access to certain resources, or
  to enforce compliance with company policy. For example, you can create
  a policy that only allows deployment of API Management APIs that use
  encrypted protocols.

- Review common Azure admin activities involved in the administration
  and management of AIS on Azure and assign RBAC permissions
  appropriately (for more detail on the permissions available, see
  [Resource Provider
  Operations](https://learn.microsoft.com/en-us/azure/role-based-access-control/resource-provider-operations)).  
  Some examples include:

<table>
<colgroup>
<col style="width: 18%" />
<col style="width: 32%" />
<col style="width: 49%" />
</colgroup>
<thead>
<tr class="header">
<th>Azure Resource</th>
<th>Azure Resource Provider</th>
<th>Activities</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>App Service Plan</td>
<td>Microsoft.Web/serverfarms</td>
<td>Read, Join, Restart, Get VNet Connections</td>
</tr>
<tr class="even">
<td>API Connection</td>
<td>Microsoft.Web/connections</td>
<td>Update, Confirm</td>
</tr>
<tr class="odd">
<td>Logic Apps and<br />
Functions</td>
<td>Microsoft.Web/sites</td>
<td>Read, Start, Stop, Restart, Swap, Update Config, Read Diagnostics,
Get VNet Connections</td>
</tr>
<tr class="even">
<td>Integration Account</td>
<td>Microsoft.Logic/integrationAccounts</td>
<td>Read/Add/Update/Delete Assemblies, Read/Add/Update/Delete Maps,
Read/Add/Update/Delete Schemas, Read/Add/Update/Delete Agreements,
Read/Add/Update/Delete Partners</td>
</tr>
<tr class="odd">
<td>Service Bus</td>
<td>Microsoft.ServiceBus</td>
<td>Read, Get Connection String, Update DR Config, Read Queues, Read
Topics, Read Subscriptions</td>
</tr>
<tr class="even">
<td>Storage Account</td>
<td>Microsoft.Storage/storageAccounts</td>
<td>Read, Change (for example workflow run history)</td>
</tr>
<tr class="odd">
<td>API Management</td>
<td>Microsoft.ApiManagement</td>
<td>Register/Delete a User, Read APIs, Manage Authorizations, Manage
Cache</td>
</tr>
<tr class="even">
<td>KeyVault</td>
<td>Microsoft.KeyVault/vaults</td>
<td>Create a Vault, Edit Access Policies</td>
</tr>
</tbody>
</table>

## Further Reading

- [Azure Active Directory Identity and access management operations
  reference guide](https://learn.microsoft.com/en-us/azure/active-directory/fundamentals/active-directory-ops-guide-iam)

- [Azure identity and access management design
  area](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access)

- [Azure identity and access for landing
  zones](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones?source=recommendations)

- [Secure access and data in Azure Logic
  Apps](https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-securing-a-logic-app?tabs=azure-portal)

- [Create custom roles in
  Azure](https://learn.microsoft.com/en-us/azure/role-based-access-control/custom-roles)

- [Azure Policy
  Overview](https://learn.microsoft.com/en-us/azure/governance/policy/overview)

- [Tutorial: Build Azure Policies to enforce
  compliance](https://learn.microsoft.com/en-us/azure/governance/policy/tutorials/create-and-manage)
