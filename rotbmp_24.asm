global _rotbmp24

;define parameters' addresses
%define     img         [ebp+8]     ;pointer to bmp image   
%define     tmp         [ebp+12]    ;destination buffer
%define     width 		[ebp+16]   


_rotbmp24:
	;making stack frame
	push    ebp
	mov     ebp, esp
	push 	esi                    ;idx_src
	push 	edi                    ;idx_dest
	push 	ebx

	;stride=3*width + padding      ;distance between pixels in the same column
	mov     ebx, width         
	lea 	ebx, [ebx + ebx*2]  
	mov 	eax, ebx               ;save val for padding computation     
	lea 	ebx, [ebx + 3]
	and     ebx, 0xfffffffc        ;store stride in $EBX

	;get padding size
	mov 	edx, ebx
	sub		edx, eax			   
	bswap 	ecx                    ;trick to use  the upper half of register
	mov 	cl, dl                 ;store padding in upper part of ecx
	bswap 	ecx

	;idx_dest = (3*width + padding)*(width-1)	  
	;start pasting pixels in the bottom-left corner of the destination buffer (tmp @ $EDI)
	mov 	eax, width 			   
	dec 	eax
	mul 	ebx                    ; @line_22
	mov 	edi, eax
	add 	edi, tmp

	;load img ptr
	mov 	esi, img

i_beg:                             ;enter outer loop
	mov 	dx, width

j_beg:                             ;enter inner loop
	mov 	cx, width

j_in:
	;actual copying
	mov 	eax, [esi]             ;copy  4 bytes
	mov 	[edi], ax              ;paste 2 bytes to destination buffer 
	shr 	eax, 16                ;get   rid of the right half of eax and get access to its left half by shifting
	mov 	[edi + 2], al          ;paste the 1  remaining byte of pixel   (3  in total, 24bpp)

	;adjust idx_dest after j-change
	sub 	edi, ebx

	;move to next pixel in src line
	lea 	esi, [esi + 3]

	;inner loop test
	dec 	cx
	jnz 	j_in

	;adjust idx_dest after i-change
	lea 	edi, [edi + 3]
	mov 	eax, ebx
	imul 	eax, dword width
	add 	edi, eax

	;add padding to src -move to next line in src
	bswap 	ecx
	movzx 	eax, cl
	add 	esi, eax 
	bswap 	ecx	

	;outer loop test	
	dec 	dx
	jnz 	j_beg

paste_back:
	;calculate total size
	mov 	eax, ebx
	mul 	dword width

	mov 	esi, img
	mov 	edi, tmp

pst:
	mov 	ebx, [edi]
	mov 	[esi], ebx
	lea 	esi, [esi + 4]
	lea 	edi, [edi + 4]
	sub 	eax, 4
	jnz 	pst

finish:
	pop 	ebx    
	pop 	edi
	pop 	esi
	mov     esp, ebp
	pop     ebp
	ret
