/**************************************************
Read gcp-lob-organization module state
**************************************************/
data "terraform_remote_state" "lob" {
  backend = "remote"
  config = {
    organization = "levi"

    workspaces = {
      name = "CPET-GCP-GC1-AI-ORG"
    }
  }
}

data "terraform_remote_state" "monitoring_project" {
  backend = "remote"
  config = {
    organization = "levi"

    workspaces = {
      name = "gmap-gcp-aimonitoring-prod-main-prod"
    }
  }
}

// GKE management from platform project
data "terraform_remote_state" "platform_project" {
  backend = "remote"
  config = {
    organization = "levi"

    workspaces = {
      name = "gmap-gcp-platform-nonprod-main-hle-gc1"
    }
  }
}

locals {
  master_authorized_networks = concat(
    var.master_authorized_networks,
    data.terraform_remote_state.platform_project.outputs.platform_subnets
  )
}

locals {
  folder_id       = data.terraform_remote_state.lob.outputs.lob_subfolders[var.folder_name]
  host_project_id = data.terraform_remote_state.lob.outputs.host_projects[var.host_project_name].project_id
  vpc             = data.terraform_remote_state.lob.outputs.host_projects[var.host_project_name].shared_vpc_map[var.shared_vpc_name]
  // Generate shared_vpc_subnets for project module. Module dynamically generate resources google_compute_subnetwork_iam_member
  // for shared vpc. Terraform can't perform plan and apply, if the list is not defined at the execution time
  // shared_vpc_subnets      = [ module.subnets.subnets.dataocean1.self_link ] raise error (The "count" value depends on resource attributes that cannot be determined)
  shared_vpc_subnets = [
    for subnet_name, subnet_value in var.subnets :
    "projects/${local.host_project_id}/regions/${subnet_value.region}/subnetworks/${var.host_project_name}-snet-${module.locations.region_codes[subnet_value.region]}-${subnet_name}"
  ]
  data_access_logs_bucket_id = data.terraform_remote_state.monitoring_project.outputs.data_access_logs_bucket.id
  gke_logs_bucket_id         = data.terraform_remote_state.monitoring_project.outputs.gke_logs_bucket.id
  audit_bucket_id            = data.terraform_remote_state.monitoring_project.outputs.audit_buckets[var.environment_short_name].bucket.id
  monitoring_project_id      = data.terraform_remote_state.monitoring_project.outputs.project_id
  prefix                     = var.service_account_prefix != "" ? "${var.service_account_prefix}-" : ""
  service_accounts_list      = [for name in var.service_account_names : google_service_account.service_accounts[name]]
  emails_list                = [for account in local.service_accounts_list : account.email]
  iam_emails_list            = [for email in local.emails_list : "serviceAccount:${email}"]
  names                      = toset(var.service_account_names)
}

module "locations" {
  source  = "app.terraform.io/levi/gcp-locations/google"
  version = "0.0.1"
}

/***********************************************
Create project
***********************************************/

module "project" {
  source               = "terraform-google-modules/project-factory/google"
  version              = "14.5.0"
  name                 = var.project_name
  random_project_id    = false
  org_id               = var.org_id
  folder_id            = local.folder_id
  billing_account      = var.billing_account
  labels               = var.labels
  create_project_sa    = false
  svpc_host_project_id = local.host_project_id

  shared_vpc_subnets = local.shared_vpc_subnets

  activate_apis = var.project_activate_apis

  depends_on = [
    module.subnets
  ]
}

module "subnets" {
  source            = "app.terraform.io/levi/gcp-subnetworks/google"
  version           = "2.0.1"
  host_project_name = var.host_project_name
  host_project_id   = local.host_project_id
  vpc               = local.vpc
  subnets           = var.subnets
  secondary_ranges  = var.secondary_ranges
}

/***********************************************
Create firewall rules
***********************************************/
module "firewall_rules" {
  source       = "app.terraform.io/levi/gcp-fw-rules/google"
  version      = "1.0.1"
  project_name = var.host_project_name
  project_id   = local.host_project_id
  network_name = local.vpc

  rules = var.rules

  depends_on = [module.subnets]
}

/**********************************************
Create service Accounts
***********************************************/
resource "google_service_account" "service_accounts" {
  for_each     = local.names
  account_id   = "${local.prefix}${lower(each.value)}"
  display_name = "${local.prefix}${lower(each.value)}"
  description  = index(var.service_account_names, each.value) >= length(var.descriptions) ? var.description : element(var.descriptions, index(var.service_account_names, each.value))
  project      = module.project.project_id

  depends_on = [
    module.project
  ]
}

/***********************************************
Grant IAM roles
***********************************************/

module "project-iam-bindings" {
  source  = "terraform-google-modules/iam/google//modules/projects_iam"
  version = "7.7.1"

  projects = [module.project.project_id]
  mode     = "additive"
  bindings = var.project_iam_bindings

  depends_on = [
    module.project,
    google_service_account.service_accounts
  ]
}

/***************************************************************************************************************
Compute Instance : GDO-8172
****************************************************************************************************************/


module "genai-search" {
  source  = "app.terraform.io/levi/gcp-rhel-coe/google"
  version = "2.0.4"

  project_name     = module.project.project_name
  project_id       = module.project.project_id
  region           = var.region
  zone             = var.zone
  rhel_version     = var.genai_host_vm_rhel_version
  long_name        = "genai-search"
  app_name         = "genai"
  id_number        = "01"
  labels           = merge(var.labels)
  preemptible      = false
  tags             = ["genai"]
  machine_type     = var.genai_machine_type
  startup_script   = var.startup_script
  subnet_self_link = module.subnets.subnets.genai.self_link
  awx_token        = var.awx_token
  scopes           = var.service_account_scopes
  service_acct     = "svc-genai@${module.project.project_id}.iam.gserviceaccount.com"
  depends_on = [
    google_service_account.service_accounts,
    module.project
  ]
}


module "pubsub" {
  source  = "terraform-google-modules/pubsub/google"
  version = "~> 6.0"

  topic        = "${module.project.project_name}-pub-gcp-notifications"
  project_id   = module.project.project_id
  topic_labels = merge(var.labels)

  depends_on = [
    module.project
  ]
}

resource "google_project_iam_member" "gke_container_engine_robot_sa_roles" {
  for_each = toset(var.gke_container_engine_robot_sa_roles)

  project = module.project.project_id
  role    = "roles/${each.value}"
  member  = "serviceAccount:service-${module.project.project_number}@container-engine-robot.iam.gserviceaccount.com"

  depends_on = [
    module.project
  ]

}

#################################### DO NOT DELETE THE BELOW LINES ##################################
# /*****************
#  GKE : GDO-8134
# ******************/
# module "gke" {
#   source                        = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
#   version                       = "29.0.0"
#   project_id                    = module.project.project_id
#   network_project_id            = local.host_project_id
#   name                          = "${module.project.project_name}-gke-${module.locations.region_codes[var.region]}-${var.gke_cluster_name_suffix}"
#   region                        = var.region
#   regional                      = true
#   network                       = regex(".*/global/networks/(.*)$", local.vpc)[0]
#   subnetwork                    = module.subnets.subnets.genai.name
#   ip_range_pods                 = "gke-pod"
#   ip_range_services             = "gke-services"
#   create_service_account        = false
#   service_account               = "${var.gke_service_account}@${module.project.project_id}.iam.gserviceaccount.com"
#   master_ipv4_cidr_block        = var.master_ipv4_cidr_block
#   enable_private_endpoint       = true
#   enable_private_nodes          = true
#   deploy_using_private_endpoint = true
#   http_load_balancing           = var.http_load_balancing
#   horizontal_pod_autoscaling    = var.horizontal_pod_autoscaling
#   network_policy                = var.network_policy
#   cluster_resource_labels       = var.labels
#   remove_default_node_pool      = var.remove_default_node_pool
#   add_cluster_firewall_rules    = true
#   kubernetes_version            = var.k8s_version
#   release_channel               = "STABLE"
#   firewall_inbound_ports        = var.gke_firewall_inbound_ports
#   master_authorized_networks    = local.master_authorized_networks
#   master_global_access_enabled  = false
#   notification_config_topic     = var.gke_notification_config_topic
#   maintenance_exclusions = [
#     {
#       name            = "no-minor-upgrades"
#       start_time      = "2023-12-27T00:00:00Z"
#       end_time        = "2024-06-24T00:00:00Z"
#       exclusion_scope = "NO_MINOR_UPGRADES"
#     }
#   ]

#   node_pools = [

#     {
#       name              = "genai-search-np01"
#       machine_type      = "n1-standard-4"
#       autoscaling       = true
#       min_count         = 1
#       max_count         = 2
#       local_ssd_count   = 0
#       spot              = true
#       disk_size_gb      = 50
#       disk_type         = "pd-standard"
#       image_type        = "COS_CONTAINERD"
#       auto_repair       = true
#       auto_upgrade      = true
#       enable_gcfs       = false
#       enable_gvnic      = false
#       logging_variant   = "DEFAULT"
#       max_pods_per_node = 32
#       service_account   = "${var.gke_service_account}@${module.project.project_id}.iam.gserviceaccount.com"
#       preemptible       = false
#       version           = var.k8s_version
#     },

#   ]



#   node_pools_oauth_scopes = {
#     all = [
#       "cloud-platform",
#       "monitoring-write",
#       "logging-write",
#       "monitoring"
#     ]
#   }

#   node_pools_labels = {
#     all = {}

#     genai-search-np01 = var.labels_genai
#   }
#   // Google labels

#   node_pools_resource_labels = {
#     genai-search-np01 = var.labels_genai
#   }

#   node_pools_taints = {
#   }

#   depends_on = [
#     module.subnets,
#     module.project,
#     module.pubsub,
#     google_project_iam_member.gke_container_engine_robot_sa_roles,
#     google_service_account.service_accounts
#   ]

# }

data "google_client_config" "provider" {}

provider "kubernetes" {

  host  = "https://${module.gke.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    module.gke.ca_certificate,
  )

}

provider "helm" {
  kubernetes {
    host  = "https://${module.gke.endpoint}"
    token = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(
      module.gke.ca_certificate,
    )
  }

}

provider "google-beta" {}
