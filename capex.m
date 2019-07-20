function [aCAPEX] = capex(s)
   global inputdata2
    %Calculate the Process capex
    %input data for capex calculation a b n from TOWLER BOOK
    load('INPUT_FOR_CAPEX_abn3')
    c_unit=zeros(1,length(s));
    a=inputdata2(:,1); b=inputdata2(:,2);n=inputdata2(:,3);
    number_of_units=length(s);
    int= 0.15; years= 20 ;% interest and plant life
    accr=int* (1+int)^years /((1+int)^years -1);
    for i=1:number_of_units
        c_unit(i)=a(i) + b(i) * s(i)^n(i);
        CAPEX = sum(c_unit);
    end
    aCAPEX=CAPEX*accr;
end

