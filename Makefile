default: binary

binary: kernel.asm
	nasm -f bin -o kernel.bin kernel.asm

floppy:	binary
	dd status=noxfer conv=notrunc if=kernel.bin of=kernel.flp

