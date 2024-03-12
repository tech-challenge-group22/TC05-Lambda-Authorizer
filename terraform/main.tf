provider "aws" {
  region  = "${var.region}"
}

terraform {
  backend "s3" {
    bucket         = "tc05-lambda"
    key            = "terraform.tfstate"
    region         = "us-east-1"
  }
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
