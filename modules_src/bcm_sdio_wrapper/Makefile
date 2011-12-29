PWD       := $(shell pwd)

EXTRA_LDFLAGS := -s

bcmsdio-objs	:= bcm_sdio.o

obj-m    := bcmsdio.o

default:
	$(MAKE) -C $(KERNELDIR) SUBDIRS=$(PWD) modules

clean:
        $(MAKE) -C $(KERNELDIR) SUBDIR=$(PWD) clean

modules:
$(warning executing $(MAKE) -C $(KERNELDIR) SUBDIR=$(PWD) modules)
        $(MAKE) -C $(KERNELDIR) SUBDIR=$(PWD) modules

modules_install:
        $(MAKE) -C $(KERNELDIR) SUBDIR=$(PWD) modules_install

clean:
	rm -rf *.o *.ko
