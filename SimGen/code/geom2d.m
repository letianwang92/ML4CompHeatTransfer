function [dl4,EdgeN,faceMax] =geom2d(L,D,X,Y,isFigure)
%X and Y are lists of x and y coordinates
X=X-0.5;
[~,N]=size(X);
    if size(X)==size(Y)
    domain = [3 %indicates square
    4
    0
    L
    L
    0
    0
    0
    L
    L];

for i=1:N
    xi=X(i);
    yi=Y(i);
    rect = [3
    4
    xi
    xi+D
    xi+D
    xi
    yi+0
    yi+0
    yi+D
    yi+D];
    
    if i==1
        gd=rect;
        ns1=char('rect01');
        sf='(rect01';
    else

        gd = [gd,rect];
        nsx=strcat('rect',num2str(i,'%02.f'));
        ns1=[ns1;nsx];
        sf=strcat(sf,'+',nsx);

    end 
    if i==N
            sf=strcat(sf,')');
    end
end 
%gd = [rect2,rect3];
%ns1 = char('rect2','rect3');
ns = ns1';
%sf = '(rect2+rect3)';
[dl,bt] = decsg(gd,sf,ns);
[dl2,bt2] = csgdel(dl,bt); % removes face boundaries


%% add big domain
dl3=dl2;
dx=dl3(end-1:end,:);
mm=max(max(dx));
faceMax=mm+1;
for i=mm:-1:0
    dx(find(dx==i))=i+1;
    
end 
dl3(end-1:end,:)=dx;

[~,num_col]=size(dl3);
domain_down=    [2;+L/2;-L/2;0;0;0;1];
domain_left=    [2;-L/2;-L/2;0;L;0;1];
domain_up=      [2;-L/2;+L/2;L;L;0;1];
domain_right=   [2;+L/2;+L/2;L;0;0;1]; 


flag=0;

for i=1:num_col % check every edge in the list.
    x1=dl3(2,i);
    x2=dl3(3,i);
    y1=dl3(4,i);
    y2=dl3(5,i);
    if and(x1==-L/2,x1==x2)
        dl3(dl3(6:7,i) ==1 ,i)=0;
        domain_left1=    [2;-L/2;-L/2;0;min(y1,y2);label_;1];
        domain_left2=    [2;-L/2;-L/2;max(y1,y2);L;0;1];   
        % here we only handle one time overlapp.
        domain_left=[domain_left1, domain_left2];
        continue;
        
    end
    
   if and(x1==L/2,x1==x2)
       dl3(dl3(6:7,i) ==1 ,i)=0;
       domain_right1=   [2;+L/2;+L/2;L;max(y1,y2);0;1]; 
       domain_right2=   [2;+L/2;+L/2;min(y1,y2);0;0;1];
       domain_right=[domain_right1 domain_right2];
       
        continue;
   end
    
   
   % defining the domain on the downsides
   if and(y1==0,y1==y2)
        dxx=dl3(6:7,i);
        index=find(dxx ==1);
        dxx(index)=0;
        dl3(6:7,i)=dxx;
%         domain_down1=    [2;+L/2;max(x1,x2);0;0;0;1];
%         domain_down2=    [2;min(x1,x2);-L/2;0;0;0;1];
%         domain_down=[domain_down1, domain_down2];
        [domain_down,~]=domain_insert_y0(domain_down,x1,x2,0);
        if x1==0.5 || x2==0.5
            EdgeN=i;
            flag=1;
            
        end
        
        continue;
        
        
   end
   % defining the domain on the upsides
   if and(y1==L,y1==y2)
        dxx=dl3(6:7,i);
        dxx(dxx ==1 ,i)=0;
        dl3(6:7,i)=dxx;
        [domain_up,~]=domain_insert_y0(domian_up,x1,x2,0);
        %domain_up1=    [2;+L/2;max(x1,x2);L;L;0;1];
        %domain_up2=    [2;min(x1,x2);-L/2;L;L;0;1];
        %domain_up=[domain_up1, domain_up2];

        continue;
        
   end
    
   
        
    
end 

if flag==0 % if there is no element contacting the bottom.
    [domain_down,id]=domain_insert_y0(domain_down,-0.5,0.5,1);
    EdgeN=num_col+id;
end

domain_dl=[domain_down,domain_left,domain_up,domain_right];
dl4=[dl3,domain_dl];
    
    

    else 
        print ('Error: X and Y are not equal size');
    end
    
    if isFigure    
        figure
        subplot(2,2,1)
        pdegplot(dl,'EdgeLabels','on','FaceLabels','on')
        axis equal
        subplot(2,2,2)
        pdegplot(dl2,'EdgeLabels','on','FaceLabels','on')
        title('Bare units')
        axis equal

        subplot(2,2,3)
        %pdegplot(dl3,'EdgeLabels','on','FaceLabels','on')

        axis equal

        subplot(2,2,4)
        pdegplot(dl4,'EdgeLabels','on','FaceLabels','on')
        title('Add background')
        axis equal
    end  
end

