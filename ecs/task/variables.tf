variable "create" {
  description = "Should resources be created"
  default     = true
  type        = bool
}

variable "role_arn" {
  description = "The ARN of IAM role that allows your Amazon ECS container task to make calls to other AWS services."
  type        = string
  default     = null
}


variable "execution_role_arn" {
  description = <<-EOT
    The ARN of IAM role that allows ECS to execute your task.

    Required when:
    - using `environment_parameters` to give ECS access to the SSM parameters
    - using `launch_type = "FARGATE"` when running the task
  EOT
  type        = string
  default     = null
}

variable "network_mode" {
  description = <<-EOT
    Docker networking mode to use for the containers in the task.
    Valid values are `none`, `bridge`, `awsvpc`, and `host`.
  EOT
  type        = string
  default     = null
}

variable "task_memory" {
  description = "Memory reserved for the task. Required when running on Fargate."
  type        = number
  default     = null
}

variable "task_cpu" {
  description = "CPU reserved for the task. Required when running on Fargate."
  type        = number
  default     = null
}

# log_group

variable "project" {
  description = "Kebab-cased project name"
  type        = string
}

variable "environment" {
  description = "Kebab-cased environment name, eg. development, staging, production."
  type        = string
}

variable "tags" {
  description = "Tags to add to resources that support them"
  type        = map(string)
  default     = {}
}

variable "task" {
  description = "ECS task definition name"
  type        = string
}

variable "container" {
  description = "Container name within the task definition, defaults to task name"
  type        = string
  default     = null
}

variable "log_retention" {
  description = <<EOF
Log retention in days.

    Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 0.
    If you select 0, the events in the log group are always retained and never expire.
  EOF

  type    = number
  default = 7
}

# container_definition

variable "image" {
  description = "Full container image name, including the version tag. Either image or image_name has to be provided."
  type        = string
  default     = null
}

variable "image_name" {
  description = "Container image name, without the version tag. Either image or image_name has to be provided."
  type        = string
  default     = null
}

variable "image_tag" {
  description = "Container image version tag, if omitted will use one from the latest revision. Used only when image_name is provided."
  type        = string
  default     = null
}

variable "memory_hard_limit" {
  description = "The amount (in MiB) of memory to present to the container. If your container attempts to exceed the memory specified here, the container is killed."
  type        = number
  default     = 1024
}

variable "memory_soft_limit" {
  description = "The soft limit (in MiB) of memory to reserve for the container. When system memory is under contention, Docker attempts to keep the container memory to this soft limit; however, your container can consume more memory when needed."
  type        = number
  default     = 256
}

variable "ports" {
  description = "List of TCP ports that should be exposed on the host, a random host port will be assigned for each container port"
  type        = list(number)
  default     = []
}

variable "cpu" {
  description = "The number of cpu units (1/1024 vCPU) the Amazon ECS container agent will reserve for the container."
  type        = number
  default     = 0
}

variable "essential" {
  description = "If the essential parameter of a container is marked as true, and that container fails or stops for any reason, all other containers that are part of the task are stopped."
  type        = bool
  default     = true
}

variable "entry_point" {
  description = "Entry point override."
  type        = list(string)
  default     = null
}

variable "command" {
  description = "Command override."
  type        = list(string)
  default     = null
}

variable "working_directory" {
  description = "Working directory override."
  type        = string
  default     = null
}

variable "environment_variables" {
  description = "Environment variables to pass to a container."
  type        = map(string)
  default     = {}
}

variable "environment_parameters" {
  description = <<-EOT
    Environment variables that should be set to Systems Manager parameter values.
    Maps environment variable names to parameters.
  EOT
  type = map(object({
    arn     = string
    version = number
  }))
  default = {}
}

variable "enable_environment_parameters_hash" {
  description = <<-EOT
    Inject an `SSM_PARAMETERS_HASH` environment variable to ensure that whenever parameter versions change the container definition will also change.
    This makes sure that any services will be updated with new task definitions whenever a parameter is updated, so the service itself doesn't need to poll SSM.
  EOT
  type        = bool
  default     = true
}

variable "placement_constraint_expressions" {
  description = "Placement constraint expressions for the task in Cluster Query Language"
  type        = list(string)
  default     = []
}

variable "other_container_definitions" {
  description = "Other container definitions to include in the task definition"
  type        = list(string)
  default     = []
}
