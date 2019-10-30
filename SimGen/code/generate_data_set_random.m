close all
Mode=4;
L=5;
padding=0;
sinkPos=0.5+1;
ratio=0.24;
num_total=floor(L^2*ratio);
list_start=1;
loop_side=177100;
plotNum=100;

num_edge1=0;
num_edge2=0;
num_edge=num_edge1+num_edge2;
num_mid=2;

X0=zeros(1,num_mid);
Y0=nchoosek(1:L-1,num_mid)-1;
loop_mid=nchoosek(L-1,num_mid);
num_side=(num_total-num_mid-num_edge1)/2-num_edge2;



%28*1000=6 hours
isFigure=0;

meshSize=[1/2^3, 1/2^4, 1/2^5, 1/2^6];
idxMesh=1;
Qin=1;
Tcold=0;
k_pair=[1, 100];
storeAll=0;

switch Mode
    case 0
        
    case 1
    close all
    load test2.mat
    [~,~,model,results] = ht_steady(L,XY,Qin,Tcold,k_pair,meshSize(idxMesh),isFigure,isEvaluate);
    case 2
        %clear all
        close all
        
        threshold=30;
        % we will not store all the temperaure information anymore
        
        filename=strcat('c_L_',num2str(L),'_num_',num2str(num_total),...
            '_mid_',num2str(num_mid),'_side_',num2str((num_total-num_mid)/2),'_pad_',num2str(padding),'_.mat');
        if exist(filename)==0
            c=nchoosek(1:((L-1)/2-padding)*(L-padding),num_side);
            rang=size(c,1);
            total_list=randperm(rang,rang);
            save(filename,'c','rang','total_list');
        else
            load(filename);
        end

        X0=zeros(1,num_mid);
        Y0=nchoosek(1:L-1,num_mid)-1;
        loop_mid=nchoosek(L-1,num_mid);
        record=zeros(loop_side*loop_mid,L^2+3);
        if storeAll
            total_T=zeros(loop_side*loop_mid,4*(floor(L/meshSize(idxMesh)))^2);
        end

        list=total_list(list_start:list_start+loop_side-1);
    
    case 3
    
        FileName=dir('c*.mat');
        rang=size(c,1);
        loop_side=1024;
        total_list=randperm(rang,rang);
        load('processed.mat'); 
        pro_list=list;   
        rem_list=setdiff(total_list,pro_list);
        list=rem_list(1:loop_side);
        record=zeros(loop_side*loop_mid,L^2+3);
        total_T=zeros(loop_side*loop_mid,4*(floor(L/meshSize(idxMesh)))^2);
        
    case 4
        %random mode
        filename=strcat('cRan_L_',num2str(L),'_num_',num2str(num_total)...
            ,'_pad_',num2str(padding),'_.mat');
    
        if exist(filename)==0
            c=nchoosek(1:(L-2*padding)*(L-padding),num_total);% different for Random.
            rang=size(c,1);
            total_list=randperm(rang,rang);
            save(filename,'c','rang','total_list');
        else
            load(filename);
        end

        loop_mid=1;
        record=zeros(loop_side*loop_mid,L^2+3);
       

        list=total_list(list_start:list_start+loop_side-1);
       
    
end 


%% Execution
k=0;
for i=1:loop_side
    
    for j=1:loop_mid
        
        % save the current data when exit.
        tic
        vector=c(list(i),:);
        if Mode==4
            dim=[(L-2*padding),(L-padding)];
            [XY, C]=genGeomRand(vector,L,dim,isFigure);
            isEvaluate=0;
            [~,~,model,results] = ht_steady_rand(L,XY,sinkPos,Qin,Tcold,k_pair,meshSize(idxMesh),isFigure,isEvaluate);
        else
            dim=[(L-1)/2-padding,L-padding];
            [XY, C]=genGeom(vector,L,padding,X0,Y0,j,isFigure);
             isEvaluate=0;
             [~,~,model,results] = ht_steady(L,XY,Qin,Tcold,k_pair,meshSize(idxMesh),isFigure,isEvaluate);
        end 
        % simulation
        
        T = results.Temperature;
        % save the final T.
        k=k+1;
        
        num_par=4;
            record(k,1:num_par)=[Qin Tcold k_pair];
        
        num_stats=4;
            [maxT,loc_idx]=max(T);
            [minT, loc_idx2]=min(T);
            redun1=-1;
            redun2=1;
            record(k,num_par+1:num_par+num_stats)=[redun1 maxT minT redun2];
        
        num=num_par+num_stats+1;
            geo = reshape(C(1:L,1:L),1,L^2);
            redun3=99;
            record(k,num:num+L^2)=[geo redun3];
        
     %   get the max T
        if storeAll
            dim=size(T,1);
            total_T(k,1:dim)=T';       
        end
     
     % and also the location
     % get a plot of T with lose grid.
     % Plot Temperature
        if isFigure==1
            figure
            pdeplot(model,'XYData',T)
            hold on
            
           
            title('Temperature Distribution');

        end
        
        
        elapsed(k)=toc;
        if mod(i,plotNum)==1
        fprintf('Current progress:  %d /%d ; %d /%d using %.2f s \n',i,loop_side,j,loop_mid,elapsed(k));
        end
    end 

end


%% save files
saveFile=strcat('Records_mesh_',num2str(idxMesh),'_sideLoop_',num2str(loop_side),'_',filename);
save (saveFile,'record');
if storeAll
    saveFile2=strcat('totalT_mesh_',num2str(idxMesh),'_sideLoop_',num2str(loop_side),'_',filename);
    save (saveFile2,'total_T');
end
% remove the parts that have been already simulated.

fprintf('Total Elasped:  %.2f s \n',sum(elapsed));