
function [OBJ_SUR] = obj_opti_surrogate(x)
    global design_para_Cells
    calc_obj_with_LCA
    
    design_para_Cells = hycell(get(op,'Item', 'Design_par'), {'A1', 'A2', 'A3', 'A4', 'A5', 'A6', 'A7','A8', 'A9', 'A10', 'A11', 'A12'});

    hyhold(hyconnect);% stop solving
    try
        hyset(design_para_Cells{1},x(1)); hyset(design_para_Cells{2},x(2)); hyset(design_para_Cells{3},x(3));hyset(design_para_Cells{4},x(4));hyset(design_para_Cells{5},x(5)); hyset(design_para_Cells{6},x(6));
        hyset(design_para_Cells{7},x(7));hyset(design_para_Cells{8},x(8));hyset(design_para_Cells{9},x(9));hyset(design_para_Cells{10},x(10));hyset(design_para_Cells{11},x(11));hyset(design_para_Cells{12},x(12));
         hystart(hyconnect);
        op.Item('ADJ-2').Reset
        op.Item('ADJ-2-2').Reset
        op.Item('ADJ-2').Reset
        while hyissolving(hyconnect)==1
            pause(1);
            time = time+1;
            if time==15 % Control of simulation time.
                
                break
            end
        end
        %%%---- optimize feed location----%%%%
%         hyhold(hyconnect)
%         h_T101.ColumnFlowsheet.Operations.Item("Main_TS").SpecifyFeedLocation(ColumnOptionalFeedStage1, x(1))
%         op.Item('T-101').ColumnFlowsheet.Reset
%         op.Item('T-101').ColumnFlowsheet.Run
%         pause(2);
%         while hyissolving(hyconnect)==1
%             pause(1);
%             time = time+1;
%             if time==15 % Control of simulation time.
%                 break
%             end
%         end
%         hystart(hyconnect);       
      %%%% start solving
        time = 1;
        calc_obj_with_LCA
        OBJ_SUR = -real(OBJ);
    catch
        OBJ_SUR=inf
    end
    
end

%hysys.Quit()