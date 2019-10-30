Mode=2;
L=9;
list_start=1;
ratio=0.12;
number=floor(L^2*ratio);
% 28*1000=6 hours

interval=0;

for mid=1:2:9
switch Mode
    case 0
        
    case 1
    close all
    load test2.mat
    [~,~,model,results] = ht_steady(L,XY,Qin,Tcold,k_pair,meshSize(idxMesh),isFigure,isEvaluate);
    case 2
        %clear all
        close all

        isFigure=0;
        threshold=30;
        storeAll=0;

        %% Generate desired strucures


        % we tentatively set L to be odd number
        % limit the total amount of the material 



        % catgory of random geometries

        %  X = randi([-(L-3)/2, (L-3)/2], number,1);
        %  Y = randi([0, L-2], number,1);
        %  XY=[X';Y'];
        % it's essentially a Cnumer-L^2


        
        meshSize=[1/2^3,1/2^4,1/2^5, 1/2^6];
        idxMesh=1;
        filename=strcat('c_L_',num2str(L),'_num_',num2str(number),...
            '_mid_',num2str(mid),'_side_',num2str((number-mid)/2),'_pad_',num2str(interval),'_.mat');
        if exist(filename)==0
            c=nchoosek(1:((L-1)/2-interval)*(L-interval),(number-mid)/2);
            rang=size(c,1);
            loop_side=rang;
            total_list=randperm(rang,rang);
            save(filename,'c','rang','total_list');
        else
            load(filename);
        end

        X0=zeros(1,mid);
        Y0=nchoosek(1:L-interval,mid)-1;
        loop_mid=nchoosek(L-interval,mid);
        record=zeros(loop_side*loop_mid,L^2+3);
        if storeAll
            total_T=zeros(loop_side*loop_mid,4*(floor(L/meshSize(idxMesh)))^2);
        end
        %%

        %p = randperm(int8((L-1)/2*L),int8((number-mid)/2));

        %processed_list=load('processed.mat');
        %rem_list=setdiff(total_list,processed_list);
        list=total_list(list_start:list_start+loop_side-1);



        % remove the completed ones from the list.

        %  save when the loop finishes
    
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
        
    
    
end 



k=0;
for i=1:loop_side
    
    for j=1:loop_mid
        
        % save the current data when exit.
        tic
        vector=c(list(i),:);
        [XY, C]=genGeom(vector,L,interval,X0,Y0,j,isFigure);
        isEvaluate=0;
        
        %% simulation
        Qin=1;
        Tcold=0;
        k_pair=[1, 100];
        

        [~,~,model,results] = ht_steady(L,XY,Qin,Tcold,k_pair,meshSize(idxMesh),isFigure,isEvaluate);

%%

        % save the final T.

        T = results.Temperature;
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
            
            
        else
            %location=model.Mesh.Nodes(:,loc_idx);
            Area=size(find(T>threshold),1);
            
        end
        
        
            
            
        
            
            
        
        
     % and also the location
     % get a plot of T with lose grid.
        %% Plot Temperature
        if isFigure==1
            figure
            pdeplot(model,'XYData',T)
            hold on
            
            scatter(location(1),location(2));
            title('Temperature Distribution');

        end
        
        
        elapsed(k)=toc;
        fprintf('Current progress:  %d /%d ; %d /%d using %.2f s \n',i,loop_side,j,loop_mid,elapsed(k));
    end 

end
%%

saveFile=strcat('Records_mesh_',num2str(idxMesh),'_sideLoop_',num2str(loop_side),'_',filename);
save (saveFile,'record');
if storeAll
    saveFile2=strcat('totalT_mesh_',num2str(idxMesh),'_sideLoop_',num2str(loop_side),'_',filename);
    save (saveFile2,'total_T');
end
% remove the parts that have been already simulated.

fprintf('Total Elasped:  %.2f s \n',sum(elapsed));
end