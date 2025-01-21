org_id            = "381535139122"
folder_name       = "HLE"
billing_account   = "01F417-26DA80-3EEA6E"
project_name      = "levi-genai-pp"
host_project_name = "levi-aishared-pp"
shared_vpc_name   = "hle"

project_activate_apis = [
  "compute.googleapis.com",
  "cloudbilling.googleapis.com",
  "storage.googleapis.com",
  "cloudresourcemanager.googleapis.com",
  "bigquery.googleapis.com",
  "recommender.googleapis.com",
  "sqladmin.googleapis.com",
  "redis.googleapis.com",
  "secretmanager.googleapis.com",
  "servicenetworking.googleapis.com",
  "aiplatform.googleapis.com",
  "vpcaccess.googleapis.com",
  "dataflow.googleapis.com",
  "datapipelines.googleapis.com",
  "storage-component.googleapis.com",
  "artifactregistry.googleapis.com",
  "notebooks.googleapis.com",
  "visionai.googleapis.com",
  "dataform.googleapis.com",
  "discoveryengine.googleapis.com",
  "logging.googleapis.com"
]

labels = {
  deployment-environment   = "preproduction"
  deployment-method        = "terraform"
  deployment-createdby     = "svc-ai-tf"
  business-applicationname = "aiml-platform"
  business-org             = "dait"
  business-owner           = "anan22"
  business-costcenter      = "990071"
  security-datatype        = "none"
}

service_account_names = [
  "genai",
  "gke",
  "jenkins",
  "harness",
  "genai-search-poc"
]

subnets = {
  genai = {
    ip_cidr_range = "10.94.60.0/22",
    region        = "us-east4"
  },
}

secondary_ranges = {
  genai = [
    {
      ip_cidr_range = "10.94.58.0/23",
      range_name    = "gke-pod"
    },
    {
      ip_cidr_range = "10.94.57.0/24",
      range_name    = "gke-services"
    }
  ]
}

master_authorized_networks = [
  {
    cidr_block   = "10.94.60.0/22"
    display_name = "VPC"
  },
  {
    cidr_block   = "10.142.252.0/28"
    display_name = "Terraform Agents subnet"
  },
]

master_ipv4_cidr_block = "10.94.56.32/28"
gke_service_account    = "svc-gke"
k8s_version            = "1.29.5-gke.1091002"

rules = [
  {
    name                    = "genai-iapssh"
    description             = "Allow identity aware proxy"
    direction               = "INGRESS"
    priority                = null
    ranges                  = ["35.235.240.0/20"]
    source_tags             = null
    source_service_accounts = null
    target_tags             = ["genai"]
    target_service_accounts = null
    allow = [{
      protocol = "tcp"
      ports    = ["22"]
    }]
    deny = []
    log_config = {
      metadata = "INCLUDE_ALL_METADATA"
    }
  },
  # Setting up Internal HTTP(S) Load Balancing by using GKE Ingress
  # https://cloud.google.com/kubernetes-engine/docs/how-to/internal-load-balance-ingress
  # https://cloud.google.com/load-balancing/docs/l7-internal/proxy-only-subnets
  {
    name        = "genai-gcp-hc-managed-proxies"
    description = "An ingress allows all TCP traffic from the Google Cloud health checking systems"
    direction   = "INGRESS"
    priority    = null
    # Google Cloud health checking systems & Proxy-only Subnets
    ranges                  = ["130.211.0.0/22", "35.191.0.0/16", "10.142.238.0/23", "10.94.57.0/24", "10.94.56.32/28", "10.94.58.0/23"]
    source_tags             = null
    source_service_accounts = null
    # list of GKE Clusters names with prefix gke-
    target_tags             = ["gke-levi-genai-pp-gke-usea4-common"]
    target_service_accounts = null
    # List of TCP ports for Service targetPorts to work ingress ILB and we can define upto 62 ports
    allow = [{
      protocol = "tcp"
      ports = [
        "80",
        "443",
        "8080",
        "5000",
      ]
    }]
    deny = []
    log_config = {
      metadata = "INCLUDE_ALL_METADATA"
    }
  }
]
