output "queue_url" {
  value = aws_sqs_queue.sandbox_queue.id
}

output "queue_arn" {
  value = aws_sqs_queue.sandbox_queue.arn
}
