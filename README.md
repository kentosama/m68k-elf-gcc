# GCC toolchain for the Motorola 68000

This is a set of bash scripts for build gcc toolchain on unix environment for the Motorola 68000 family (m68k) was mainly used in **SEGA Mega Drive**, **SEGA Mega CD**, **SNK NeoGeo**, **Atari ST**, **Amiga** and older computers.

## Build the toolchain

First, you need to install devel environment was come with your Linux distro for build the toolchain. 

**ArchLinux**
```bash
$ sudo pacman -Syu
$ sudo pacman -S base-devel
```

**Debian**
```bash
$ sudo apt update
$ sudo apt install build-essential
```

**Ubuntu**
```bash
$ sudo apt update
$ sudo apt install build-essential
```

**Fedora**
```bash
$ sudo dnf update
$ sudo dnf groupinstall "Development Tools"
$ sudo dnf groupinstall "C Development Tools and Libraries"
```

After, going into your workspace where you want build the toolchain (for example ~/workspace/source) and clone this repository:

```bash
cd ~/workspace/source
git clone https://github.com/kentosama/m68k-elf-gcc.git
cd m68k-elf-gcc
```
Now, you can run **build-toolchain.sh** for start the build. The process should take approximately 15 min or several hours depending on your computer. **Please, don't run this script as root!**

```bash
$ ./buid-toolchain.sh
```

For build the toolchain with the newlib, use the  ```--with-newlib``` argument:

```bash
$ ./build-toolchain.sh --with-newlib
```

For build the toolchain with other processors of the Motrola 68000 family, use the --with-cpu argument:

```bash
$ ./build-toolchain.sh --with-cpu=68000,68030...
```

For change the program prefix, use the --program-prefix argument:

```bash
$ ./build-toolchain.sh --program-prefix=sega-genesis-
```

## Install

Once the SH2 toolchain was successful built, you can process to the installation. Move or copy the "sh2-toolchain" folder in "/opt" or "/usr/local":

```bash
$ sudo cp -R m68k-toolchain /opt
```

If you want, add the SH2 toolchain to your path environment:

```bash
$ echo export PATH="${PATH}:/opt/m68k-toolchain/bin" > ~/.bash_profile
$ source ~/.bash_profile
```

Finally, check that m68k-elf-gcc is working properly:

```bash
$ m68k-elf-gcc -v
```

The result should display something like this:

```bash
Using built-in specs.
COLLECT_GCC=./m68k-elf-gcc
COLLECT_LTO_WRAPPER=/home/kentosama/Workspace/m68-elf-gcc/m68k-toolchain/libexec/gcc/m68k-elf/6.3.0/lto-wrapper
Target: m68k-elf
Configured with: ../../source/gcc-6.3.0/configure --prefix=/home/kentosama/Workspace/m68-elf-gcc/m68k-toolchain --build=x86_64-pc-linux-gnu --host=x86_64-pc-linux-gnu --target=m68k-elf --program-prefix=m68k-elf- --enable-languages=c --enable-obsolete --enable-lto --disable-threads --disable-libmudflap --disable-libgomp --disable-nls --disable-werror --disable-libssp --disable-shared --disable-multilib --disable-libgcj --disable-libstdcxx --disable-gcov --without-headers --without-included-gettext --with-cpu=m68000
Thread model: single
gcc version 6.3.0 (GCC) 
```

For backup, you can store the Motorola 68000 toolchain in external drive:
```bash
$ tar -Jcvf sh2-gcc-6.3.0-toolchain.tar.xz m68k-toolchain
$ mv m68k-gcc-6.3.0-toolchain.tar.xz /storage/toolchains/
```
