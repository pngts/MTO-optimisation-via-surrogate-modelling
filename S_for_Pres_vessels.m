function [s] = S_for_Pres_vessels(r,l)
    rss=8000 ;% steel density kg/m3
    d=0.0254;% meters
    s=rss*((pi*(r+d)^2 * (l+2*d))-pi*r^2 *l);
end

