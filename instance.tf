# Go and grab the latest Windows Server 2012 image from Amazon 
data "aws_ami" "windows" {
  most_recent = true

  filter {
    name   = "name"
    values = ["Windows_Server-2012-R2_RTM-English-64Bit-Base-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["801119661308"] # amazon
}

resource "aws_instance" "windowsec2" {
  ami                         = "${data.aws_ami.windows.id}"
  instance_type               = "t2.small"
  associate_public_ip_address = "true"
  subnet_id                   = "subnet-1a152c53"

  key_name = "${aws_key_pair.mykey.key_name}"

  # Run the powershell command to add a user to the instance
  # Open the firewall port for Remote Desktop
  # Make sure service is set to autostart and started
  user_data = <<EOF
  <powershell>
  net user ${var.INSTANCE_USERNAME} ${var.INSTANCE_PASSWORD} /add
  net localgroup administrators ${var.INSTANCE_USERNAME} /add
  winrm quickconfig -q
  winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="300"}'
  winrm set winrm/config '@{MaxTimeoutms="1800000"}'
  winrm set winrm/config/service '@{AllowUnencrypted="true"}'
  winrm set winrm/config/service/auth '@{Basic="true"}'
  netsh advfirewall firewall add rule name="WinRM 5985" protocol=TCP dir=in localport=5985 action=allow
  netsh advfirewall firewall add rule name="WinRM 5986" protocol=TCP dir=in localport=5986 action=allow
  net stop winrm
  sc.exe config winrm start=auto
  net start winrm
  </powershell>
EOF

  # Copy a file from this machine to the remote machine
  provisioner "file" {
    source      = "test.txt"
    destination = "C:/test.txt"
  }

  # Create a winrmm connection 
  connection {
    type     = "winrm"
    user     = "${var.INSTANCE_USERNAME}"
    password = "${var.INSTANCE_PASSWORD}"
  }

  # Create the standard set of tags
  tags {
    App          = "TerraformWindowStarterApp"
    Name         = "TerraformWindowStarterInstance"
    CreationTime = "${timestamp()}"
  }
}

# Create a key pair in aws
resource "aws_key_pair" "mykey" {
  key_name   = "WindowsLoggingKey"
  public_key = "${file("${var.PATH_TO_PUBLIC_KEY}")}"
}
