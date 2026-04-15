locals {
  environment = terraform.workspace == "default" ? "localhost" : terraform.workspace
  web_context = abspath("${path.module}/../src/web")
  api_context = abspath("${path.module}/../src/api")
  db_name     = "lab_db"
  db_user     = "lab_user"
  db_password = "lab_password"

  web_source_hash = sha1(join("", [
    for file in sort(fileset(local.web_context, "**")) :
    filesha256("${local.web_context}/${file}")
  ]))
  api_source_hash = sha1(join("", [
    for file in sort(fileset(local.api_context, "**")) :
    filesha256("${local.api_context}/${file}")
  ]))
}

resource "docker_network" "app" {
  name = "lab-${local.environment}-network"
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

resource "docker_image" "db" {
  name         = "mysql:8.4"
  keep_locally = true
}

resource "docker_container" "db" {
  name  = "db-${local.environment}-01"
  image = docker_image.db.image_id

  env = [
    "MYSQL_DATABASE=${local.db_name}",
    "MYSQL_USER=${local.db_user}",
    "MYSQL_PASSWORD=${local.db_password}",
    "MYSQL_ROOT_PASSWORD=${local.db_password}",
  ]

  ports {
    internal = 3306
    external = var.db_port[local.environment]
  }

  networks_advanced {
    name    = docker_network.app.name
    aliases = ["db"]
  }
}

resource "docker_container" "api" {
  name  = "api-${local.environment}-01"
  image = docker_image.api.image_id

  env = [
    "DB_HOST=db",
    "DB_PORT=3306",
    "DB_NAME=${local.db_name}",
    "DB_USER=${local.db_user}",
    "DB_PASSWORD=${local.db_password}",
  ]

  ports {
    internal = 3000
    external = var.api_port[local.environment]
  }

  networks_advanced {
    name    = docker_network.app.name
    aliases = ["api01"]
  }

  depends_on = [docker_container.db]
}
