SECTION "main", ROM0[$0]

; init stack
ld sp, $FFFE

; init vram
ld hl, $8000    ; vram address
ld bc, $2000    ; vram size
xor a           ; zeroing a           
call Memset

; init ram
ld hl, $A000    ; ram address
ld bc, $2000    ; ram size
call Memset     ; a is alrady 0

; init oam
ld hl, $FE00    ; OAM adress
ld c, $A0       ; OAM size, since 0xA0 is smaller than 0xFF no need to set the whole register
call Memset

; turn on the lcd
ld a, $80
ld [$ff00+$40], a

jp FinishBoot

; hl - address to set
; bc - non zero length
; a - value to set
Memset:
    ldi [hl], a
    dec bc
    jr nz, Memset
    ret

ds $100 - 4 - @, 0 ; filling the bootrom with 0

; writing to the bootrom register turning the boot off
FinishBoot:
    ld a, 1
    ld [$ff00+$50], a