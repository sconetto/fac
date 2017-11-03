##### This subroutine first generates 256 words crc32 table for ASCII codes and then computes the actual crc32 checksum of the file
#input:
#$a1 = block
#$v0 = length
#output:
#$v0 = crc32 checksum
.text

crc32_checksum:
    li      $t0, 0xedb88320         # CRC32 code generator
    #li     $t0, 0xa001     # CRC16 code generator
    #li     $t0, 0x8c       # CRC8 code generator

    la      $t1, crc_tab        # address of the table to fill in

    li      $t2, 0      # load 0 into $t2

tab_gen:
    move    $t3, $t2        # move counter of 8 digit hex values packed into table to $t3

    li  $t4, 8      # digit/bit counter equals 8

tab_byte:
    and     $t5, $t3, 1     # AND data with 1
    beqz    $t5, shift      # branch to 'shift' if equal 0

    srl     $t3, $t3, 1     # shift right data
    xor     $t3, $t3, $t0   # XOR both values (shifted data with CRC polynomial)
    b       next        # branch to next 

shift:
    srl     $t3, $t3, 1     # shift right data

next:
    sub     $t4, $t4, 1     # decrese digit/bit counter
    bnez    $t4, tab_byte   # branch if byte/bit counter is not equal to zero

    sw      $t3, 0($t1)     # store 8 digit hex value
    add     $t1, $t1, 4     # move to the next address to be fill


    add     $t2, $t2, 1     # increase counter of 8 digit hex values packed into table
    bltu    $t2, 256, tab_gen   # branch until 256 8 digit hex values are packed into table


#### # Calculate the actual CRC32

    li      $t0, 0xffffffff # initialize crc value for CRC32 code
    #li     $t0, 0x0000     # initialize crc value for CRC16 code
    #li     $t0, 0xffff     # initialize crc value for CRC16 code
    #li     $t0, 0xff       # initialize crc value for CRC8 code

    la      $t1, crc_tab        # point to crc_tab

crc32:
    lbu     $t2, 0($a1)     # load byte of data
    add     $a1, $a1, 1     # advance the data pointer
    xor     $t2, $t2, $t0   # byte of data XOR with crc
    and     $t2, $t2, 0xff  # (byte of data XOR with crc) AND with 0xff (to produce a table index)
    sll     $t2, $t2, 2         # scale (*4) the index because of addressing 32-bit words
    add     $t2, $t2, $t1   # form the final address in the table

    lw      $t2, 0($t2)     # load a value from the table
    srl     $t3, $t0, 8     # crc shifted 8 bits right
    xor     $t0, $t2, $t3   # XOR both values (i.e. shifted crc and the value read from the table)


    sub     $v0, $v0, 1     # decrement the byte counter
    bnez    $v0, crc32      # repeat untill all bytes of data are processed

    not     $v0, $t0        # invert all bits of final crc

    move    $t7, $v0

    jr      $ra     # jump to return address