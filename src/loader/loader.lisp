(org 0x3000)
(jmp main)

(include "print.lisp")
(include "macros.lisp")

(label disk_command)
  (db 0)
  (db 4)
  (dw 1)
  (dw 0x8000)

(label main)
  (display hello)

  (in #r1 1) ; Read bus address
  (ldr #r0 #r1) ; Get number of devices
  (add #r1 4) ; Get devices[0].type

  (call find_disk)

  (add #r1 4) ; Get disk.addr
  (ldw #r3 #r1) ; Load it into r3
  (stw #r3 disk_command)  ; Write to disk address

  (xor #r0 #r0)
  (xor #r1 #r1)
  (xor #r2 #r2)
  (xor #r3 #r3)
  (jmp 0x8000)

; Parameters:
; r0 -> device count
; r1 -> bus address
(label find_disk)
  (cmp #r2 #r0) ; if i == device_count
  (je disk_end) ; stop
  (add #r2 1) ; i++
  (ldr #r3 #r1) ; r3 = *r1
  (cmp #r3 1) ; if r3 == 1, we found a disk
  (je disk_end)
  (add #r1 8) ; r1 += 8
  (jmp find_disk)

(label disk_end)
    (ret)

(label hello)
  (db "Hello from the bootloader!!" #\nl 0)

(fill 0 510)
(db 0x55)
(db 0xAA)
