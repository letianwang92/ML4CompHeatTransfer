%% section for save the records
L=11;
num_total=30;
padding=0;
sinkP=0.5;
filename=strcat('cRan_L_',num2str(L),'_num_',num2str(num_total)...
            ,'_pad_',num2str(padding),'_pos_',num2str(sinkP),'_.mat');

list_begin=9001;
loop_nums=3000;
endpoint=list_begin+loop_nums-1;
fixRecord=0;
if fixRecord

record=record(1:loop,:);
saveFile=strcat('Records_mesh_',num2str(idxMesh),'_end_',num2str(list_begin+loop_nums-1),'_comNum_',num2str(loop_nums),'_',filename);
        fid=dir (filename);
save (saveFile,'record');
end 
%% for 


load(filename)
rang=endpoint;
total_list=total_list(1:endpoint,:);
save(filename)