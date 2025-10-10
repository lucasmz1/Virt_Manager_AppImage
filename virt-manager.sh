#!/bin/bash
sudo apt-get install desktop-file-utils debootstrap schroot perl git wget xz-utils bubblewrap autoconf coreutils
wget -q "https://github.com/pkgforge-dev/appimagetool-uruntime/releases/download/continuous/appimagetool-x86_64.AppImage" -O appimagetool && chmod a+x appimagetool
wget -c "https://archive.archlinux.org/iso/"
wget -c "https://github.com/xplshn/pelf/releases/download/190/pelf_x86_64" -o pelf && chmod a+x pelf
cat index.html | tail -n 3 | awk '{print $2}' | cut -d "/" -f 1 | cut -d "\"" -f 2 | xargs -i -t -exec wget -r --no-parent np -l 1 -A "*.zst" -erobots=off -P . "https://archive.archlinux.org/iso/{}/archlinux-bootstrap-x86_64.tar.zst"
find ${GITHUB_WORKSPACE} -name '*.zst' | xargs -i -t -exec mv {} ${GITHUB_WORKSPACE}
mkdir arch
tar xf archlinux-bootstrap-x86_64.tar.zst -C ./arch/
# criar no github uma nova pasta parao AppRun e demais arquivos.
cp /etc/resolv.conf -t ${GITHUB_WORKSPACE}/arch/root.x86_64/etc/ && cp ${GITHUB_WORKSPACE}/mirrorlist -t ${GITHUB_WORKSPACE}/arch/root.x86_64/etc/pacman.d/ && cp ${GITHUB_WORKSPACE}/chaotic-mirrorlist -t ${GITHUB_WORKSPACE}/arch/root.x86_64/etc/pacman.d/ && cp ${GITHUB_WORKSPACE}/pacman.conf -t ${GITHUB_WORKSPACE}/arch/root.x86_64/etc/
cd ${GITHUB_WORKSPACE}
sudo chroot ./arch/root.x86_64/ /bin/bash -c "pacman -Syyu --noconfirm && pacman -S --noconfirm libpng libjpeg-turbo giflib libtiff librsvg webp libheif libavif gdk-pixbuf2 dnsmasq bridge-utils openbsd-netcat virt-manager-git swtpm dnsmasq virtiofsd qemu-full jack2 --noconfirm && pacman -Scc --noconfirm && rm -rf /var/cache/pacman/pkg/* && sed -i '17,$ {/^[#] *[a-zA-Z]/s/^# *//}' /etc/locale.gen && locale-gen"
wget -c "https://github.com/lucasmz1/bubblewrap-musl-static/releases/download/7f9bc5f/bwrap-x86_64" && mv bwrap-x86_64 bwrap && chmod +x bwrap && mv bwrap ./arch/
cp ${GITHUB_WORKSPACE}/AppRun ${GITHUB_WORKSPACE}/arch/
chmod a+x ${GITHUB_WORKSPACE}/arch/AppRun 
cp ${GITHUB_WORKSPACE}/virt-manager.desktop -t ${GITHUB_WORKSPACE}/arch/ 
cp ${GITHUB_WORKSPACE}/virt-manager.png -t ${GITHUB_WORKSPACE}/arch/
mv ${GITHUB_WORKSPACE}/arch/root.x86_64/  ${GITHUB_WORKSPACE}/arch/root/
ARCH=x86_64 ./appimagetool -n ./arch/
##sh -c './pelf -d --add-appdir "./arch/" --appbundle-id "Virt-Manager-lucasmz1" --output-to "Virt-Manager.dwf.AppBundle"'
