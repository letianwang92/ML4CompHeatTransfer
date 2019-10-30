function [dl4,EdgeN,faceMax,face_domain] =geom2d_whole_rand(L,D,X,Y,sinkPos,isFigure)
% generate the whole domain  
% UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
X=X;
[~,N]=size(X);
    if size(X)==size(Y)
        domain = [3 %indicates square
        4
        1
        L+1
        L+1
        1
        1
        1
        L+1
        L+1];

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
        %gd = [rect2,rect3];
        %ns1 = char('rect2','rect3');
        ns = ns1';
        %sf = '(rect2+rect3)';
        [dl,bt] = decsg(gd,sf,ns);
        [dl2,bt2] = csgdel(dl,bt); % removes face boundaries
        
        %ind=find(bt2==1);
        %domain1=ind(1); % is the label for the large face.
        list=sum(bt,2);
        ind=find(list==1);
        %domains=ind(find(ind!=domain));  % the rest if the disconnected ones.
        face_domain=ind;
        faceMax=size(list,1);

         
        % insert edge N
        % set the location of EdgeN
        loc=[sinkPos 1];
        % find if there is Egde N 
       
        
        
        % if not, find the id contains edge N
        
        % break it into 2
        [dl4,EdgeN]=domain_insert_y_rand(dl,loc,1);
        
 
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

