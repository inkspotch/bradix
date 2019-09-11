
SOURCES=boot.o main.o common.o monitor.o

CFLAGS=-m32 -nostdlib -nostdinc -fno-builtin -fno-stack-protector
LDFLAGS=-Tlink.ld -m elf_i386
ASFLAGS=-felf

all: build

build: 
	docker run --rm --name dev-build \
		--mount type=bind,source="`pwd`",target=/build \
		-w="/build" \
		dev make os.iso

write_disk:
	dd if=/dev/zero of=boot.img bs=1024 count=1440
	dd if=kernel of=boot.img bs=1 count=512 conv=notrunc

clean:
	rm -f *.o kernel.elf os.iso

kernel.elf: $(SOURCES)
	ld $(LDFLAGS) -o $@ ${SOURCES}

.s.o:
	nasm $(ASFLAGS) $<

os.iso: kernel.elf
#	docker run --rm --name dev-build \
#                --mount type=bind,source="`pwd`",target=/build \
#                -w="/build" \
#                dev genisoimage -R                              
	mv kernel.elf iso/boot/kernel.elf
	genisoimage -R \
                -b boot/grub/stage2_eltorito    \
                -no-emul-boot                   \
                -boot-load-size 4               \
                -A os                           \
                -input-charset utf8             \
                -quiet                          \
                -boot-info-table                \
                -o $@                           \
                iso

.PHONY: docker_image
docker_image:
	docker build -t dev -f Dockerfile .
