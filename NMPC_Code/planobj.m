
function y = planobj(x)

global Task VortData PeakData

Nd = length(x) / 3 ;
tempx = reshape(x,[3,Nd]) ;
u = tempx ;

[t,y] = RULER(@dynamics,Task.IniState,Task.Timeinte(1),Task.Timeinte(2),Nd,u)










end