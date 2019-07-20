%% INITIALIZE
hysys = actxserver('Hysys.Application');
invoke(hysys);
[stat,mess]=fileattrib;
%SimCase= hysys.ActiveDocument; %It opens the Hysys file which is active
SimCase = hysys.SimulationCases.Open([mess.Name,'\mtp 1.10eida2.hsc']);
SimCase.invoke('Activate');
SimCase.visible= true;
%invoke(SimCase);

fs=SimCase.get('flowsheet');
op=fs.get('Operations');
ms=fs.get('MaterialStreams');
es=fs.get('EnergyStreams');
sheet3=op.Item('SPRDSHT-3');

%ms.Item('21').MolarFlowValue

b=get(hysys.activeDocument);
c=get (hysys.activeDocument.Flowsheet);
d=get (c.Operations);
d.Names ;
%--- getting feeds
% mystream=SimCase.Flowsheet.streams;
% myfeed=get(mystream,'Item','21');
% myfeed.TemperatureValue=23
%--- Get operations
% Myoperations=SimCase.Flowsheet.Operations;
% mydist=get(Myoperations,'Item','T-101')
%--- setting some units volumes
he_100=get(hysys.activeDocument.Flowsheet.Operations,'item','E-100');
he_101=get(hysys.activeDocument.Flowsheet.Operations,'item','E-101');
he_102=get(hysys.activeDocument.Flowsheet.Operations,'item','E-102');
he_103=get(hysys.activeDocument.Flowsheet.Operations,'item','E-103');
%he_104=get(a.activeDocument.Flowsheet.Operations,'item','E-104');
herv=get(hysys.activeDocument.Flowsheet.Operations,'item','ERV-100');
h_v103=get(hysys.activeDocument.Flowsheet.Operations,'item','V-103');
%herv.VolumeValue=4.07243492132010e-003;
hPFR=get(hysys.activeDocument.Flowsheet.Operations,'item','PFR-100');
h_k100=get(hysys.activeDocument.Flowsheet.Operations,'item','K-100');
h_k101=get(hysys.activeDocument.Flowsheet.Operations,'item','K-101');
h_k102=get(hysys.activeDocument.Flowsheet.Operations,'item','K-102');
h_T101=get(hysys.activeDocument.Flowsheet.Operations,'item','T-101');
ColumnOptionalFeedStage1 = h_T101.ColumnFlowsheet.FeedStreams.Item(1);
%--- streams
InputObject= get(hysys.activeDocument.Flowsheet.Streams,'Item','21');
%h=get(a.activeDocument.Flowsheet.Operations,'item','PFR-100');
%hh= get(h);
S=zeros(1,20);
%% assumptions
T_steam=260; Tw_in=15; Tw_out=45; U1=800/1000; U2=1500/1000;

%% collect data for CAPEX
load('INPUT_FOR_CAPEX_abn3')

%Pump P-100 calc. we need the flow
S(1)=InputObject.StdLiqVolFlowValue*1000;

%->Heater E-100
Q_1=he_100.DutyValue; %in KW
S(2)=Q_1 ;

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
S(7)=h_k100.EnergyValue;
S(9)=h_k101.EnergyValue;
S(11)=h_k102.EnergyValue;
%->E-102 & E-103
Q_1=he_102.DutyValue; T1=he_102.FeedTemperatureValue; T2=he_102.ProductTemperatureValue; %in KW
S(8)=heater_area(Q_1,U1,[T1 T2 Tw_in Tw_out]) ;
Q_1=he_103.DutyValue; T1=he_103.FeedTemperatureValue; T2=he_103.ProductTemperatureValue; %in KW
S(10)=heater_area(Q_1,U1,[T1 T2 Tw_in Tw_out]) ;
%-COLLUMN 1 and 2 -
%SpreadsheetCOLUMN = get(a.ActiveDocument.Flowsheet.Operations,'Item', 'SPRDSHT-2');
%column_radio_lenght = hycell(get(a.ActiveDocument.Flowsheet.Operations,'Item', 'SPRDSHT-2'), {'A1', 'A2'})
column_radio_lenght=hyvalue(hycell(get(hysys.ActiveDocument.Flowsheet.Operations,'Item', 'SPRDSHT-2'), {'A1', 'A2'})); %a1=diammeter a2=HEIGHT)
S(12)=S_for_Pres_vessels(column_radio_lenght(1)/2 , column_radio_lenght(2));
COND_column_ra_le=hyvalue(hycell(get(hysys.ActiveDocument.Flowsheet.Operations,'Item', 'SPRDSHT-2'), {'B1', 'B2'})); %a1=diammeter a2=HEIGHT)
S(14)=S_for_Pres_vessels(COND_column_ra_le(1)/2 , COND_column_ra_le(2));
REBOIL_column_ra_len=hyvalue(hycell(get(hysys.ActiveDocument.Flowsheet.Operations,'Item', 'SPRDSHT-2'), {'C1', 'C2'})) ;%a1=diammeter a2=HEIGHT)
S(15)=S_for_Pres_vessels(REBOIL_column_ra_len(1)/2 , REBOIL_column_ra_len(2));
S(16)=column_radio_lenght(1)/2;

column_radio_lenght=hyvalue(hycell(get(hysys.ActiveDocument.Flowsheet.Operations,'Item', 'SPRDSHT-3'), {'A1', 'A2'})); %a1=diammeter a2=HEIGHT)
S(17)=S_for_Pres_vessels(column_radio_lenght(1)/2 , column_radio_lenght(2));
COND_column_ra_le=hyvalue(hycell(get(hysys.ActiveDocument.Flowsheet.Operations,'Item', 'SPRDSHT-3'), {'B1', 'B2'})); %a1=diammeter a2=HEIGHT)
S(18)=S_for_Pres_vessels(COND_column_ra_le(1)/2 , COND_column_ra_le(2));
REBOIL_column_ra_len=hyvalue(hycell(get(hysys.ActiveDocument.Flowsheet.Operations,'Item', 'SPRDSHT-3'), {'C1', 'C2'})) ;%a1=diammeter a2=HEIGHT)
S(19)=S_for_Pres_vessels(REBOIL_column_ra_len(1)/2 , REBOIL_column_ra_len(2));
S(20)=column_radio_lenght(1)/2;

aCAPEX = capex(S);
%% collect data for OPEX

working_time=8200; cwCost= 0.00002; eleCost=16.8; methaCost=0.3; eleSell=10; ethylene_sell=1.4; propylene_sell=1.8; steamCost=14.2; refrig=7.89; OilCost=14;
DTwater=25;CP_water=4.18;
opex_table=[];
%--- methanol raw
opex_table(1)=ms.Item('21').MassFlowValue*60*60*working_time*methaCost;
%--- CW
cl_location= [1 2 7 5];
for i=1: length(cl_location)
opex_table(1+i)=(es.Item(cl_location(i)).HeatFlowValue *3600 / (DTwater *CP_water))*working_time*cwCost;
end
%--- refrigerant
opex_table(6)=es.Item(14).HeatFlowValue*1e-6*60*60*working_time*refrig;
%-- steam demants in reboilers 
opex_table(7)=es.Item(15).HeatFlowValue*1e-6*60*60*working_time*steamCost;
opex_table(8)=es.Item(3).HeatFlowValue*1e-6*60*60*working_time*steamCost;
%--- fuel oil demants 
opex_table(9)=es.Item(14).HeatFlowValue*1e-6*60*60*working_time*OilCost;
%--- electricity demands
comp_location=[4 6 8 10];
e_demands=zeros(1,length(comp_location));
for i=1:length(comp_location)
e_demands(i)=[es.Item(comp_location(i)).HeatFlowValue*1e-6 *60*60];%GJ/h;
end
e_demands_total=sum(e_demands);
e_gives=(es.Item(12).HeatFlowValue + abs(es.Item(16).HeatFlowValue))*1e-6 *60*60;
e_diff=e_gives-e_demands_total;
 if e_diff>0
    opex_table(10)=-e_diff*working_time*eleSell ;% a minus because i will set objective= rev-capex -opex_table 
 else
    opex_table(10)=e_diff*working_time*eleCost;
 end
OPEX=sum(opex_table);
%% revenue 
revenue=ms.Item('16').MassFlowValue*60*60*propylene_sell*working_time;
%% OBJECTIVE 
OBJ=revenue-OPEX-aCAPEX

%% RUN HYSYS

%% on/off solver HYSYS
% h = actxserver('WScript.Shell');
% h.AppActivate(regexprep(hysys.Caption, '.*- ', ''));
% h.SendKeys('{F8}');
% release(h);

%%%%%%%%%%%%%%%%%%
