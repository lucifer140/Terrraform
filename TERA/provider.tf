#this is for default region
provider "aws" {
region = "ap-east-1"

}


#this is for another VPC with different region 
#everytime you have to include this provider for making
#other resources for this VPC
provider "aws" {
region = "ap-southeast-3"
alias = "accept"
}
