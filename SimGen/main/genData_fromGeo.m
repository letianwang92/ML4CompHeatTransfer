

function []=genData_fromGeo(L,ratio,sinkP,list_start,loop_num,isFigure,plotNum)
close all

Mode=5;

% L=8;
% ratio=0.125;
padding=0;
display(L);
display(sinkP);
sinkPos=sinkP+1;

num_total=floor(L*L*ratio);
display(num_total);
%list_start=1;
%loop_side=20;
%isFigure=0;

num_edge1=0;
num_edge2=0;
num_edge=num_edge1+num_edge2;
num_mid=2;

X0=zeros(1,num_mid);
Y0=nchoosek(1:L-1,num_mid)-1;
loop_mid=nchoosek(L-1,num_mid);
num_side=(num_total-num_mid-num_edge1)/2-num_edge2;

%28*1000=6 hours


meshSize=[1/2^3, 1/2^4, 1/2^5, 1/2^6];
idxMesh=1;
Qin=1;
Tcold=0;
k_pair=[1, 100];
storeAll=0;

switch Mode
    case 6
        filenameGeo=
        vector=
    
    
    case 5
        %random mode
        filename=strcat('cRan_L_',num2str(L),'_num_',num2str(num_total)...
            ,'_pad_',num2str(padding),'_pos_',num2str(sinkP),'_.mat');
        
        saveFile=strcat('Records_mesh_',num2str(idxMesh),'_end_',num2str(list_start+loop_num-1),'_comNum_',num2str(loop_num),'_',filename);
        fid=dir (filename);
        if isempty(fid)
            dims=(L-2*padding)*(L-padding);
            %c=nchoosek(1:dims,num_total);% different for Random.
            %rang=size(c,1);
            %display(rang);
            if L==5
                c=nchoosek(1:dims,num_total);
                rang=size(c,1);
                if loop_num==rang
                    total_list=c;
                end
            end
            rang=loop_num;
            seed=1;
            rng(seed); 
            for i=1:rang
                total_list(i,:)=randperm(dims,num_total);
                list=total_list;
            end
            save(filename,'dims','seed','rang','total_list');
            display(rang);
        else
            load(filename);
            rang1=rang;
            assert(list_start==rang1+1,'Wrong start: list_start shoulbe be rang+1');
            rang=rang1+loop_num;
            for i=1:loop_num
                total_list(list_start+i-1,:)=randperm(dims,num_total);
            end
            
            save(filename,'dims','seed','rang', 'total_list');
        end
        
        display(seed);
        

        loop_mid=1;
        record=zeros(loop_num*loop_mid,L^2+9);
        list=total_list(list_start:list_start+loop_num-1,:);
       
    
end 


%% Execution
k=0;
for i=1:loop_num
    
    for j=1:loop_mid
        
        % save the current data when exit.
        tic
        vector=list(i,:);
        if Mode>=4
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
            fprintf('Current progress:  %d /%d ; %d /%d using %.2f s \n',i,loop_num,j,loop_mid,elapsed(k));
        end 
    end 

end


%% save files

save (saveFile,'record');
if storeAll
    saveFile2=strcat('totalT_mesh_',num2str(idxMesh),'_comNum_',num2str(loop_num),'_',filename);
    save (saveFile2,'total_T');
end
% remove the parts that have been already simulated.

fprintf('Total Elasped:  %.2f s \n',sum(elapsed));

end

