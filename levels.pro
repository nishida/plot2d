; make levels array for contour
; see also levelf.pro
; 2009/10/02 Created by Keisuke Nishida
; 2011/09/09 Modified by Keisuke Nishida

function levels,minlv,maxlv,nlv,log=log,uniq=uniq,double=double

COMPILE_OPT strictarr
on_error,2

if (nlv lt 1) then message,'NLV mult be >=1'
if (nlv eq 1) then return,[1d * minlv]

if keyword_set(log) then begin
	level = 10^(dindgen(nlv)/(nlv-1d)*(alog10(double(maxlv))-alog10(double(minlv)))+alog10(double(minlv)))
endif else begin
	level = dindgen(nlv)/(nlv-1d)*(double(maxlv)-double(minlv))+minlv
endelse

if (~keyword_set(double) && size(minlv,/type) ne 5 && size(maxlv,/type) ne 5) then level=float(level)

if keyword_set(uniq) then begin
	return,level[uniq(level)]
endif else begin
	return,level
endelse

end

