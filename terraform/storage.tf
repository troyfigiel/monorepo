resource "b2_bucket" "backup" {
  bucket_name = "troyfigiel-backup"
  bucket_type = "allPrivate"
  default_server_side_encryption {
    algorithm = "AES256"
    mode      = "SSE-B2"
  }
  lifecycle_rules {
    # An empty string means this policy should apply to all files.
    # See: https://github.com/Backblaze/terraform-provider-b2/issues/3
    file_name_prefix              = ""
    days_from_hiding_to_deleting  = 30
    days_from_uploading_to_hiding = 0
  }
}
