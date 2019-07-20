global design_para_Cells lb ub

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
mf =10*length(design_para_Cells); % max fun evals
m_fm=15; % multi. variable for fmincon mac fun evals
lb = [0.05, 2 , 5 , 400 , 2200,2200,2000,2000, 500 ,20, 1600, 2500];
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

psopts = optimoptions('patternsearch','PlotFcn','psplotbestf','MaxFunctionEvaluations',mf);
[psol,pfval] = patternsearch(fun1,x0,[],[],[],[],lb,ub,[],psopts)
perc_improv2=((INITIAL_OBJ+pfval)/INITIAL_OBJ)*100;
solutions_opti(2,:)=[INITIAL_OBJ/1.0e+06  -pfval/1.0e+06 -perc_improv2]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

opts = optimoptions('fmincon','PlotFcn','optimplotfval','MaxFunctionEvaluations',mf*m_fm);
[fmsol,fmfval,eflag,fmoutput] = fmincon(fun1,x0,[],[],[],[],lb,ub,[],opts)
perc_improv3=((INITIAL_OBJ+fmfval)/INITIAL_OBJ)*100;
solutions_opti(3,:)=[INITIAL_OBJ/1.0e+06 -fmfval/1.0e+06 -perc_improv3]
%%%%%%%%%%%%%%%%%%
opts = optimoptions('fmincon','PlotFcn','optimplotfval','MaxFunctionEvaluations',mf*m_fm,'Algorithm','sqp');
[fmsol2,fmfval2,eflag,fmoutput] = fmincon(fun1,x0,[],[],[],[],lb,ub,[],opts)
perc_improv4=((INITIAL_OBJ+fmfval2)/INITIAL_OBJ)*100;
solutions_opti(4,:)=[INITIAL_OBJ/1.0e+06 -fmfval2/1.0e+06 -perc_improv4]
%%%%%%%%%%%%%%%%%%
opts = optimoptions('fmincon','PlotFcn','optimplotfval','MaxFunctionEvaluations',mf*m_fm,'Algorithm','sqp-legacy');
[fmso3,fmfval3,eflag,fmoutput] = fmincon(fun1,x0,[],[],[],[],lb,ub,[],opts)
perc_improv5=((INITIAL_OBJ+fmfval3)/INITIAL_OBJ)*100;
solutions_opti(5,:)=[INITIAL_OBJ/1.0e+06 -fmfval3/1.0e+06 -perc_improv5]
%%%%%%%%%%%%%%%%%%
opts = optimoptions('fmincon','PlotFcn','optimplotfval','MaxFunctionEvaluations',mf*m_fm,'Algorithm','active-set');
[fmso4,fmfval4,eflag,fmoutput] = fmincon(fun1,x0,[],[],[],[],lb,ub,[],opts)
perc_improv6=((INITIAL_OBJ+fmfval4)/INITIAL_OBJ)*100;
solutions_opti(6,:)=[INITIAL_OBJ/1.0e+06 -fmfval4/1.0e+06 -perc_improv6]
%%%%%%%%%%%%%%%%%%%%%
% options = optimset('PlotFcns',@optimplotfval);
% [x,fval4] = fminsearch(fun,x0);
% perc_improv6=((INITIAL_OBJ+fval4)/INITIAL_OBJ)*100;
% solutions_opti(6,:)=[INITIAL_OBJ/1.0e+06 -fval4/1.0e+06 -perc_improv6]
%%%%%%%%%%%%%%%%%%
%% --- LCA
options = optimoptions('surrogateopt','MaxFunctionEvaluations',mf,'PlotFcn','surrogateoptplot');
[xm,fvalm,~,~,pop] = surrogateopt(fun2,lb,ub,options)
perc_improv1=((INITIAL_LCA-fvalm)/INITIAL_LCA)*100;
solutions_opti(1,:)=[INITIAL_LCA fvalm perc_improv1]
%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PatternSearch
options = optimoptions('paretosearch','PlotFcn','psplotparetof','MaxFunctionEvaluations',5000,'MaxTime',20000);
[x,fval] = paretosearch(fun3,12,[],[],[],[],lb,ub,[],options);


%% gamultiobj
options = optimoptions('gamultiobj','PlotFcn',{@gaplotpareto,@gaplotscorediversity});
options = optimoptions(options,'FunctionTolerance',1e-3,'MaxStallGenerations',150,'MaxTime',10000);

[x_ga,fval_ga,exitflag,output] = gamultiobj(fun3,12,[],[],[],[],lb,ub,options);
%% SOCEMO
%format short  
testdriver(300)
xeval_socemo = Data.xlow + (Data.xup-Data.xlow).*Data.S_for_tv
%[x,fval] = fminimax(fun3,x0,[],[],[],[],lb,ub)

% hysys.Quit()
% calc_obj


