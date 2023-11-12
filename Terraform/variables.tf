variable "location" {
  description = "The location of Azure resources."
  type        = string
  default     = "West Europe"
}

variable "vm_size" {
  description = "The VM size for the AKS default node pool."
  type        = string
  default     = "Standard_DS2_v2"
}

variable "k8s_cluster_name" {
  description = "The name of the Azure Kubernetes Service (AKS) cluster."
  type        = string
  default     = "practice-aks-cluster"
}