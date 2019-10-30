function [XY,C] = genGeomRand(vector,L,dim,isFigure)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%X1=floor(vector/(L-interval))+1
        %Y1=mod(vector,L-interval)
        
         [X1,Y1]=ind2sub(dim,vector);
         Y1=Y1;
         X=[X1];
         Y=[Y1];
         XY=[X;Y];

        
        C=zeros(L+1);
        idx = sub2ind(size(C), Y, X);
        C(idx)=1;
        
        
        if isFigure

            figure
            pcolor(C)
        end

       end

