FROM ubuntu:22.04

RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y tftpd-hpa wget
RUN DEBIAN_FRONTEND=noninteractive apt-get download shim.signed grub-efi-amd64-signed grub-common

RUN wget -P /srv/tftp/ "https://stable.release.flatcar-linux.net/amd64-usr/current/flatcar_production_pxe.vmlinuz"
RUN wget -P /srv/tftp/ "https://stable.release.flatcar-linux.net/amd64-usr/current/flatcar_production_pxe_image.cpio.gz"

RUN dpkg-deb --fsys-tarfile shim-signed*deb | tar x ./usr/lib/shim/shimx64.efi.signed.latest -O > /srv/tftp/bootx64.efi
RUN dpkg-deb --fsys-tarfile grub-efi-amd64-signed*deb | tar x ./usr/lib/grub/x86_64-efi-signed/grubnetx64.efi.signed -O > /srv/tftp/grubx64.efi
RUN dpkg-deb --fsys-tarfile grub-common*deb | tar x ./usr/share/grub/unicode.pf2 -O > /srv/tftp/unicode.pf2

CMD echo -n "Starting " && in.tftpd --version && in.tftpd -L --user tftp -a 0.0.0.0:69 -s -B1468 -v /srv/tftp


