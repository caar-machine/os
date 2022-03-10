(org 0x8000)
(jmp _start)

(include "macros.lisp")

(label _start)

  (in #r1 1) ; Read bus address
  (ldr #r0 #r1) ; Get number of devices
  (add #r1 4) ; Get devices[0].type

  (call find-gpu)

  (add #r1 4) ; Get gpu.addr
  (ldw #r0 #r1) ; Load it into r0
  (ldw #r0 #r0)  ; Getting framebuffer

  (xor #r6 #r6)

  (label draw_line)
    (mov #r1 #r6)
    (mov #r2 0)
    (mov #r3 0xFF0000)
    (call plot-pixel)
    (cmp #r6 100)
    (add #r6 1) 
    (jne draw_line)


  (label _loop)
    (jmp _loop)


; plot-pixel:
; Plots a pixel at framebuffer r0, X r1, Y r2, color r3
(label plot-pixel)
    (mov #r4 #r0) ; r4 is fb.addr
    (mov #r5 #r2) ; r5 is y

    (mul #r5 1024) ; r5 is y * 1024(pitch)
    (add #r5 #r1) ; r5 is y * 1024 + x

    (add #r4 #r5) ; r4 = fb.addr[r5]

    (stw #r4 #r3) ; *r4 = r3

    (xor #r5 #r5)
    (xor #r4 #r4)

    (ret)
   

; find-gpu:
; Find a graphics card and returns the address in r1
(label find-gpu)
  (cmp #r2 #r0) ; if i == device_count
  (je gpu_end) ; TODO: add support for running headless.
  (add #r2 1) ; i++
  (ldr #r3 #r1) ; D = *B
  (cmp #r3 2) ; if type == 2, we found a gpu
  (je gpu_end)
  (add #r1 8) ; B += 8
  (jmp find-gpu)

(label gpu_end)
  (ret)
