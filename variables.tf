variable "region" {
    type      = string
    default   = "us-east-1"
}

variable "key_name" {
    type      = string
    default   = "my_key"

}

variable "instance_count" {
  default = "2"
}

variable "instance_tags" {
  type = list
  default = ["AppServerInstance", "JenkinsServerInstance"]
}
