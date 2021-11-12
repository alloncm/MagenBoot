SECTION "main", ROM0[$0]

Main::
    ld sp, $FFFE    ; init stack
    di              ; interrupts are not needed in the boot

    xor a           ; zeroing a   

    ld hl, $8000    ; vram address
    ld bc, $2000    ; vram size        
    call .memset    ; init vram

    ld hl, $A000    ; ram address
    ld bc, $2000    ; ram size
    call .memset    ; init ram
 
    ld hl, $FE00    ; OAM adress
    ld bc, $00A0    ; OAM size
    call .memset    ; init oam

    ld hl, $9000    ; Tile data address
    ld bc, .tile_start
    ld de, .tile_end - .tile_start
    call .memcpy

    ; turn on the lcd
    ld a, %10000001 ; Turn lcd and BG on
    ld [$ff40], a

    .loop:
        halt
        jr .loop

    jp .finishBoot

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
    
    .tile_start
        dw $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    .tile_end

    ds $100 - 4 - @, 0 ; filling the bootrom with 0

    ; writing to the bootrom register turning the boot off
    .finishBoot:
        ld a, 1
        ld [$ff50], a