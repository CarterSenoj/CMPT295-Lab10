.section .note.GNU-stack, ""
    .global dot_double
    .global dot_single
    .global map_poly_double
    .global map_poly_single
    .global sin_x87

.text

# USES SAME LOGIC AS LAB 7
dot_double: 
pxor %xmm0, %xmm0

# zero check
mov $0, %r8

dot_double_loop:
cmp %rdx, %r8
je dot_double_done

# Load arr1[i]
movsd (%rdi, %r8, 8), %xmm1
# load arr2[i]
movsd (%rsi, %r8, 8), %xmm2
# arr1[i] *= arr2[i]
mulsd %xmm2, %xmm1
# add to acc
addsd %xmm1, %xmm0 

inc %r8
jmp dot_double_loop

dot_double_done:
ret

# void map_poly_double(double* input, double* output, uint64_t length,
#                        double a, double b, double c, double d)
# rdi = input array
# rsi = output array
# rdx = length
# xmm0 = a
# xmm1 = b
# xmm2 = c
# xmm3 = d
map_poly_double:
mov $0, %r8

map_poly_dloop:
cmp %rdx, %r8
je map_poly_d_done

movsd (%rdi, %r8, 8), %xmm4

movsd %xmm4, %xmm5
# xmm5 = a*x
mulsd %xmm0, %xmm5

# xmm5 = a*x + b
addsd %xmm1, %xmm5

# xmm5 = x*(a*x + b)
mulsd %xmm4, %xmm5

# xmm5 = x*(a*x + b) + c
addsd %xmm2, %xmm5

# xmm5 = x*(x*(a*x + b) + c)
mulsd %xmm4, %xmm5

# xmm5 = x*(x*(a*x + b) + c) + d
addsd %xmm3, %xmm5

movsd %xmm5, (%rsi, %r8, 8)

inc %r8
jmp map_poly_dloop

map_poly_d_done:
ret

# pretty much same as dot_double
dot_single:
pxor %xmm0, %xmm0

mov $0, %r8

dot_single_loop:
cmp %rdx, %r8
je dot_single_done

movss (%rdi, %r8, 4), %xmm1
movss (%rsi, %r8, 4), %xmm2

mulss %xmm2, %xmm1
addss %xmm1, %xmm0
inc %r8
jmp dot_single_loop

dot_single_done:
ret

map_poly_single:
mov $0, %r8

map_poly_s_loop:
cmp %rdx, %r8
je map_poly_s_done


movss (%rdi, %r8, 4), %xmm4

# xmm5 = a*x
movss %xmm4, %xmm5
mulss %xmm0, %xmm5

# xmm5 = a*x + b
addss %xmm1, %xmm5

# xmm5 = x*(a*x + b)
mulss %xmm4, %xmm5

# xmm5 = x*(a*x + b) + c
addss %xmm2, %xmm5

# xmm5 = x*(x*(a*x + b) + c)
mulss %xmm4, %xmm5

# xmm5 = x*(x*(a*x + b) + c) + d
addss %xmm3, %xmm5

movss %xmm5, (%rsi, %r8, 4)

inc %r8
jmp map_poly_s_loop

map_poly_s_done:
ret

sin_x87:
    mov $0, %rcx
s87_loop:
    cmp %rdx, %rcx
    jae s87_ret
    fldl (%rdi, %rcx, 8)
    fsin
    fstpl (%rsi, %rcx, 8)
    inc %rcx
    jmp s87_loop
s87_ret:
    ret