output "site_url" {
  value = "http://${aws_instance.site.public_ip}/"
}

output "ssh" {
  value = "ssh -i ~/.ssh/lab-key.pem ec2-user@${aws_instance.site.public_ip}"
}
