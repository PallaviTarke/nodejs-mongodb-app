variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "us-central1"
}

variable "credentials_file" {
  description = "Path to GCP credentials JSON file"
  type        = string
}

variable "deletion_protection" {
  description = "Enable or disable deletion protection on the GKE cluster"
  type        = bool
  default     = false
}
