SECTION "main", ROM0[$0]

; turn on the lcd
ld a, $80
ld [$ff00+$40], a

ds $100 - 4 - @, 0 ; filling the bootrom with 0

; writing to the bootrom register turning the boot off
ld a, 1
ld [$ff00+$50], a