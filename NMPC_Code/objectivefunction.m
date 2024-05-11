
function y = objectivefunction(x)

global xtemp Qoad Cont ttemp target SOCRef

Nd = length(x) / 3 ;
Qg = zeros(1,Nd) ;
Sg = zeros(1,Nd) ;
temp = reshape(x,[3,Nd]) ;
ug = temp ;

[t,s] = RULER(@nonlinearStateFcn,xtemp,ttemp(1),ttemp(end),Nd,ug,Qg,Sg) ;

[c,ceq] = nonlinearcons(x);

y;


end
