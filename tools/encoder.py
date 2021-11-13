# This python script will encode a file of Gameboy tile data in a more compact way
# I wrote it in order to fit my boot screen into the 256 bytes of the bootrom
# Note that this encoding technique is based on that tiles pixels are always in groups of 4 pixels
# And are on even indexes! (like the nintendo boot screen logo in the original bootrom)

import sys

def encode_byte_to_nible(byte:int)->int:
    high = (((byte & 0xF0) >> 4) & 0b0110) << 1
    low = ((byte & 0xF) & 0b0110) >> 1
    return high | low

raw_data = open(sys.argv[1], "rb").read()

if len(raw_data) % 8 != 0:
    raise Exception("Error! payload must be a divisor of 8")

encoded_data = []
for i in range(0, len(raw_data), 8):
    b1 = raw_data[i]
    b2 = raw_data[i+4]
    encoded = (encode_byte_to_nible(b1) << 4) | encode_byte_to_nible(b2)
    encoded_data.append(encoded)

for i in range(0,len(encoded_data)):
    if i % 16 == 0:
        print()
    print(hex(encoded_data[i]),end=' ')