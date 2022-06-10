provider "aws" {
region = "eu-west-3"

}


#this is for another VPC with different region
#everytime you have to include this provider for making
#other resources for this VPC
provider "aws" {
region = "eu-north-1"
alias = "peer"
}

