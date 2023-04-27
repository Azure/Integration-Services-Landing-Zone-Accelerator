# Security

Good security is the cornerstone of any Azure application. *Azure
Integration Services* face a particular challenge, as there are many
resources that make up an application; each of these resources has their
own security considerations.

Good security involves many different considerations including (but not
limited to):

- Locking down access to resources (Access Control).

- Encrypting data both in-transit and at-rest.

- Logging all attempts to access resources.

- Auditing access to resources.

As an example:

- Encrypting and restricting access to sensitive data (e.g., passwords
  or certificates).

- Encrypting and restricting stored data (e.g., Personally Identifiable
  Information).

- Restricting access to external endpoints (e.g., using IP Filtering, or
  placing in a VNet).

- Using Managed Identities and an OAuth 2 flow to access Azure
  resources.

With Azure this is also a difference between *Design-Time security*, and
*Run-Time security*:

- *Design-Time* *security* involves access to the management and
  creation of Azure resources e.g., via the portal, or a management API.
  Within Azure, we use AAD and *Role Based Access Control* (RBAC) to
  achieve this.

- *Run-Time security* involves access to endpoints and resources during
  the flow of an application (e.g., authenticating and authorizing a
  user that calls a Logic App, or which calls an operation in API
  Management).

## Design Considerations

- Decide early on if you need

  - *Private Cloud* (all your resources in a Virtual Network, not
    visible/available to the Public Internet, potentially available to
    your on-premises resources via VPN/Express Route).

  - *Public Cloud* (all your resources available to Public Internet,
    although locked to down to restrict access.

  - *Hybrid* (some resources private, some public).

> The choice that you make will affect both the cost of your resources,
> along with how secure your applications will be.

- If you have resources available publicly, look at using DNS
  obfuscation to deter any attackers; obfuscation means either custom
  domain names, or specific Azure resource names that don’t reveal the
  purpose or owner of a resource.

## Design Recommendations

- Where possible, always use *Managed Identities* where a resource needs
  to access a service. For example, if your Logic App workflow needs to
  access Key Vault to retrieve a secret, use the
  [Managed](https://learn.microsoft.com/en-us/azure/logic-apps/create-managed-service-identity)
  Identity of your Logic App to achieve this; Managed Identities provide
  a more security, easier to manage mechanism to access resources, as
  Azure managed the identity on your behalf.

- When storing data (e.g., Azure Storage or Azure SQL Server), always
  enable *Encryption at Rest*. Lock down access to the data, ideally
  only to services and a limited number of administrators. Remember that
  this also applies to Log data as well. For more information, see
  [Azure data encryption at
  rest](https://learn.microsoft.com/en-us/azure/security/fundamentals/encryption-atrest)
  and [Azure encryption
  overview](https://learn.microsoft.com/en-us/azure/security/fundamentals/encryption-overview).

- Always use *Encryption in Transit* (e.g., TLS) when transferring data
  between resources – never send data over an unencrypted channel.

- When using TLS protocols, always use TLS 1.2 or greater.

- Look at the use of an *Application Gateway* (e.g., Azure Application
  Gateway, Azure Front Door) or *Web Application Firewall* (WAF) in
  front of your accessible endpoints; this will help with automatic
  encryption of data and allow you monitor and configure your endpoints
  more easily.

  - [Front
    Door](https://learn.microsoft.com/en-us/azure/frontdoor/front-door-overview)
    is an application delivery network that provides global
    load-balancing and site acceleration service for web applications.
    Front Door offers Layer 7 capabilities like SSL offload, path-based
    routing, fast failover, and caching to improve performance and
    availability of your applications.

  - [Traffic
    Manager](https://learn.microsoft.com/en-us/azure/traffic-manager/traffic-manager-overview)
    is a DNS-based traffic load balancer that lets you distribute
    traffic optimally to services across global Azure regions, while
    providing high availability and responsiveness. Because Traffic
    Manager is a DNS-based load-balancing service, it loads balances
    only at the domain level. For that reason, it can't fail over as
    quickly as Front Door, because of common challenges around DNS
    caching and systems not honoring DNS TTL.

  - [Application
    Gateway](https://learn.microsoft.com/en-us/azure/application-gateway/overview)
    provides a managed application delivery controller with various
    Layer 7 load-balancing capabilities. You can use Application Gateway
    to optimize web-farm productivity by offloading CPU-intensive SSL
    termination to the gateway.

  - [Azure Load
    Balancer](https://learn.microsoft.com/en-us/azure/load-balancer/load-balancer-overview)
    is a high-performance, ultra-low-latency Layer 4 inbound and
    outbound load-balancing service for all UDP and TCP protocols. Load
    Balancer handles millions of requests per second. Load Balancer is
    zone-redundant, ensuring high availability across Availability
    Zones.

- Actively use [*Azure
  Policy*](https://learn.microsoft.com/en-us/azure/governance/policy/overview)
  to look for security issues/flaws e.g., endpoints without IP
  Filtering.

- Where available, use [*Microsoft Defender for
  Cloud*](https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-cloud-introduction)
  to scan your resources and identify potential weaknesses.

- Keep secrets in [*Azure Key
  Vault*](https://learn.microsoft.com/en-us/azure/key-vault/general/basic-concepts),
  and then link these to *App Settings* (Functions, Logic Apps), *Named
  Values* (API Management), or *Configuration Entries* (App
  Configuration).

- Use *OAuth 2.0* as the authentication mechanism between resource
  endpoints:

  - In Logic Apps or Functions, enable Easy Auth, which requires all
    external callers to use an OAuth identity (usually AAD, but could be
    any Identity Provider).

  - In API Management, use the *jwt-validation* policy element to
    require an OAuth flow for connections to endpoints.

  - In Azure Storage and Key Vault, setup Access Policies to restrict
    access to specific identities.

- Use *IP Filtering* to lock down your endpoints so they can only be
  accessed by known network addresses.

- Always follow the principal of *least privilege* when assigning
  access: give an identity the minimum permissions it needs. Sometimes
  this will involve creating custom AAD role, if there isn’t a built-in
  role with the minimal permissions you need, then consider creating a
  custom role with just these permissions.

- Use automated deployment to configure security. Where possible, use a
  CI/CD pipeline (Azure DevOps, Terraform, Octopus, etc.) to not only
  deploy your resources, but also to configure security. This ensures
  your resources will be automatically protected whenever they are
  deployed.

- Regularly review audit logs (ideally using an automated tool) to
  identify both security attacks, and any unauthorized access to your
  resources.

- Look at the use of PEN (penetration) testing, to identify any
  weaknesses in your security design.

## Further Reading

- What is Microsoft Defender for Cloud?

- [What are managed identities for Azure
  resources?](https://learn.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/overview)

- [Authenticate access to Azure resources with managed identities in
  Azure Logic
  Apps](https://learn.microsoft.com/en-us/azure/logic-apps/create-managed-service-identity?tabs=standard)

- [Security considerations for data movement in Azure Data
  Factory](https://learn.microsoft.com/en-us/azure/data-factory/data-movement-security-considerations)

- [Trigger workflows in Standard logic apps with Easy
  Auth](https://techcommunity.microsoft.com/t5/integrations-on-azure-blog/trigger-workflows-in-standard-logic-apps-with-easy-auth/ba-p/3207378)

- [Protect an API in Azure API Management using OAuth 2.0 authorization
  with Azure Active
  Directory](https://learn.microsoft.com/en-us/azure/api-management/api-management-howto-protect-backend-with-aad)

- [Azure Key Vault
  security](https://learn.microsoft.com/en-us/azure/key-vault/general/security-features)

- [Storage Accounts and
  security](https://learn.microsoft.com/en-us/azure/architecture/framework/services/storage/storage-accounts/security)