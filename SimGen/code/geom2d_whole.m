function [dl4,EdgeN,faceMax,face_domain] =geom2d_whole(L,D,X,Y,isFigure)
% generate the whole domain  
% UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
X=X-0.5;
[~,N]=size(X);
    if size(X)==size(Y)
        domain = [3 %indicates square
        4
        -L/2
        L/2
        L/2
        -L/2
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
                ns1=char('rect01');
                sf='(rect01';
            else
                gd = [gd,rect2];
                nsx=strcat('rect',num2str(i,'%02.f'));
                ns1=[ns1;nsx];
                sf=strcat(sf,'+',nsx);

            end 
            if i==N
                gd=[gd domain];
                nsx=strcat('rect00');
                ns1=[ns1;nsx];
                sf=strcat(sf,'+',nsx);
                sf=strcat(sf,')');

            end
        end 

        ns = ns1';

        [dl,bt] = decsg(gd,sf,ns);
        [dl2,bt2] = csgdel(dl,bt); % removes face boundaries
        
        % modify the face id
        list=sum(bt,2);
        ind=find(list==1);

        face_domain=ind;
        faceMax=size(list,1);

         
        % insert edge N
        % set the location of EdgeN
        loc=[0 0];
        % find if there is Egde N 
        % if not, find the id contains edge N
        
        % break it into 2
        [dl4,EdgeN]=domain_insert_y(dl,loc,1);
        
 
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

