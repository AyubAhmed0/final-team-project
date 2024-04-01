# IAM Role for EKS - this role is meant for Kubernetes service accounts to interact with AWS services
module "eks_iam_roles" {
  source                   = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                  = "4.2.0" 
  create_role              = true
  role_name                = "EKS-Team-Role"
# Only line 8 will need to be changed upon each apply
  provider_url             = "oidc.eks.eu-west-2.amazonaws.com/id/730FAAAE1D1078C1C545D8EEA499053F"
  oidc_fully_qualified_subjects = ["system:serviceaccount:default:team4"] 
  role_policy_arns         = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSServicePolicy",
  ]
}

# IAM Users for team members
resource "aws_iam_user" "team_user" {
  for_each = toset(["sahr", "ayub", "alex", "rik"])
  name     = each.value
}

# IAM Group for EKS Developers
resource "aws_iam_group" "eks_developers" {
  name = "EKSDevelopers"
}

# Attach users to the IAM group
resource "aws_iam_group_membership" "team_membership" {
  name = "team-membership"
  users = [for u in aws_iam_user.team_user : u.name]
  group = aws_iam_group.eks_developers.name
}

# Policy attached to the group that should allow EKS access 
resource "aws_iam_policy" "eks_access" {
  name        = "EKSAccessPolicy"
  description = "Policy to allow access to EKS cluster"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters",
          "eks:ListNodegroups",
          "eks:ListFargateProfiles",
          "eks:AccessKubernetesApi" 
        ],
        Resource = "*" 
      }
    ]
  })
}

# Attach the access policy to the group
resource "aws_iam_group_policy_attachment" "eks_access_attachment" {
  group      = aws_iam_group.eks_developers.name
  policy_arn = aws_iam_policy.eks_access.arn
}