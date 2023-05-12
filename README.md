# Introduction to Azure Integration Services Cloud Adoption Framework

This article series outlines the process for establishing an Azure
Integration Services platform into your organization’s cloud adoption
efforts.

## Executive summary of Azure Integration Services

These articles describe how Azure Integration Services workloads impact
your overall strategy, cloud adoption plan, and environmental readiness
efforts, with detailed guidance on common drift for each effort. This
document highlights important best practices to adopt when provisioning
Azure Integration Services and also provides automation that allows you
to provision Azure Integration Services based upon the best practices
that we outline in this document. To support your cloud adoption needs,
the series also outlines considerations and best practices for managing
governance and operations throughout an Azure Integration Services
implementation.

Azure Integration Services (AIS) is the collective name given to a suite
of related, but separate, resource offerings within Azure, which enable
you to build effective integration solutions.

Those resources include:

- API Management

- Data Factory

- Event Grid

- Event Hubs

- Function Apps

- Logic Apps

- Service Bus

- Storage Accounts

To accelerate these efforts, the articles also include detailed
technical resources that describe how to build an enterprise-scale
landing zone that can support your mission-critical Azure Integration
Services needs.

The enterprise architecture is broken down into six different design areas. You can find the links to each here:
| Design Area|Considerations|Recommendations|
|:--------------:|:--------------:|:--------------:|
| [Identity and Access Management](docs/Identity%20and%20Access%20Management.md)|[Design Considerations](docs/Identity%20and%20Access%20Management.md#design-considerations)|[Design Recommendations](docs/Identity%20and%20Access%20Management.md#design-recommendations)|
| [Network Topology and Connectivity](docs/Network%20Topology%20and%20Connectivity.md)|[Design Considerations](docs/Network%20Topology%20and%20Connectivity.md#design-considerations)|[Design Recommendations](docs/Network%20Topology%20and%20Connectivity.md#design-recommendations)|
| [Security](docs/Security.md)|[Design Considerations](docs/Security.md#design-considerations)|[Design Recommendations](docs/Security.md#design-recommendations)|
| [Management](docs/Management.md)|[Design Considerations](docs/Management.md#design-considerations)|[Design Recommendations](docs/Management.md#design-recommendation)|
| [Governance](docs/Governance.md)|[Design Considerations](docs/Governance.md#design-considerations)|[Design Recommendations](docs/Governance.md#design-recommendations)|
| [Platform Automation and DevOps](docs/Platform%20Automation%20and%20DevOps.md)|[Design Considerations](docs/Platform%20Automation%20and%20DevOps.md#design-considerations)|[Design Recommendations](docs/Platform%20Automation%20and%20DevOps.md#design-recommendations)|
| [Reference Implementation](docs/Reference%20Implementation.md)| | |

## Next Steps to implement the Integration Services Landing Zone Accelerator

Pick one of the scenarios below to get started on a reference implementation.

:arrow_forward: [Scenario 1: Enterprise Deployment of AIS](docs/scenario1/Reference%20Implementation.md)
:arrow_forward: [Scenario 2: Integrating ServiceNow with AIS](docs/scenario2/Reference%20Implementation.md)

---

## Got a feedback

Please leverage issues if you have any feedback or request on how we can improve on this repository.

---
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at https://go.microsoft.com/fwlink/?LinkId=521839. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.

### Telemetry Configuration

Telemetry collection is on by default.

To opt-out, set the variable enableTelemetry to `false` in Bicep/ARM file and disable_terraform_partner_id to `false` on Terraform files.

---

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft 
trademarks or logos is subject to and must follow 
[Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general).
Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship.
Any use of third-party trademarks or logos are subject to those third-party's policies.

