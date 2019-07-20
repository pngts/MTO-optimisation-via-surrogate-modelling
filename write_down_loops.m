filename = 'loops_for_maxfunction.xlsx';

for i=1:2:18
global design_para_Cells lb ub
solutions_opti=zeros(3);
cl
calc_obj_with_LCA
INITIAL_OBJ=OBJ;
INITIAL_LCA=LCA_TOTAL;
INITIAL_BOTH=LCA_TOTAL/(-real(OBJ));
design_para_Cells = hycell(get(op,'Item', 'Design_par'), {'A1', 'A2', 'A3', 'A4', 'A5', 'A6', 'A7','A8', 'A9', 'A10', 'A11', 'A12'});
INITIAL_VALUES=hyvalue(design_para_Cells);

rng default % For reproducibility
fun1 = @(x) obj_opti_surrogate(x);
fun2 = @(x) obj_opti_surrogate_with_lca(x);
fun3= @(x)[obj_opti_surrogate(x);obj_opti_surrogate_with_lca(x)];
N = 20; % any even number
mf =i*length(design_para_Cells); % max fun evals
m_fm=15; % multi. variable for fmincon mac fun evals
lb = [0.05, 2 , 5 , 400 , 2000,2000,1800,2000, 500 ,20, 1600, 2500];
ub = [1.5 , 5 , 35, 450 , 3000,3000,3000,3000, 900,40, 2000, 3000];
rng default
x0 = [INITIAL_VALUES(:)];

%options = optimoptions('surrogateopt','MaxFunctionEvaluations',mf);
%[xm,fvalm,~,~,pop] = surrogateopt(fun1,lb,ub,options)

options = optimoptions('surrogateopt','MaxFunctionEvaluations',mf,'PlotFcn','surrogateoptplot');
[xm,fvalm,~,~,pop] = surrogateopt(fun1,lb,ub,options)
perc_improv1=((INITIAL_OBJ+fvalm)/INITIAL_OBJ)*100;
solutions_opti(1,:)=[INITIAL_OBJ/1.0e+06 -fvalm/1.0e+06 -perc_improv1]
%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
 
writematrix(solutions_opti,filename,'Sheet',i,'Range','A1')
ex
end