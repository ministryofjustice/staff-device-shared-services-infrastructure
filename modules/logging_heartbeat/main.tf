data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id            = data.aws_vpc.default.id
}

data "aws_subnet" "default" {
  count = length(data.aws_subnet_ids.default.ids)
  id    = tolist(data.aws_subnet_ids.default.ids)[count.index]
}

resource "aws_cloudwatch_log_group" "logging_heartbeat_pre_production" {
  name = "logging-heartbeat-pre-production"

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "logging_heartbeat_development" {
  name = "logging-heartbeat-development"

  tags = var.tags
}

resource "aws_instance" "logging_heartbeat" {
  ami           = "ami-032598fcc7e9d1c7a"
  instance_type = "t2.micro"
  subnet_id                   = data.aws_subnet.default[0].id
  monitoring                  = true
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.logging_heartbeat.id

  instance_initiated_shutdown_behavior = "terminate"

  user_data = <<DATA
  #!/bin/bash -xe
  yum install perl-Switch perl-DateTime perl-Sys-Syslog perl-LWP-Protocol-https -y
  yum -y install perl-Digest-SHA perl-URI perl-libwww-perl perl-MIME-tools perl-Crypt-SSLeay perl-XML-LibXML unzip curl awslogs jq
  mkdir -p /home/ec2-user/scripts
  cd /home/ec2-user/scripts
  curl https://aws-cloudwatch.s3.amazonaws.com/downloads/CloudWatchMonitoringScripts-1.2.2.zip -O
  unzip CloudWatchMonitoringScripts-1.2.2.zip
  rm CloudWatchMonitoringScripts-1.2.2.zip
  mv aws-scripts-mon /home/ec2-user/scripts/mon

  touch /var/log/heartbeat-development
  touch /var/log/heartbeat-pre-production

cat > /etc/awslogs/awslogs.conf << EOF
[general]
state_file = /var/lib/awslogs/agent-state

[/var/log/heartbeat-development]
file = /var/log/heartbeat-development
log_group_name = logging-heartbeat-development
log_stream_name = {instance_id}/{hostname}
datetime_format = %b %d %H:%M:%S

[/var/log/heartbeat-pre-production]
file = /var/log/heartbeat-pre-production
log_group_name = logging-heartbeat-pre-production
log_stream_name = {instance_id}/{hostname}
datetime_format = %b %d %H:%M:%S
EOF

  region=eu-west-2
  sed -i -e "s/region = us-east-1/region = $region/g" /etc/awslogs/awscli.conf
  systemctl start awslogsd
  systemctl enable awslogsd.service

  while true; do
    echo "Hello from the Prison Technology Transformation Programme Shared Services" >> /var/log/heartbeat-development
    echo "Hello from the Prison Technology Transformation Programme Shared Services" >> /var/log/heartbeat-pre-production
    sleep 60
  done
DATA

  tags = {
    Name = "Heartbeat instance"
  }
}