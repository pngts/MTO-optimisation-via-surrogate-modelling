function [s_heater] = heater_area(q,u,T)
    % T=[Th1 Th2 Tc1 TC2]
    s_heater= q/(u*((T(1)-T(4)-T(2)+T(3))/log((T(1)-T(4))/(T(2)-T(3)))));
end

