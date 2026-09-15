# IAM-Policy-Audit-Lab-GRC-Lab
GRC IAM Audit lab using Terraform and Rego focusing on writing "policy as code"

Instructions : https://github.com/Johnbjoseph-cybersec/GRC-Playground/
# Overview
This lab demonstrates how Governance, Risk, and Compliance (GRC) principles can be translated into automated security controls using Infrastructure as Code (IaC) and Policy as Code.
I built and tested a Rego policy using Open Policy Agent (OPA) and Conftest to identify overly permissive AWS IAM policies before they could be deployed.
The scenario focused on detecting IAM policies containing wildcard permissions:
Action: "*" — allows any IAM action
Resource: "*" — applies permissions to all resources
These configurations violate the principle of least privilege and can significantly increase the impact of a compromised account or workload.

# Objective
The goal of this lab was to demonstrate how a GRC/security practitioner can:

- Identify a cloud access-control risk
- Translate a security requirement into a machine-enforceable policy
- Use Rego to define security guardrails
- Test Infrastructure-as-Code configurations with Conftest
- Map technical controls to NIST SP 800-53
- Shift security and compliance validation earlier into the development lifecycle
  
Scenario: The IAM Wildcard Risk
The starting point was an intentionally insecure Terraform IAM policy that grants unrestricted actions against unrestricted resources.

# From a GRC perspective, this creates several risks:
- Violates least-privilege principles
- Increases the potential impact of compromised credentials
- Creates opportunities for privilege escalation
- Allows access to sensitive resources without appropriate scoping
- Makes effective access governance more difficult
  
 # Tools & Technologies

Terraform	- Define the IAM configuration as Infrastructure as Code

Rego - Define security and compliance rules

Open Policy Agent (OPA)	- Policy engine used by Conftest

Conftest - Test configuration files against Rego policies

GitHub Codespaces	- Cloud-based development environment

Git/GitHub - Version control and project documentation

# What Was Built
1. Created an intentionally vulnerable IAM policy
I created a Terraform configuration containing unrestricted IAM permissions using:
Action   = "*"
Resource = "*"

The purpose was to create a known-bad configuration that could be used to validate the effectiveness of the security control.

2. Simulated Terraform output
I created bad-policy.json to represent the IAM policy structure that would be evaluated during policy testing.

3. Developed a Rego security policy
I created iam.rego to identify wildcard IAM permissions.
The policy checks each IAM statement for:
Action == "*"
and:
Resource == "*"
When either condition is detected, Conftest returns a policy violation.
Example findings:
Wildcard action '*' is not allowed.
Wildcard resource '*' is not allowed.

4. Tested the configuration with Conftest
I used Conftest to evaluate the JSON configuration against my Rego policy.
Because my Rego policy was stored in the project root, I explicitly provided the policy path:
conftest test bad-policy.json --policy .
This successfully identified the intentionally vulnerable IAM configuration.

# GRC & Compliance Mapping
The technical control was mapped to relevant NIST SP 800-53 Access Control (AC) requirements.

AC-3 – Access Enforcement
The Rego policy provides an automated mechanism for enforcing defined access-control requirements.

AC-4 – Information Flow Enforcement
Restricting unrestricted access helps prevent uncontrolled access to resources and information.

AC-6 – Least Privilege
The primary security principle demonstrated in this lab is least privilege: users, roles, and workloads should receive only the permissions necessary to perform their functions.

AC-6(1) – Authorize Access to Security Functions
Restricting overly broad permissions helps limit access to security-relevant functions and capabilities.

The broader lesson is that compliance requirements can be translated into automated, testable technical controls rather than relying exclusively on manual review.

# Security Finding
Finding: Overly Permissive IAM Policy

Risk: High

Condition:
Action: "*"
Resource: "*"

Risk Description:
The IAM policy grants unrestricted permissions across AWS resources. If assigned to a compromised user, role, workload, or service account, these permissions could significantly increase the potential blast radius of a security incident.

Recommended Remediation
Replace wildcard permissions with explicitly defined actions and resources.

For example:

Action: "s3:GetObject"
instead of:
Action: "*"
And use a specifically scoped resource ARN instead of:
Resource: "*"

# Policy-as-Code Approach
One of the biggest takeaways from this project was seeing how GRC requirements can be incorporated directly into the development workflow.

This approach helps shift security left by identifying misconfigurations before they reach production.

# Lessons Learned
This lab helped reinforce several concepts at the intersection of GRC and technical security:

- Least privilege is both a security principle and an enforceable technical requirement. 
- GRC controls can be translated into automated policy checks.
- Policy as Code can reduce reliance on manual security reviews.
- IaC provides an opportunity to identify security and compliance issues before deployment.
- Rego provides a flexible way to express organizational security requirements.
- Conftest can be used as a practical validation layer for configuration and IaC.
- Effective GRC requires understanding how policy requirements translate into actual technical controls.
