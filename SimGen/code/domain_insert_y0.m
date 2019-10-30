function [domain,id] = domain_insert_y0(domain,x1,x2,ifbreak)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% find the subdomain to insert.
xmin=min(x1,x2);
xmax=max(x1,x2);
num_col=size(domain,2);
    for i=1:num_col
        if domain(3,i)<=xmin & domain(2,i)>=xmax
            idx=i;
            position=0;
            domain_up1=domain(:,idx);
             domain_up2=domain(:,idx);
             domain_sink=domain(:,idx);
             domain_up1(3)= xmax;
             domain_up2(2)= xmin;
             domain_sink(2)= xmax;
             domain_sink(3)= xmin;
            if domain(3,i)==xmin
                position=-1;
                domain_up1=[];
            end
            if domain(2,i)==xmax
                domain_up2=[];
            end

             break;
        else
            print('Error');
        end

    end 
      
    
    if ifbreak


         domain=[domain(:,1:idx-1),domain_up1,domain_sink, domain_up2,domain(:,idx+1:end)];
         
         
     else
           domain=[domain(:,1:idx-1),domain_up1, domain_up2,domain(:,idx+1:end)];
     end
     
     id=idx+position+1;
end

