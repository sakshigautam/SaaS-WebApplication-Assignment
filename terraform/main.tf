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
  acm_cert        = "your-acm-certificate-arn"
}



module "compute" {
  source            = "../../modules/compute"
  private_subnets   = module.vpc.private_subnet_ids
  target_group_arn  = module.alb.target_group_arn
  ami               = "ami-xxxxxxxx"
  instance_profile  = "your-ec2-instance-profile"
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

