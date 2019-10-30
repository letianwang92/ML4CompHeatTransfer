proFile='processed.mat';

if exist(proFile)==0
    save (proFile, 'list')
else
    list2=list;
    load(proFile)
    list_new=[list list2];
end


%%
loop_side=1024;
total_list=randperm(rang,rang);
load('processed.mat'); 
pro_list=list;   
rem_list=setdiff(total_list,pro_list);
list=rem_list(1:loop_side);