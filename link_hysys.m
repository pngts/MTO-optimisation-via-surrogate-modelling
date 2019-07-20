%% LINK HYSYS
a = actxserver('Hysys.Application');
invoke(a);
%SimCase= hy.ActiveDocument; %It opens the Hysys file which is active
SimCase = a.SimulationCases.Open([cd,'\mtp 1.10eiDA.hsc']);
SimCase.visible= true;
%invoke(SimCase);
b=get(a.activeDocument);
c=get (a.activeDocument.Flowsheet);
d=get (c.Operations);
d.Names ;
%------getting feeds--------

% mystream=SimCase.Flowsheet.streams;
% myfeed=get(mystream,'Item','21');
% myfeed.TemperatureValue=23
%------Get operations---------

% Myoperations=SimCase.Flowsheet.Operations;
% mydist=get(Myoperations,'Item','T-101')
%------------ setting some units volumes------------

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