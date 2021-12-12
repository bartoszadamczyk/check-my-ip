variable "region" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "hosted_zone_id" {
  type = string
}

variable "common_tags" {
  type = map(string)
}
