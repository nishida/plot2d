;+
; rgb.pro Version 2.0
;
; color24 = rgb(red8, green8, blue8)
;	red8, green8, blue8 are 1-dimensional arrays
;
; color24 = rgb(color8)
;       color8 is (n, 3) or 3 elements array
;
; Calculate color code for true color mode (1-dimensional LONG array)
;
; Created       Keisuke Nishida  16-Sep-2008
; Modified      Keisuke Nishida  14-Dec-2011
;-
function rgb, r, g, b
	COMPILE_OPT strictarr
	on_error,2

	if n_params() eq 3 then begin
		return, r + 256L * g + 65536L * b
	endif else begin
		if size(r, /n_dimensions) eq 1 && size(r, /dimensions) eq 3 then begin
			return, r[0] + 256L * r[1] + 65536L * r[2]
		endif else if size(r, /n_dimensions) eq 2 && (size(r, /dimensions))[1] eq 3 then begin
			return, r[*, 0] + 256L * r[*, 1] + 65536L * r[*, 2]
		endif else begin
			message, 'invalid dimensions'
		endelse
	endelse
end

