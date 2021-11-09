RGBASM = rgbasm
RGBLINK = rgblink

RM_F = rm -f

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