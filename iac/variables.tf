variable "web_port" {
  type = map(number)

  default = {
    localhost = 4001
    dev       = 5001
  }
}

variable "api_port" {
  type = map(number)

  default = {
    localhost = 4002
    dev       = 5002
  }
}

variable "db_port" {
  type = map(number)

  default = {
    localhost = 4003
    dev       = 5003
  }
}
