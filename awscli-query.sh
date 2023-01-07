#!/bin/bash
# The awscli uses JMESPath Query expressions, rather than regex.

#Advanced JMESPath Query - good help and examples here.
# http://jmespath.org/specification.html

#Examples
# List all users, (basic query)
aws iam list-users --output text --query "Users[].UserName"
# List all users, NOT NULL
aws iam list-users --output text --query 'Users[?UserName!=`null`].UserName'
# list users STARTS_WITH "a"
aws iam list-users --output text --query 'Users[?starts_with(UserName, `a`) == `true`].UserName'
# list users CONTAINS "ad"
aws iam list-users --output text --query 'Users[?contains(UserName, `ad`) == `false`].UserName'

# get the latest mysql engine version
aws rds describe-db-engine-versions \
--query 'DBEngineVersions[]|[?contains(Engine, `mysql`) == `true`].[Engine,DBEngineVersionDescription]' \
| sort -r -k 2 | head -1



#############################################################



roles=$(aws iam list-roles --query 'Roles[?starts_with(RoleName, `test`)].RoleName' --output text)

for role in $roles; do
  echo deleting policies for role $role
  policies=$(aws iam list-role-policies --role-name=$role --query PolicyNames --output text)
  for policy in $policies; do 
    echo deleting policy $policy for role $role
    aws iam delete-role-policy --policy-name $policy --role-name $role
  done
  echo deleting role $role
  aws iam delete-role --role-name $role
done
