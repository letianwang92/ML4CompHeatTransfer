clear all;
L=11;
D=1;
X=[0,0,0,1,1,-1,-1];
Y=[1,0,2,2,3,2,3];
X=X-0.5;
xi=1;
yi=0;
[~,N]=size(X);
domain = [3
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
    rect2 = [3
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
    gd=rect2;
    ns1=char('rect1');
    sf='(rect1';
else
    
    gd = [gd,rect2];
    nsx=strcat('rect',num2str(i));
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
dx((dx==1))=2;
dx((dx==0))=1;
dl3(end-1:end,:)=dx;

[~,num_col]=size(dl3);
domain_up=      [2;-L/2;+L/2;L;L;0;1];
domain_left=    [2;-L/2;-L/2;0;L;0;1];
domain_right=   [2;+L/2;+L/2;L;0;0;1]; 
domain_down=    [2;+L/2;+L/2;0;0;0;1];

for i=1:num_col
    x1=dl3(2,i);
    x2=dl3(3,i);
    y1=dl3(4,i);
    y2=dl3(5,i);
    if and(x1==-L/2,x1==dl3(3,i))
        dl3(dl3(6:7,i) ==1 ,i)=0;
        domain_left1=    [2;-L/2;-L/2;0;min(y1,y2);label_;1];
        domain_left2=    [2;-L/2;-L/2;max(y1,y2);L;0;1];   
        % here we only handle one time overlapp.
        domain_left=[domain_left1, domain_left2];
    break;
        
    end
    
   if and(x1==L/2,x1==dl3(3,i))
       dl3(dl3(6:7,i) ==1 ,i)=0;
       domain_right1=   [2;+L/2;+L/2;L;max(y1,y2);0;1]; 
       domain_right2=   [2;+L/2;+L/2;min(y1,y2);0;0;1];
       domain_right=[domain_right1 domain_right2];
    break;
        
   end
    
   if and(y1==0,y1==y2)
        dxx=dl3(6:7,i);
        dxx(dxx ==1 ,i)=0;
        dl3(6:7,i)=dxx;
        domain_down1=    [2;+L/2;max(x1,x2);0;0;0;1];
        domain_down2=    [2;min(x1,x2);-L/2;0;0;0;1];
        domain_down=[domain_down1, domain_down2];
    break;
        
    end
        
    
end 

domain_dl=[domain_left,domain_up,domain_right,domain_down];
dl4=[dl3,domain_dl];
%%



%%

figure
subplot(2,2,1)
pdegplot(dl,'EdgeLabels','on','FaceLabels','on')
axis equal
subplot(2,2,2)
pdegplot(dl2,'EdgeLabels','on','FaceLabels','on')
axis equal

subplot(2,2,3)
%pdegplot(dl3,'EdgeLabels','on','FaceLabels','on')
axis equal
subplot(2,2,4)
pdegplot(dl4,'EdgeLabels','on','FaceLabels','on')
axis equal