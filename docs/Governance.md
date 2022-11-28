# Governance

Governance involves making sure any policies you have in place are being
followed, and that you can show your applications are compliant with any
legal, financial, regulatory, or internal requirements. For smaller
applications, this may be a manual process; for larger applications,
automation may be essential. Azure contains several offerings designed
to make the compliance and governance process easier.

Please note that this section delas with the [Control
Plane](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/control-plane-and-data-plane)
only i.e., how we create, manage, and configure the resources in Azure
(generally via the *Azure Resource Manager*). This section does not deal
with governance of the Data Plane (i.e., how the endpoints for your
resources are governed or secured or monitored).

## Design Considerations

- Have you defined the roles and responsibilities for all individuals
  that will interact with your resources?

- If required, have you defined a Disaster Recovery (DR) plan, and do
  you need to automate this (e.g., redundant resources in geographically
  disparate regions).

- Do you have specific *Recovery Time Objective* (RTO) or *Recovery
  Point Objective* (RPO) policies that need to be observed?

- Do you have an alert or escalation plan that needs to be implemented?

- What industry, legal, or financial regulations are your resources
  subject to, and how do you ensure that you are compliant?

- What tooling do you have for managing all your resources? Do you need
  to perform manual remediation, or can you automate this? How are you
  alerted if any part of your estate is not in compliance?

## Design Recommendations

- Use [*Azure
  Policy*](https://learn.microsoft.com/en-us/azure/governance/policy/overview)
  to enforce organizational standards, and help you assess compliance.
  Azure Policy can provide you with an aggregated view, enabling to
  evaluate the overall state of your environment, with the ability to
  drill down to per-resource per-policy granularity. For example, you
  can have policies that look for unauthorized or expensive resources;
  or which look for resources that are provisioned without adequate
  security.

- Automate your deployments using a *Continuous Integration/Continuous
  Deployment* (CI/CD) tool (e.g., Azure DevOps, Terraform). This will
  help ensure that any policies you have in place are followed, without
  the need for manual configuration.

- Use [*Automation
  Tasks*](https://learn.microsoft.com/en-us/azure/logic-apps/create-automation-tasks-azure-resources)
  to automate tasks e.g., to send alerts on weekly or monthly spend on
  resources; or to archive or delete old data. Automation Tasks use
  Logic Apps (Consumption) workflows to achieve this.

- Use [*Role Based Access
  Control*](https://learn.microsoft.com/en-us/azure/role-based-access-control/overview)
  (RBAC) to restrict user and application access to differing levels of
  scope.

- Use *Monitoring Tools* (such as *[Azure
  Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/overview)*
  or Kovai’s *Serverless360*) to identify where resources are either in
  breach of policy, or to identify resources that will breach policy
  soon.

- Enable [*Microsoft Defender for
  Cloud*](https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-cloud-introduction)
  to help identify resources that are in breach of security of endpoint
  policies.

## Further Reading

- What is Azure Policy?

- [Manage Azure resources and monitor costs by creating automation
  tasks](https://learn.microsoft.com/en-us/azure/logic-apps/create-automation-tasks-azure-resources)

- [Azure RBAC
  documentation](https://learn.microsoft.com/en-us/azure/role-based-access-control/)