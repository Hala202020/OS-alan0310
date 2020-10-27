  .file [name="checkpoint2.3.bin", type="bin", segments="XMega65Bin"]
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
// memset(void* zeropage(8) str, byte register(X) c, word zeropage(6) num)
memset: {
    .label end = 6
    .label dst = 8
    .label num = 6
    .label str = 8
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
    jsr exit_hypervisor
    rts
}
//Here are a couple sample SYSCALL handlers that iust display a character on the screen 
exit_hypervisor: {
    rts
}
UNDEFINE_TRAP: {
    jsr exit_hypervisor
    rts
}
VF011WR: {
    jsr exit_hypervisor
    rts
}
VF011RD: {
    jsr exit_hypervisor
    rts
}
ALTTABKEY: {
    jsr exit_hypervisor
    rts
}
RESTORKEY: {
    jsr exit_hypervisor
    rts
}
PAGFAULT: {
    jsr exit_hypervisor
    rts
}
RESET: {
    .label sc = $c
    .label msg = $a
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
SYSCALL3F: {
    jsr exit_hypervisor
    rts
}
SYSCALL3E: {
    jsr exit_hypervisor
    rts
}
SYSCALL3D: {
    jsr exit_hypervisor
    rts
}
SYSCALL3C: {
    jsr exit_hypervisor
    rts
}
SYSCALL3B: {
    jsr exit_hypervisor
    rts
}
SYSCALL3A: {
    jsr exit_hypervisor
    rts
}
SYSCALL39: {
    jsr exit_hypervisor
    rts
}
SYSCALL38: {
    jsr exit_hypervisor
    rts
}
SYSCALL37: {
    jsr exit_hypervisor
    rts
}
SYSCALL36: {
    jsr exit_hypervisor
    rts
}
SYSCALL35: {
    jsr exit_hypervisor
    rts
}
SYSCALL34: {
    jsr exit_hypervisor
    rts
}
SYSCALL33: {
    jsr exit_hypervisor
    rts
}
SYSCALL32: {
    jsr exit_hypervisor
    rts
}
SYSCALL31: {
    jsr exit_hypervisor
    rts
}
SYSCALL30: {
    jsr exit_hypervisor
    rts
}
SYSCALL2F: {
    jsr exit_hypervisor
    rts
}
SYSCALL2E: {
    jsr exit_hypervisor
    rts
}
SYSCALL2D: {
    jsr exit_hypervisor
    rts
}
SYSCALL2C: {
    jsr exit_hypervisor
    rts
}
SYSCALL2B: {
    jsr exit_hypervisor
    rts
}
SYSCALL2A: {
    jsr exit_hypervisor
    rts
}
SYSCALL29: {
    jsr exit_hypervisor
    rts
}
SYSCALL28: {
    jsr exit_hypervisor
    rts
}
SYSCALL27: {
    jsr exit_hypervisor
    rts
}
SYSCALL26: {
    jsr exit_hypervisor
    rts
}
SYSCALL25: {
    jsr exit_hypervisor
    rts
}
SYSCALL24: {
    jsr exit_hypervisor
    rts
}
SYSCALL23: {
    jsr exit_hypervisor
    rts
}
SYSCALL21: {
    jsr exit_hypervisor
    rts
}
SYSCALL20: {
    jsr exit_hypervisor
    rts
}
SYSCALL1F: {
    jsr exit_hypervisor
    rts
}
SYSCALL1E: {
    jsr exit_hypervisor
    rts
}
SYSCALL1D: {
    jsr exit_hypervisor
    rts
}
SYSCALL1C: {
    jsr exit_hypervisor
    rts
}
SYSCALL1B: {
    jsr exit_hypervisor
    rts
}
SYSCALL1A: {
    jsr exit_hypervisor
    rts
}
SYSCALL19: {
    jsr exit_hypervisor
    rts
}
SYSCALL18: {
    jsr exit_hypervisor
    rts
}
SYSCALL17: {
    jsr exit_hypervisor
    rts
}
SYSCALL16: {
    jsr exit_hypervisor
    rts
}
SYSCALL15: {
    jsr exit_hypervisor
    rts
}
SYSCALL14: {
    jsr exit_hypervisor
    rts
}
SYSCALL13: {
    jsr exit_hypervisor
    rts
}
SECUREXIT: {
    jsr exit_hypervisor
    rts
}
SECURENTR: {
    jsr exit_hypervisor
    rts
}
SYSCALL10: {
    jsr exit_hypervisor
    rts
}
SYSCALL0F: {
    jsr exit_hypervisor
    rts
}
SYSCALL0E: {
    jsr exit_hypervisor
    rts
}
SYSCALL0D: {
    jsr exit_hypervisor
    rts
}
SYSCALL0C: {
    jsr exit_hypervisor
    rts
}
SYSCALL0B: {
    jsr exit_hypervisor
    rts
}
SYSCALL0A: {
    jsr exit_hypervisor
    rts
}
SYSCALL09: {
    jsr exit_hypervisor
    rts
}
SYSCALL08: {
    jsr exit_hypervisor
    rts
}
SYSCALL07: {
    jsr exit_hypervisor
    rts
}
SYSCALL06: {
    jsr exit_hypervisor
    rts
}
SYSCALL05: {
    jsr exit_hypervisor
    rts
}
SYSCALL04: {
    jsr exit_hypervisor
    rts
}
SYSCALL03: {
    jsr exit_hypervisor
    rts
}
SYSCALL02: {
    jsr exit_hypervisor
    rts
}
SYSCALL01: {
    jsr exit_hypervisor
    rts
}
SYSCALL00: {
    jsr exit_hypervisor
    rts
}
.segment Data
  //Some text to display
  MESSAGE: .text "checkpoint2.3 by alan0310"
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
