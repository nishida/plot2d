;+
; NORMVECTOR3 Version 1.3
; Write unit vector.
;
; normvector3, unit=unit, scale=scale, hsize=hsize, charsize=charsize, $
; headposition=headposition, vector_color=vector_color, label_color=label_color, $
; [Also accepts all ARROW keywords]
;
; charsize keyword is required if you use charsize ckeyword in original plot
; title keyword can be set to 2-elements array
;
; Created by Keisuke Nishida 2-Sep-2011 Version 1.0
;    extension of Shiota-san's NORMVECTOR2 Version 12-Jun-2003
;
; Modified by Keisuke Nishida 9-Sep-2011 Version 1.1
;    bug fix (when !p.charsize = 0)
;    change method to determine the position
;
; Modified by Keisuke Nishida 18-Nov-2011 Version 1.2
;    new keyword: OFFSET
;    support reversed XRANGE and YRANGE
;    support !P.MULTI
;    change default position
;
; Modified by Keisuke Nishida 06-Mar-2012 Version 1.3
;    new keywords: VECTOR_COLOR, LABEL_COLOR
;
;-

pro normvector3,unit = unit0, scale=scale0, hsize=hsize0, charsize=charsize0, $
headposition=headposition0, offset=offset, title=title0, $
vector_color=vector_color, label_color=label_color, _extra=extra

COMPILE_OPT strictarr
on_error, 2

unit = (n_elements(unit0) eq 0) ? 1.0 : unit0
scale = (n_elements(scale0) eq 0) ? 1.0 : scale0
hsize = (n_elements(hsize0) eq 0)  ? -0.2 : hsize0
charsize = (n_elements(charsize0) eq 0) ? (!p.charsize eq 0 ? 1.0 : !p.charsize) : charsize0
charsizefactor = (!p.multi[1] > !p.multi[2]) le 2 ? 1.0 : 0.5
charsize *= charsizefactor

title = (n_elements(title0) eq 0) ? 'Velocity ('+strcompress(string(unit,format='(g9.3)'))+') ' : title0

; average height of character in normalize coord
charheight = 1.0 * !d.y_ch_size / !d.y_size * charsize

headposition = (n_elements(headposition) eq 0) ? $
	[!x.window[1], !y.window[0] - charheight * 4] : headposition0

if n_elements(offset) eq 2 then headposition += offset

head_x = headposition[0]
tail_x = headposition[0] - abs(!x.s[1] * unit * scale)

tail_y = headposition[1]
head_y = headposition[1]


arrow,tail_x,tail_y,head_x,head_y,/normal,hsize=hsize,color=vector_color,_extra=extra

xyouts,tail_x,tail_y - charheight / 4, title[0], alignment=1.0,charsize=charsize, $
	color=label_color,/normal,_extra=extra

if n_elements(title) ge 2 then xyouts,head_x,tail_y - charheight / 4, title[1], $
	alignment=0.0,charsize=charsize,color=label_color,/normal,_extra=extra

end

