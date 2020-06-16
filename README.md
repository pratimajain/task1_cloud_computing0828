# task1_cloud_computing0828
cloud_computing task1

*Task description:
1. Create the key and security group which allows the port 80.
2. Launch EC2 instance.
3. In this Ec2 instance use the key and security group which we have created in step 1.
4. Launch one Volume (EBS) and mount that volume into /var/www/html
5. The developer has uploaded the code into GitHub repo also the repo has some images.
6. Copy the GitHub repo code into /var/www/html
7. Create S3 bucket, and copy/deploy the images from GitHub repo into the s3 bucket and change the permission to public readable.
8. Create a Cloudfront using s3 bucket(which contains images) and use the Cloudfront URL to update in code in /var/www/html

* Prerequisites:-
Account on aws
To make new account/login :- https://aws.amazon.com/console/

aws cliv2 download

To download :- https://awscli.amazonaws.com/AWSCLIV2.msi

Terraform download

To download:- https://releases.hashicorp.com/terraform/0.12.26/terraform_0.12.26_windows_amd64.zip

* Terms Used
Instance:-  launched Amazon Linux 2 AMI (HVM), SSD Volume Type 64 bit used t2 micro which has 1 CPU power and 8 GB Ebs storage and memory of 1 GB provide a tag for it.

S3 bucket:- S3 bucket is used to store the data that can be audio, video, documents, etc

Key pair:- created a key pair to enable the terraform code to run this file.

Security group:- in a security group that enabled port 22 for SSH and port 80 HTTP.

Cloud Front:- Amazon CloudFront is a content delivery network (CDN) offered by Amazon Web Services. 
Content delivery networks provide a globally-distributed network of proxy servers which cache content, such as web videos or other bulky media, 
more locally to consumers, thus improving access speed for downloading the content.

*Commands of terraform to run the code:-

terraform init. :it is necessary to download the required plugins.
terraform validate : To check the validation of our code.
terraform apply -auto-aprove : To run the terraform code.

#cd Desktop
#cd cd tera
#cd mytask
#notepad task.tf
#terraform init
#terraform validate
#terraform apply -auto-approve

*CONCLUSION:

We have launched a website using amazon Services- EC2+EBS+S3+CloudFront. 
Above, we have created a web server using EC2 attached EBS volume then formated and mounted volume.
Also, I created an S3 bucket and uploaded images from the Github repository and uploaded it on the s3 bucket. 
Created CloudFront distribution for the S3 bucket. 
Cloned git repository into document root i.e /var/www/html also created file with CloudFront URL.




