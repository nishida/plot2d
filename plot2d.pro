;+
; plot2d.pro Vesion 3.5.3
;
; Plot 2D data with a line contour, filled contour and vector map.
;
; pro plot2d[, x, y][, data1[, data2[, vector_x, vector_y]]]
;
; pro plot2d, data1
; pro plot2d, data1, data2
; pro plot2d, data1, data2, vector_x, vector_y
; pro plot2d, x, y
; pro plot2d, x, y, data1
; pro plot2d, x, y, data1, data2
; pro plot2d, x, y, data1, data2, vector_x, vector_y
;
; x, y: coordinates array (1D)
; data1: 2D array to filled contour plot
; data2: 2D array to contour plot
; vector_x, vector_y: velocity vector  (2D)
;
; any arguments can be set to !NULL in IDL 8.0 or later
;
; plot2d,x,y,0,0,0,0,/noplot,get_position=tmppos,get_region=tmpregion[,other keywords]
;    get layout without plot
;
; <General options>
;             position=position, get_position=get_position, $
;             region=region, get_region=get_region, $
;             /noplot, /noerase, $
;             charsize=charsize, charthick=charthick, font=font, $
;             xmargin=xmargin, ymargin=ymargin, offset_xmargin=offset_xmargin,
;             offset_ymargin=offset_ymargin, /nofitlayout, $
;             xrange=xrange, yrange=yrange, title=title, $
;             xtitle=xtitle, ytitle=ytitle, xstyle=xstyle, ystyle=ystyle, $
;             ticklen=ticklen, xticklen=xticklen, yticklen=yticklen, $
;
; <Options for filled contour>
;             /nodata1, c_colors=c_colors, /allcolors, levels=levels, nlevels=nlevels, $
;             maxlevel=maxlevel, minlevel=minlevel, /log, /abs, $
;             /cell_fill, /noadjustdrange, $
;
; <Options for line contour: prefix = 'l'>
;             /nodata2, lc_colors=lc_colors, llevels=llevels, lnlevels=lnlevels, $
;             lmaxlevel=lmaxlevel, lminlevel=lminlevel, $
;
; <Options for vector field>
;             novector=novector, interv=interv, coef=coef, vector_interval = vector_interval, $
;             vector_x_interval = vector_x_interval, vector_y_interval = vector_y_interval, $
;             vector_xrange = vector_xrange, vector_yrange = vector_yrange, $
;             vector_scale=vector_scale, vector_thick=vector_thick, vector_hthick = vector_hthick, $
;             vector_solid=vector_solid, vector_uniform=vector_uniform, vector_hsize=vector_hsize, $
;             vector_clip=vector_clip, vector_color=vector_color, $
;
; <Options for unit vector>
;             /nounitvector, uvector_color=uvector_color, uvector_label_color=uvector_label_color, $
;             uvector_unit=uvector_unit, $
;             uvector_title=uvector_title, uvector_offset=uvector_offset, $
;
; <Options for extra plots>
;             plotx=plotx, ploty=ploty, psym=psym, symcolor=symcolor, $
;
; <Options for color bar>
;             nocolorbar=nocolorbar, $
;             cbposition=cbposition, cbnoborder=cbnoborder, $
;             cbhorizontal=cbhorizontal, cblog=cblog, $
;             cbminor=cbminor, cbtickformat=cbtickformat, cbtickinterval=cbtickinterval, $
;             cbticklayout=cbticklayout, cbticklen=cbticklen, cbtickname=cbtickname, $
;             cbticks=cbticks, cbtickunits=cbtickunits, cbtickv=cbtickv, $
;             cbthick=cbthick, cbgridstyle=cbgridstyle, $
;             cblabel_position=cblabel_position, $
;             cbnormal=cbnormal, cbdevice=cbdevice, $
;             cbmaintitle=cbmaintitle, $
;             cbtoptitle=cbtoptitle, cblefttitle=cblefttitle, $
;             cbrighttitle = cbrighttitle, cbbottomtitle = cbbottomtitle, $
;             cbtitlesize = cbtitlesize, cbnosavecoord=cbnosavecoord, $
;             cbsubtitle = cbsubtitle, cbxtitle=cbxtitle, cbytitle=cbytitle, $
;
; <Other options>
;             [keywords accepted by CONTOUR are also supported]
;
;
; Derived from SNAP2D.PRO developed by Daikou Shiota 30-Sep-2002
;
; Modified by Keisuke Nishida before 30-Nov-2007
;     Change subroutine name to SNAP2DP
;     add PLOTX and PLOTY arguments
;     add PSYM, NOCOLORBAR, and NOVECTOR keywords
;     remove MOVIE and WHITE keywords
;     change default color scale
;     draw color bar before main plot
;     avoid error when phisical variable is uniform
;
; Modified by Keisuke Nishida 30-Nov-2007
;     add POSITION keyword
;     restore MOVIE and WHITE keywords
;     change default color scale (return to original)
;
; Modified by Keisuke Nishida 26-Oct-2008
;     change type of PLOTX and PLOTY from arguments to keywords
;     added keywords: ZOOM, NOERASE, XTITLE, YTITLE, BLACK, NOUNITVECTOR, CB*
;     support _EXTRA keyword
;     remove MOVIE keyword
;     disuse PostScript specific function
;     change default value of XRANGE and YRANGE
;     USE COLOR_BAR3
;
; Modified by Keisuke Nishida 3-Nov-2008
;     add MAXLEVEL, MINLEVEL, PMAXLEVEL, PMINLEVEL keywords
;     use COMPILE_OPT strictarr and on_error, 2            
;
; Modified by Keisuke Nishida 19-Dec-2008
;     open window before set graphics options
;
; Modified by Keisuke Nishida 18-Feb-2010
;     new keyword: NOPSI
;
; Modified by Keisuke Nishida 9-Sep-2011 Version 2.0
;     improve default position and style
;     new keywords: COMPATIBLE, NOTIMEINTITLE, VECTOR_*, UVECTOR_*, CB*, LOG, PCOLOR
;     use COLOR_BAR4
;     use VECTORWRITE2
;     use NORMVECTOR3
;
; Modified by Keisuke Nishida 9-Sep-2011 Version 2.1
;     new keywords: CELL_FILL, NOADJUSTDRANGE
;
; Modified by Keisuke Nishida 27-Sep-2011 Version 3.0
;     change subroutine name to PLOT2D
;     change input data form (from 3D to 2D)
;     new keywords: NODATA1, XSTYLE, YSTYLE
;     removed arguments: TIME, TA
;     removed keywords: COMPATIBLE, ZOOM, NOTIMEINTITLE, WHITE, BLACK
;     renamed keywords: COLOR => C_COLORS, LEVEL => LEVELS, NOPSI => NODATA2, 
;                       PCOLOR => LC_COLORS, PLEVELS => LLEVELS, PNLEVELS => LNLEVELS,
;                       PMAXLEVEL => LMAXLEVEL, PMINLEVEL => LMINLEVEL
;
; Modified by Keisuke Nishida 08-Oct-2011 Version 3.1
;     new keywords: NOPLOT, GET_POSITION
;     support 24-bit color mode
;     modify data range for log plot
;
; Modified by Keisuke Nishida 19-Nov-2011 Version 3.2
;     change default layout
;     default of [xy]title are changed to ''
;     new keywords: NOFITLAYOUT, REGION, GET_REGION, TICKLEN, UVECTOR_OFFSET
;     x and y can be set to !NULL or omitted
;     data[12] and vector_[xy] can be set to !NULL instead of use /nodata[12] and /novector
;     support !P.POSITION, !P.REGION, !P.MULTI system variables
;
; Modified by Keisuke Nishida 17-Dec-2011 Version 3.3
;     new keywords: ABS, XMARGIN_OFFSET, YMARGIN_OFFSET
;     default NOERASE is TRUE when NOPLOT is set
;
; Modified by Keisuke Nishida 06-Mar-2012 Version 3.4
;     new keyword: UVECTOR_LABEL_COLOR
;
; Modified by Keisuke Nishida 09-Mar-2012 Version 3.4.1
;     new keyword: SYMCOLOR
;     bug fix in xmargin and xrange when data1 doesn't exist
;
; Modified by Keisuke Nishida 01-Apr-2012 Version 3.5
;     don't draw vector outside data box
;     bug fix in POSITION keyword
;     bug fix in PSYM keyword
;
; Modified by Keisuke Nishida 15-Sep-2012 Version 3.5.1
;     renamed keywords: XMARGIN_OFFSET => OFFSET_XMARGIN, YMARGIN_OFFSET => OFFSET_YMARGIN
;     allow scalar for OFFSET_XMARGIN and OFFSET_YMARGIN
;
; Modified by Keisuke Nishida 11-Mar-2013 Version 3.5.2
;     new keyword: ALLCOLORS
;
; Modified by Keisuke Nishida 23-Janr-2019 Version 3.5.3
;     bug fix for !P.POSITION
;-

pro plot2d, arg1, arg2, arg3, arg4, arg5, arg6, $
	position = position, get_position=get_position, $
	region=region, get_region=get_region, $
	noplot=noplot, noerase=noerase, $
	charsize = charsize, charthick=charthick, font=font, $
	xmargin = xmargin, ymargin=ymargin, offset_xmargin = offset_xmargin, $
	offset_ymargin = offset_ymargin, nofitlayout=nofitlayout, $
	xrange = xrange, yrange=yrange, title=title, $
	xtitle = xtitle, ytitle=ytitle, xstyle=xstyle, ystyle=ystyle, $
	ticklen=ticklen, xticklen = xticklen, yticklen=yticklen, $
	nodata1 = nodata1, c_colors=c_colors, allcolors=allcolors, levels=levels, nlevels=nlevels, $
	maxlevel = maxlevel, minlevel=minlevel, log=log, abs=abs, $
	cell_fill = cell_fill, noadjustdrange=noadjustdrange, $
	nodata2 = nodata2, lc_colors=lc_colors, llevels=llevels, lnlevels=lnlevels, $
	lmaxlevel = lmaxlevel, lminlevel = lminlevel, $
	novector = novector, interv = interv, coef = coef, vector_interval = vector_interval, $
	vector_x_interval = vector_x_interval, vector_y_interval = vector_y_interval, $
	vector_xrange = vector_xrange, vector_yrange = vector_yrange, $
	vector_scale=vector_scale, vector_thick=vector_thick, vector_hthick = vector_hthick, $
	vector_solid=vector_solid, vector_uniform=vector_uniform, vector_hsize=vector_hsize, $
	vector_clip=vector_clip, vector_color=vector_color, $
	nounitvector=nounitvector, uvector_color = uvector_color, uvector_label_color=uvector_label_color, $
	uvector_unit=uvector_unit, $
	uvector_title=uvector_title, uvector_offset=uvector_offset, $
	plotx=plotx, ploty=ploty, psym=psym, symcolor=symcolor, $
	nocolorbar=nocolorbar, $
	cbposition=cbposition, cbnoborder=cbnoborder, $
	cbhorizontal=cbhorizontal, cblog=cblog, $
	cbminor=cbminor, cbtickformat=cbtickformat, cbtickinterval=cbtickinterval, $
	cbticklayout=cbticklayout, cbticklen=cbticklen, cbtickname=cbtickname, $
	cbticks=cbticks, cbtickunits=cbtickunits, cbtickv=cbtickv, $
	cbthick=cbthick, cbgridstyle=cbgridstyle, $
	cblabel_position=cblabel_position, $
	cbnormal=cbnormal, cbdevice=cbdevice, $
	cbmaintitle=cbmaintitle, $
	cbtoptitle=cbtoptitle, cblefttitle=cblefttitle, $
	cbrighttitle = cbrighttitle, cbbottomtitle = cbbottomtitle, $
	cbtitlesize = cbtitlesize, cbnosavecoord=cbnosavecoord, $
	cbsubtitle = cbsubtitle, cbxtitle=cbxtitle, cbytitle=cbytitle, $
	_extra=extra

COMPILE_OPT strictarr
on_error, 2

x_exist = 1
y_exist = 1
data1_exist = ~keyword_set(nodata1)
data2_exist = ~keyword_set(nodata2) 
vector_exist = ~keyword_set(novector)

case n_params() of
	1 : begin ; arg1=data1
		x_exist = 0
		y_exist = 0
		if (data1_exist  and= n_elements(arg1) gt 0) then data1 = reform(arg1)
		data2_exist = 0
		vector_exist = 0
	end
	2 : begin
		if size(arg1, /n_dimensions) le 1 && size(arg2, /n_dimensions) le 1 then begin
			; arg1=x, arg2=y
			if (x_exist      and= n_elements(arg1) gt 0) then x = reform(arg1)
			if (y_exist      and= n_elements(arg2) gt 0) then y = reform(arg2)
			data1_exist = 0
			data2_exist = 0
			vector_exist = 0
		endif else begin
			; arg1=data1, arg2=data2
			x_exist = 0
			y_exist = 0
			if (data1_exist  and= n_elements(arg1) gt 0) then data1 = reform(arg1)
			if (data2_exist  and= n_elements(arg2) gt 0) then data2 = reform(arg2)
			vector_exist = 0
		endelse
	end
	3 : begin ; arg1=x, arg2=y, arg3=data1
		if (x_exist      and= n_elements(arg1) gt 0) then x = reform(arg1)
		if (y_exist      and= n_elements(arg2) gt 0) then y = reform(arg2)
		if (data1_exist  and= n_elements(arg3) gt 0) then data1 = reform(arg3)
		data2_exist = 0
		vector_exist = 0
	end
	4 : begin
		if size(arg1, /n_dimensions) le 1 && size(arg2, /n_dimensions) le 1 then begin
			; arg1=x, arg2=y, arg3=data1, arg4=data2
			if (x_exist      and= n_elements(arg1) gt 0) then x = reform(arg1)
			if (y_exist      and= n_elements(arg2) gt 0) then y = reform(arg2)
			if (data1_exist  and= n_elements(arg3) gt 0) then data1 = reform(arg3)
			if (data2_exist  and= n_elements(arg4) gt 0) then data2 = reform(arg4)
			vector_exist = 0
		endif else begin
			; arg1=data1, arg2=data2, arg3=vector_x, arg4=vector_y
			x_exist = 0
			y_exist = 0
			if (data1_exist  and= n_elements(arg1) gt 0) then data1 = reform(arg1)
			if (data2_exist  and= n_elements(arg2) gt 0) then data2 = reform(arg2)
			if (vector_exist and= n_elements(arg3) gt 0 && n_elements(arg4) gt 0) then begin
				vector_x = reform(arg3)
				vector_y = reform(arg4)
			endif
		endelse
	end
	6 : begin ; arg1=x, arg2=y, arg3=data1, arg4=data2, arg5=vector_x, arg6=vector_y
		if (x_exist      and= n_elements(arg1) gt 0) then x = reform(arg1)
		if (y_exist      and= n_elements(arg2) gt 0) then y = reform(arg2)
		if (data1_exist  and= n_elements(arg3) gt 0) then data1 = reform(arg3)
		if (data2_exist  and= n_elements(arg4) gt 0) then data2 = reform(arg4)
		if (vector_exist and= n_elements(arg5) gt 0 && n_elements(arg6) gt 0) then begin
			vector_x = reform(arg5)
			vector_y = reform(arg6)
		endif
	end
	else : begin
		message, 'invalid number of arguments'
	end
endcase

if x_exist && size(x, /n_dimensions) ne 1 then message, 'dimension of X should be 1'
if y_exist && size(y, /n_dimensions) ne 1 then message, 'dimension of Y should be 1'

; if NOPLOT keyword is set, data is not checked
if ~keyword_set(noplot) then begin
	if data1_exist && size(data1, /n_dimensions) ne 2 then message, 'dimension of DATA1 should be 2'
	if data2_exist && size(data2, /n_dimensions) ne 2 then message, 'dimension of DATA2 should be 2'
	if vector_exist && size(vector_x, /n_dimensions) ne 2 then message, 'dimension of VECTOR_X should be 2'
	if vector_exist && size(vector_y, /n_dimensions) ne 2 then message, 'dimension of VECTOR_Y should be 2'
endif

size0 = x_exist && y_exist ? [n_elements(x), n_elements(y)] : $
	(data1_exist ? size(data1, /dimensions) : $
	(data2_exist ? size(data2, /dimensions) : $
	(vector_exist ? size(vector_x, /dimensions) : $
	-1)))

if size0[0] eq -1 then message, 'Not enough valid data'
nx = size0[0]
ny = size0[1]

; if NOPLOT keyword is set, data is not checked
if ~keyword_set(noplot) then begin
	if data1_exist && ~array_equal(size(data1, /dimensions), size0) then message, 'incompatible size of DATA1'
	if data2_exist && ~array_equal(size(data2, /dimensions), size0) then message, 'incompatible size of DATA2'
	if vector_exist && ~array_equal(size(vector_x, /dimensions), size0) then message, 'incompatible size of VECTOR_X'
	if vector_exist && ~array_equal(size(vector_y, /dimensions), size0) then message, 'incompatible size of VECTOR_Y'
endif

if x_exist then begin
	if n_elements(x) ne nx then message, 'incompatible size of X'
endif else begin
	x = lindgen(nx)
endelse

if y_exist then begin
	if n_elements(y) ne ny then message, 'incompatible size of Y'
endif else begin
	y = lindgen(ny)
endelse

if (!d.name eq 'X' || !d.name eq 'WIN') && !d.window eq -1 then window

decomposed=0
if !d.name eq 'X' || !d.name eq 'WIN' || !d.name eq 'Z' || !d.name eq 'PS' then device, get_decomposed=decomposed

if n_elements(title) eq 0 then title = ''
if n_elements(xtitle) eq 0 then xtitle = ''
if n_elements(ytitle) eq 0 then ytitle = ''
if n_elements(xstyle) eq 0 then xstyle = 1
if n_elements(ystyle) eq 0 then ystyle = 1

if n_elements(cbhorizontal) eq 0 then cbhorizontal = 0
if n_elements(xticklen) eq 0 then xticklen = (n_elements(ticklen) eq 0) ? -0.02 : ticklen
if n_elements(yticklen) eq 0 then yticklen = (n_elements(ticklen) eq 0) ? -0.02 : ticklen

if n_elements(charsize) eq 0 then charsize = !p.charsize eq 0 ? 1.0 : !p.charsize

charsizefactor = (!p.multi[1] > !p.multi[2]) le 2 ? 1.0 : 0.5
x_ch_size_norm = 1.0 * !d.x_ch_size * charsize / !d.x_size * charsizefactor
y_ch_size_norm = 1.0 * !d.y_ch_size * charsize / !d.y_size * charsizefactor

; units of xmargin and ymargin are character size
if n_elements(xmargin) eq 0 then begin
	xmargin_left = 6.5
	xmargin_right = 3.0
	if keyword_set(nofitlayout) || ytitle ne '' then xmargin_left += 1.5
	if ~cbhorizontal && ~keyword_set(nocolorbar) && data1_exist then xmargin_right += 7.0
	xmargin = [xmargin_left, xmargin_right]
	implicit_xmargin = 1
endif else begin
	if n_elements(xmargin) ne 2 then message,'xmargin should be 2-elements array'
	implicit_xmargin = 0
endelse

if n_elements(offset_xmargin) eq 0 then begin
	xmargin_modified = xmargin
endif else if n_elements(offset_xmargin) le 2 then begin
	xmargin_modified = xmargin + offset_xmargin
endif else begin
	message,'offset_xmargin should be scalar or 2-elements array'
endelse

if n_elements(ymargin) eq 0 then begin
	ymargin_top = 2.0
	ymargin_bottom = 2.5
	if keyword_set(nofitlayout) || xtitle ne '' then ymargin_bottom += 1.5
	if cbhorizontal && ~keyword_set(nocolorbar) && data1_exist then ymargin_bottom += 3.0
	if vector_exist && ~keyword_set(nounitvector) then ymargin_bottom += 1.0
	ymargin = [ymargin_bottom, ymargin_top]
	implicit_ymargin = 1
endif else begin
	if n_elements(ymargin) ne 2 then message,'ymargin should be 2-elements array'
	implicit_ymargin = 0
endelse

if n_elements(offset_ymargin) eq 0 then begin
	ymargin_modified = ymargin
endif else if n_elements(offset_ymargin) le 2 then begin
	ymargin_modified = ymargin + offset_ymargin
endif else begin
	message,'offset_ymargin should be scalar or 2-elements array'
endelse

multiplot = 0

; Priority: position keyword > region keyword > !p.position > !p.region > !p.multi > use whole area [default]
; POSITION_TMP will be modified later due to outside tick, then copy to POSITION
if n_elements(position) eq 0 then begin
	xmargin_norm_tmp = xmargin_modified * x_ch_size_norm
	ymargin_norm_tmp = ymargin_modified * y_ch_size_norm
	position_offset_tmp = [xmargin_norm_tmp[0], ymargin_norm_tmp[0], -xmargin_norm_tmp[1], -ymargin_norm_tmp[1]]
	if n_elements(region) eq 4 && ~array_equal(region, [0, 0, 0, 0]) then begin
		position_tmp = region + position_offset_tmp
	endif else if ~array_equal(!p.position, [0, 0, 0, 0]) then begin
		position_tmp = !p.position
	endif else if ~array_equal(!p.region, [0, 0, 0, 0]) then begin
		position_tmp = !p.region + position_offset_tmp
	endif else if !p.multi[1] le 1 && !p.multi[2] le 1 then begin
		position_tmp = [0.0, 0.0, 1.0, 1.0] + position_offset_tmp
	endif else begin
		; if !P.MULTI is used, POSITION is not passed to contour
		; POSITION_TMP is used only for modify margin
		position_tmp = [0.0, 0.0, 1.0 / !p.multi[1], 1.0 / !p.multi[2]] + position_offset_tmp
		multiplot = 1
	endelse
endif else begin
	position_tmp = position
	if n_elements(region) ne 0 then message, /info, 'REGION is ignored when POSITION is supplied'
endelse

; margin and position are modified when ticklen < 0 (outside tick)
; when POSITION keyword is supplied , position is not modified
if ~keyword_set(nofitlayout) then begin
	if implicit_xmargin && yticklen lt 0 then begin
		if n_elements(position) eq 0 then begin
			ytickmargin_norm = 1.0 * (-yticklen) * (position_tmp[2] - position_tmp[0]) / (1.0 - 2 * yticklen)
			position_tmp[0] += ytickmargin_norm
			position_tmp[2] -= ytickmargin_norm
		endif
		ytickmargin_char = 1.0 * (-yticklen) * (position_tmp[2]-position_tmp[0]) / x_ch_size_norm
		xmargin_modified += ytickmargin_char
	endif
	if implicit_ymargin && xticklen lt 0 then begin
		if n_elements(position) eq 0 then begin
			xtickmargin_norm = 1.0 * (-xticklen) * (position_tmp[3] - position_tmp[1]) / (1.0 - 2 * xticklen)
			position_tmp[1] += xtickmargin_norm
			position_tmp[3] -= xtickmargin_norm
		endif
		xtickmargin_char = 1.0 * (-xticklen) * (position_tmp[3]-position_tmp[1]) / y_ch_size_norm
		ymargin_modified += xtickmargin_char
	endif

	if n_elements(position) eq 0 && ~multiplot then position = position_tmp
endif

if n_elements(position) eq 4 && (position[0] ge position[2] || position[1] ge position[3]) then $
	message, 'Plot area is too small'

if n_elements(noerase) eq 0 then noerase = keyword_set(noplot)

if keyword_set(noplot) then begin
	; only set coordinates and exit
	contour, intarr(nx, ny, /nozero), x, y, /nodata, xstyle=xstyle or 4, ystyle=ystyle or 4, $
		xmargin=xmargin_modified, ymargin=ymargin_modified, xrange=xrange, yrange=yrange, $
		noerase=noerase, position=position, $
		_extra=extra

endif else if data1_exist then begin
	if keyword_set(abs) then data1 = temporary(abs(data1))
	if  n_elements(levels) ne 0 then begin 
		nlevels = n_elements(levels)
		if n_elements(minlevel) eq 0 then minlevel = levels[0]
	endif else begin
		if n_elements(nlevels) eq 0 then nlevels = 11
		if n_elements(maxlevel) eq 0 then maxlevel = max(data1)
		if n_elements(minlevel) eq 0 then minlevel = min(data1)
		if keyword_set(log) then begin
			if maxlevel le 0 then begin
				levels = [(machar()).xmin]
			endif else if minlevel le 0 then begin
				tmpminlevel = maxlevel * 1e-8
				levels = 10^(dindgen(nlevels)/(nlevels)*(alog10(double(maxlevel))-alog10(double(tmpminlevel))) $
					+alog10(double(tmpminlevel)))
			endif else if maxlevel eq minlevel then begin
				levels = [maxlevel]
			endif else begin
				levels = 10^(dindgen(nlevels)/(nlevels)*(alog10(double(maxlevel))-alog10(double(minlevel))) $
					+alog10(double(minlevel)))
			endelse
		endif else begin
			if maxlevel ne minlevel then begin
				levels = dindgen(nlevels)/nlevels*(double(maxlevel)-double(minlevel))+minlevel 
			endif else begin
				levels = [maxlevel]
			endelse
		endelse
	endelse

	if n_elements(c_colors) eq 0 then begin
		if decomposed eq 0 then begin
			; indexed color
			if keyword_set(allcolors) then begin
				c_colors = levels(1, 254, nlevels) ; 1 to 254
			endif else begin
				c_colors = findgen(nlevels)/nlevels*200+40 ; 40 to <=239
			endelse
		endif else begin
			; 24-bit color (using color table if c_colors is omitted)
			tvlct, red, green, blue, /get
			if keyword_set(allcolors) then begin
				c_colors = (rgb(red, green, blue))[levels(1, 254, nlevels)]
			endif else begin
				c_colors = (rgb(red, green, blue))[findgen(nlevels)/nlevels*200+40]
			endelse
		endelse
	endif
	if keyword_set(noadjustdrange) then begin
		data = data1
	endif else begin
		data = levels[0] > data1 ; NaN is conserved, because data is put on RHS
	endelse

	contour, data, x, y, xstyle=xstyle, ystyle=ystyle, /fill, $
		xmargin=xmargin_modified, ymargin=ymargin_modified, xrange=xrange, yrange=yrange, $
		noerase=noerase, c_colors=c_colors, levels=levels, position=position, $
		xtitle=xtitle, ytitle=ytitle, xticklen=xticklen, yticklen=yticklen, $
		title=title, charsize=charsize, charthick=charthick, font=font, $
		cell_fill=cell_fill, _extra=extra
endif else begin
	contour, intarr(nx, ny, /nozero), x, y, /nodata, xstyle=xstyle, ystyle=ystyle, $
		xmargin=xmargin_modified, ymargin=ymargin_modified, xrange=xrange, yrange=yrange, $
		noerase=noerase, position=position, $
		xtitle=xtitle, ytitle=ytitle, xticklen=xticklen, yticklen=yticklen, $
		title=title, charsize=charsize, charthick=charthick, font=font, $
		_extra=extra
endelse


if arg_present(get_position) then $
	get_position = [!x.window[0], !y.window[0], !x.window[1], !y.window[1]]
if arg_present(get_region) then $
	get_region = [!x.region[0], !y.region[0], !x.region[1], !y.region[1]]

if keyword_set(noplot) then return

if data2_exist then begin
	if n_elements(llevels) ne 0 then begin
		lnlevels = n_elements(llevels)
	endif else begin
		if n_elements(lnlevels) eq 0 then lnlevels = 21
		if n_elements(lmaxlevel) eq 0 then lmaxlevel = max(data2)
		if n_elements(lminlevel) eq 0 then lminlevel = min(data2)
		if lmaxlevel ne lminlevel then $
			llevels = findgen(lnlevels)/(lnlevels-1)*(lmaxlevel-lminlevel)+lminlevel $
		else $
			llevels = [lmaxlevel]
	endelse
	contour, data2, x, y, levels=llevels, /overplot, c_colors=lc_colors, _extra=extra
endif


if vector_exist then begin
	default_vector_scale = (abs(!x.crange[1]-!x.crange[0]) / 5.0) < 1.0
	if n_elements(vector_scale) eq 0 then begin
		vector_scale = (n_elements(coef) eq 0) ? default_vector_scale : coef
		if n_elements(uvector_title) ne 0 then $
			message, /info, 'Though VECTOR_SCALE is set automatically, UVECTOR_TITLE is set explicitly.'
	endif
	
	if n_elements(vector_interval) eq 0 then begin
		vector_interval = (n_elements(interv) ne 0) ? interv: (keyword_set(vector_uniform) ? 1 : 10)
	endif
	if n_elements(vector_x_interval) eq 0 then vector_x_interval = vector_interval
	if n_elements(vector_y_interval) eq 0 then vector_y_interval = vector_interval
	if n_elements(vector_solid) eq 0 then vector_solid = 1
	if n_elements(vector_xrange) eq 0 then vector_xrange = !x.crange > min(x) < max(x)
	if n_elements(vector_yrange) eq 0 then vector_yrange = !y.crange > min(y) < max(y)

	vectorwrite2, x, y, vector_x, vector_y, $
		x_interval=vector_x_interval, y_interval=vector_y_interval, $
		xrange = vector_xrange, yrange = vector_yrange, $
		scale=vector_scale, thick=vector_thick, hthick = vector_hthick, $
		solid=vector_solid, uniform=vector_uniform, hsize=vector_hsize, clip=vector_clip, color=vector_color

	if ~keyword_set(nounitvector) then begin
		if n_elements(uvector_offset) eq 0 then begin
			xtickmargin_norm = -(xticklen < 0) * (!y.window[1] - !y.window[0])
			uvector_offset = [0.0, 0.0]
			if ~keyword_set(nofitlayout) && xtitle eq '' then uvector_offset[1] += 1.5 * y_ch_size_norm
			if ~keyword_set(nofitlayout) then uvector_offset[1] += -xtickmargin_norm
		endif

		normvector3, unit=uvector_unit, scale=vector_scale, thick=vector_thick, $
			hthick = vector_hthick, title=uvector_title, offset=uvector_offset, $
			solid=vector_solid, hsize=vector_hsize, vector_color=uvector_color, $
			label_color=uvector_label_color, $
			charsize=charsize, charthick=charthick, font=font, _extra=extra
	endif
endif

if n_elements(psym) ne 0 && n_elements(plotx) ne 0 && n_elements(ploty) ne 0 then begin
	oplot, plotx, ploty, psym=psym, color=symcolor, _extra=extra
endif

if ~keyword_set(nocolorbar) && data1_exist then begin
	nocbspace = 0
	if n_elements(cbposition) eq 0 then begin
		if ~cbhorizontal then begin
			if n_elements(cblabel_position) eq 0 then cblabel_position = 1
			ytickmargin_norm = keyword_set(nofitlayout) ? 0 : -(yticklen < 0) * (!x.window[1] - !x.window[0])
			cbminwidth_norm = 4.0 * x_ch_size_norm
			if !x.region[1] - !x.window[1] lt cbminwidth_norm + ytickmargin_norm then begin
				nocbspace = 1
			endif else begin
				if cblabel_position then begin
					pos1 = (!x.window[1] + ytickmargin_norm + 1.0 * x_ch_size_norm) < (!x.region[1] - cbminwidth_norm)
					pos2 = (pos1 + 2.5 * x_ch_size_norm) < (!x.region[1] - cbminwidth_norm + 0.5 * x_ch_size_norm) 
				endif else begin
					pos1 = (!x.window[1] + ytickmargin_norm + 6.0 * x_ch_size_norm) < (!x.region[1] - 1.0 * x_ch_size_norm)
					pos2 = (pos1 + 2.5 * x_ch_size_norm) < (!x.region[1] - 0.5 * x_ch_size_norm)
				endelse
				cbposition = [pos1, !y.window[0], pos2, !y.window[1]]
			endelse
		endif else begin
			if n_elements(cblabel_position) eq 0 then cblabel_position = 0
			xtickmargin_norm = keyword_set(nofitlayout) ? 0 : -(xticklen < 0) * (!y.window[1] - !y.window[0])
			xlabelheight_norm = (keyword_set(nofitlayout) || xtitle ne '' ? 4.0 : 2.5) * y_ch_size_norm
			uvectorheight_norm = (vector_exist && ~keyword_set(nounitvector) ? 1.0 : 0.0) * y_ch_size_norm
			cbminheight_norm = 2.5 * y_ch_size_norm
			if !y.window[0] - !y.region[0] lt cbminheight_norm + xtickmargin_norm + uvectorheight_norm + xlabelheight_norm then begin
				nocbspace = 1
			endif else begin
				if cblabel_position then begin
					pos2 = (!y.window[0] - xtickmargin_norm - xlabelheight_norm - uvectorheight_norm - 1.5 * y_ch_size_norm ) > $
						(!y.region[0] + 1.0 * y_ch_size_norm)
					pos1 = (pos2 - 1.0 * y_ch_size_norm) > (!y.region[0] + 0.5 * y_ch_size_norm)
				endif else begin
					pos2 = (!y.window[0] - xtickmargin_norm - xlabelheight_norm - uvectorheight_norm) > $
						(!y.region[0] + cbminheight_norm)
					pos1 = (pos2 - 1.0 * y_ch_size_norm) > (!y.region[0] + cbminheight_norm - 0.5 * y_ch_size_norm)
				endelse
				cbposition = [!x.window[0], pos1, !x.window[1], pos2]
			endelse
		endelse
	endif
	if n_elements(cblog) eq 0 && keyword_set(log) then cblog = 1

	if nocbspace eq 1 then begin
		message, 'No space for color bar', /info
	endif else begin
		color_bar4, c_colors=c_colors, levels=levels, $
			position=cbposition, noborder=cbnoborder, $
			horizontal=cbhorizontal, log=cblog, $
			minor=cbminor, tickformat=cbtickformat, tickinterval=cbtickinterval, $
			ticklayout=cbticklayout, ticklen=cbticklen, tickname=cbtickname, $
			ticks=cbticks, tickunits=cbtickunits, tickv=cbtickv, $
			thick=cbthick, gridstyle=cbgridstyle, $
			label_position=cblabel_position, $
			normal=cbnormal, device=cbdevice, $
			maintitle=cbmaintitle, $
			toptitle=cbtoptitle, lefttitle=cblefttitle, $
			righttitle = cbrighttitle, bottomtitle = cbbottomtitle, $
			titlesize = cbtitlesize, nosavecoord=cbnosavecoord, $
			subtitle = cbsubtitle, xtitle=cbxtitle, ytitle=cbytitle, $
			charsize=charsize, charthick=charthick, font=font
	endelse
endif

end


