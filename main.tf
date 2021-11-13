terraform {
  backend "remote" {
    organization = "workshopTF"

    workspaces {
      name = "gmc-project"
    }
  }
}

# from where to allocate resources
provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "kubernetes-admin@kubernetes"
}

resource "kubernetes_deployment" "discord-bot-deployment-tf" {
  metadata {
    name = "discord-bot-deployment"
    labels = {
      app = "discord-bot"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "discord-bot"
      }
    }

    template {
      metadata {
        labels = {
          app = "discord-bot"
        }
      }

      spec {
        container {
          image = "raniakh/discord_bot_quotes:latest"
          name  = "discord-bot"

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          port{
              container_port = "40044"
          }
        }
      }
    }
  }
}
