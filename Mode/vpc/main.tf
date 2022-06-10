module "VPC-1" {
  source = "../modules/vpc/"
  cidr_block = "10.0.0.0/16"
  public_subnet = "10.0.0.0/24"


}
module "public_instance" {
  source = "../modules/ec2/"
  key  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDBHzvFLr6+BKI5kww+sehfl2QFCHbhQyJUEFqu4+h5tHITJ4szTkPQQ697RtJB+OQmf4SXU7EDuv6SueS1QWuvQJvCWAa4Sns+1BLr7/SjH0Vl0iSQOtaeyJMNjt0wOxd12Nd4FdrMBq+aDZmp368mkiWdEJ0GpbxayhKNq26LmeP6V6B5tE65G2o2mZsRPGFha1bg3bx4XQEGK2i8gOx8wQFnOxg7EgRx9b0iP5vLRfe4BD/3tSjyOa+vzmmdT+YAr4qHJF4SN4iq63EiXNFDuOP7pKsD11nBBBPFGJQwbzL534A0E1BWjZWrrVhtUaAU9ux64FWBfnEiVM4QqpxdqDqSXEf9FaDsVLUjna5kXew8BZsXL/xtfOsbOtXaGWFoFVeGlws+iHmpAPZ0KfuOT0EtXto6l80D9rPHAH8+23HWdsLRYudOifI9ANzFrubB9jWTVQfBVxh56eZnU2Id9JgM6l6jgo/UybgwCGarFY072fjJq7y8Sd5T2GXzjnU= lucifer@lucifer-Inspiron-3576"
 ami = "ami-079b5e5b3971bd10d"
 instance_type = "t2.micro"
 public_subnet = "10.0.0.0/24"

}


