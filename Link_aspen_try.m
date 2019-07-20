global S inputdata2
a = actxserver('Hysys.Application');
invoke(a);
SimCase = a.SimulationCases.Open([cd,'\mtp 1.10eiDA.hsc']);
SimCase.visible= true;
%invoke(SimCase);
b=get(a.activeDocument);
c=get (a.activeDocument.Flowsheet);
d=get (c.Operations);
d.Names ;
%% getting feeds
% mystream=SimCase.Flowsheet.streams;
% myfeed=get(mystream,'Item','21');
% myfeed.TemperatureValue=23
%% Get operations
% Myoperations=SimCase.Flowsheet.Operations;
% mydist=get(Myoperations,'Item','T-101')
%% setting some units volumes
he_100=get(a.activeDocument.Flowsheet.Operations,'item','E-100');
he_101=get(a.activeDocument.Flowsheet.Operations,'item','E-101');
he_102=get(a.activeDocument.Flowsheet.Operations,'item','E-102');
he_103=get(a.activeDocument.Flowsheet.Operations,'item','E-103');
%he_104=get(a.activeDocument.Flowsheet.Operations,'item','E-104');
herv=get(a.activeDocument.Flowsheet.Operations,'item','ERV-100');
h_v103=get(a.activeDocument.Flowsheet.Operations,'item','V-103');
%herv.VolumeValue=4.07243492132010e-003;
hPFR=get(a.activeDocument.Flowsheet.Operations,'item','PFR-100');
h_k100=get(a.activeDocument.Flowsheet.Operations,'item','K-100');
h_k101=get(a.activeDocument.Flowsheet.Operations,'item','K-101');
h_k102=get(a.activeDocument.Flowsheet.Operations,'item','K-102');

%h_T101=get(a.activeDocument.Flowsheet.Operations,'item','T-101');
%streams
InputObject= get(a.activeDocument.Flowsheet.Streams,'Item','21');
%%
%h=get(a.activeDocument.Flowsheet.Operations,'item','PFR-100');
%hh= get(h);
S=zeros(1,20);
%% assumptions
T_steam=350; Tw_in=15; Tw_out=45; U1=800/1000; U2=1500/1000;

%% collect data for CAPEX
load('INPUT_FOR_CAPEX_abn3')

%Pump P-100 calc. we need the flow
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
%-> phase separator V-103
r_v103=0.1 ; l_v103=0.6 ;
S(6)=S_for_Pres_vessels(r_v103,l_v103);
r_v101=0.1 ; l_v101=0.6 ;
S(13)=S_for_Pres_vessels(r_v101,r_v101);
% -> K100
S(7)=h_k100.EnergyValue
S(9)=h_k101.EnergyValue
S(11)=h_k102.EnergyValue
%->E-102 & E-103
Q_1=he_102.DutyValue; T1=he_102.FeedTemperatureValue; T2=he_102.ProductTemperatureValue; %in KW
S(8)=heater_area(Q_1,U1,[T1 T2 Tw_in Tw_out]) ;
Q_1=he_103.DutyValue; T1=he_103.FeedTemperatureValue; T2=he_103.ProductTemperatureValue; %in KW
S(10)=heater_area(Q_1,U1,[T1 T2 Tw_in Tw_out]) ;
%-COLLUMN 1 and 2 -
%SpreadsheetCOLUMN = get(a.ActiveDocument.Flowsheet.Operations,'Item', 'SPRDSHT-2');
%column_radio_lenght = hycell(get(a.ActiveDocument.Flowsheet.Operations,'Item', 'SPRDSHT-2'), {'A1', 'A2'})
column_radio_lenght=hyvalue(hycell(get(a.ActiveDocument.Flowsheet.Operations,'Item', 'SPRDSHT-2'), {'A1', 'A2'})) %a1=diammeter a2=HEIGHT)
S(12)=S_for_Pres_vessels(column_radio_lenght(1)/2 , column_radio_lenght(2))
COND_column_ra_le=hyvalue(hycell(get(a.ActiveDocument.Flowsheet.Operations,'Item', 'SPRDSHT-2'), {'B1', 'B2'})) %a1=diammeter a2=HEIGHT)
S(14)=S_for_Pres_vessels(COND_column_ra_le(1)/2 , COND_column_ra_le(2))
REBOIL_column_ra_len=hyvalue(hycell(get(a.ActiveDocument.Flowsheet.Operations,'Item', 'SPRDSHT-2'), {'C1', 'C2'})) %a1=diammeter a2=HEIGHT)
S(15)=S_for_Pres_vessels(REBOIL_column_ra_len(1)/2 , REBOIL_column_ra_len(2))
S(16)=column_radio_lenght(1)/2

column_radio_lenght=hyvalue(hycell(get(a.ActiveDocument.Flowsheet.Operations,'Item', 'SPRDSHT-3'), {'A1', 'A2'})) %a1=diammeter a2=HEIGHT)
S(17)=S_for_Pres_vessels(column_radio_lenght(1)/2 , column_radio_lenght(2))
COND_column_ra_le=hyvalue(hycell(get(a.ActiveDocument.Flowsheet.Operations,'Item', 'SPRDSHT-3'), {'B1', 'B2'})) %a1=diammeter a2=HEIGHT)
S(18)=S_for_Pres_vessels(COND_column_ra_le(1)/2 , COND_column_ra_le(2))
REBOIL_column_ra_len=hyvalue(hycell(get(a.ActiveDocument.Flowsheet.Operations,'Item', 'SPRDSHT-3'), {'C1', 'C2'})) %a1=diammeter a2=HEIGHT)
S(19)=S_for_Pres_vessels(REBOIL_column_ra_len(1)/2 , REBOIL_column_ra_len(2))
S(20)=column_radio_lenght(1)/2

aCAPEX = capex(S)
%% colect data for OPEX





%% RUN HYSYS

%% on/off solver HYSYS
h = actxserver('WScript.Shell');
h.AppActivate(regexprep(a.Caption, '.*- ', ''));
h.SendKeys('{F8}');
release(h);

%%%%%%%%%%%%%%%%%%
