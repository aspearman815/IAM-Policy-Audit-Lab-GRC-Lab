package main

deny contains msg if {
  statement := input.resource.aws_iam_policy[_].policy.Statement[_]
  statement.Action == "*"
  msg := "Wildcard action '*' is not allowed."
}

deny contains msg if {
  statement := input.resource.aws_iam_policy[_].policy.Statement[_]
  statement.Resource == "*"
  msg := "Wildcard resource '*' is not allowed."
}
