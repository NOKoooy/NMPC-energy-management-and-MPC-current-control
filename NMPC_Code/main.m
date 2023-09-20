
clear all
clc
format long
close all

global xtemp Qoad Cont ttemp target SOCRef EpsN EpsS meth Nline

%% Initialization

% metbag = [{'AGPSO'},{'SQP'},{'GA'},{'GA_SQP'},{'TestGWO'}] ;
metbag = [{'SQP'},{'GA'},{'GA_SQP'},{'TestGWO_SQP'}] ;
for kkkk = 4
MethodSer = kkkk ;
meth = metbag{MethodSer} ;

SOCRef = 50 ; 
EpsN   = 10 ;
EpsS   = 3  ;
load('NengRef.mat','NengRef') ;
NengRef = NengRef' ;
x0    = [ NengRef(1) ; 48 ; 0 ; 0 ; 0 ] ;
Cont.N = [ 1800 , 0 ] ;
Cont.um = [ 90 , -90 ] ;
Cont.dum = [ 50 , -50 ] ;
Cont.duc = [ 20 , -10 ] ;
Cont.Soc = [ 80 , 20 ] ;
t0       = 0 ;
tf       = 1100 ;
N        = length(NengRef)  ;
Cont.t   = linspace(t0,tf,N) ;

Tp = 5 ;

TS = 5 ;

Qoad = zeros(1,N);

SOCoad = zeros(1,N);

epssNeng = 3 ;
epssSOC  = 1 ;

%% Generate Reference Control

timeline = linspace(t0,tf,(tf-t0)/TS) ;
Nline = 20 ;

tempu = zeros(3,Nline) ;
tempx = zeros(3,Nline) ; 

xstate(:,1) = x0 ;
ustate(:,1) = zeros(3,1) ;
tstate(1) = t0 ;
xstate_enl = [] ;
ustate_enl = [] ;
tstate_enl = [] ;

figure(kkkk)
hold on
grid on
box  on
plot(Cont.t,NengRef,'-.r','Linewidth',2) ;

for ii = 1 : length(timeline)-1

    tempt0 = timeline(ii) ;
    temptf = min( timeline(ii) + Tp , timeline(end) ) ;
    ug  = tempu ;
    Qg  = zeros(1,Nline) ;
    Sg  = zeros(1,Nline) ;
    [t,tempx] = RULER(@nonlinearStateFcn,xstate(:,ii),tempt0,temptf,Nline,ug,Qg,Sg) ;
    targetN = interp1(Cont.t,NengRef,temptf) ;
    deltaN(ii)  = abs( targetN - tempx(1,end) ) ;
    deltaS(ii)  = abs( 50 - tempx(2,end) ) ;

        tic
        tempu = ComU(tempt0,xstate(:,ii),temptf,NengRef) ;
        time(ii)=toc;

    ustate(:,ii+1) = tempu(:,end) ;
    ustate_enl = [ ustate_enl , tempu ] ;
    
    ug  = tempu ;
    Qg  = interp1(Cont.t,Qoad,linspace(tempt0,temptf,Nline))/Nline ;
    Sg   = interp1(Cont.t,SOCoad,linspace(tempt0,temptf,Nline))/Nline ;
    [t,tempx] = RULER(@nonlinearStateFcn,xstate(:,ii),timeline(ii),timeline(ii+1),Nline,ug,Qg,Sg) ;
    xstate(:,ii+1) = tempx(:,end) ;

    xstate_enl = [ xstate_enl , tempx ] ;
    
    tstate(ii+1) = timeline(ii+1) ;
    tstate_enl = [ tstate_enl , t ] ;
       
end
end

