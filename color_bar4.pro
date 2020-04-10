;+
; COLOR_BAR4
; Write a color bar.
;
; color_bar4,c_colors=c_colors,levels=levels, $
;	position=position, /noborder, $
;	/horizontal, /log, $
;	minor=minor, tickformat=tickformat, tickinterval=tickinterval, $
;	ticklayout=ticklayout, ticklen=ticklen, tickname=tickname, $
;	ticks=ticks, tickunits=tickunits, tickv=tickv, $
;	thick=thick, gridstyle=gridstyle, $
;	label_position=label_position, $
;	normal=normal,device=device, $
;	maintitle=maintitle, $
;	toptitle=toptitle, lefttitle=lefttitle, $
;	/rotlefttitle, offsetlefttitle=offsetlefttitle$
;	righttitle = righttitle, bottomtitle = bottomtitle, $
;	/rotrighttitle, offsetrighttitle=offsetrighttitle, $
;	titlesize = titlesize, /nosavecoord,charsize=charsize, $
;	/compatible, [Also accepts other Direct Graphics Keywords]
;
; CHARSIZE: character size for tick mark labels, XTITLE, YTITLE, MAINTITLE (*1.25), SUBTITLE
; TITLESIZE: character size for TOPTITLE, LEFTTITLE, BOTTOMTITLE, RIGHTTITLE.
;            When TITLESIZE is ommitted, CHARSIZE are used.
; XTITLE can be used when HORIZONTAL=1
; YTITLE can be used when HORIZONTAL=0
;
; Created   Keisuke Nishida Nov-28-2007
; Modified  Keisuke Nishida Sep-08-2011
;
; Modified  Keisuke Nishida Sep-07-2019
;  New keyword: rotlefttitle, offsetlefttitle, rotrighttitle, offsetrighttitle
;-

pro color_bar4,c_colors=c_colors,levels=levels, $
	position=position, noborder=noborder, $
	horizontal=horizontal, log=log, $
	minor=minor, tickformat=tickformat, tickinterval=tickinterval, $
	ticklayout=ticklayout, ticklen=ticklen, tickname=tickname, $
	ticks=ticks, tickunits=tickunits, tickv=tickv, $
	thick=thick, gridstyle=gridstyle, $
	label_position=label_position, $
	normal=normal,device=device, $
	maintitle=maintitle, $
	toptitle=toptitle, lefttitle=lefttitle, $
	rotlefttitle = rotlefttitle, offsetlefttitle=offsetlefttitle, $
	righttitle = righttitle, bottomtitle = bottomtitle, $
	rotrighttitle = rotrighttitle, offsetrighttitle=offsetrighttitle, $
	titlesize = titlesize, nosavecoord=nosavecoord,charsize=charsize, $
	compatible=compatible,_extra=ex

COMPILE_OPT strictarr
on_error,2

if (n_elements(charsize) eq 0) then charsize=!p.charsize eq 0 ? 1.0 : !p.charsize
if (n_elements(titlesize) eq 0) then titlesize=charsize

if keyword_set(compatible) then begin
	if ~keyword_set(horizontal) then begin
		; vertical color bar
		if n_elements(position) ne 4 then position=[0.93,0.2,0.96,0.8]
	endif else begin
		; horizontal color bar
		if n_elements(position) ne 4 then position=[0.2,0.1,0.8,0.15]
	endelse
endif else begin
	if ~keyword_set(horizontal) then begin
		; vertical color bar
		if n_elements(position) ne 4 then begin
			cbheight = !y.window[1] - !y.window[0]
			position=[!x.window[1]-0.06,!y.window[0]+cbheight*0.15,!x.window[1]-0.03,!y.window[0]+cbheight*0.85]
		endif
	endif else begin
		; horizontal color bar
		if n_elements(position) ne 4 then begin
			cbwidth = !y.window[1] - !y.window[0]
			charheight = 1.0 * !d.y_ch_size * charsize / !d.y_size
			position=[!x.window[0]+cbwidth*0.15,!y.window[0]+charheight+0.05,!x.window[0]+cbwidth*0.85,!y.window[0]+charheight+0.08]
		endif
	endelse
endelse


if ~keyword_set(nosavecoord) then begin
	oldp = !p
	oldx = !x
	oldy = !y
	oldz = !z
endif

nlevels=n_elements(levels)
if levels[0] eq levels[nlevels-1] then nlevels = 1

if keyword_set(log) and min(levels) le 0 then message,'zero or negative LEVELS for log plot'

barsmoothness=3000
if nlevels ne 1 then begin
	if keyword_set(log) then begin
		bardata0=exp(dindgen(barsmoothness)/(barsmoothness-1) $
			* (alog(levels[nlevels-1])-alog(levels[0]))*(nlevels/(nlevels-1.d))+alog(levels[0]))
		if (alog10(levels[nlevels-1])-alog10(levels[0]) le 2.5) then begin
			if ~keyword_set(compatible) && n_elements(minor) eq 0 then minor=9
		endif
	endif else begin
		bardata0=dindgen(barsmoothness)/(barsmoothness-1) $
			* (levels[nlevels-1]-levels[0])*(nlevels/(nlevels-1.d))+levels[0]
	endelse
endif else begin
	bardata0=dindgen(barsmoothness)/(barsmoothness-1)+levels[0]
	if n_elements(tickv) eq 0 then tickv=levels[0]
	if n_elements(ticks) eq 0 then ticks=1
	if n_elements(tickname) eq 0 then tickname=['', ' '] ; show only one lavel
end

bardata=[[bardata0],[bardata0]]

; !{x|y}.ticklen and !{x|y}.minor are not used as default settings
if n_elements(ticklen) eq 0 then ticklen=0.2999 ; if ticklen exceeds 0.3, minor tick is drawn in default size
if n_elements(minor) eq 0 then minor=-1
if n_elements(label_position) eq 0 then label_position=0

nolabelside = logical_true(label_position) ? 0 : 1
if keyword_set(noborder) then begin
	if n_elements(ticklayout) eq 0 then ticklayout = 1
endif

if ~keyword_set(horizontal) then begin
	bardata=rotate(bardata,1)
	contour,bardata,[0,1],bardata0,/fill,c_colors=c_colors,levels=levels[0:nlevels-1],xstyle=5,ystyle=5, $
		charsize=charsize,title=maintitle,position=position,normal=normal,device=device,ylog=log,/noerase,_extra=ex
	if ~keyword_set(noborder) then begin
		plots,[nolabelside,nolabelside],[bardata0[0],bardata0[barsmoothness-1]], thick=thick,/data,_extra=ex
		plots,[0,1],[bardata0[0],bardata0[0]], thick=thick,/data,_extra=ex
		plots,[0,1],[bardata0[barsmoothness-1],bardata0[barsmoothness-1]], thick=thick,/data,_extra=ex
	endif

	axis,yaxis=label_position,ystyle=1,ylog=log, charsize=charsize, $
		yminor=minor, ytickformat=tickformat, ytickinterval=tickinterval, $
		yticklayout=ticklayout, yticklen=ticklen, ytickname=tickname, $
		yticks=ticks, ytickunits=tickunits, ytickv=tickv, $
		ygridstyle=gridstyle ,ythick=thick, /data, _extra=ex

	if n_elements(lefttitle) ne 0 then begin
		if n_elements(offsetlefttitle) ne 0 then begin
			offsetx1 = -charsize * offsetlefttitle * !d.x_ch_size
		endif else begin
			offsetx1 = label_position ? 0.0 : -charsize * 6.0 * !d.x_ch_size
		endelse
		offsetx1 = (offsetx1 - titlesize * (keyword_set(rotlefttitle) ? 1.0 : 0.5) * !d.y_ch_size) / !d.x_size
		orientation = keyword_set(rotlefttitle) ? 270 : 90
		xyouts,!x.window[0]+offsetx1,(!y.window[0]+!y.window[1])/2,lefttitle,align=0.5,charsize=titlesize,/norm,orient=orientation,_extra=ex
	endif

	if n_elements(righttitle) ne 0 then begin
		if n_elements(offsetrighttitle) ne 0 then begin
			offsetx2 = charsize * offsetrighttitle * !d.x_ch_size
		endif else begin
			offsetx2 = label_position ? charsize * 6.0 * !d.x_ch_size : 0.0
		endelse
		offsetx2 = (offsetx2 + titlesize * (keyword_set(rotrighttitle) ? 1.0 : 1.5) * !d.y_ch_size) / !d.x_size
		orientation = keyword_set(rotrighttitle) ? 270 : 90
		xyouts,!x.window[1]+offsetx2,(!y.window[0]+!y.window[1])/2,righttitle,align=0.5,charsize=titlesize,/norm,orient=orientation,_extra=ex
	endif

	offsety1 = titlesize * 0.5 * !d.y_ch_size / !d.y_size
	offsety2 = -titlesize * 1.5 * !d.y_ch_size / !d.y_size

endif else begin
	contour,bardata,bardata0,[0,1],/fill,c_colors=c_colors,levels=levels[0:nlevels-1],xstyle=5,ystyle=5, $
		charsize=charsize,title=maintitle,normal=normal,device=device,position=position,xlog=log,/noerase,_extra=ex
	if ~keyword_set(noborder) then begin
		plots,[bardata0[0],bardata0[0]],[0,1], thick=thick,/data,_extra=ex
		plots,[bardata0[barsmoothness-1],bardata0[barsmoothness-1]],[0,1], thick=thick,/data,_extra=ex
		plots,[bardata0[0],bardata0[barsmoothness-1]],[nolabelside,nolabelside], thick=thick,/data,_extra=ex
	endif

	axis,xaxis=label_position,xstyle=1,xlog=log, charsize=charsize, $
		xminor=minor, xtickformat=tickformat, xtickinterval=tickinterval, $
		xticklayout=ticklayout, xticklen=ticklen, xtickname=tickname, $
		xticks=ticks, xtickunits=tickunits, xtickv=tickv, $
		xgridstyle=gridstyle, xthick=thick, /data, _extra=ex

	offsetx1 = -titlesize * 1.0 * !d.x_ch_size / !d.x_size
	if n_elements(lefttitle) ne 0 then $
		xyouts,!x.window[0]+offsetx1,!y.window[0],lefttitle,align=1,charsize=titlesize,/norm,_extra=ex
	offsetx2 = titlesize * 1.0 * !d.x_ch_size / !d.x_size
	if n_elements(righttitle) ne 0 then $
		xyouts,!x.window[1]+offsetx2,!y.window[0],righttitle,align=0,charsize=titlesize,/norm,_extra=ex
	offsety1 = (label_position ? charsize * 1.0 + (titlesize > charsize) * 0.5 : titlesize * 0.5) * !d.y_ch_size / !d.y_size
	offsety2 = (label_position ? -titlesize * 1.5 : -charsize * 1.0 - (titlesize > charsize) * 0.5 - titlesize * 1.0) * !d.y_ch_size / !d.y_size

endelse

if n_elements(toptitle) ne 0 then $
	xyouts,(!x.window[0]+!x.window[1])/2,!y.window[1] + offsety1,toptitle,charsize=titlesize,align=0.5,/norm,_extra=ex
if n_elements(bottomtitle) ne 0 then $
	xyouts,(!x.window[0]+!x.window[1])/2,!y.window[0] + offsety2,bottomtitle,charsize=titlesize,align=0.5,/norm,_extra=ex

if ~keyword_set(nosavecoord) then begin
	!p = oldp
	!x = oldx
	!y = oldy
	!z = oldz
endif

end

