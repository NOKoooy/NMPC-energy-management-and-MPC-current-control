
function [c,ceq] = nonlinearcons(x)

global xtemp Qoad Cont ttemp target EpsN SOCRef EpsS

Nd = length(x) / 3 ;
Qg = zeros(1,Nd) ; % interp1(Cont.t,Qoad,ttemp) ;
Sg = zeros(1,Nd) ;
temp = reshape(x,[3,Nd]) ;
ug = temp ;

[t,s] = RULER(@nonlinearStateFcn,xtemp,ttemp(1),ttemp(end),Nd,ug,Qg,Sg) ;

c = s(1,:) - Cont.N(1) ;
c = [ c , - s(1,:) + Cont.N(2) ] ;
c = [ c , - s(2,:) + Cont.Soc(2) ] ;
c = [ c , s(2,:) - Cont.Soc(1) ] ;
c = [ c , s(5,:) - Cont.um(1) ] ;
c = [ c , - s(5,:) + Cont.um(2) ] ;
c = [ c , norm(target(end)-s(1,end))-EpsN ] ;
c = [ c , norm(SOCRef-s(2,end))-EpsS ] ;
c = real(c) ;
ceq = [] ;


end