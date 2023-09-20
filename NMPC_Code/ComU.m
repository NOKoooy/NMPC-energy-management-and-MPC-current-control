
function U = ComU(t0,x0,tr,NengRef)

global xtemp Qoad Cont ttemp target meth Nline

Nd = Nline;
% Nd = 20 ;
% NengRef = NengRef' ;
ttemp = linspace(t0,tr,Nd) ;

Ng = interp1(Cont.t,NengRef,ttemp ) ;
target = Ng ;

x = reshape( randn(3,Nd)*1 , [ 1 , 3 * Nd ] ) ;
narv = length(x) ;

Lb = reshape( repmat( [ Cont.duc(2) ; Cont.um(2) ; -500 ] , [1,Nd] ) , [1,3*Nd] ) ;
Ub = reshape( repmat( [ Cont.duc(1) ; Cont.um(1) ; 500 ] , [1,Nd] ) , [1,3*Nd] ) ;

%
switch (meth)
    case 'SQP'
        opssqp = optimoptions('fmincon','MaxIterations',10,'Display','iter','MaxFunctionEvaluations',1e3,'ConstraintTolerance',0.2,...
            'OptimalityTolerance',1);
        xtemp = x0 ;
        xsolution = fmincon(@objectivefunction,x,[],[],[],[],Lb,Ub,@nonlinearcons,opssqp) ;
    case 'GA'
        xtemp = x0 ;
        opsga = optimoptions('ga','MaxStallGenerations',30,'MaxGenerations',30,...
            'PopulationSize',10,'ConstraintTolerance',0.2,'FunctionTolerance',0.1,'Display','iter');
        xsolution = ga(@objectivefunction,narv,[],[],[],[],Lb,Ub,@nonlinearcons,[],opsga) ;

    case 'AGPSO'
xtemp = x0 ;
% opspso = psooptimset('Algorithm','pso','MaxStallGenerations',1,'MaxGenerations',1,...
%             'PopulationSize',1,'ConstraintTolerance',0.2,'FunctionTolerance',0.1,'Display','iter');
options.CognitiveAttraction = 0.5 ;
options.ConstrBoundary = 'penalize' ;
options.AccelerationFcn = @psoiterate ;
options.DemoMode = 'off' ;
options.Display = 'iter' ;
options.FitnessLimit = -inf ;
options.Generations = 20 ;
options.HybridFcn = [] ;
options.InitialPopulation = [] ;
options.InitialVelocities = [] ;
options.KnownMin = [] ;
options.OutputFcns = {} ;
options.PlotFcns = {} ;
options.PlotInterval = 1 ;
options.PopInitRange = [0;1] ;
options.PopulationSize = 10 ;
options.PopulationType = 'doubleVector' ;
options.SocialAttraction = 1.25 ;
options.StallGenLimit = 10 ;
options.StallTimeLimit = Inf ;
options.TimeLimit = Inf ;
options.TolCon = 1e-6 ;
options.TolFun = 1e-6 ;
options.UseParallel = 'never' ;
options.Vectorized = 'off' ;
options.VelocityLimit = [] ;
[xsolution,~,~] = pso(@objectivefunction,narv,[],[],[],[],Lb,Ub,@nonlinearcons,options) ;
    case 'GA_SQP'

        xtemp = x0 ;
        opsga = optimoptions('ga','MaxStallGenerations',20,'MaxGenerations',20,...
            'PopulationSize',10,'ConstraintTolerance',0.2,'FunctionTolerance',0.1,'Display','iter');
        xsolutiontt = ga(@objectivefunction,narv,[],[],[],[],Lb,Ub,@nonlinearcons,[],opsga) ;
        opssqp = optimoptions('fmincon','MaxIterations',20,'Display','iter','MaxFunctionEvaluations',1e3,'ConstraintTolerance',0.2,...
            'OptimalityTolerance',1);
        xsolution = fmincon(@objectivefunction,xsolutiontt,[],[],[],[],Lb,Ub,@nonlinearcons,opssqp) ;

    case 'TestGWO_SQP'

xtemp = x0 ;
[xsolution2,bestf,cputime] = CGWO(@objectivefunction,@nonlinearcons,50,100,narv,Lb,Ub,...
    1e-6);
opssqp = optimoptions('fmincon','MaxIterations',50,'Display','final','MaxFunctionEvaluations',3e3,'ConstraintTolerance',0.01,...
            'OptimalityTolerance',0.01);
        xsolution = fmincon(@objectivefunction,xsolution2,[],[],[],[],Lb,Ub,@nonlinearcons,opssqp) ;
    case 'GWO'
        xtemp = x0;
        [xsolution,bestf,cputime] = CGWO(@objectivefunction,@nonlinearcons,10,5,narv,Lb,Ub,...
    1e-6);

end

U = reshape(xsolution,[3,Nd]) ;



end