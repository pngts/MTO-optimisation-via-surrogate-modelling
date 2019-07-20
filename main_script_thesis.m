cl
calc_obj;
kk=0;

design_para_Cells = hycell(get(op,'Item', 'Design_par'), {'A1', 'A2', 'A3', 'A4', 'A5', 'A6', 'A8', 'A9', 'A10', 'A12','B1'});


INITIAL_VALUES=hyvalue(design_para_Cells);

%% create the multiplication table
multi_table=ones(1,60);
step=0.015;
for ii=length(multi_table)/2 :-1: 1
    multi_table(ii)=multi_table(ii+1)-step;
end
for ii= length(multi_table)/2: length(multi_table)
    multi_table(ii)=multi_table(ii-1)+step;
end
%%
feedback=[];
for ii=1:length(INITIAL_VALUES)
    
    hyhold(hyconnect);% stop solving
    er_count=0;
    for j=1:length(multi_table)
        %hyhold(hyconnect);
        try
            hyset(design_para_Cells{ii}, INITIAL_VALUES(ii)*multi_table(j));
            
            if ii==14
                op.Item('T-101').ColumnFlowsheet.Reset
                op.Item('T-101').ColumnFlowsheet.Run
                pause(2);
                while hyissolving(hyconnect)==1
                    pause(1);
                    time = time+1;
                    if time==15 % Control of simulation time.
                        kk=1;j=length(multi_table);
                        break
                    end
                end
            end
            if ii==13
                op.Item('T-103').ColumnFlowsheet.Reset
                op.Item('T-103').ColumnFlowsheet.Run
                pause(2);
                
                while hyissolving(hyconnect)==1
                    pause(1);
                    time = time+1;
                    if time==15 % Control of simulation time.
                        kk=1;j=length(multi_table);
                        break
                    end
                end
            end
            hystart(hyconnect); % start solving
            time = 1;
            while hyissolving(hyconnect)==1
                pause(1);
                time = time+1;
                if time==15 % Control of simulation time.
                    kk=1;
                    break
                end
            end
            if kk==0
                calc_obj;
            else
                OBJ=inf;
            end
            design_var(ii,j)=INITIAL_VALUES(ii)*multi_table(j)
            feedback(ii,j)=OBJ
            kk=0;
            ii
            j
        catch
            %calc_obj;
            OBJ=inf;
            %             er_count=er_count+1;
            %             if er_count>2
            %                 calc_obj
            %                 break
            %             end
            design_var(ii,j)=INITIAL_VALUES(ii)*multi_table(j)
            feedback(ii,j)=OBJ
            hyset(design_para_Cells{ii}, INITIAL_VALUES(ii));
            if ii==14
                op.Item('T-103').ColumnFlowsheet.Reset
                op.Item('T-103').ColumnFlowsheet.Run
            end
            if ii==13
                op.Item('T-101').ColumnFlowsheet.Reset
                op.Item('T-101').ColumnFlowsheet.Run
                pause(3)
            end
            kk=0;
            continue
        end
        
    end
    subplot(length(design_para_Cells)/2,2,ii);
    plot(design_var(ii,:),feedback(ii,:))
    title(ii);
    hyset(design_para_Cells{ii}, INITIAL_VALUES(ii));
    if ii==14
        %hysys.Quit()
        %pause(3)     
    end
    if  ii==13
        op.Item('T-103').ColumnFlowsheet.Reset
        op.Item('T-103').ColumnFlowsheet.Run
        pause(2);
        %hysys.Quit()
        pause(3)
        %calc_obj;
        pause(8);
    end
end


% hysys.Quit()
% cl
% calc_obj;
% design_para_column=hycell(get(op,'Item', 'Design_par'), {'A13', 'A14');
% kk=0;



