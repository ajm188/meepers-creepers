    .data
string:
    .asciiz "hello"

    .text
main:
    li      $v0, 4
    la      $a0, string
    syscall