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
