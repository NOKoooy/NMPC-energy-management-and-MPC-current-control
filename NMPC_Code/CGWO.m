
function [Alpha_pos,bestf,cputime] = CGWO(f,conf,Max_iteration,SearchAgents_no,dim,lb,ub,...
    ConsTolerance)

% ConsTolerance = 0.1 ;
% OpTolerance = 1 ;

% t1 = tic ;
% initialize alpha, beta, and delta_pos
Alpha_pos=zeros(1,dim); % 初始化Alpha狼的位置
Alpha_score=inf; % 初始化Alpha狼的目标函数值，change this to -inf for maximization problems

Beta_pos=zeros(1,dim); % 初始化Beta狼的位置
Beta_score=inf; % 初始化Beta狼的目标函数值，change this to -inf for maximization problems

Delta_pos=zeros(1,dim); % 初始化Delta狼的位置
Delta_score=inf; % 初始化Delta狼的目标函数值，change this to -inf for maximization problems

%Initialize the positions of search agents
Positions=initialization(SearchAgents_no,dim,ub,lb);

Convergence_curve=zeros(1,Max_iteration);

l=0; % Loop counter循环计数器

% Main loop主循环
while l<Max_iteration  % 对迭代次数循环
    for i=1:size(Positions,1)  % 遍历每个狼
       flag=1;
       % Return back the search agents that go beyond the boundaries of the search space
       % 若搜索位置超过了搜索空间，需要重新回到搜索空间
        Flag4ub=Positions(i,:)>ub;
        Flag4lb=Positions(i,:)<lb;
        % 若狼的位置在最大值和最小值之间，则位置不需要调整，若超出最大值，最回到最大值边界；
        % 若超出最小值，最回答最小值边界
        Positions(i,:)=(Positions(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb; % ~表示取反           
      
      
       
       [c,ceq] = conf(Positions(i,:)) ;
       if length(ceq) == 0
           ceq = 0 ;
       end
       if length(c) == 0
           c = 0 ;
       end
        if (max(c)>ConsTolerance)|(min(abs(ceq))>ConsTolerance)
            flag=0;
        end
       if(flag==1) %如满足约束条件
           % 计算适应度函数值
            fitnessw=f(Positions(i,:));
            fitness=fitnessw; % 正求最小值，负求最大值

            % Update Alpha, Beta, and Delta
            if fitness<Alpha_score % 如果目标函数值小于Alpha狼的目标函数值
                Alpha_score=fitness; % 则将Alpha狼的目标函数值更新为最优目标函数值，Update alpha
                Alpha_pos=Positions(i,:); % 同时将Alpha狼的位置更新为最优位置
            end

            if fitness>Alpha_score && fitness<Beta_score % 如果目标函数值介于于Alpha狼和Beta狼的目标函数值之间
                Beta_score=fitness; % 则将Beta狼的目标函数值更新为最优目标函数值，Update beta
                Beta_pos=Positions(i,:); % 同时更新Beta狼的位置
            end

            if fitness>Alpha_score && fitness>Beta_score && fitness<Delta_score  % 如果目标函数值介于于Beta狼和Delta狼的目标函数值之间
                Delta_score=fitness; % 则将Delta狼的目标函数值更新为最优目标函数值，Update delta
                Delta_pos=Positions(i,:); % 同时更新Delta狼的位置
            end
       end

    end
    
    a=2*cos(l/Max_iteration*pi/2); % 对每一次迭代，计算相应的a值，a decreases linearly fron 2 to 0
    
    % Update the Position of search agents including omegas
    for i=1:size(Positions,1) % 遍历每个狼
        for j=1:size(Positions,2) % 遍历每个维度
            
            % 包围猎物，位置更新
            
            r1=rand(); % r1 is a random number in [0,1]
            r2=rand(); % r2 is a random number in [0,1]
            
            A1=2*a*r1-a; % 计算系数A，Equation (3.3)
            C1=2*r2; % 计算系数C，Equation (3.4)
            
            % Alpha狼位置更新
            D_alpha=abs(C1*Alpha_pos(j)-Positions(i,j)); % Equation (3.5)-part 1
            X1=Alpha_pos(j)-A1*D_alpha; % Equation (3.6)-part 1
                       
            r1=rand();
            r2=rand();
            
            A2=2*a*r1-a; % 计算系数A，Equation (3.3)
            C2=2*r2; % 计算系数C，Equation (3.4)
            
            % Beta狼位置更新
            D_beta=abs(C2*Beta_pos(j)-Positions(i,j)); % Equation (3.5)-part 2
            X2=Beta_pos(j)-A2*D_beta; % Equation (3.6)-part 2       
            
            r1=rand();
            r2=rand(); 
            
            A3=2*a*r1-a; % 计算系数A，Equation (3.3)
            C3=2*r2; % 计算系数C，Equation (3.4)
            
            % Delta狼位置更新
            D_delta=abs(C3*Delta_pos(j)-Positions(i,j)); % Equation (3.5)-part 3
            X3=Delta_pos(j)-A3*D_delta; % Equation (3.5)-part 3             
            
            % 位置更新
            Positions(i,j)=(X1+X2+X3)/3;% Equation (3.7)
            
        end
    end
    l=l+1;    
    Convergence_curve(l)=Alpha_score;
%     disp(['迭代次数为：',num2str(l),' ; ','性能指标为：',num2str(Alpha_score)]);
end
% bestc=Alpha_pos(1,1);
% bestg=Alpha_pos(1,2);
bestf=Alpha_score;
%% 打印参数选择结果
% disp('打印选择结果');
% str=sprintf('Best f = %g，Best x1 = %g，Best x2 = %g',bestf,bestc,bestg);
% disp(str)
%% 显示程序运行时间
% t2 = toc ;
cputime =[];% t2 - t1 ;


end