function dxdt = nonlinearStateFcn(t,x,u,Qload,SOCload)

%state:Neng SOC mec uice uem  control:uice_dot uem_dot Qload

Neng=x(1);
SOC=x(2);
mec=x(3);
uice=x(4);
um=x(5);

uice_dot=u(1);
um_dot=u(2);
e=u(3);%

Jsystem=12.047;
weng=(2*pi/60).*Neng;
%
k1=696;
k2=1.022;
Uoc=k2.*SOC+k1;
%
Qice=238.75+15.96.*uice+0.2343.*Neng+0.0001247.*Neng.^2;
Qem=5.8*um; %cem=5.8;
P0=385.18;
e=0.9598;
%
% Pem=(Qem.*weng+P0)./e;   
Pem=(Qem.*weng+P0).*e;    
Pb=Pem;
% Qnom=2.5;
Ri=0.664;
% igb=2.45;
%% 
[mf,mc]=fuel_CO2(abs(uice),Neng);

%%=======================================================================%%
A=0.8; 
lambdaC=0.067;
lambdaSOC=1-((2.*SOC-100)/60).^3;
lambda=1.56.*lambdaSOC;
Qc=3.3e7;


dxdt=zeros(5,1);

dxdt(1)=1/Jsystem .* (Qice+Qem-Qload);

dxdt(2)=-((Uoc-sqrt(Uoc.^2-4.*Pb.*Ri))./2*Ri)./(3600*200)+SOCload;

dxdt(3)=(1-A).*mf+A.*lambdaC.*mc+lambda.*(1/Qc).*Pb;% A dmec/dt

dxdt(4)=uice_dot;

dxdt(5)=um_dot;

end
