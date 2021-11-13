SECTION "main", ROM0[$0]

Main::
    ld sp, $FFFE    ; init stack
    di              ; interrupts are not needed in the boot

    xor a           ; zeroing a   

    ld hl, $8000    ; vram address
    ld bc, $2000    ; vram size        
    call .memset    ; init vram

    ld hl, $C000    ; ram address
    ld bc, $2000    ; ram size
    call .memset    ; init ram
 
    ld hl, $FE00    ; OAM adress
    ld bc, $00A0    ; OAM size
    call .memset    ; init oam

    ld hl, $9903
    ld de, $9923
    ld b, 29
    ld a, 1
    call .setTilemap
    
    ld hl, $8010
    ld bc, .encodedTileDataStart
    ld d, .encodedTileDataEnd - .encodedTileDataStart
    call .decodeLogoToVram

    ; turn on the lcd
    ld a, %11111100
    ld [$ff47], a
    ld a, %10010001 ; Turn lcd and BG on
    ld [$ff40], a

    .loop:
        halt
        jr .loop

    jp .finishBoot

    ; mut hl - start address of the tilemap
    ; mut de - second start address
    ; mut a - start index for the tiles
    ; const b - max index of the tiles
    .setTilemap
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
        jr nz, .setTilemap
        .return
            ret

    ; mut hl - dst (address to set)
    ; mut bc - len (non zero length)
    ; const a - val (value to set)
    .memset:
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
            jr .memset
    
    ; mut hl - dst (address to copy to)
    ; mut bc - src (adress to copy from)
    ; mut de - len (length of src to copy to dst)
    .memcpy:
        ld a, [bc]
        inc bc
        ldi [hl], a
        dec de
        ; detect if de is zero
        xor a
        cp a, e
        jr nz, .memcpy
        cp a, d
        jr nz, .memcpy
        ret
    
    ; mut hl - pointer to vram
    ; mut bc - pointer to encoded data
    ; mut d - encoded data length
    .decodeLogoToVram:
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
        jr nz, .decodeLogoToVram
        ret
        

    .encodedTileDataStart:
        db $ce,$ff,$dd,$c0,$37,$ff,$bb,$30,$00,$70,$34,$30,$00,$8d,$dd,$c0
        db $00,$f9,$9f,$1f,$00,$9b,$bb,$90,$00,$e3,$f0,$f0,$00,$67,$66,$60
        db $00,$c6,$66,$60,$fc,$cf,$cc,$f0,$8c,$c9,$dd,$80,$00,$f9,$99,$f0
        db $00,$33,$b9,$01,$00,$33,$3e,$c8
    .encodedTileDataEnd

    ds $100 - 4 - @, 0 ; filling the bootrom with 0

    ; writing to the bootrom register turning the boot off
    .finishBoot:
        ld a, 1
        ld [$ff50], a