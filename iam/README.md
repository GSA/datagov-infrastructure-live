# IAM

Manage Data.gov sandbox access through Infrastructure as Code.


## Goals

- Manage IAM users and access using Infrastructure as Code
- Consolidate policy definitions in a single, easy to audit, location
- Manage both human users and machine accounts
- Automatically apply changes through GH workflow


## Features

- Enforce MFA on all human users
- Create machine accounts for continuous deployment
- New users can sign in with temporary password


## Usage


### New users

Add the `aws_iam_user` and `aws_iam_user_group_membership` resources. Make sure
the user is in the `developer` group which enforces MFA.

Apply the changes to create the user.

    $ terraform apply

Log into IAM to enable console access and set a temporary password for the user.

![Screenshot showing how to enable IAM console access](./docs/enable_new_user.png)

At this point, the user can login with the temporary password. They'll have to
set a new password and enable MFA before they can do anything else.

_Note: the new user may have to sign out and back in again._


### Removing a user

Remove the user's `aws_iam_user` and `aws_iam_user_group_membership` resources.
Then apply the changes.

_Note: make sure `force_destroy = true` has been applied prior to removing the
resources. Otherwise you might run into a DeleteConflict with the user's login
profile._
