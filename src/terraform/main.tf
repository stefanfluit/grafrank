resource "aws_instance" "binance-collector" {
    ami           = data.aws_ami.ubuntu.id
    instance_type = "t3.nano"
    subnet_id     = module.vpc.subnet_public_id
    vpc_security_group_ids = [ aws_security_group.ec2-bc.id ]
    associate_public_ip_address = true

    tags = {
        Name = "binance-collector"
    }

    user_data = file("user_data.yml")
    depends_on = [ module.vpc.vpc_id, module.vpc.igw_id ]

}

module "vpc" {
    source = "github.com/robogeek/terraform-aws-modules//modules/vpc-simple"
    vpc_name = "vpc-bc"
    vpc_cidr = "10.0.0.0/16"
    public_cidr = "10.0.1.0/24"
    private_cidr = "10.0.2.0/24"
}

resource "aws_security_group" "ec2-bc" {
  name        = "security-group-bc"
  description = "allow inbound access"
  vpc_id      = module.vpc.vpc_id

  ingress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
