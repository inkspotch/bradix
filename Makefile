
SOURCES=boot.o main.o

CFLAGS=-m32 -nostdlib -nostdinc -fno-builtin -fno-stack-protector
LDFLAGS=-Tlink.ld -m elf_i386
ASFLAGS=-felf

all: build

build: 
	docker run --rm --name dev-build \
		--mount type=bind,source="`pwd`",target=/build \
		-w="/build" \
		dev make link

write_disk:
	dd if=/dev/zero of=boot.img bs=1024 count=1440
	dd if=kernel of=boot.img bs=1 count=512 conv=notrunc

clean:
	-rm -f *.o kernel

link: $(SOURCES)
	ld $(LDFLAGS) -o kernel ${SOURCES}

.s.o:
	nasm $(ASFLAGS) $<
