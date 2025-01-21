project_iam_bindings = {
  "roles/compute.osLogin" : [
    "group:res-gcp-aiml-lsa-ds@levi.com",
    "group:res-gcp-aiml-lse-ds@levi.com",
    "group:res-gcp-aiml-lsa-mlengineer@levi.com",
    "group:res-gcp-aiml-lse-mlengineer@levi.com",
    "group:res-gcp-aiml-mlengineer@levi.com",
    "group:res-gcp-aiml-mlopsengineer@levi.com",
  ],
  "roles/compute.viewer" : [
    "group:res-gcp-aiml-lsa-ds@levi.com",
    "group:res-gcp-aiml-lse-ds@levi.com",
    "group:res-gcp-aiml-lsa-mlengineer@levi.com",
    "group:res-gcp-aiml-lse-mlengineer@levi.com",
    "group:res-gcp-aiml-mlengineer@levi.com",
    "group:res-gcp-aiml-mlopsengineer@levi.com",
  ],
  "roles/compute.instanceAdmin.v1" : [
    "group:res-gcp-aiml-lsa-ds@levi.com",
    "group:res-gcp-aiml-lse-ds@levi.com",
    "group:res-gcp-aiml-lsa-mlengineer@levi.com",
    "group:res-gcp-aiml-lse-mlengineer@levi.com",
    "group:res-gcp-aiml-mlengineer@levi.com",
    "group:res-gcp-aiml-mlopsengineer@levi.com",
    "serviceAccount:svc-jenkins@levi-genai-pp.iam.gserviceaccount.com",
    "serviceAccount:svc-harness@levi-genai-pp.iam.gserviceaccount.com"
  ],
  "roles/pubsub.editor" : [
    "serviceAccount:svc-genai@levi-genai-pp.iam.gserviceaccount.com"
  ],
  "roles/iam.serviceAccountUser" : [
    "group:res-gcp-aiml-lsa-ds@levi.com",
    "group:res-gcp-aiml-lse-ds@levi.com",
    "group:res-gcp-aiml-lsa-mlengineer@levi.com",
    "group:res-gcp-aiml-lse-mlengineer@levi.com",
    "group:res-gcp-aiml-mlengineer@levi.com",
    "group:res-gcp-aiml-mlopsengineer@levi.com",
    "serviceAccount:svc-genai@levi-genai-pp.iam.gserviceaccount.com"
  ],
  "roles/logging.viewer" : [
    "group:res-gcp-aiml-lsa-ds@levi.com",
    "group:res-gcp-aiml-lse-ds@levi.com",
    "group:res-gcp-aiml-lsa-mlengineer@levi.com",
    "group:res-gcp-aiml-lse-mlengineer@levi.com",
    "group:res-gcp-aiml-mlengineer@levi.com",
    "group:res-gcp-aiml-mlopsengineer@levi.com",
    "group:res-gcp-aiml-dataengineer@levi.com",
    "serviceAccount:svc-genai@levi-genai-pp.iam.gserviceaccount.com"
  ],
  "roles/logging.logWriter" : [
    "serviceAccount:svc-genai@levi-genai-pp.iam.gserviceaccount.com"
  ],
  "roles/serviceusage.serviceUsageConsumer" : [
    "serviceAccount:svc-genai@levi-genai-pp.iam.gserviceaccount.com"
  ],
  "roles/compute.networkViewer" : [
    "group:res-gcp-aiml-lsa-ds@levi.com",
    "group:res-gcp-aiml-lse-ds@levi.com",
    "group:res-gcp-aiml-lsa-mlengineer@levi.com",
    "group:res-gcp-aiml-lse-mlengineer@levi.com",
    "group:res-gcp-aiml-mlengineer@levi.com",
    "group:res-gcp-aiml-mlopsengineer@levi.com",
  ],
  "roles/bigquery.jobUser" : [
    "group:res-gcp-aiml-lsa-ds@levi.com",
    "group:res-gcp-aiml-lse-ds@levi.com",
    "group:res-gcp-aiml-lsa-mlengineer@levi.com",
    "group:res-gcp-aiml-lse-mlengineer@levi.com",
    "group:res-gcp-aiml-mlengineer@levi.com",
    "group:res-gcp-aiml-mlopsengineer@levi.com",
    "serviceAccount:svc-genai@levi-genai-pp.iam.gserviceaccount.com"
  ],
  "roles/storage.objectAdmin" : [
    "serviceAccount:svc-genai@levi-genai-pp.iam.gserviceaccount.com",
    "serviceAccount:svc-genai-search-poc@levi-genai-pp.iam.gserviceaccount.com"
  ],
  "roles/artifactregistry.repoAdmin" : [
    "serviceAccount:svc-genai@levi-genai-pp.iam.gserviceaccount.com"
  ],
  "roles/bigquery.readSessionUser" : [
    "group:res-gcp-aiml-lsa-ds@levi.com",
    "group:res-gcp-aiml-lse-ds@levi.com",
    "group:res-gcp-aiml-lsa-mlengineer@levi.com",
    "group:res-gcp-aiml-lse-mlengineer@levi.com",
    "group:res-gcp-aiml-mlengineer@levi.com",
    "group:res-gcp-aiml-mlopsengineer@levi.com",
    "group:res-gcp-aiml-dataengineer@levi.com",
    "serviceAccount:svc-genai@levi-genai-pp.iam.gserviceaccount.com"
  ],
  "roles/bigquery.dataViewer" : [
    "group:res-gcp-aiml-lsa-ds@levi.com",
    "group:res-gcp-aiml-lse-ds@levi.com",
    "group:res-gcp-aiml-lsa-mlengineer@levi.com",
    "group:res-gcp-aiml-lse-mlengineer@levi.com",
    "group:res-gcp-aiml-mlengineer@levi.com",
    "group:res-gcp-aiml-mlopsengineer@levi.com",
    "serviceAccount:svc-genai@levi-genai-pp.iam.gserviceaccount.com"
  ],
  "roles/bigquery.dataEditor" : [
    "serviceAccount:svc-genai@levi-genai-pp.iam.gserviceaccount.com"
  ],
  "roles/bigquery.user" : [
    "group:res-gcp-aiml-lsa-ds@levi.com",
    "group:res-gcp-aiml-lse-ds@levi.com",
    "group:res-gcp-aiml-lsa-mlengineer@levi.com",
    "group:res-gcp-aiml-lse-mlengineer@levi.com",
    "group:res-gcp-aiml-mlengineer@levi.com",
    "group:res-gcp-aiml-mlopsengineer@levi.com",
    "group:res-gcp-aiml-dataengineer@levi.com"
  ],
  "roles/storage.admin" : [
    "group:res-gcp-aiml-lsa-ds@levi.com",
    "group:res-gcp-aiml-lse-ds@levi.com",
    "group:res-gcp-aiml-lsa-mlengineer@levi.com",
    "group:res-gcp-aiml-lse-mlengineer@levi.com",
    "group:res-gcp-aiml-mlengineer@levi.com",
    "group:res-gcp-aiml-mlopsengineer@levi.com",
    "serviceAccount:svc-genai@levi-genai-pp.iam.gserviceaccount.com",
    "serviceAccount:svc-jenkins@levi-genai-pp.iam.gserviceaccount.com",
    "serviceAccount:svc-harness@levi-genai-pp.iam.gserviceaccount.com"
  ],
  "roles/aiplatform.admin" : [
    "group:res-gcp-aiml-lsa-ds@levi.com",
    "group:res-gcp-aiml-lse-ds@levi.com",
    "group:res-gcp-aiml-lsa-mlengineer@levi.com",
    "group:res-gcp-aiml-lse-mlengineer@levi.com",
    "group:res-gcp-aiml-mlengineer@levi.com",
    "group:res-gcp-aiml-mlopsengineer@levi.com",
    "group:res-gcp-aiml-dataengineer@levi.com",
    "serviceAccount:svc-genai@levi-genai-pp.iam.gserviceaccount.com"
  ],
  "organizations/381535139122/roles/storage.customViewer" : [
    "serviceAccount:svc-genai@levi-genai-pp.iam.gserviceaccount.com"
  ],
  "roles/notebooks.admin" : [
    "group:res-gcp-aiml-lsa-ds@levi.com",
    "group:res-gcp-aiml-lse-ds@levi.com",
    "group:res-gcp-aiml-lsa-mlengineer@levi.com",
    "group:res-gcp-aiml-lse-mlengineer@levi.com",
    "group:res-gcp-aiml-mlengineer@levi.com",
    "group:res-gcp-aiml-mlopsengineer@levi.com",
    "group:res-gcp-aiml-dataengineer@levi.com",
    "serviceAccount:svc-genai@levi-genai-pp.iam.gserviceaccount.com"
  ],
  "roles/dataproc.editor" : [
    "serviceAccount:svc-genai@levi-genai-pp.iam.gserviceaccount.com"
  ],
  "roles/compute.instanceAdmin" : [
    "group:res-gcp-aiml-lsa-ds@levi.com",
    "group:res-gcp-aiml-lse-ds@levi.com",
    "group:res-gcp-aiml-lsa-mlengineer@levi.com",
    "group:res-gcp-aiml-lse-mlengineer@levi.com",
    "group:res-gcp-aiml-mlengineer@levi.com",
    "group:res-gcp-aiml-mlopsengineer@levi.com",
    "group:res-gcp-aiml-dataengineer@levi.com"
  ],
  "roles/viewer" : [
    "group:res-gcp-aiml-lsa-ds@levi.com",
    "group:res-gcp-aiml-lse-ds@levi.com",
    "group:res-gcp-aiml-lsa-mlengineer@levi.com",
    "group:res-gcp-aiml-lse-mlengineer@levi.com",
    "group:res-gcp-aiml-mlengineer@levi.com",
    "group:res-gcp-aiml-mlopsengineer@levi.com"
  ],
  "roles/discoveryengine.admin" : [
    "group:res-gcp-aiml-lsa-ds@levi.com",
    "group:res-gcp-aiml-lse-ds@levi.com",
    "group:res-gcp-aiml-lsa-mlengineer@levi.com",
    "group:res-gcp-aiml-lse-mlengineer@levi.com",
    "group:res-gcp-aiml-mlengineer@levi.com",
    "group:res-gcp-aiml-mlopsengineer@levi.com",
    "serviceAccount:svc-genai@levi-genai-pp.iam.gserviceaccount.com"
  ],
  "roles/secretmanager.secretAccessor" : [
    "serviceAccount:svc-genai@levi-genai-pp.iam.gserviceaccount.com"
  ],
  "roles/cloudsql.viewer" : [
    "serviceAccount:svc-genai@levi-genai-pp.iam.gserviceaccount.com"
  ],
  "roles/cloudsql.client" : [
    "serviceAccount:svc-genai@levi-genai-pp.iam.gserviceaccount.com"
  ],

}
