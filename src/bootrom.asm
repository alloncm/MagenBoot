INCLUDE "hardware.inc"

DEF WAIT_LEN equ 2
DEF SCROLL_LEN equ 10

SECTION "main", ROM0[$0]

Main::
    ld sp, $FFFE    ; init stack
    di              ; interrupts are not needed in the boot

    xor a           ; zeroing a   

    ld hl, $8000    ; vram address
    ld bc, $2000    ; vram size        
    call Memset    ; init vram

    ld hl, $9A43
    ld de, $9A63
    ld b, 29
    ld a, 1
    call SetTilemap
    
    ld hl, $8010
    ld bc, EncodedTileData.start
    ld d, EncodedTileData.end - EncodedTileData.start
    call DecodeLogoToVram

    ; turn on the lcd
    ld a, %11111100
    ld [$ff47], a
    ld a, %10010001 ; Turn lcd and BG on
    ld [$ff40], a

.scrollLoop
    ld b, SCROLL_LEN    ; wait time
    call Wait
    ld a, [$FF42]
    inc a
    ld [$FF42], a
    cp a, $50
    jr nz, .scrollLoop
     
    ; start sound
    ld a, %01110111 ; left and right max volume
    ld [rNR50], a
    ld a, %10001    ; turn channel 1 on
    ld [rNR51], a
    ld a, $80       ; enable sound
    ld [rNR52], a
    ld a, %10000000 ; normal wave duty and max len
    ld [rNR11], a
    ld a, $F1       ; 0xF volume, volume envelope len 1
    ld [rNR12], a
    ld a, $FF       ; 0xFF low freq 
    ld [rNR13], a
    ld a, %11000110 ; start sound, terminated by len, 0x6 high freq
    ld [rNR14], a

    ld c, WAIT_LEN  ; counter for the wait loop, determines the length of the wait
.waitLoop
    ld b, $FF   ; max wait for Wait proc, 
    call Wait
    dec c
    jr nz, .waitLoop

    jp FinishBoot

; mut b - wait length
Wait:   
    ld a, [$FF44]
    cp a, $90
    jr nz, Wait
    dec b
    jr nz, Wait
    ret

; mut hl - start address of the tilemap
; mut de - second start address
; mut a - start index for the tiles
; const b - max index of the tiles
SetTilemap:
    ldi [hl], a
    inc a
    cp a, b
    jr z, .return
    push hl
    ld h, d
    ld l, e
    ldi [hl], a
    inc a
    ld d, h
    ld e, l
    pop hl
    cp a, b
    jr nz, SetTilemap
.return
    ret

; mut hl - dst (address to set)
; mut bc - len (non zero length)
; const a - val (value to set)
Memset:
    ldi [hl], a
    dec bc
    ; detect if bc is zero and return if so
    ld d, a     ; saves a 
    xor a
    cp a, c
    jr nz, .continue
    cp a, b
    jr nz, .continue

    ld a, d     ; loads a
    ret
.continue:
    ld a, d ; loads a
    jr Memset

; mut hl - dst (address to copy to)
; mut bc - src (adress to copy from)
; mut de - len (length of src to copy to dst)
Memcpy:
    ld a, [bc]
    inc bc
    ldi [hl], a
    dec de
    ; detect if de is zero
    xor a
    cp a, e
    jr nz, Memcpy
    cp a, d
    jr nz, Memcpy
    ret

; mut hl - pointer to vram
; mut bc - pointer to encoded data
; mut d - encoded data length
DecodeLogoToVram:
    push de
    ld a, [bc]
    push bc
    ld d, a
    ld e, a
    ld c, 2
.decodeNibleToByte
    ld b, 4
.mulBit
    rl d
    rla
    rl e
    rla
    dec b
    jr nz, .mulBit
    ld b, 2
.loadValueToVram
    ldi [hl], a
    ld [hl], 0      ; redunant the vram is already zeroed
    inc hl
    dec b
    jr nz, .loadValueToVram
    dec c
    jr nz, .decodeNibleToByte
    pop bc
    pop de
    inc bc
    dec d
    jr nz, DecodeLogoToVram
    ret
    

EncodedTileData:
    .start:
        db $ce,$ff,$dd,$c0,$37,$ff,$bb,$30,$00,$70,$34,$30,$00,$8d,$dd,$c0
        db $00,$f9,$9f,$1f,$00,$9b,$bb,$90,$00,$e3,$f0,$f0,$00,$67,$66,$60
        db $00,$c6,$66,$60,$fc,$cf,$cc,$f0,$8c,$c9,$dd,$80,$00,$f9,$99,$f0
        db $00,$3b,$b9,$01,$00,$33,$3e,$c8
    .end

ds $100 - 4 - @, 0 ; filling the bootrom with 0

; writing to the bootrom register turning the boot off
FinishBoot:
    ld a, 1
    ld [$ff50], a