a = actxserver('Hysys.Application');
SimCase = a.SimulationCases.Open([cd,'\mtp 1.8.hsc']);
SimCase.visible= true;
%invoke(SimCase);
b=get(a.activeDocument);
c=get (a.activeDocument.Flowsheet);
c1=get (a.activeDocument.ProcessUtilityManager);
d=get (c.Operations);
d.Names ;

%% setting some units volumes 
he_100=get(a.activeDocument.Flowsheet.Operations,'item','E-100');
he_101=get(a.activeDocument.Flowsheet.Operations,'item','E-101');
he_102=get(a.activeDocument.Flowsheet.Operations,'item','E-102');
he_103=get(a.activeDocument.Flowsheet.Operations,'item','E-103');
he_104=get(a.activeDocument.Flowsheet.Operations,'item','E-104');
herv=get(a.activeDocument.Flowsheet.Operations,'item','ERV-100');
h_v103=get(a.activeDocument.Flowsheet.Operations,'item','V-103');
%herv.VolumeValue=4.07243492132010e-003;
hPFR=get(a.activeDocument.Flowsheet.Operations,'item','PFR-100');
h_k100=get(a.activeDocument.Flowsheet.Operations,'item','K-100');
h_k101=get(a.activeDocument.Flowsheet.Operations,'item','K-101');
h_k102=get(a.activeDocument.Flowsheet.Operations,'item','K-102');

h_T101=get(a.activeDocument.Flowsheet.Operations,'item','T-101');
%streams
InputObject= get(a.activeDocument.Flowsheet.Streams,'Item','21');
%%
%h=get(a.activeDocument.Flowsheet.Operations,'item','PFR-100');
%hh= get(h);
S=zeros(13);
%% assumptions 
T_steam=350; Tw_in=15; Tw_out=45; U1=800/1000; U2=1500/1000;

%% collect data for CAPEX

%Pump P-100 calc. we need the flow 
         %----excluded---- 
S(1)=InputObject.StdLiqVolFlowValue /1000   
 
%->Heater E-100
Q_1=he_100.DutyValue; T1=he_100.FeedTemperatureValue; T2=he_100.ProductTemperatureValue; %in KW
S(2)=heater_area(Q_1,U2,[T_steam T_steam T1 T2]) ;

%->Eq.Reactor ERV-100
r_erv=0.1 ; l_erv=0.5 ;
S(3)=S_for_Pres_vessels(r_erv,l_erv);

%->Eq.Reactor PFR-100
r_PFR=hPFR.TubeDiameterValue; l_PFR=hPFR.TubeLengthValue;
S(4)=S_for_Pres_vessels(r_PFR,l_PFR);
%->Heater E-101

Q_1=he_101.DutyValue; T1=he_101.FeedTemperatureValue; T2=he_101.ProductTemperatureValue; %in KW
S(5)=heater_area(Q_1,U1,[T1 T2 Tw_in Tw_out]) ;
%->Heater E-104

Q_1=he_104.DutyValue; T1=he_104.FeedTemperatureValue; T2=he_104.ProductTemperatureValue; %in KW
S(6)=heater_area(Q_1,U1,[T1 T2 Tw_in Tw_out]) ;
%-> phase separator V-100
r_v103=0.1 ; l_v103=0.6 ;
S(7)=S_for_Pres_vessels(r_v103,l_v103);
% -> K100
S(8)=h_k100.EnergyValue
S(10)=h_k101.EnergyValue
S(12)=h_k102.EnergyValue
%->E-102 & E-103
Q_1=he_102.DutyValue; T1=he_102.FeedTemperatureValue; T2=he_102.ProductTemperatureValue; %in KW
S(9)=heater_area(Q_1,U1,[T1 T2 Tw_in Tw_out]) ;
Q_1=he_103.DutyValue; T1=he_103.FeedTemperatureValue; T2=he_103.ProductTemperatureValue; %in KW
S(11)=heater_area(Q_1,U1,[T1 T2 Tw_in Tw_out]) ;
%-COLLUMN-

%% colect data for OPEX 

%% RUN HYSYS
h=actxserver('WScript.Shell');
h.AppActivate(regexprep(a.Caption,' .*- ', ''));
h.SendKeys('(F8)');
a.activeDocument.solver.Integrator.Reset;
%%%%%%%%%%%%%%%%%%
