  .file [name="checkpoint3.3.bin", type="bin", segments="XMega65Bin"]
.segmentdef XMega65Bin [segments="Syscall, Code, Data, Stack, Zeropage"]
.segmentdef Syscall [start=$8000, max=$81ff]
.segmentdef Code [start=$8200, min=$8200, max=$bdff]
.segmentdef Data [startAfter="Code", min=$8200, max=$bdff]
.segmentdef Stack [min=$be00, max=$beff, fill]
.segmentdef Zeropage [min=$bf00, max=$bfff, fill]
  .label VIC_MEMORY = $d018
  .label SCREEN = $d0400
  .label COLS = $d800
  .const WHITE = 1
  .const JMP = $4c
  .const NOP = $ea
  .label current_screen_x = 6
  .label current_screen_line = 2
  .label current_screen_line_16 = 4
  .label current_screen_line_56 = 4
  .label current_screen_line_57 = 4
  .label current_screen_line_58 = 4
  .label current_screen_line_59 = 4
.segment Code
main: {
    rts
}
undefinetrap: {
    jsr exit_hypervisor
    rts
}
exit_hypervisor: {
    lda #1
    sta $d67f
    rts
}
cpukil: {
    jsr exit_hypervisor
    rts
}
reserved: {
    jsr exit_hypervisor
    rts
}
vf011rd: {
    jsr exit_hypervisor
    rts
}
vf011wr: {
    jsr exit_hypervisor
    rts
}
alttabkey: {
    jsr exit_hypervisor
    rts
}
restorekey: {
    jsr exit_hypervisor
    rts
}
pagefault: {
    jsr exit_hypervisor
    rts
}
reset: {
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
    lda #<msg1
    sta.z print_to_screen.message
    lda #>msg1
    sta.z print_to_screen.message+1
    lda #0
    sta.z current_screen_x
    lda #<$400
    sta.z current_screen_line_16
    lda #>$400
    sta.z current_screen_line_16+1
    jsr print_to_screen
    lda #<$400
    sta.z current_screen_line
    lda #>$400
    sta.z current_screen_line+1
    jsr print_newline
    lda.z current_screen_line
    sta.z current_screen_line_59
    lda.z current_screen_line+1
    sta.z current_screen_line_59+1
    lda #<msg2
    sta.z print_to_screen.message
    lda #>msg2
    sta.z print_to_screen.message+1
    lda #0
    sta.z current_screen_x
    jsr print_to_screen
    jsr print_newline
    jsr detect_devices
    jsr print_newline
  __b1:
    jmp __b1
  .segment Data
    msg1: .text " operating system starting"
    .byte 0
    msg2: .text "testing hardware"
    .byte 0
}
.segment Code
print_newline: {
    lda #$28
    clc
    adc.z current_screen_line
    sta.z current_screen_line
    bcc !+
    inc.z current_screen_line+1
  !:
    rts
}
detect_devices: {
    .label num = 9
    lda #0
    sta.z current_screen_x
    lda #<$d000
    sta.z num
    lda #>$d000
    sta.z num+1
  __b1:
    lda.z num+1
    cmp #>$dff0
    bcc __b2
    bne !+
    lda.z num
    cmp #<$dff0
    bcc __b2
  !:
    lda.z current_screen_line
    sta.z current_screen_line_56
    lda.z current_screen_line+1
    sta.z current_screen_line_56+1
    lda #<message
    sta.z print_to_screen.message
    lda #>message
    sta.z print_to_screen.message+1
    jsr print_to_screen
    jsr print_newline
    rts
  __b2:
    jsr detect_vicii
    cmp #0
    bne __b4
  __b5:
    lda #$10
    clc
    adc.z num
    sta.z num
    bcc !+
    inc.z num+1
  !:
    jmp __b1
  __b4:
    lda.z current_screen_line
    sta.z current_screen_line_57
    lda.z current_screen_line+1
    sta.z current_screen_line_57+1
    lda #<message1
    sta.z print_to_screen.message
    lda #>message1
    sta.z print_to_screen.message+1
    jsr print_to_screen
    lda.z num
    sta.z print_hex.value
    lda.z num+1
    sta.z print_hex.value+1
    jsr print_hex
    jsr print_newline
    lda #0
    sta.z current_screen_x
    jmp __b5
  .segment Data
    message: .text "finished probing devices"
    .byte 0
    message1: .text "vic -ii detected at $"
    .byte 0
}
.segment Code
// print_hex(word zeropage(7) value)
print_hex: {
    .label __4 = $d
    .label __7 = $f
    .label value = 7
    ldx #0
  __b1:
    cpx #4
    bcc __b2
    lda #0
    sta hex+4
    lda.z current_screen_line
    sta.z current_screen_line_58
    lda.z current_screen_line+1
    sta.z current_screen_line_58+1
    lda #<hex
    sta.z print_to_screen.message
    lda #>hex
    sta.z print_to_screen.message+1
    jsr print_to_screen
    rts
  __b2:
    lda.z value+1
    cmp #>$a000
    bcc __b4
    bne !+
    lda.z value
    cmp #<$a000
    bcc __b4
  !:
    ldy #$c
    lda.z value
    sta.z __4
    lda.z value+1
    sta.z __4+1
    cpy #0
    beq !e+
  !:
    lsr.z __4+1
    ror.z __4
    dey
    bne !-
  !e:
    lda.z __4
    sec
    sbc #9
    sta hex,x
  __b5:
    asl.z value
    rol.z value+1
    asl.z value
    rol.z value+1
    asl.z value
    rol.z value+1
    asl.z value
    rol.z value+1
    inx
    jmp __b1
  __b4:
    ldy #$c
    lda.z value
    sta.z __7
    lda.z value+1
    sta.z __7+1
    cpy #0
    beq !e+
  !:
    lsr.z __7+1
    ror.z __7
    dey
    bne !-
  !e:
    lda.z __7
    clc
    adc #'0'
    sta hex,x
    jmp __b5
  .segment Data
    hex: .fill 5, 0
}
.segment Code
// print_to_screen(byte* zeropage(7) message)
print_to_screen: {
    .label sc = $d
    .label message = 7
    lda.z current_screen_x
    clc
    adc.z current_screen_line_16
    sta.z sc
    lda #0
    adc.z current_screen_line_16+1
    sta.z sc+1
  __b1:
    ldy #0
    lda (message),y
    cmp #0
    bne __b2
    rts
  __b2:
    ldy #0
    lda (message),y
    sta (sc),y
    inc.z sc
    bne !+
    inc.z sc+1
  !:
    inc.z message
    bne !+
    inc.z message+1
  !:
    inc.z current_screen_x
    jmp __b1
}
// detect_vicii(word zeropage(9) adress)
detect_vicii: {
    .label p = $b
    .label v1 = $11
    .label i = $d
    .label adress = 9
    lda #<0
    sta.z p
    sta.z p+1
    ldy #$12
    lda (adress),y
    sta.z v1
    lda #<0
    sta.z i
    sta.z i+1
  __b3:
    lda.z i+1
    cmp #>$3e8
    bcc __b5
    bne !+
    lda.z i
    cmp #<$3e8
    bcc __b5
  !:
    ldy #$12
    lda (adress),y
    cmp.z v1
    bne __b1
    lda #0
    rts
  __b1:
    lda #1
    rts
  __b5:
    inc.z i
    bne !+
    inc.z i+1
  !:
    jmp __b3
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zeropage($d) str, byte register(X) c, word zeropage(9) num)
memset: {
    .label end = 9
    .label dst = $d
    .label num = 9
    .label str = $d
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
syscall3F: {
    jsr exit_hypervisor
    rts
}
syscall3E: {
    jsr exit_hypervisor
    rts
}
syscall3D: {
    jsr exit_hypervisor
    rts
}
syscall3C: {
    jsr exit_hypervisor
    rts
}
syscall3B: {
    jsr exit_hypervisor
    rts
}
syscall3A: {
    jsr exit_hypervisor
    rts
}
syscall39: {
    jsr exit_hypervisor
    rts
}
syscall38: {
    jsr exit_hypervisor
    rts
}
syscall37: {
    jsr exit_hypervisor
    rts
}
syscall36: {
    jsr exit_hypervisor
    rts
}
syscall35: {
    jsr exit_hypervisor
    rts
}
syscall34: {
    jsr exit_hypervisor
    rts
}
syscall33: {
    jsr exit_hypervisor
    rts
}
syscall32: {
    jsr exit_hypervisor
    rts
}
syscall31: {
    jsr exit_hypervisor
    rts
}
syscall30: {
    jsr exit_hypervisor
    rts
}
syscall2F: {
    jsr exit_hypervisor
    rts
}
syscall2E: {
    jsr exit_hypervisor
    rts
}
syscall2D: {
    jsr exit_hypervisor
    rts
}
syscall2C: {
    jsr exit_hypervisor
    rts
}
syscall2B: {
    jsr exit_hypervisor
    rts
}
syscall2A: {
    jsr exit_hypervisor
    rts
}
syscall29: {
    jsr exit_hypervisor
    rts
}
syscall28: {
    jsr exit_hypervisor
    rts
}
syscall27: {
    jsr exit_hypervisor
    rts
}
syscall26: {
    jsr exit_hypervisor
    rts
}
syscall25: {
    jsr exit_hypervisor
    rts
}
syscall24: {
    jsr exit_hypervisor
    rts
}
syscall23: {
    jsr exit_hypervisor
    rts
}
syscall22: {
    jsr exit_hypervisor
    rts
}
syscall21: {
    jsr exit_hypervisor
    rts
}
syscall20: {
    jsr exit_hypervisor
    rts
}
syscall1F: {
    jsr exit_hypervisor
    rts
}
syscall1E: {
    jsr exit_hypervisor
    rts
}
syscall1D: {
    jsr exit_hypervisor
    rts
}
syscall1C: {
    jsr exit_hypervisor
    rts
}
syscall1B: {
    jsr exit_hypervisor
    rts
}
syscall1A: {
    jsr exit_hypervisor
    rts
}
syscall19: {
    jsr exit_hypervisor
    rts
}
syscall18: {
    jsr exit_hypervisor
    rts
}
syscall17: {
    jsr exit_hypervisor
    rts
}
syscall16: {
    jsr exit_hypervisor
    rts
}
syscall15: {
    jsr exit_hypervisor
    rts
}
syscall14: {
    jsr exit_hypervisor
    rts
}
syscall13: {
    jsr exit_hypervisor
    rts
}
syscall12: {
    jsr exit_hypervisor
    rts
}
syscall11: {
    jsr exit_hypervisor
    rts
}
syscall10: {
    jsr exit_hypervisor
    rts
}
syscall0F: {
    jsr exit_hypervisor
    rts
}
syscall0E: {
    jsr exit_hypervisor
    rts
}
syscall0D: {
    jsr exit_hypervisor
    rts
}
syscall0C: {
    jsr exit_hypervisor
    rts
}
syscall0B: {
    jsr exit_hypervisor
    rts
}
syscall0A: {
    jsr exit_hypervisor
    rts
}
syscall09: {
    jsr exit_hypervisor
    rts
}
syscall08: {
    jsr exit_hypervisor
    rts
}
syscall07: {
    jsr exit_hypervisor
    rts
}
syscall06: {
    jsr exit_hypervisor
    rts
}
syscall05: {
    jsr exit_hypervisor
    rts
}
syscall04: {
    jsr exit_hypervisor
    rts
}
syscall03: {
    jsr exit_hypervisor
    rts
}
syscall02: {
    jsr exit_hypervisor
    rts
}
syscall01: {
    jsr exit_hypervisor
    rts
}
syscall00: {
    jsr exit_hypervisor
    rts
}
.segment Syscall
  SYSCALLS: .byte JMP
  .word syscall00
  .byte NOP, JMP
  .word syscall01
  .byte NOP, JMP
  .word syscall02
  .byte NOP, JMP
  .word syscall03
  .byte NOP, JMP
  .word syscall04
  .byte NOP, JMP
  .word syscall05
  .byte NOP, JMP
  .word syscall06
  .byte NOP, JMP
  .word syscall07
  .byte NOP, JMP
  .word syscall08
  .byte NOP, JMP
  .word syscall09
  .byte NOP, JMP
  .word syscall0A
  .byte NOP, JMP
  .word syscall0B
  .byte NOP, JMP
  .word syscall0C
  .byte NOP, JMP
  .word syscall0D
  .byte NOP, JMP
  .word syscall0E
  .byte NOP, JMP
  .word syscall0F
  .byte NOP, JMP
  .word syscall10
  .byte NOP, JMP
  .word syscall11
  .byte NOP, JMP
  .word syscall12
  .byte NOP, JMP
  .word syscall13
  .byte NOP, JMP
  .word syscall14
  .byte NOP, JMP
  .word syscall15
  .byte NOP, JMP
  .word syscall16
  .byte NOP, JMP
  .word syscall17
  .byte NOP, JMP
  .word syscall18
  .byte NOP, JMP
  .word syscall19
  .byte NOP, JMP
  .word syscall1A
  .byte NOP, JMP
  .word syscall1B
  .byte NOP, JMP
  .word syscall1C
  .byte NOP, JMP
  .word syscall1D
  .byte NOP, JMP
  .word syscall1E
  .byte NOP, JMP
  .word syscall1F
  .byte NOP, JMP
  .word syscall20
  .byte NOP, JMP
  .word syscall21
  .byte NOP, JMP
  .word syscall22
  .byte NOP, JMP
  .word syscall23
  .byte NOP, JMP
  .word syscall24
  .byte NOP, JMP
  .word syscall25
  .byte NOP, JMP
  .word syscall26
  .byte NOP, JMP
  .word syscall27
  .byte NOP, JMP
  .word syscall28
  .byte NOP, JMP
  .word syscall29
  .byte NOP, JMP
  .word syscall2A
  .byte NOP, JMP
  .word syscall2B
  .byte NOP, JMP
  .word syscall2C
  .byte NOP, JMP
  .word syscall2D
  .byte NOP, JMP
  .word syscall2E
  .byte NOP, JMP
  .word syscall2F
  .byte NOP, JMP
  .word syscall30
  .byte NOP, JMP
  .word syscall31
  .byte NOP, JMP
  .word syscall32
  .byte NOP, JMP
  .word syscall33
  .byte NOP, JMP
  .word syscall34
  .byte NOP, JMP
  .word syscall35
  .byte NOP, JMP
  .word syscall36
  .byte NOP, JMP
  .word syscall37
  .byte NOP, JMP
  .word syscall38
  .byte NOP, JMP
  .word syscall39
  .byte NOP, JMP
  .word syscall3A
  .byte NOP, JMP
  .word syscall3B
  .byte NOP, JMP
  .word syscall3C
  .byte NOP, JMP
  .word syscall3D
  .byte NOP, JMP
  .word syscall3E
  .byte NOP, JMP
  .word syscall3F
  .byte NOP
  .align $100
  SYSCALL_RESET: .byte JMP
  .word reset
  .byte NOP, JMP
  .word pagefault
  .byte NOP, JMP
  .word restorekey
  .byte NOP, JMP
  .word alttabkey
  .byte NOP, JMP
  .word vf011rd
  .byte NOP, JMP
  .word vf011wr
  .byte NOP, JMP
  .word reserved
  .byte NOP, JMP
  .word cpukil
  .byte NOP, JMP
  .word undefinetrap
  .byte NOP, JMP
  .word undefinetrap
  .byte NOP, JMP
  .word undefinetrap
  .byte NOP, JMP
  .word undefinetrap
  .byte NOP, JMP
  .word undefinetrap
  .byte NOP, JMP
  .word undefinetrap
  .byte NOP, JMP
  .word undefinetrap
  .byte NOP, JMP
  .word undefinetrap
  .byte NOP, JMP
  .word undefinetrap
  .byte NOP, JMP
  .word undefinetrap
  .byte NOP, JMP
  .word undefinetrap
  .byte NOP, JMP
  .word undefinetrap
  .byte NOP, JMP
  .word undefinetrap
  .byte NOP, JMP
  .word undefinetrap
  .byte NOP, JMP
  .word undefinetrap
  .byte NOP, JMP
  .word undefinetrap
  .byte NOP, JMP
  .word undefinetrap
  .byte NOP, JMP
  .word undefinetrap
  .byte NOP, JMP
  .word undefinetrap
  .byte NOP, JMP
  .word undefinetrap
  .byte NOP, JMP
  .word undefinetrap
  .byte NOP, JMP
  .word undefinetrap
  .byte NOP, JMP
  .word undefinetrap
  .byte NOP, JMP
  .word undefinetrap
  .byte NOP, JMP
  .word undefinetrap
  .byte NOP, JMP
  .word undefinetrap
  .byte NOP, JMP
  .word undefinetrap
  .byte NOP, JMP
  .word undefinetrap
  .byte NOP, JMP
  .word undefinetrap
  .byte NOP, JMP
  .word undefinetrap
  .byte NOP, JMP
  .word undefinetrap
  .byte NOP, JMP
  .word undefinetrap
  .byte NOP, JMP
  .word undefinetrap
  .byte NOP, JMP
  .word undefinetrap
  .byte NOP, JMP
  .word undefinetrap
  .byte NOP, JMP
  .word undefinetrap
  .byte NOP, JMP
  .word undefinetrap
  .byte NOP, JMP
  .word undefinetrap
  .byte NOP, JMP
  .word undefinetrap
  .byte NOP, JMP
  .word undefinetrap
  .byte NOP
