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
        description = "alb for bastion instance"
    }
  
}

variable "zone_id" {
    default = "Z05818272ZT7Y387ZB6VY"
}

variable "domain_name" {
    default = "expense94.online"
}