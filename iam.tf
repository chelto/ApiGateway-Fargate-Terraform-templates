
data "aws_iam_policy_document" "fargate_task_policy_doc" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}


data "aws_iam_policy_document" "ecs-secret-policy_doc" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetAuthorizationToken",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"
    ]
  }
}

resource "aws_iam_role" "fargate_task_role" {
  tags               = var.default_tags
  name               = "${var.name_prefix}-fargate_task_role"
  assume_role_policy = data.aws_iam_policy_document.fargate_task_policy_doc.json
}

resource "aws_iam_policy" "policy" {
  tags   = var.default_tags
  name   = "${var.name_prefix}-fargate_task_policy"
  policy = data.aws_iam_policy_document.ecs-secret-policy_doc.json
}

resource "aws_iam_role_policy_attachment" "task_attachment" {
  role       = aws_iam_role.fargate_task_role.name
  policy_arn = aws_iam_policy.policy.arn
}
