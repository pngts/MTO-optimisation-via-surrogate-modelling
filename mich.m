function  mich(fileName_location,start_cell,end_cell,x_label,y_label)
%--------> example re gare: mich('C:\Users\Panagiotis\Downloads\self1.dat',1,40,'xlabel','ylabel')
xy= importdata(fileName_location)
A=start_cell;
B=end_cell;
%C=EXCLUDE_CELLS
delimiter = ' ';

formatSpec = '%f%*s%f%[^\n\r]';

%fileID = fopen(fileName_location,'r');


%dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'TextType', 'string',  'ReturnOnError', false);
%fclose(fileID);

x = xy(:, 1);
y = xy(:, 3);

clearvars filename delimiter formatSpec fileID dataArray ans;
   
[xData, yData] = prepareCurveData( x(A:B,1), y(A:B,1));
    
    % Set up fittype and options.
    ft = fittype( 'poly1' );
    
    % Fit model to data.
    [fitresult, gof] = fit( xData, yData, ft );
    
    % Plot fit with data.
    figure( 'Name', 'untitled fit 1' );
    h = plot( fitresult, xData, yData );
    legend( h, 'y vs. x', 'linear fit', 'Location', 'NorthEast' );
    % Label axes
    xlabel x_label
    ylabel y_label
    grid on
    
end

