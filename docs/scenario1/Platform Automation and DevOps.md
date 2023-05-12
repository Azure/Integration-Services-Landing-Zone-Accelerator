# Platform Automation and DevOps

Platform automation and DevOps provide opportunities to modernize your
approach to environmental deployment with *Infrastructure-as-Code* (IaC)
options. Plan for a DevOps and highly automated approach by relying on
automation and general DevOps/DevSecOps best practices.

Broadly speaking, *Platform Automation* is the process of automated
deployment and configuration of Azure platform products such as APIM,
Services Bus, Logic Apps etc., whilst *DevOps* is the automated
deployment of developed artifacts as part of the enterprise solutions
(such as workflows, functions, API’s etc.).

## Design Considerations

### Platform Automation

- Consider the [Azure service
  limitations](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits)
  and [GitHub
  limitations](https://docs.github.com/en/actions/learn-github-actions/usage-limits-billing-and-administration)
  in your continuous integration and continuous delivery (CI/CD)
  environment when determining your engineering and automation approach.

- Platform Automation helps your platform teams adopt key development
  practices that improve their agility and efficiency. Your teams can
  track changes and control which ones move to production by housing
  code in repositories and using version control systems to manage it.

- Consider using [a branching
  strategy](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/development-strategy-development-lifecycle#design-considerations-1)
  that allows teams to collaborate better and efficiently manage version
  control. Adopt a branching strategy which will help you collaborate
  while providing flexibility as well. Keep your strategy simple, use
  short-living feature isolation and allow modifications back to your
  main branch through pull requests with manual and automated code
  analysis.

- Teams should use version control systems and enforce peer review.
  Repositories let your teams define important branches and protect them
  with branch policies. You can use policy to require code changes on
  these branches to meet certain criteria, like a minimum number of team
  member approvals, before they can merge into a protected branch.

- Teams should implement a *Continuous Integration and Continuous
  Delivery* (CI/CD) process. Every code change should automatically
  trigger a CI process that executes static code analysis, validation,
  and test deployments. CI ensures that developers check their code
  early (often referred to as fail fast or shift-left testing) for
  errors that can cause future issues. Once changes are approved and
  merged, the CD process deploys those changes to production. This code
  management system provides your team with a single source of truth for
  what is running in each environment.

- You can use [Azure
  Policies](https://learn.microsoft.com/en-us/azure/governance/policy/overview)
  to add some automation to your platform. Consider using IaC to deploy
  and manage Azure Policies, often referred to as *Policy-as-Code*
  (PaC). These policies let you automate activities like log collection.
  Many PaC frameworks also implement an exemption process, so plan for
  your workload teams to request exemptions from policies.

### DevOps Considerations

- Depending on the network configuration (*Azure Private Link* for
  example), some platform components might not be reachable from the
  public internet and the use of public hosted agents will not work for
  deployments. Plan to use [self-hosted
  agents](https://azure.github.io/AppService/2021/01/04/deploying-to-network-secured-sites.html)
  in that scenario.

- When securing and protecting access to development, test, Q&A, and
  production environments, consider security options from a CI/CD
  perspective. Deployments happen automatically, so map access control
  accordingly.

## Design Recommendations

- Deploy early and often by using trigger-based and scheduled pipelines.
  Trigger-based pipelines ensure changes go through proper validation,
  while scheduled pipelines manage behavior in changing environments.

- Separate infrastructure deployment from application deployment. Core
  infrastructure changes less than applications. Treat each type of
  deployment as a separate flow and pipeline.

- Store secrets and other sensitive artifacts in the relevant secret
  store (e.g., Azure Key Vault or GitHub secrets), allowing actions and
  other workflow parts to read them if needed while executing.

- Make sure that your business logic is checked by unit tests in the
  build pipeline. Use integration tests in the release pipeline to check
  that every service and resource work together after a new release.

- Cover non-functional performance requirements with load tests in your
  staging environment.

- Implement the [4-eyes
  principle](https://www.unido.org/overview/member-states/change-management/faq/what-four-eyes-principle#:~:text=The%20four%2Deyes%20principle%20means,of%20authority%20and%20increase%20transparency.)
  and a process for peer-programming or peer-review to ensure that all
  code changes are reviewed by your team before being deployed to
  production.

- Establish a process for using code to implement quick fixes. Always
  register quick fixes in your team's backlog so each fix can be
  reworked at a later point, and you can limit technical debt.

- Take advantage of specific landing zone accelerator recommendations
  (for example,
  [APIM](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/app-platform/api-management/platform-automation-and-devops#design-recommendations)).

### Platform Automation

Platform Automation should be developed so engineers can eliminate
future toil or technical dept. Most automation involves a percentage of
toil, which is the operational work that is related to a process that is
manual, repetitive, can be automated, and has minimal value. A project's
production velocity will decrease if engineers are continuously
interrupted by manual tasks attributed to toil, either planned or
unplanned.

Platform Automation will

- Ensure repeatability across environments – Ensure that key
  infrastructure component configuration is consistently applied across
  all environments.

- Ensure consistency - The more manual processes are involved, the more
  prone to human error. This can lead to mistakes, oversights, reduction
  of data quality, and reliability problems.

- Centralize mistakes: Choose a platform to allow you to fix bugs in one
  place to fix them everywhere. This reduces the chance of error and the
  possibility of the bug being re-introduced.

- Identify issues quickly: Complex issue may not always be able to be
  identified in a timely manner. However, with good automation,
  detection of these issues should occur quickly.

Platform Automation is required to deliver consistent infrastructure
deployment and configuration.

### Infrastructure deployment

Organizations need to repeatedly deploy their solutions and know that
their infrastructure is in a reliable state. To meet this challenge,
automated deployments use a practice referred to as “[infrastructure as
code](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/infrastructure-as-code)”
(IaC). In code, the infrastructure that needs to be deployed is defined.

Suggested deployment technologies:

- [Azure
  Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/)

- [Azure Resource Manager (ARM)
  templates](https://learn.microsoft.com/en-us/azure/architecture/framework/devops/automation-infrastructure#automate-deployments-with-arm-templates)

- Hashicorp
  [Terraform](https://learn.microsoft.com/en-us/azure/architecture/framework/devops/automation-infrastructure#automate-deployments-with-terraform)  
  Terraform is an open-source IaC (Infrastructure-as-Code) tool for
  provisioning and managing cloud infrastructure.

These technologies use a declarative approach, which defines what the
end infrastructure estate is without having to write the sequence of
programming commands to create it. All AIS products can be deployed in
this way.

### Infrastructure configuration

Infrastructure configuration often varies with different [deployment
environments](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/environments).
To support the same IaC deployment code being used to deploy to all
environments, it should be “environmentalized” using some form of
parameterization, such as:

- Parameter Files –
  [Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/parameters)
  and
  [ARM](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/best-practices#parameters)
  both support executing templates with different parameter files which
  can contain settings per environment.

- Key Vault – should be used for storing [secure
  parameters.](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/key-vault-parameter?tabs=azure-cli)

- [DevOps
  Pipelines](https://learn.microsoft.com/en-us/azure/devops/pipelines/process/variables?view=azure-devops&tabs=yaml%2Cbatch)
  / [GitHub
  Actions](https://docs.github.com/en/actions/learn-github-actions/contexts)
  – Infrastructure deployments will often be automated via your IaC
  repository workflow, and so utilizing the parameterization approach
  for that workflow will bring many benefits.

If you configuration isn’t managed carefully, organizations could
encounter disruptions such as systems outages and security issues.
Optimal configuration can enable you to quickly detect and correct
configurations that could interrupt or slow performance.

## Further Reading

- [Platform
  Automation](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/automation)

- [DevOps
  Considerations](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/devops-principles-and-practices)

- [How Microsoft develops with
  DevOps](https://learn.microsoft.com/en-us/devops/develop/how-microsoft-develops-devops)

- [Security in DevOps
  (DevSecOps)](https://learn.microsoft.com/en-us/devops/operate/security-in-devops)