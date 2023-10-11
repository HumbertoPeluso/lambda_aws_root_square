resource "aws_apigatewayv2_api" "this" {
  name          = "${local.namespaced_service_name}-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "this" {
  api_id      = aws_apigatewayv2_api.this.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "todos" {
  for_each = {
    for k, v in local.lambdas : k => v if v.trigger == "api"
  }

  api_id                 = aws_apigatewayv2_api.this.id
  integration_type       = "AWS_PROXY"
  integration_method     = "POST"
  payload_format_version = "2.0"
  integration_uri        = aws_lambda_function.todos[each.key].invoke_arn
}

resource "aws_apigatewayv2_route" "todos" {
  for_each = {
    for k, v in local.lambdas : k => v if v.trigger == "api"
  }

  api_id    = aws_apigatewayv2_api.this.id
  route_key = "${upper(each.value.http_type)} /v1/todos/${each.key}"
  target    = "integrations/${aws_apigatewayv2_integration.todos[each.key].id}"
}

/* resource "aws_apigatewayv2_route" "todos_get_one" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "GET /v1/todos/{todoId}"
  target    = "integrations/${aws_apigatewayv2_integration.todos["get"].id}"
}

resource "aws_apigatewayv2_route" "todos_get" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "GET /v1/todos"
  target    = "integrations/${aws_apigatewayv2_integration.todos["get"].id}"
}

resource "aws_apigatewayv2_route" "todos_delete" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "DELETE /v1/todos"
  target    = "integrations/${aws_apigatewayv2_integration.todos["delete"].id}"
}

resource "aws_apigatewayv2_route" "todos_post" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "POST /v1/todos/{todoId}"
  target    = "integrations/${aws_apigatewayv2_integration.todos["post"].id}"
}

resource "aws_apigatewayv2_route" "todos_put" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "PUT /v1/todos/{todoId}"
  target    = "integrations/${aws_apigatewayv2_integration.todos["put"].id}"
}

resource "aws_apigatewayv2_route" "todos_test" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "GET /v1/todos/test"
  target    = "integrations/${aws_apigatewayv2_integration.todos["test"].id}"
} */

# resource "aws_apigatewayv2_route" "todos_test" {
#   api_id    = aws_apigatewayv2_api.this.id
#   route_key = "POST /v1/todos/auth/signup"
#   target    = "integrations/${aws_apigatewayv2_integration.todos["signup"].id}"
# }

# resource "aws_apigatewayv2_route" "root_square" {
#   api_id    = aws_apigatewayv2_api.this.id
#   route_key = "POST /v1/todos/root_square"
#   target    = "integrations/${aws_apigatewayv2_integration.todos["root_square"].id}"
# }