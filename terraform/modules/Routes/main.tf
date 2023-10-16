resource "aws_route_table" "main" {
    vpc_id = var.vpc_id
    route = var.route

    tags = var.tags
}