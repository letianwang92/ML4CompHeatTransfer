function [domain,id] = domain_insert_y_rand(domain,loc,ifbreak)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
 num_col=size(domain,2);
 xmin=loc(1)-0.5;
 xmax=loc(1)+0.5;
 flag=0;
 for i=1:num_col
     
     if domain(4,i)==loc(2) && domain(5,i)==loc(2)
         dmax=max(domain(2:3,i));
         dmin=min(domain(2:3,i));
         label=nonzeros(domain(6:7,i));
         if dmax>=xmax && dmin<=xmin
             idx=i;
             position=0;
             domain(6:7,idx)=[label;0];
             domain_up1=domain(:,idx);
             domain_up2=domain(:,idx);
             domain_sink=domain(:,idx);
             domain_up1(2)= dmin;
             domain_up1(3)= xmin;
             domain_sink(2)= xmin;
             domain_sink(3)= xmax;
             domain_up2(2)= xmax;
             domain_up2(3)= dmax;

             
             if dmin==xmin
                 position=-1;
                 domain_up1=[];
             end
             if dmax==xmax
                 domain_up2=[];
             end
             
             flag=1;
             break;
         
         end
     end
 end
 
 if flag~=1
     disp('error');
 end

 if ifbreak
     
     
     domain=[domain(:,1:idx-1),domain_up1,domain_sink, domain_up2,domain(:,idx+1:end)];
     
     
 else
     domain=[domain(:,1:idx-1),domain_up1, domain_up2,domain(:,idx+1:end)];
 end
 
 id=idx+position+1;
end

