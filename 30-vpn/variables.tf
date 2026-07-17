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
        description = "vpn network"
    }
  
}