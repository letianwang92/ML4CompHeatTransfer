function [XY,C] = genGeom(vector,L,interval,X0,Y0,j,isFigure)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%X1=floor(vector/(L-interval))+1
        %Y1=mod(vector,L-interval)
        dim=[(L-1)/2-interval,L-interval];
        [X1,Y1]=ind2sub(dim,vector);
        Y1=Y1-1;
        X2=-X1;
        Y2=Y1;
        X=[X1 X0 X2];
        Y=[Y1 Y0(j,:) Y2];
        XY=[X;Y];
        C=zeros(L+1);
        idx = sub2ind(size(C), X+(L-1)/2+1, Y+1);
        C(idx)=1;
        
        if isFigure

            figure
            pcolor(C)
        end

       
end

