## Create global account services here.
## This could be the Activity Tracker.

# Stub as example
data "ibm_iam_account_settings" "iam_account_settings" {
}

# The following is not done, but you could provision
# the per-region Activity tracker here. It would serve
# all of your environments.

/* # Create an Activity Tracker instance in this region
resource "ibm_resource_instance" "activity_tracker" {
  name = "activity-tracker-${var.region}"
  service = "logdnaat"
  plan = "lite"
  location = var.region
} */