#!/bin/bash

USER=$1

# Resource Group: Viewer
bx iam user-policy-create $USER --roles Viewer --resource-type resource-group --resource "default"

# Platform Access Roles in the Resource Group: Editor, Viewer
bx iam user-policy-create $USER --roles Editor,Viewer --resource-group-name "default"
