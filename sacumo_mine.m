function Data= sacumo_mine
    global design_para_Cells lb ub 

%%datainput_mop2.m is a multi-objective test problems example, source:
%Fonesca and Fleming 'multiobjective optimization and multiple constraint handling
% with evolutionary algorithms -Part II: Application example', 1998
%optimal solution: x in [-1/sqrt(3), 1/sqrt(3)]
%nonconvex Pareto front
%in order to define your own inputs file, copy-paste the structure of this
%file and adjust values as needed
%--------------------------------------------------------------------------
%Author information
%Juliane Mueller
%juliane.mueller2901@gmail.com
%--------------------------------------------------------------------------

Data.dim = 12; %problem dimension variable for mop2
Data.xlow= lb; %variable lower bounds
Data.xup= ub;  %variable upper bounds
Data.nr_obj = 2; %number of objective functions
Data.objfunction=@(x)my_fff(x); %handle to objective function evaluation
end %function
