provider "kubernetes" {
  config_path = "~/.kube/config"
  
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "null_resource" "kubectl" {
  provisioner "local-exec" {
    command = "aws eks --region ${var.region} update-kubeconfig --name  ${var.env}-${var.cluster_name}-cluster"
  }
  depends_on = [aws_eks_cluster.this]
}

resource "helm_release" "ingress_nginx" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"


  namespace        = var.ingress_nginx_namespace
  create_namespace = true

  timeout = 600

  depends_on = [
    aws_eks_cluster.this,
    null_resource.kubectl
  ]

}

resource "null_resource" "wait_for_ingress_nginx" {
  triggers = {
    key = uuid()
  }

  provisioner "local-exec" {
    command = <<EOF
      printf "\nWaiting for the nginx ingress controller...\n"
      kubectl wait --namespace ${helm_release.ingress_nginx.namespace} \
        --for=condition=ready pod \
        --selector=app.kubernetes.io/component=controller \
        --timeout=200s
    EOF
  }

  depends_on = [helm_release.ingress_nginx]
}