resource "argocd_repository" "homelab" {
  name            = "homelab"
  repo            = "git@github.com:asosnovsky/homelab.git"
  username        = "git"
  ssh_private_key = var.ssh_key
  insecure        = true
}

resource "argocd_application_set" "apps" {
  metadata {
    name = "apps"
  }
  spec {
    generator {
      git {
        repo_url = argocd_repository.homelab.repo
        revision = "v2"
        file {
          path = "charts/apps/*"
        }
      }
    }
    template {
      metadata {
        name = "apps-{{path.basename}}"
      }

      spec {
        source {
          repo_url        = argocd_repository.homelab.repo
          target_revision = "v2"
          path            = "{{path}}"
        }

        destination {
          server    = "https://kubernetes.default.svc"
          namespace = "{{path.basename}}"
        }
      }
    }
  }
}
