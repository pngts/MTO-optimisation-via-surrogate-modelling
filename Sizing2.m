%% Accesing the flowsheet

hy = actxserver('HYSYS.APPLICATION'); % Link MATLAB and HYSYS
%SimCase= hy.ActiveDocument; %It opens the Hysys file which is active
SimCase = hy.SimulationCases.Open([cd,'\mtp 1.8.hsc']); %This is when
% you want to specify the path where the HYSYS file is 
SimCase.visible = true;
fs = get(SimCase.Flowsheet); %To acces the flowsheet
Mat_Streams = get(fs.MaterialStreams); %To acces the material streams
ms_Names = Mat_Streams.Names; % cell array of the stream names vector
Ene_Streams = get(fs.EnergyStreams); %To acces the energy streams
unit_operations = get(fs.Operations); %To acces the unit operations in the flowsheet
UnitOp = unit_operations.Names; %To acces the names of the unit operations
%Stream = fs.MaterialStreams.Item(0).TemperatureValue;
i = fs.Operations.Count;
%% Cosntants
Patm = 14.6959;

%% sizing
%Info for PFRS
vector_of_PFRs = []; %Initializes the vector of PFRs
V_PFR = [];
Dt_PFR = [];
Delta_PFR = [];
Dshell = [];
L_PFR = [];
Nt_PFR = [];
T_PFR = [];
P_PFR = [];
Pdis_PFR = [];
Tdis_PFR = [];


%Info for PFRs
vector_of_vessels = [];

%Info compresssors
vector_comp = [];

for k = 0:i-1; %Unit operations counted from 0
    %PFRs
    found_reactor = strncmp(fs.Operations.Item(k).Name,'PFR',3);% It compares the first three letters in the names of the UnitOp
    if found_reactor
        %vector_of_PFRs = [vector_of_PFRs, fs.Operations.Item(k)];%Vector of PFR in the flowsheet
        vector_of_PFRs = fs.Operations.Item(k);
        Vpfr =  fs.Operations.Item(k).TotalVolumeValue;
        V_PFR = [V_PFR,Vpfr];%Vector of volumes
        Dpfr = fs.Operations.Item(k).TubeDiameter.Value;
        Dt_PFR = [Dt_PFR,Dpfr]; %vector of daimeter of the tube (m)
        St = 0.15; %Separation between tubes (m)
        deltapfr = fs.Operations.Item(k).TubeWallThicknessValue;
        Delta_PFR = [Delta_PFR,deltapfr];
        Rr = 0.49977003163288;
        Dspfr =(2*(Dt_PFR+2*Delta_PFR+St)/(pi*Dt_PFR)*sqrt(2*sqrt(3)*V_PFR/Rr)).^(2/3);
        Dshell = [Dshell,Dspfr];
        Lpfr = fs.Operations.Item(k).TubeLengthValue;
        L_PFR = [L_PFR,Lpfr];
        Ntpfr = fs.Operations.Item(k).NumberOfTubes;
        Nt_PFR = [Nt_PFR,Ntpfr];
        In_PFR =  fs.Operations.Item(k).Feeds.Name; % gets the name of the streams ingoint to the PFRs
        idxpfr = char(In_PFR); %trasnforms In_PFR into character type
        Tpfr = fs.MaterialStreams.Item(idxpfr).TemperatureValue; % reads the temperature from the stream in Celsius
        T_PFR = [T_PFR,Tpfr];
        Ppfr = fs.MaterialStreams.Item(idxpfr).PressureValue/101.325*14.69598-Patm; % reasds the P form the stream in kPa
        P_PFR = [P_PFR,Ppfr];
        % Specficifation of design temperatures and pressures 
        if (P_PFR <= 0)
            Pd_PFR = 15;
        elseif (P_PFR > 0) && (P_PFR < 10)
            Pd_PFR = 40;
        elseif P_PFR > 10
            Pd_PFR = P_PFR + 25 + max(0.1*(P_PFR + 25),25);
        end
        Pdis_PFR = [Pdis_PFR,Pd_PFR];
        if (T_PFR >=  -30) && (T_PFR < 345)
            Td_PFR = T_PFR + 25;
        else
            Td_PFR = T_PFR + 26;
        end
        Tdis_PFR = [Tdis_PFR, Td_PFR];
    end
    % Vessels
     found_vessel = strncmp(fs.Operations.Item(k).Name,'V-1',3);
     if found_vessel
         vector_of_vessels = [vector_of_vessels, fs.Operations.Item(k)];
     end
    % Compressors 
     found_comp = strncmp(fs.Operations.Item(k).Name,'K-1',1);
     if found_comp
         vector_comp = [vector_comp, fs.Operations.Item(k)];
     end
end


