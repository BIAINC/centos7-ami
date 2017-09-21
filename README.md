# CentOS 7 AMI Builder Script
This repository includes a build script for a CentOS 7 AMI.
1. Minimal Packages
2. SELinux - Configured in permissive mode
3. Partition Scheme Compatible with CIS Benchmarks for Centos
  - 1MB Boot Loader (Not Mounted)
  - 4GB Root        (/)
  - 2GB Swap        (None)
  - 4GB Home        (/home)
  - 1GB log         (/var/log)
  - 1GB audit       (/var/log/audit)
  - 4GB var         (/var)

## Usage
1. Start an existing Centos Images and Attach a 16GB volume to `sdb`
2. Copy build.sh
3. Execute `sudo sh build.sh`
4. Shutdown the instance
5. Take a snapshot of the 16GB volume
6. Register the AMI
`aws --region us-east-1 --profile terraformrole ec2 register-image --name 'CentOS-7.0-test' --description 'Centos7 Master Beta' --virtualization-type hvm --root-device-name /dev/sda1 --block-device-mappings '[{"DeviceName":"/dev/sda1","Ebs": { "SnapshotId": "snap-06637969bf4557d79", "VolumeSize":16,  "DeleteOnTermination": true, "VolumeType": "gp2"}}, { "DeviceName":"/dev/xvdb","VirtualName":"ephemeral0"}, { "DeviceName":"/dev/xvdc","VirtualName":"ephemeral1"}]' --architecture x86_64 --sriov-net-support simple --ena-support`

# Centos 7 AMI Customizer (Packer)

