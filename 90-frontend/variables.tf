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
        description = "frontend"
    }
  
}

variable "domain_name" {
    default = "expense94.online"
  
}