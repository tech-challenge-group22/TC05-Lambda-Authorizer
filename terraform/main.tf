provider "aws" {
  region  = "${var.region}"
}

terraform {
  backend "s3" {
  }
}

resource "aws_sqs_queue" "order-queue-finished" {
  content_based_deduplication       = false
  deduplication_scope               = "queue"
  delay_seconds                     = 0
  fifo_queue                        = true
  fifo_throughput_limit             = "perQueue"
  kms_data_key_reuse_period_seconds = 300
  kms_master_key_id                 = null
  max_message_size                  = 2048
  message_retention_seconds         = 86400
  name                              = "OrderQueueFinished.fifo"
  name_prefix                       = null
  policy                            = "{\"Statement\":[{\"Action\":[\"sqs:SendMessage\",\"sqs:ReceiveMessage\",\"sqs:DeleteMessage\",\"sqs:GetQueueAttributes\"],\"Effect\":\"Allow\"}],\"Version\":\"2012-10-17\"}"
  receive_wait_time_seconds         = 2
  redrive_allow_policy              = null
  redrive_policy                    = null
  sqs_managed_sse_enabled           = true
  tags                              = {}
  tags_all                          = {}
  visibility_timeout_seconds        = 30
}

resource "aws_sqs_queue" "order-queue-received" {
  content_based_deduplication       = false
  deduplication_scope               = "queue"
  delay_seconds                     = 0
  fifo_queue                        = true
  fifo_throughput_limit             = "perQueue"
  kms_data_key_reuse_period_seconds = 300
  kms_master_key_id                 = null
  max_message_size                  = 2048
  message_retention_seconds         = 86400
  name                              = "OrderQueueReceived.fifo"
  name_prefix                       = null
  policy                            = "{\"Statement\":[{\"Action\":[\"sqs:SendMessage\",\"sqs:ReceiveMessage\",\"sqs:DeleteMessage\",\"sqs:GetQueueAttributes\"],\"Effect\":\"Allow\"}],\"Version\":\"2012-10-17\"}"
  receive_wait_time_seconds         = 2
  redrive_allow_policy              = null
  redrive_policy                    = null
  sqs_managed_sse_enabled           = true
  tags                              = {}
  tags_all                          = {}
  visibility_timeout_seconds        = 30
}

resource "aws_sqs_queue" "payment-queue-received" {
  content_based_deduplication       = false
  deduplication_scope               = "queue"
  delay_seconds                     = 0
  fifo_queue                        = true
  fifo_throughput_limit             = "perQueue"
  kms_data_key_reuse_period_seconds = 300
  kms_master_key_id                 = null
  max_message_size                  = 2048
  message_retention_seconds         = 86400
  name                              = "PaymentQueueReceived.fifo"
  name_prefix                       = null
  policy                            = "{\"Statement\":[{\"Action\":[\"sqs:SendMessage\",\"sqs:ReceiveMessage\",\"sqs:DeleteMessage\",\"sqs:GetQueueAttributes\"],\"Effect\":\"Allow\"}],\"Version\":\"2012-10-17\"}"
  receive_wait_time_seconds         = 2
  redrive_allow_policy              = null
  redrive_policy                    = null
  sqs_managed_sse_enabled           = true
  tags                              = {}
  tags_all                          = {}
  visibility_timeout_seconds        = 30
}

resource "aws_sqs_queue" "payment-notification" {
  content_based_deduplication       = false
  deduplication_scope               = "queue"
  delay_seconds                     = 0
  fifo_queue                        = true
  fifo_throughput_limit             = "perQueue"
  kms_data_key_reuse_period_seconds = 300
  kms_master_key_id                 = null
  max_message_size                  = 2048
  message_retention_seconds         = 86400
  name                              = "PaymentStatusNotification.fifo"
  name_prefix                       = null
  policy                            = "{\"Statement\":[{\"Action\":[\"sqs:SendMessage\",\"sqs:ReceiveMessage\",\"sqs:DeleteMessage\",\"sqs:GetQueueAttributes\"],\"Effect\":\"Allow\"}],\"Version\":\"2012-10-17\"}"
  receive_wait_time_seconds         = 2
  redrive_allow_policy              = null
  redrive_policy                    = null
  sqs_managed_sse_enabled           = true
  tags                              = {}
  tags_all                          = {}
  visibility_timeout_seconds        = 30
}

resource "aws_sqs_queue" "payment_queue_processed" {
  content_based_deduplication       = false
  deduplication_scope               = "queue"
  delay_seconds                     = 0
  fifo_queue                        = true
  fifo_throughput_limit             = "perQueue"
  kms_data_key_reuse_period_seconds = 300
  kms_master_key_id                 = null
  max_message_size                  = 2048
  message_retention_seconds         = 86400
  name                              = "PaymentQueueProcessed.fifo"
  name_prefix                       = null
  policy                            = "{\"Statement\":[{\"Action\":[\"sqs:SendMessage\",\"sqs:ReceiveMessage\",\"sqs:DeleteMessage\",\"sqs:GetQueueAttributes\"],\"Effect\":\"Allow\"}],\"Version\":\"2012-10-17\"}"
  receive_wait_time_seconds         = 2
  redrive_allow_policy              = null
  redrive_policy                    = null
  sqs_managed_sse_enabled           = true
  tags                              = {}
  tags_all                          = {}
  visibility_timeout_seconds        = 30
}

resource "aws_lambda_function" "validate-customer" {
  filename      = "../lambda/dist/validate-customer.zip"
  function_name = "validate-customer"
  role          = "${var.lab_role_arn}"
  handler       = "index.handler"

  runtime = "nodejs18.x"
  environment {
    variables = {
      DB_HOST              = "${var.db_host}"
      DB_PASSWORD          = "${var.database_password}"
      DB_USER              = "${var.database_username}"
      SECRET_KEY_JWT_TOKEN = "${var.secret_key_jwt_token}"
    }
  }
}
