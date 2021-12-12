resource "aws_api_gateway_domain_name" "api_gateway_domain_name" {
  certificate_arn = var.certificate_arn
  domain_name     = var.domain_name
}

resource "aws_route53_record" "alias" {
  name    = var.app_name
  type    = "A"
  zone_id = var.hosted_zone_id

  alias {
    evaluate_target_health = true

    name    = aws_api_gateway_domain_name.api_gateway_domain_name.cloudfront_domain_name
    zone_id = aws_api_gateway_domain_name.api_gateway_domain_name.cloudfront_zone_id
  }
}

resource "aws_api_gateway_rest_api" "api" {
  name        = "${var.app_name}-${var.env}"
  description = var.description

  disable_execute_api_endpoint = true

  endpoint_configuration {
    types = ["EDGE"]
  }
}

resource "aws_api_gateway_base_path_mapping" "mapping" {
  api_id      = aws_api_gateway_rest_api.api.id
  stage_name  = var.env
  domain_name = var.domain_name
}

resource "aws_api_gateway_stage" "stage" {
  deployment_id = ""
  rest_api_id   = ""
  stage_name    = ""
}

resource "aws_ssm_parameter" "ssm_api_id" {
  name        = "${var.app_name}-${var.env}-api-id"
  description = "Check my IP - ApiGateway ID"
  type        = "String"
  value       = aws_api_gateway_rest_api.api.id
}

resource "aws_ssm_parameter" "ssm_api_root_resource_id" {
  name        = "${var.app_name}-${var.env}-api-root-resource-id"
  description = "Check my IP - ApiGateway root resource ID"
  type        = "String"
  value       = aws_api_gateway_rest_api.api.root_resource_id
}
