variable "project" {
    default = "expense"
  
}

variable "environment" {
    default = "dev"
  
}

variable "common_tags" {
    default = {
        project_name = "expense"
        environment = "dev"
        description = "https_certificate"
    }
  
}

variable "domain_name" {
    default = "expense94.online"
  
}

variable "zone_id" {
    default = "Z05818272ZT7Y387ZB6VY"
}