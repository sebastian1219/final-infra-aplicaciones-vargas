# Cola SQS para eventos
resource "aws_sqs_queue" "hospital_queue" {
  name                       = "hospital-events-queue"
  visibility_timeout_seconds = 30
  message_retention_seconds  = 86400
}

# Policy de la cola: permite que el rol LabRole envíe mensajes (SendMessage)
resource "aws_sqs_queue_policy" "hospital_queue_policy" {
  queue_url = aws_sqs_queue.hospital_queue.id
  policy    = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Sid      : "AllowLabRoleToSend",
        Effect   : "Allow",
        Principal: { AWS: "arn:aws:iam::730335546358:role/LabRole" },
        Action   : [ "sqs:SendMessage" ],
        Resource : aws_sqs_queue.hospital_queue.arn
      }
    ]
  })
}
