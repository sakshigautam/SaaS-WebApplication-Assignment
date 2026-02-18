provider "aws" {
  region = var.region
}

module "vpc" {
  source          = "../../modules/vpc"
  cidr            = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = var.azs
}

module "security" {
  source = "../../modules/security"
  vpc_id = module.vpc.vpc_id
}

module "alb" {
  source          = "../../modules/alb"
  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnet_ids
  alb_sg          = module.security.alb_sg_id
  acm_cert = "arn:aws:acm:us-east-1:123456789012:certificate/7b1c2d34-56ef-78ab-90cd-ef1234567890"
}

module "compute" {
  source           = "../../modules/compute"
  private_subnets  = module.vpc.private_subnet_ids
  target_group_arn = module.alb.target_group_arn
  ami = "ami-0c02fb55956c7d316"
  instance_profile = "ec2-saas-prod-instance-profile"
}

module "monitoring" {
  source         = "../../modules/monitoring"
  asg_name       = module.compute.asg_name
  alb_arn_suffix = module.alb.target_group_arn_suffix
  sns_email      = var.sns_email
}

module "budget" {
  source       = "../../modules/budget"
  email        = var.budget_email
  limit_amount = "100"
}
