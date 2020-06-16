provider "aws" {
  region                  = "ap-south-1"
  profile                 = "pratima"
}

//to create private key-pairs
resource "tls_private_key" "mytaskkey" {
    algorithm   =  "RSA"
    rsa_bits    =  4096
}
resource "local_file" "private_key" {
    content         =  tls_private_key.mytaskkey.private_key_pem
    filename        =  "mytaskkey.pem"
    file_permission =  0400
}
resource "aws_key_pair" "mytaskkey" {
    key_name   = "mytaskkey"
    public_key = tls_private_key.mytaskkey.public_key_openssh
}


//to create security group
resource "aws_security_group" "mysecurity" {
  name        = "mysecurity"
  description = " security"

 ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mysecurity"
  }
}

//to create ec2-instance
resource "aws_instance" "mytask_instance" {
  ami           = "ami-0447a12f28fddb066"
  instance_type = "t2.micro"
  key_name = "mytaskkey"
  security_groups = [ "mysecurity" ]
  
connection {
 type = "ssh"
 user = "ec2-user"
 private_key = tls_private_key.mytaskkey.private_key_pem
 host = aws_instance.mytask_instance.public_ip
}
provisioner"remote-exec"{
inline=[
  "sudo yum install httpd php git -y",
  "sudo systemctl restart httpd",
  "sudo systemctl enable httpd",
]
}
tags = {
    Name = "mytask_instance"
  }
}

//to create volume
resource "aws_ebs_volume" "ebstask" {
  availability_zone = aws_instance.mytask_instance.availability_zone
  size              = 1
 
  tags = {
    Name = "ebstask"
   }
}

//to attach volume
resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.ebstask.id
  instance_id = aws_instance.mytask_instance.id
}


//to format,mount and store code in github
resource "null_resource" "format_git" {  
   connection {  
           type = "ssh"  
           user = "ec2-user"  
           private_key = tls_private_key.mytaskkey.private_key_pem
           host = aws_instance.mytask_instance.public_ip 
   }
   provisioner "remote-exec" {  
   inline = [     
              "sudo mkfs -t ext4 /dev/xvdf1",   
              "sudo mount /dev/xvdf1  /var/www/html",   
              "sudo rm -rf /var/www/html/*",    
              "sudo git clone https://github.com/pratimajain/task1_cloud_computing0828.git /var/www/html/", 
            ]  
   }  
   depends_on = ["aws_volume_attachment.ebs_att"]
}

//to create s3 bucket
resource "aws_s3_bucket" "smurfs" {
  bucket = "smurfs0828"
  acl    = "public-read"
  force_destroy = true
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST"]
    allowed_origins = ["https://smurfs"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}




