%___________________________________________________________________%
%  Grey Wolf Optimizer (GWO) source codes version 1.0               %
%                                                                   %
%  Developed in MATLAB R2011b(7.13)                                 %
%                                                                   %
%  Author and programmer: Seyedali Mirjalili                        %
%                                                                   %
%         e-Mail: ali.mirjalili@gmail.com                           %
%                 seyedali.mirjalili@griffithuni.edu.au             %
%                                                                   %
%       Homepage: http://www.alimirjalili.com                       %
%                                                                   %
%   Main paper: S. Mirjalili, S. M. Mirjalili, A. Lewis             %
%               Grey Wolf Optimizer, Advances in Engineering        %
%               Software , in press,                                %
%               DOI: 10.1016/j.advengsoft.2013.12.007               %
%                                                                   %
%___________________________________________________________________%

% This function initialize the first population of search agents
function Positions=initialization(SearchAgents_no,dim,ub,lb)

Boundary_no= size(ub,2); % numnber of boundaries

% If the boundaries of all variables are equal and user enter a signle
% number for both ub and lb
if Boundary_no==1
    for j=1:SearchAgents_no
        Positions(j)=mod(2*cos(2/5*pi)*j,1).*(ub-lb)+lb;
%         mod(2*cos(2/5*pi)*j,1).*
    end
end

% If each variable has a different lb and ub
if Boundary_no>1
%     for i=1:dim
%         ub_i=ub(i);
%         lb_i=lb(i);
%         Positions(:,i)=rand(SearchAgents_no,1).*(ub_i-lb_i)+lb_i;
%     end
    for j=1:SearchAgents_no
        for i=1:dim
            ub_i=ub(i);
            lb_i=lb(i);
            Positions(j,i)=mod(2*cos(2/7*pi)*j,1).*(ub_i-lb_i)+lb_i;
%             mod(2*cos(2/7*pi*i)*j,1).*
        end
    end
end