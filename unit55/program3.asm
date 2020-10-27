.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    jsr fork
    cmp #0
    bne __b1
    jsr exec
  __b3:
    jsr yield
    jmp __b3
  __b1:
    jsr showpid
    jmp __b3
    program_name: .text "program4.prg"
    .byte 0
}
showpid: {
    jsr enable_syscalls
    lda #0
    sta $d646
    nop
    rts
}
enable_syscalls: {
    lda #$47
    sta $d02f
    lda #$53
    sta $d02f
    rts
}
yield: {
    jsr enable_syscalls
    lda #0
    sta $d645
    nop
    rts
}
exec: {
    .label tr_area = $300
    .const Max_name_len = $10
    .label i = 2
    .label i_3 = $c
    .label i_6 = 4
    .label __7 = $e
    .label __8 = 6
    .label __9 = 8
    .label __10 = $a
    .label i_8 = 4
    lda #<0
    sta.z i
    sta.z i+1
  __b1:
    lda.z i+1
    cmp #>$11
    bcc __b2
    bne !+
    lda.z i
    cmp #<$11
    bcc __b2
  !:
    lda #<0
    sta.z i_6
    sta.z i_6+1
  __b3:
    lda #<main.program_name
    clc
    adc.z i_6
    sta.z __8
    lda #>main.program_name
    adc.z i_6+1
    sta.z __8+1
    lda #<tr_area
    clc
    adc.z i_6
    sta.z __9
    lda #>tr_area
    adc.z i_6+1
    sta.z __9+1
    ldy #0
    lda (__8),y
    sta (__9),y
    lda #<main.program_name
    clc
    adc.z i_6
    sta.z __10
    lda #>main.program_name
    adc.z i_6+1
    sta.z __10+1
    lda.z i_6
    clc
    adc #1
    sta.z i_3
    lda.z i_6+1
    adc #0
    sta.z i_3+1
    lda.z i_6+1
    cmp #>Max_name_len
    bcc !+
    bne __b4
    lda.z i_6
    cmp #<Max_name_len
    bcs __b4
  !:
    ldy #0
    lda (__10),y
    cmp #0
    bne __b7
  __b4:
    jsr enable_syscalls
    lda #0
    sta $d648
    nop
    rts
  __b7:
    lda.z i_3
    sta.z i_8
    lda.z i_3+1
    sta.z i_8+1
    jmp __b3
  __b2:
    lda #<tr_area
    clc
    adc.z i
    sta.z __7
    lda #>tr_area
    adc.z i+1
    sta.z __7+1
    lda #0
    tay
    sta (__7),y
    inc.z i
    bne !+
    inc.z i+1
  !:
    jmp __b1
}
fork: {
    jsr enable_syscalls
    lda #0
    sta $d647
    nop
    lda $300
    rts
}
