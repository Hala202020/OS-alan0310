  .file [name="checkpoint2.2.bin", type="bin", segments="XMega65Bin"]
.segmentdef XMega65Bin [segments="Syscall, Code, Data, Stack, Zeropage"]
.segmentdef Syscall [start=$8000, max=$81ff]
.segmentdef Code [start=$8200, min=$8200, max=$bdff]
.segmentdef Data [startAfter="Code", min=$8200, max=$bdff]
.segmentdef Stack [min=$be00, max=$beff, fill]
.segmentdef Zeropage [min=$bf00, max=$bfff, fill]
  //Some definitions of addresses and special valves that this peogram uses
  .label RASTER = $d012
  .label VIC_MEMORY = $d018
  .label SCREEN = $400
  .label BGCOL = $d021
  .label COLS = $d800
  .const BLACK = 0
  .const WHITE = 1
  .const JMP = $4c
  .const NOP = $ea
.segment Code
main: {
    .label sc = 4
    .label msg = 2
    //Initialize screen memory, and select correct font
    lda #$14
    sta VIC_MEMORY
    ldx #' '
    lda #<SCREEN
    sta.z memset.str
    lda #>SCREEN
    sta.z memset.str+1
    lda #<$28*$19
    sta.z memset.num
    lda #>$28*$19
    sta.z memset.num+1
    jsr memset
    ldx #WHITE
    lda #<COLS
    sta.z memset.str
    lda #>COLS
    sta.z memset.str+1
    lda #<$28*$19
    sta.z memset.num
    lda #>$28*$19
    sta.z memset.num+1
    jsr memset
    lda #<SCREEN+$28
    sta.z sc
    lda #>SCREEN+$28
    sta.z sc+1
    lda #<MESSAGE
    sta.z msg
    lda #>MESSAGE
    sta.z msg+1
  //The messag to display
  // A simple copy routine to copy the string 
  __b1:
    ldy #0
    lda (msg),y
    cmp #0
    bne __b2
  __b3:
    lda #$36
    cmp RASTER
    beq __b4
    lda #$42
    cmp RASTER
    beq __b4
    lda #BLACK
    sta BGCOL
    jmp __b3
  __b4:
    lda #WHITE
    sta BGCOL
    jmp __b3
  __b2:
    ldy #0
    lda (msg),y
    sta (sc),y
    inc.z sc
    bne !+
    inc.z sc+1
  !:
    inc.z msg
    bne !+
    inc.z msg+1
  !:
    jmp __b1
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zeropage(4) str, byte register(X) c, word zeropage(2) num)
memset: {
    .label end = 2
    .label dst = 4
    .label num = 2
    .label str = 4
    lda.z num
    bne !+
    lda.z num+1
    beq __breturn
  !:
    lda.z end
    clc
    adc.z str
    sta.z end
    lda.z end+1
    adc.z str+1
    sta.z end+1
  __b2:
    lda.z dst+1
    cmp.z end+1
    bne __b3
    lda.z dst
    cmp.z end
    bne __b3
  __breturn:
    rts
  __b3:
    txa
    ldy #0
    sta (dst),y
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b2
}
CPUKIL: {
    rts
}
UNDEFINE_TRAP: {
    rts
}
VF011WR: {
    rts
}
VF011RD: {
    rts
}
ALTTABKEY: {
    rts
}
RESTORKEY: {
    rts
}
PAGFAULT: {
    rts
}
RESET: {
    rts
}
SYSCALL3F: {
    rts
}
SYSCALL3E: {
    rts
}
SYSCALL3D: {
    rts
}
SYSCALL3C: {
    rts
}
SYSCALL3B: {
    rts
}
SYSCALL3A: {
    rts
}
SYSCALL39: {
    rts
}
SYSCALL38: {
    rts
}
SYSCALL37: {
    rts
}
SYSCALL36: {
    rts
}
SYSCALL35: {
    rts
}
SYSCALL34: {
    rts
}
SYSCALL33: {
    rts
}
SYSCALL32: {
    rts
}
SYSCALL31: {
    rts
}
SYSCALL30: {
    rts
}
SYSCALL2F: {
    rts
}
SYSCALL2E: {
    rts
}
SYSCALL2D: {
    rts
}
SYSCALL2C: {
    rts
}
SYSCALL2B: {
    rts
}
SYSCALL2A: {
    rts
}
SYSCALL29: {
    rts
}
SYSCALL28: {
    rts
}
SYSCALL27: {
    rts
}
SYSCALL26: {
    rts
}
SYSCALL25: {
    rts
}
SYSCALL24: {
    rts
}
SYSCALL23: {
    rts
}
SYSCALL21: {
    rts
}
SYSCALL20: {
    rts
}
SYSCALL1F: {
    rts
}
SYSCALL1E: {
    rts
}
SYSCALL1D: {
    rts
}
SYSCALL1C: {
    rts
}
SYSCALL1B: {
    rts
}
SYSCALL1A: {
    rts
}
SYSCALL19: {
    rts
}
SYSCALL18: {
    rts
}
SYSCALL17: {
    rts
}
SYSCALL16: {
    rts
}
SYSCALL15: {
    rts
}
SYSCALL14: {
    rts
}
SYSCALL13: {
    rts
}
SECUREXIT: {
    rts
}
SECURENTR: {
    rts
}
SYSCALL10: {
    rts
}
SYSCALL0F: {
    rts
}
SYSCALL0E: {
    rts
}
SYSCALL0D: {
    rts
}
SYSCALL0C: {
    rts
}
SYSCALL0B: {
    rts
}
SYSCALL0A: {
    rts
}
SYSCALL09: {
    rts
}
SYSCALL08: {
    rts
}
SYSCALL07: {
    rts
}
SYSCALL06: {
    rts
}
SYSCALL05: {
    rts
}
SYSCALL04: {
    rts
}
SYSCALL03: {
    rts
}
SYSCALL02: {
    rts
}
SYSCALL01: {
    rts
}
SYSCALL00: {
    rts
}
.segment Data
  //Some text to display
  MESSAGE: .text "checkpoint2.2 by alan0310"
  .byte 0
.segment Syscall
  SYSCALLS: .byte JMP
  .word SYSCALL00
  .byte NOP, JMP
  .word SYSCALL01
  .byte NOP, JMP
  .word SYSCALL02
  .byte NOP, JMP
  .word SYSCALL03
  .byte NOP, JMP
  .word SYSCALL04
  .byte NOP, JMP
  .word SYSCALL05
  .byte NOP, JMP
  .word SYSCALL06
  .byte NOP, JMP
  .word SYSCALL07
  .byte NOP, JMP
  .word SYSCALL08
  .byte NOP, JMP
  .word SYSCALL09
  .byte NOP, JMP
  .word SYSCALL0A
  .byte NOP, JMP
  .word SYSCALL0B
  .byte NOP, JMP
  .word SYSCALL0C
  .byte NOP, JMP
  .word SYSCALL0D
  .byte NOP, JMP
  .word SYSCALL0E
  .byte NOP, JMP
  .word SYSCALL0F
  .byte NOP, JMP
  .word SYSCALL10
  .byte NOP, JMP
  .word SECURENTR
  .byte NOP, JMP
  .word SECUREXIT
  .byte NOP, JMP
  .word SYSCALL13
  .byte NOP, JMP
  .word SYSCALL14
  .byte NOP, JMP
  .word SYSCALL15
  .byte NOP, JMP
  .word SYSCALL16
  .byte NOP, JMP
  .word SYSCALL17
  .byte NOP, JMP
  .word SYSCALL18
  .byte NOP, JMP
  .word SYSCALL19
  .byte NOP, JMP
  .word SYSCALL1A
  .byte NOP, JMP
  .word SYSCALL1B
  .byte NOP, JMP
  .word SYSCALL1C
  .byte NOP, JMP
  .word SYSCALL1D
  .byte NOP, JMP
  .word SYSCALL1E
  .byte NOP, JMP
  .word SYSCALL1F
  .byte NOP, JMP
  .word SYSCALL20
  .byte NOP, JMP
  .word SYSCALL21
  .byte NOP, JMP
  .word SYSCALL20
  .byte NOP, JMP
  .word SYSCALL23
  .byte NOP, JMP
  .word SYSCALL24
  .byte NOP, JMP
  .word SYSCALL25
  .byte NOP, JMP
  .word SYSCALL26
  .byte NOP, JMP
  .word SYSCALL27
  .byte NOP, JMP
  .word SYSCALL28
  .byte NOP, JMP
  .word SYSCALL29
  .byte NOP, JMP
  .word SYSCALL2A
  .byte NOP, JMP
  .word SYSCALL2B
  .byte NOP, JMP
  .word SYSCALL2C
  .byte NOP, JMP
  .word SYSCALL2D
  .byte NOP, JMP
  .word SYSCALL2E
  .byte NOP, JMP
  .word SYSCALL2F
  .byte NOP, JMP
  .word SYSCALL30
  .byte NOP, JMP
  .word SYSCALL31
  .byte NOP, JMP
  .word SYSCALL32
  .byte NOP, JMP
  .word SYSCALL33
  .byte NOP, JMP
  .word SYSCALL34
  .byte NOP, JMP
  .word SYSCALL35
  .byte NOP, JMP
  .word SYSCALL36
  .byte NOP, JMP
  .word SYSCALL37
  .byte NOP, JMP
  .word SYSCALL38
  .byte NOP, JMP
  .word SYSCALL39
  .byte NOP, JMP
  .word SYSCALL3A
  .byte NOP, JMP
  .word SYSCALL3B
  .byte NOP, JMP
  .word SYSCALL3C
  .byte NOP, JMP
  .word SYSCALL3D
  .byte NOP, JMP
  .word SYSCALL3E
  .byte NOP, JMP
  .word SYSCALL3F
  .byte NOP
  // In this example 
  .align $100
  SYSCALL_TRAPS: .byte JMP
  .word main
  .byte NOP, JMP
  .word RESET
  .byte NOP, JMP
  .word PAGFAULT
  .byte NOP, JMP
  .word RESTORKEY
  .byte NOP, JMP
  .word ALTTABKEY
  .byte NOP, JMP
  .word VF011RD
  .byte NOP, JMP
  .word VF011WR
  .byte NOP, JMP
  .word UNDEFINE_TRAP
  .byte NOP, JMP
  .word UNDEFINE_TRAP
  .byte NOP, JMP
  .word UNDEFINE_TRAP
  .byte NOP, JMP
  .word UNDEFINE_TRAP
  .byte NOP, JMP
  .word UNDEFINE_TRAP
  .byte NOP, JMP
  .word UNDEFINE_TRAP
  .byte NOP, JMP
  .word UNDEFINE_TRAP
  .byte NOP, JMP
  .word UNDEFINE_TRAP
  .byte NOP, JMP
  .word UNDEFINE_TRAP
  .byte NOP, JMP
  .word UNDEFINE_TRAP
  .byte NOP, JMP
  .word UNDEFINE_TRAP
  .byte NOP, JMP
  .word UNDEFINE_TRAP
  .byte NOP, JMP
  .word UNDEFINE_TRAP
  .byte NOP, JMP
  .word UNDEFINE_TRAP
  .byte NOP, JMP
  .word UNDEFINE_TRAP
  .byte NOP, JMP
  .word UNDEFINE_TRAP
  .byte NOP, JMP
  .word UNDEFINE_TRAP
  .byte NOP, JMP
  .word UNDEFINE_TRAP
  .byte NOP, JMP
  .word UNDEFINE_TRAP
  .byte NOP, JMP
  .word UNDEFINE_TRAP
  .byte NOP, JMP
  .word UNDEFINE_TRAP
  .byte NOP, JMP
  .word UNDEFINE_TRAP
  .byte NOP, JMP
  .word UNDEFINE_TRAP
  .byte NOP, JMP
  .word UNDEFINE_TRAP
  .byte NOP, JMP
  .word UNDEFINE_TRAP
  .byte NOP, JMP
  .word UNDEFINE_TRAP
  .byte NOP, JMP
  .word UNDEFINE_TRAP
  .byte NOP, JMP
  .word UNDEFINE_TRAP
  .byte NOP, JMP
  .word UNDEFINE_TRAP
  .byte NOP, JMP
  .word UNDEFINE_TRAP
  .byte NOP, JMP
  .word UNDEFINE_TRAP
  .byte NOP, JMP
  .word UNDEFINE_TRAP
  .byte NOP, JMP
  .word UNDEFINE_TRAP
  .byte NOP, JMP
  .word UNDEFINE_TRAP
  .byte NOP, JMP
  .word UNDEFINE_TRAP
  .byte NOP, JMP
  .word UNDEFINE_TRAP
  .byte NOP, JMP
  .word UNDEFINE_TRAP
  .byte NOP, JMP
  .word UNDEFINE_TRAP
  .byte NOP, JMP
  .word UNDEFINE_TRAP
  .byte NOP, JMP
  .word UNDEFINE_TRAP
  .byte NOP, JMP
  .word UNDEFINE_TRAP
  .byte NOP, JMP
  .word CPUKIL
  .byte NOP
