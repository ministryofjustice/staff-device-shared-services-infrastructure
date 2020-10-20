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

resource "aws_instance" "logging_heartbeat" {
  ami           = "ami-032598fcc7e9d1c7a"
  instance_type = "t2.micro"
  subnet_id                   = data.aws_subnet.default[0].id
  monitoring                  = true
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.logging_heartbeat.id

  instance_initiated_shutdown_behavior = "terminate"

  user_data = <<DATA
Content-Type: multipart/mixed; boundary="==BOUNDARY=="

MIME-Version: 1.0
--==BOUNDARY==
MIME-Version: 1.0
Content-Type: text/cloud-config; charset="us-ascii"
#cloud-config
repo_update: true
repo_upgrade: all

--==BOUNDARY==
MIME-Version: 1.0
Content-Type: text/x-shellscript; charset="us-ascii"
#!/bin/bash
sudo yum install perl-Switch perl-DateTime perl-Sys-Syslog perl-LWP-Protocol-https -y
sudo yum -y install perl-Digest-SHA perl-URI perl-libwww-perl perl-MIME-tools perl-Crypt-SSLeay perl-XML-LibXML unzip curl
mkdir -p /home/ec2-user/scripts
cd /home/ec2-user/scripts
curl https://aws-cloudwatch.s3.amazonaws.com/downloads/CloudWatchMonitoringScripts-1.2.2.zip -O
unzip CloudWatchMonitoringScripts-1.2.2.zip
rm CloudWatchMonitoringScripts-1.2.2.zip
mv aws-scripts-mon /home/ec2-user/scripts/mon
touch /var/log/heartbeat
while true; do echo "Hello from the Prison Technology Transformation Programme" >> /var/log/heartbeat; sleep 1; done &
EOF

--==BOUNDARY==
MIME-Version: 1.0
Content-Type: text/x-shellscript; charset="us-ascii"
#!/bin/bash
# Install awslogs and the jq JSON parser
yum install -y awslogs jq
# Inject the CloudWatch Logs configuration file contents
cat > /etc/awslogs/awslogs.conf <<- EOF
[general]
state_file = /var/lib/awslogs/agent-state
[/var/log/heartbeat]
file = /var/log/heartbeat
log_group_name = Logging-Heartbeat
log_stream_name = {instance_id}/{hostname}
datetime_format = %b %d %H:%M:%S
EOF

--==BOUNDARY==
MIME-Version: 1.0
Content-Type: text/x-shellscript; charset="us-ascii"
#!/bin/bash
region=eu-west-2
sed -i -e "s/region = us-east-1/region = $region/g" /etc/awslogs/awscli.conf
systemctl start awslogsd
systemctl enable awslogsd.service

--==BOUNDARY==
DATA

  tags = {
    Name = "Heartbeat instance"
  }
}