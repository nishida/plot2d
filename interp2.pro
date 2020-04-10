;+
; interp2
; Bilinear interpolation with a non-uniform grid.
;
; result=interp2(data0,x0,y0,x1,y1,/grid)
;
; data0: 2D array for input. Any type except string can be used.
;
; x0, y0: 
;     n-element arrays defining the input grid. 
;     x0[i] and y0[j] define the location of data0[i,j].
;     The values MUST be monotonically ascending or descending.
;
; x1, y1:
;     n-element arrays defining the output grid.
;     x1 and y1 does not need to be monotonic. 
;     When grid keyword is set, x1[i] and y1[j] define the location 
;     of result[i,j].
;     When grid keyword is not set, x1[i] and y1[i] define the location
;     of result[i], and result and x1 and y1 must have same number of 
;     elmenents.
;
; result:
;     The output array.  When grid is set, the result is 2D array 
;     and has n_elements(x1) * n_elements(y1) elements.
;     When grid keyword is not set, the result is 1D array and 
;     has the same number of elements as x1 and y1.
;
;
; Created by Keisuke Nishida 12-Feb-2006
; Modified by Keisuke Nishida 25-Oct-2008
;        Use value_locate function.
; Modified by Keisuke Nishida 26-Oct-2008
;        Support grid keyword.
;
;-
function interp2,data0,x0,y0,x1,y1,grid=grid

COMPILE_OPT strictarr
on_error,2

ix = value_locate(x0,x1) > 0 < (n_elements(x0)-2)
iy = value_locate(y0,y1) > 0 < (n_elements(y0)-2)

if not keyword_set(grid) then begin
return,1.0 * $
       ((x0[ix+1]-x1) * (y0[iy+1]-y1) * data0[ix,iy] $
      + (x1-x0[ix])   * (y0[iy+1]-y1) * data0[ix+1,iy] $
      + (x0[ix+1]-x1) * (y1-y0[iy])   * data0[ix,iy+1] $
      + (x1-x0[ix])   * (y1-y0[iy])   * data0[ix+1,iy+1]) $
      / (x0[ix+1]-x0[ix]) / (y0[iy+1]-y0[iy])
endif else begin
return,1.0 * $
       ((x0[ix+1]-x1) # (y0[iy+1]-y1) * (data0[ix,*])[*,iy] $
      + (x1-x0[ix])   # (y0[iy+1]-y1) * (data0[ix+1,*])[*,iy] $
      + (x0[ix+1]-x1) # (y1-y0[iy])   * (data0[ix,*])[*,iy+1] $
      + (x1-x0[ix])   # (y1-y0[iy])   * (data0[ix+1,*])[*,iy+1]) $
      / ((x0[ix+1]-x0[ix]) # (y0[iy+1]-y0[iy]))
endelse
end

