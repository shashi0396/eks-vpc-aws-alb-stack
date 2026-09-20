output "alb_role_arn" {
	value = aws_iam_role.alb_controller.arn
}

output "service_account_name" {
	value = kubernetes_service_account.alb_controller.metadata[0].name
}
