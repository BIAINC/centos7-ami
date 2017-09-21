set -euxo pipefail

DEVICE=/dev/xvdb
ROOTFS=/rootfs
RELEASE_RPM=http://mirrors.kernel.org/centos/7/os/x86_64/Packages/centos-release-7-4.1708.el7.centos.x86_64.rpm
ENA_VER=1.3.0

# Update both of the below together
IXGBEVF_VER=4.2.1
IXGBEVF_URI=https://downloadmirror.intel.com/18700/eng/ixgbevf-4.2.1.tar.gz

# Initialize the block device
parted ${DEVICE} --script \
  mktable gpt \
  mkpart primary ext2 1 2 \
  set 1 bios_grub on \
  mkpart primary xfs 2 4002 \
  mkpart primary linux-swap 4002 6001\
  mkpart primary xfs 6001 10001 \
  mkpart primary xfs 10001 11001 \
  mkpart primary xfs 11001 12001 \
  mkpart primary xfs 12001 100%

# Wait for the OS to recognize the new partitions
partprobe --summary ${DEVICE}

# Format Partitions
mkfs.xfs -f -L root ${DEVICE}2
mkswap -L swap ${DEVICE}3
mkfs.xfs -f -L home ${DEVICE}4
mkfs.xfs -f -L log ${DEVICE}5
mkfs.xfs -f -L audit ${DEVICE}6
mkfs.xfs -f -L var ${DEVICE}7

# Mount Volumes
mount ${DEVICE}2 ${ROOTFS}/
mkdir ${ROOTFS}/home
mount ${DEVICE}4 ${ROOTFS}/home
mkdir ${ROOTFS}/var
mount ${DEVICE}7 ${ROOTFS}/var
mkdir ${ROOTFS}/var/log
mount ${DEVICE}5 ${ROOTFS}/var/log
mkdir ${ROOTFS}/var/log/audit
mount ${DEVICE}6 ${ROOTFS}/var/log/audit

# Intialize the root filesystem
rpm --root=$ROOTFS --initdb
rpm --root=$ROOTFS -ivh $RELEASE_RPM
yum --installroot=$ROOTFS install -y kernel
yum --installroot=$ROOTFS -y groupinstall core

# Configure chroot environment mount poings
touch ${ROOTFS}/etc/resolv.conf
BINDMNTS="dev sys etc/hosts etc/resolv.conf"
for d in $BINDMNTS ; do
  mount --bind /${d} ${ROOTFS}/${d}
done
mount -t proc none ${ROOTFS}/proc

# Customize packages
chroot $ROOTFS yum -y install openssh-server grub2 acpid tuned epel-release openssl
chroot $ROOTFS yum -C -y remove NetworkManager --setopt="clean_requirements_on_remove=1"
chroot $ROOTFS yum -y install cloud-init cloud-utils-growpart gdisk dkms make perl gcc kernel-devel \
  auditd perl curl wget net-tools vim-minimal bzip2 bind-utils selinux-policy-targeted
chroot $ROOTFS yum remove -y aic94xx-firmware alsa-firmware alsa-lib alsa-tools-firmware \
biosdevname iprutils ivtv-firmware iwl100-firmware iwl1000-firmware iwl105-firmware iwl135-firmware \
iwl2000-firmware iwl2030-firmware iwl3160-firmware iwl3945-firmware iwl4965-firmware iwl5000-firmware \
iwl5150-firmware iwl6000-firmware iwl6000g2a-firmware iwl6000g2b-firmware iwl6050-firmware iwl7260-firmware \
libertas-sd8686-firmware libertas-sd8787-firmware libertas-usb8388-firmware iwl7265-firmware plymouth \
firewalld postfix linux-firmware mariadb-libs
chroot ${ROOTFS} yum clean all -y

# Configure networking

#  Basic network settings
cat > ${ROOTFS}/etc/sysconfig/network << END
NETWORKING=yes
NOZEROCONF=yes
GATEWAYDEV=eth0
END

#  Autostart the first 10 network devices
cat > ${ROOTFS}/etc/sysconfig/network-scripts/ifcfg-eth0  << END
DEVICE=eth0
ONBOOT=yes
BOOTPROTO=dhcp
PERSISTENT_DHCLIENT=1
END

# Filesystems
cat > ${ROOTFS}/etc/fstab << END
LABEL=root    /                   xfs     defaults,relatime                     0 1
LABEL=swap    none                swap    defaults                              0 0
LABEL=home    /home               xfs     defaults,relatime,nodev               0 2
LABEL=var     /var                xfs     defaults,relatime                     0 2
LABEL=log     /var/log            xfs     defaults,relatime,nosuid,nodev,noexec 0 2
LABEL=audit   /var/log/audit      xfs     defaults,relatime,nosuid,nodev,noexec 0 2
tmpfs         /dev/shm            tmpfs   defaults,relatime,nosuid,nodev,noexec 0 0
tmpfs         /tmp                tmpfs   defaults,relatime,nosuid,nodev,noexec 0 0
tmpfs         /var/tmp            tmpfs   defaults,relatime,nosuid,nodev,noexec 0 0
devpts        /dev/pts            devpts  gid=5,mode=620                        0 0
sysfs         /sys                sysfs   defaults                              0 0
proc          /proc               proc    defaults                              0 0
END

# Grub Boot

cat > ${ROOTFS}/etc/default/grub << END
GRUB_TIMEOUT=1
GRUB_DEFAULT=saved
GRUB_DISABLE_SUBMENU=true
GRUB_TERMINAL="serial console"
GRUB_CMDLINE_LINUX="crashkernel=auto console=ttyS0,115200 console=tty0 net.ifnames=0 biosdevname=0 audit=1"
GRUB_DISABLE_RECOVERY="true"
GRUB_SERIAL_COMMAND="serial --speed=115200"
END


echo 'RUN_FIRSTBOOT=NO' > ${ROOTFS}/etc/sysconfig/firstboot

# Configure IXGBEVF Drivers
KVER=$(chroot $ROOTFS rpm -q kernel | sed -e 's/^kernel-//')
curl  -L -o /tmp/ixgbe_${IXGBEVF_VER}.tar.gz ${IXGBEVF_URI}
mkdir ${ROOTFS}/usr/src/ixgbevf-${IXGBEVF_VER}
tar --strip-components=1 -C ${ROOTFS}/usr/src/ixgbevf-${IXGBEVF_VER} -xvzf /tmp/ixgbe_${IXGBEVF_VER}.tar.gz

cat > ${ROOTFS}/usr/src/ixgbevf-${IXGBEVF_VER}/dkms.conf << END
PACKAGE_NAME="ixgbevf"
PACKAGE_VERSION="${IXGBEVF_VER}"
CLEAN="cd src/; make clean"
MAKE="cd src/; make BUILD_KERNEL=\${kernelver}"
BUILT_MODULE_LOCATION[0]="src/"
BUILT_MODULE_NAME[0]="ixgbevf"
DEST_MODULE_LOCATION[0]="/updates"
DEST_MODULE_NAME[0]="ixgbevf"
AUTOINSTALL="yes"
END

chroot $ROOTFS dkms add -m ixgbevf -v ${IXGBEVF_VER}
chroot $ROOTFS dkms build -m ixgbevf -v ${IXGBEVF_VER} -k $KVER
chroot $ROOTFS dkms install -m ixgbevf -v ${IXGBEVF_VER} -k $KVER

echo "options ixgbevf InterruptThrottleRate=1,1,1,1,1,1,1,1" > ${ROOTFS}/etc/modprobe.d/ixgbevf.conf


# Configure ENA Drivers
KVER=$(chroot $ROOTFS rpm -q kernel | sed -e 's/^kernel-//')
curl  -L -o /tmp/ena_linux_${ENA_VER}.tar.gz https://github.com/amzn/amzn-drivers/archive/ena_linux_${ENA_VER}.tar.gz
mkdir ${ROOTFS}/usr/src/ena-${ENA_VER}
tar --strip-components=1 -C ${ROOTFS}/usr/src/ena-${ENA_VER} -xvzf /tmp/ena_linux_${ENA_VER}.tar.gz

cat > ${ROOTFS}/usr/src/ena-${ENA_VER}/dkms.conf << END
PACKAGE_NAME="ena"
PACKAGE_VERSION="${ENA_VER}"
CLEAN="make -C kernel/linux/ena clean"
MAKE="make -C kernel/linux/ena/ BUILD_KERNEL=\${kernelver}"
BUILT_MODULE_NAME[0]="ena"
BUILT_MODULE_LOCATION="kernel/linux/ena"
DEST_MODULE_LOCATION[0]="/updates"
DEST_MODULE_NAME[0]="ena"
AUTOINSTALL="yes"
END

chroot $ROOTFS dkms add -m ena -v ${ENA_VER}
chroot $ROOTFS dkms dkms build -m ena -v ${ENA_VER} -k ${KVER}
chroot $ROOTFS dkms install -m ena -v ${ENA_VER} -k ${KVER}

# Install the bootloader
chroot ${ROOTFS} grub2-mkconfig -o /boot/grub2/grub.cfg
chroot ${ROOTFS} grub2-install $DEVICE

# Setup Services
chroot ${ROOTFS} systemctl enable sshd.service
chroot ${ROOTFS} systemctl enable cloud-init.service
chroot ${ROOTFS} systemctl mask tmp.mount
chroot ${ROOTFS} systemctl mask swap.swap
chroot ${ROOTFS} systemctl enable auditd
chroot ${ROOTFS} systemctl enable crond
chroot ${ROOTFS} systemctl disable kdump

# Disable SELinux
cat > ${ROOTFS}/etc/sysconfig/selinux << END
# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#       enforcing - SELinux security policy is enforced.
#       permissive - SELinux prints warnings instead of enforcing.
#       disabled - SELinux is fully disabled.
SELINUX=permissive
# SELINUXTYPE= type of policy in use. Possible values are:
#       targeted - Only targeted network daemons are protected.
#       strict - Full SELinux protection.
SELINUXTYPE=targeted

# SETLOCALDEFS= Check local definition changes
SETLOCALDEFS=0
END

# Configure cloud-init
cat > ${ROOTFS}/etc/cloud/cloud.cfg << END
users:
 - default

disable_root: true
ssh_pwauth:   true
resize_rootfs: false
mount_default_fields: [~, ~, 'auto', 'defaults,nofail', '0', '2']
resize_rootfs_tmp: /dev
ssh_svcname: sshd
ssh_deletekeys:   True
ssh_genkeytypes:  [ 'rsa', 'ecdsa', 'ed25519' ]
syslog_fix_perms: ~

cloud_init_modules:
 - migrator
 - bootcmd
 - write-files
 - growpart
 - resizefs
 - set_hostname
 - update_hostname
 - update_etc_hosts
 - rsyslog
 - users-groups
 - ssh

cloud_config_modules:
 - disk_setup
 - mounts
 - locale
 - set-passwords
 - yum-add-repo
 - package-update-upgrade-install
 - timezone
 - puppet
 - chef
 - salt-minion
 - mcollective
 - disable-ec2-metadata
 - runcmd

cloud_final_modules:
 - rightscale_userdata
 - scripts-per-once
 - scripts-per-boot
 - scripts-per-instance
 - scripts-user
 - ssh-authkey-fingerprints
 - keys-to-console
 - phone-home
 - final-message

system_info:
  default_user:
    name: centos
    lock_passwd: true
    gecos: Cloud User
    groups: [wheel, adm, systemd-journal]
    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
    shell: /bin/bash
  distro: rhel
  paths:
    cloud_dir: /var/lib/cloud
    templates_dir: /etc/cloud/templates
  ssh_svcname: sshd

mounts:
 - [ swap, none, swap, sw, "0", "0" ]

datasource_list: [ Ec2, None ]

# vim:syntax=yaml
END

# Clean the slack space
set +o pipefail
PARTITIONS=$(mount|grep rootfs|grep xfs| grep -v xvda1| awk '{print $3}'| sort -r)
for p in $PARTITIONS ; do
  echo "Cleaning whitespace for $p"
  count=$(df --sync -kP $p | tail -n1 | awk -F ' ' '{print $4}')
  dd if=/dev/zero of=$p/whitespace bs=1M count=$count || echo "dd exit code $? is suppressed";
  rm -f $p/whitespace
done
set -o pipefail

for p in $PARTITIONS ; do
  umount $p
end

# We're done!
for d in $BINDMNTS ; do
  umount ${ROOTFS}/${d}
done

# Snapshot the volume then create the AMI with:
# aws ec2 register-image --name 'CentOS-7.0-test' --description 'Unofficial CentOS7 + cloud-init' --virtualization-type hvm --root-device-name /dev/sda1 --block-device-mappings '[{"DeviceName":"/dev/sda1","Ebs": { "SnapshotId": "snap-7f042d5f", "VolumeSize":5,  "DeleteOnTermination": true, "VolumeType": "gp2"}}, { "DeviceName":"/dev/xvdb","VirtualName":"ephemeral0"}, { "DeviceName":"/dev/xvdc","VirtualName":"ephemeral1"}]' --architecture x86_64 --sriov-net-support simple --ena-support

