# create your instance
resource "aws_instance" "public_instance" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  associate_public_ip_address = "true"
  key_name = var.key
  tags = {
        Name = "${var.public_instance}"
  }
}
