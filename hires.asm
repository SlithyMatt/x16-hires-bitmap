.org $080D
.segment "STARTUP"
.segment "INIT"
.segment "ONCE"
.segment "CODE"

   jmp start

.include "x16.inc"

pal_fn:
.byte "pal.bin"
end_pal_fn:
PAL_FN_LENGTH = end_pal_fn - pal_fn

BITMAP_VRAM = $00000

bitmap_fn:
.byte "bitmap.bin"
end_bitmap_fn:
BITMAP_FN_LENGTH = end_bitmap_fn - bitmap_fn


start:
   ; configure Display Composer
   lda #$02
   sta VERA_ctrl        ; set DC_SEL to 1
   lda #20
   sta VERA_dc_vstart   ; set VSTART to 40
   lda #220
   sta VERA_dc_vstop    ; set VSTOP to 440
   stz VERA_ctrl        ; reset DC_SEL

   ; configure VRAM Layer 1
   lda #$06
   sta VERA_L1_config   ; 4bpp bitmap
   lda #((BITMAP_VRAM >> 9) | $01)
   sta VERA_L1_tilebase ; 640-pixel-wide, starting at BITMAP_VRAM

   ; load palette
   lda #1
   ldx #8
   ldy #0
   jsr SETLFS
   lda #PAL_FN_LENGTH
   ldx #<pal_fn
   ldy #>pal_fn
   jsr SETNAM
   lda #(2 + ^VRAM_palette)
   ldx #<VRAM_palette
   ldy #>VRAM_palette
   jsr LOAD

   ; load bitmap
   lda #BITMAP_FN_LENGTH
   ldx #<bitmap_fn
   ldy #>bitmap_fn
   jsr SETNAM
   lda #(2 + ^BITMAP_VRAM)
   ldx #<BITMAP_VRAM
   ldy #>BITMAP_VRAM
   jsr LOAD

loop:
   wai
   bra loop
