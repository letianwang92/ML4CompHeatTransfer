
clear all
close all
L=11;
loop_num=1;

X=[0,0,0,1,1,-1,-1,-1,-1,-1,-1];
Y=[1,0,2,2,3,+2,+3,+4,+5,+6,+7];
%X=[0,0,0,1,1,-1,-1];
%Y=[1,0,2,2,3,2,3];

X=[+0,+0,+1,+1,-1,-1,-1,-1,-1,+4,-4];
Y=[+1,+2,+2,+3,+2,+3,+4,+5,+6,+0,+0];
XY=[X;Y];

number=9;
edge_up=3;
edge=3;
X = randi([-(L-1-2*edge)/2, (L-1-2*edge)/2], number,1);
Y = randi([0, L-1-edge_up], number,1);
XY=[X';Y'];
% must remove overlap

X1=[0 1];
Y1=[0 2];
C=zeros(L+1);
idx = sub2ind(size(C), X+(L-1)/2+1, Y+1);
C(idx)=1;
figure
pcolor(C)

Qin=1;
Tcold=20;
k_pair=[1, 100];
IsFigure=1;


    for i=0:loop_num
    meshSize(i+1)=1/2^i;
    tic
    [HeatRate(i+1),Qflux(i+1,:),model,results] = ht_steady(L,XY,Qin,Tcold,k_pair,meshSize(i+1),IsFigure);
    usedTime(i+1)=toc;
    totalElement(i+1)=(L/meshSize(i+1))^2;
    end

%%
figure
subplot(2,2,1)
loglog(meshSize,usedTime,'o-');
ylim([0,100]);
xlabel('Mesh Size');
title('Computation Time');

subplot(2,2,2)
semilogx(meshSize,HeatRate/100,'o-');
xlabel('Mesh Size');
title('Normalized Heat Rate');

subplot(2,2,3)
semilogx(meshSize,Qflux(:,1),'o-');
xlabel('Mesh Size');
title('Flux_X');

subplot(2,2,4)
semilogx(meshSize,Qflux(:,2),'o-');
xlabel('Mesh Size');
title('Flux_Y');

%%

figure

plot(meshSize,HeatRate/L^2,'o-');
xlabel('Mesh Size');
title('Normalized Heat Rate');
%%
T = results.Temperature;
%% Plot Temperature
if IsFigure==1
    figure
    pdeplot(model,'XYData',T)
    title('Temperature Distribution');
    
end