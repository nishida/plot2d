pro vectorwrite,x,y,vx,vy, $
    x_interval=x_interval, y_interval=y_interval,cof=cof 
 
;!p.background=255
;!p.color=0.
ix=n_elements(x)
iy=n_elements(y)
if (n_elements(x_interval) eq 0) then x_interval=1
if (n_elements(y_interval) eq 0) then y_interval=1
if (n_elements(cof) eq 0) then c=0.003 else c=cof
;print,interval,c
i=0
j=0
ei=(ix-2)/x_interval
ej=(iy-2)/y_interval
for ii=0,ei do begin
i=ii*x_interval
for jj=0,ej  do begin
j=jj*y_interval

a1=x(i)+c*vx(i,j)
b1=y(j)+c*vy(i,j)
a2=x(i)+c*(0.8*vx(i,j)+0.116*vy(i,j))
b2=y(j)+c*(0.8*vy(i,j)-0.116*vx(i,j))
a3=x(i)+c*(0.8*vx(i,j)-0.116*vy(i,j))
b3=y(j)+c*(0.8*vy(i,j)+0.116*vx(i,j))
zz=vx(i,j)*vx(i,j)+vy(i,j)*vy(i,j)
if zz le 0.1e-8 then goto,l1
oplot,[x(i),a1,a2,a1,a3],[y(j),b1,b2,b1,b3]
l1:
endfor
endfor


return
end

