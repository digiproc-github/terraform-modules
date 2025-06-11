locals {
  cluster_name = var.create ? substr(data.aws_arn.cluster[0].resource, length("cluster/"), -1) : ""
}

data "aws_arn" "cluster" {
  count = var.create ? 1 : 0

  arn = var.cluster_arn
}

resource "aws_ecs_service" "service" {
  count = var.create ? 1 : 0

  name                               = var.name
  cluster                            = var.cluster_arn
  task_definition                    = var.task_definition_arn
  desired_count                      = var.desired_count
  launch_type                        = var.launch_type
  scheduling_strategy                = "REPLICA"
  deployment_maximum_percent         = var.deployment_max_percent
  deployment_minimum_healthy_percent = var.deployment_min_percent

  wait_for_steady_state = var.wait_for_steady_state

  # Add dynamic blocks for placement constraints
  dynamic "placement_constraints" {
    for_each = var.placement_constraints
    content {
      type       = placement_constraints.value.type
      expression = placement_constraints.value.expression
    }
  }

  # Add dynamic blocks for placement strategies
  dynamic "ordered_placement_strategy" {
    for_each = var.ordered_placement_strategy
    content {
      type  = ordered_placement_strategy.value.type
      field = ordered_placement_strategy.value.field
    }
  }

  deployment_circuit_breaker {
    enable   = var.deployment_rollback
    rollback = var.deployment_rollback
  }

  timeouts {
    create = var.deployment_timeout
    update = var.deployment_timeout
    delete = var.deployment_timeout
  }

  lifecycle {
    create_before_destroy = true
  }
}

