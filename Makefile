RGBASM = rgbasm
RGBLINK = rgblink

RM_F =
ifeq ($(OS), Windows_NT)
	RM_F = Del
else
	RM_F = rm -f
endif

ASMFLAGS = -h
LINKFLAGS = -x

SRC_DIR = src

TARGET = dmg_boot

$(TARGET).bin: $(TARGET).o
	$(RGBLINK) ${LINKFLAGS} -o $@ $^

$(TARGET).o: $(SRC_DIR)/bootrom.asm
	$(RGBASM) $(ASMFLAGS) -o $@ $^

.PHONY: clean
clean:
	$(RM_F) *.o