#!/bin/bash

USER=$1
GROUP="Example-Developer-Role"

# Check if the group exist
if ibmcloud iam access-group $GROUP >/dev/null; then
  echo "Role already exists"
else
  # Create the access group for the role if the group does not exist
  ibmcloud iam access-group-create $GROUP --description "used by the multiple-environments-as-code tutorial"

  # Set the permissions for this group
  # Resource Group: Viewer
  ibmcloud iam access-group-policy-create $GROUP --roles Viewer --resource-type resource-group --resource "default"

  # Platform Access Roles in the Resource Group: Viewer
  ibmcloud iam access-group-policy-create $GROUP --roles Viewer --resource-group-name "default"

  # Monitoring: Administrator, Editor, Viewer
  ibmcloud iam access-group-policy-create $GROUP --roles Administrator,Editor,Viewer --service-name monitoring
fi

# Add the user to the group
ibmcloud iam access-group-user-add $GROUP $USER
