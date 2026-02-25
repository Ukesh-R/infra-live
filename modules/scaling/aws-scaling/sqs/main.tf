resource "aws_sqs_queue" "sandbox_queue" {
    name = var.queue_name
    visibility_timeout_seconds = 300
    message_retention_seconds = 86400
}