variable "org_id" {
  type = string
}
variable "folder_name" {
  type = string
}

variable "project_name" {
  type = string
}

variable "project_activate_apis" {
  type = list(string)
}

variable "host_project_name" {
  type = string
}

variable "shared_vpc_name" {
  type = string
}

variable "billing_account" {
  type = string
}

variable "region" {
  type    = string
  default = "us-east4"
}


variable "zone" {
  type    = string
  default = "us-east4-a"
}

variable "labels" {
  description = "Project labels."
  type        = map(string)
  default     = {}
}

variable "subnets" {
  description = "Map of subnet definitions (ex. desc = {cidr = 10.10.10.0/24, region = us-central1 } )"
  type = map(object({
    ip_cidr_range = string
    region        = string
  }))
  default = {}
}

variable "secondary_ranges" {
  description = "Secondary ranges for particular subnets"
  type = map(list(object({
    range_name    = string
    ip_cidr_range = string
  })))
  default = {}
}

variable "rules" {
  description = "List of custom rule definitions (refer to variables file for syntax)."
  default     = []
  type = list(object({
    name                    = string
    description             = string
    direction               = string
    priority                = number
    ranges                  = list(string)
    source_tags             = list(string)
    source_service_accounts = list(string)
    target_tags             = list(string)
    target_service_accounts = list(string)
    allow = list(object({
      protocol = string
      ports    = list(string)
    }))
    deny = list(object({
      protocol = string
      ports    = list(string)
    }))
    log_config = object({
      metadata = string
    })
  }))
}

variable "service_account_prefix" {
  type        = string
  description = "Prefix applied to service account names (defaults to 'svc')."
  default     = "svc"
}
variable "service_account_names" {
  type        = list(string)
  description = "Names of the service accounts to create."
  default     = []
}

variable "environment_short_name" {
  description = "Default Environment Short Name"
  type        = string
  default     = "pp"
}

variable "description" {
  type        = string
  description = "Default description of the created service accounts (defaults to no description)"
  default     = ""
}

variable "descriptions" {
  type        = list(string)
  description = "List of descriptions for the created service accounts (elements default to the value of `description`)"
  default     = []
}

variable "project_iam_bindings" {
  description = "Roles binding at the project"
  type        = map(list(string))
  default     = {}
}


variable "service_account_scopes" {
  description = "Default service account scopes "
  type        = list(any)
  default = [
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/cloud-platform"
  ]
}

variable "gce_service_account" {
  description = "Service account to associate to the Trinity VM"
  default     = "svc-gce"
}

variable "startup_script" {
  description = "Startup script"
  default     = <<EOT
  #!/bin/bash
  yum install -y tcpdump bind-utils nmap wget make gcc zlib-devel mlocate libffi-devel openssl-devel kubectl google-cloud-sdk-gke-gcloud-auth-plugin jq
  ionice -c3 updatedb
  wget -c https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.18.0/kubeseal-0.18.0-linux-amd64.tar.gz -O - | sudo tar -xz -C /usr/local/bin/ && chmod +x /usr/local/bin/kubeseal
  curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
  EOT
}

variable "rhel_version" {
  description = "Default Image Version Name"
  type        = string
  default     = "rhel-8"
}

###############################################################################
#                            DNS zone variables                               #
###############################################################################

variable "dns_domain_name" {
  description = "Zone domain, must end with a period."
  type        = string
  default     = "aiml.gcp.levi.com."
}

variable "dns_zone_name" {
  description = "Zone name, must be unique within the project."
  type        = string
  default     = "private-aiml-gcp-levi-com"
}

variable "dns_zone_shared_project" {
  description = "The name of DNS Zone Project"
  default     = "levi-aishared-p-5a89"
  type        = string
}


variable "sharedproject_iam_bindings" {
  description = "Roles binding at the shared project"
  type        = map(list(string))
  default     = {}
}

variable "sharedproject_network_access" {
  description = "Roles for the shared project"
  type        = list(string)
  default     = []
}

variable "vertexai_custom_metadata" {
  type        = map(string)
  description = "Labels of the Custom Metadata for Vertex AI Notebooks."
  default = {
    proxy-mode = "service_account"
  }
}

variable "vertexai_labels" {
  type        = map(string)
  description = "Labels of the Custom Metadata for Vertex AI Notebooks."
  default = {
    goog-caip-notebook-volume = "notebook"
  }

}

//GDO-8172

variable "genai_host_vm_rhel_version" {
  description = "Default Image Version Name"
  type        = string
  default     = "rhel-8"
}

variable "genai_machine_type" {
  description = "Type of Cloud SQL Proxy VM"
  type        = string
  default     = "e2-standard-4"
}

variable "awx_token" {
  description = "AWX token"
  type        = string
  sensitive   = true
}


// GKE : GDO-8134

variable "gke_cluster_name_suffix" {
  description = "A suffix to append to the default cluster name"
  default     = "common"
}

variable "k8s_version" {
  description = "K8S Version"
  type        = string
}

variable "gke_service_account" {
  description = "Service account to associate to the nodes in the cluster"
  type        = string
  default     = "svc-gke"
}

variable "master_ipv4_cidr_block" {
  type = string
}

variable "horizontal_pod_autoscaling" {
  type        = bool
  description = "Enable horizontal pod autoscaling addon"
  default     = true
}

variable "http_load_balancing" {
  type        = bool
  description = "Enable httpload balancer addon"
  default     = true
}
variable "network_policy" {
  type        = bool
  description = "Enable network policy addon"
  default     = false
}

variable "network_policy_provider" {
  type        = string
  description = "The network policy provider."
  default     = "CALICO"
}
variable "master_authorized_networks" {
  type = list(object({
    cidr_block   = string
    display_name = string
  }))
  description = "List of master authorized networks. If none are provided, disallow external access (except the cluster node IPs, which GKE automatically whitelists)."

}

variable "remove_default_node_pool" {
  type        = bool
  description = "Remove default node pool while setting up the cluster"
  default     = true
}

variable "gke_firewall_inbound_ports" {
  type        = list(string)
  description = "List of TCP ports for admission/webhook controllers. Either flag `add_master_webhook_firewall_rules` or `add_cluster_firewall_rules` (also adds egress rules) must be set to `true` for inbound-ports firewall rules to be applied."
  default     = ["8080", "8443", "9443", "15017"]
}

variable "labels_genai" {
  description = "Common labels for ept resources"
  type        = map(string)
  default = {
    aiml-service-type : "ml"
    aiml-team-name : "genai"
    business-applicationname : "genai"
  }
}
variable "gke_notification_config_topic" {
  description = "The desired Pub/Sub topic to which notifications will be sent by GKE. Format is projects/{project}/topics/{topic}."
  default     = "projects/levi-genai-pp/topics/levi-genai-pp-pub-gcp-notifications"
}

variable "gke_container_engine_robot_sa_roles" {
  type        = list(string)
  description = "List of GKE Container Engine Robot Service Account Roles"
  default = [
    "compute.networkUser",
    "container.hostServiceAgentUser",
  ]
}
