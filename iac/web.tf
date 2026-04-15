locals {
  environment = terraform.workspace == "default" ? "localhost" : terraform.workspace
  web_context = abspath("${path.module}/../src/web")
  api_context = abspath("${path.module}/../src/api")

  web_source_hash = sha1(join("", [
    for file in sort(fileset(local.web_context, "**")) :
    filesha256("${local.web_context}/${file}")
  ]))
  api_source_hash = sha1(join("", [
    for file in sort(fileset(local.api_context, "**")) :
    filesha256("${local.api_context}/${file}")
  ]))
}

resource "docker_image" "web" {
  name         = "lab/web"
  keep_locally = true

  triggers = {
    source_hash = local.web_source_hash
  }

  build {
    context    = local.web_context
    dockerfile = "Dockerfile"
  }
}

resource "docker_container" "web" {
  name  = "web-${local.environment}-01"
  image = docker_image.web.image_id

  ports {
    internal = 80
    external = var.web_port[local.environment]
  }
}

resource "docker_image" "api" {
  name         = "lab/api"
  keep_locally = true

  triggers = {
    source_hash = local.api_source_hash
  }

  build {
    context    = local.api_context
    dockerfile = "Dockerfile"
  }
}

resource "docker_container" "api" {
  name  = "api-${local.environment}-01"
  image = docker_image.api.image_id

  ports {
    internal = 3000
    external = var.api_port[local.environment]
  }
}
