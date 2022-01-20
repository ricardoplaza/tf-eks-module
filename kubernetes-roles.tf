### DEV ROLES ###

resource "kubernetes_role" "eks-developers-role" {
  metadata {
    name = "eks-dev-role"
    namespace = "ricardoplaza"
  }

  rule {
    api_groups = ["", "extensions", "apps", "batch", "autoscaling", "scaling.k8s.restdev.com", "cronjobber.hidde.co", "policy"]
    resources  = ["namespaces", "deployments", "replicasets", "pods", "pods/log", "services", "ingresses", "configmaps", "cronjobs", "tzcronjobs", "jobs", "horizontalpodautoscalers", "endpoints", "schedulerscalers", "statefulsets", "poddisruptionbudgets", "pods/portforward", "pods/exec"]
    verbs      = ["*"]
  }

  depends_on = [module.eks]
}

resource "kubernetes_role_binding" "eks-developers-role-binding" {
  metadata {
    name      = "eks-developers-role-binding"
    namespace = "ricardoplaza"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "eks-developers-role"
  }
  subject {
    kind      = "User"
    name      = "eks-developers"
    api_group = "rbac.authorization.k8s.io"
  }

  depends_on = [module.eks]
}

### List Namespaces - Must be ClusterRole ###

resource "kubernetes_cluster_role" "eks-dev-ns-role" {
  metadata {
    name = "eks-developers-role"
  }

  rule {
    api_groups = [""]
    resources  = ["namespaces"]
    verbs      = ["get", "list", "watch"]
  }

  depends_on = [module.eks]
}

resource "kubernetes_cluster_role_binding" "eks-dev-ns-role-binding" {
  metadata {
    name      = "eks-developers-role-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "eks-dev-role"
  }
  subject {
    kind      = "User"
    name      = "eks-developers"
    api_group = "rbac.authorization.k8s.io"
  }

  depends_on = [module.eks]
}