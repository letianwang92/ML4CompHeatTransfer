function [HeatRate,Qflux,thermalmodel,thermalresults] = ht_steady_rand(L,XY,sinkPos,Qin,Tcold,k_pair,MeshSize,isFigure,isEvaluate)
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
HeatRate=0;
Qflux=0;
X=XY(1,:);
Y=XY(2,:);
k_low=k_pair(1);
k_high=k_pair(2);
D=1; % default size
[dl,EdgeN,faceMax,face_domain]=geom2d_whole_rand(L,D,X,Y,sinkPos,isFigure);

thermalmodel = createpde('thermal','steadystate');
%generate geometries
geometryFromEdges(thermalmodel,dl);

if isFigure==1
    figure('Position',[10,10,800,400]);
    subplot(1,2,1)
    pdegplot(thermalmodel,'FaceAlpha',0.25,'FaceLabel','on')
    title('Geometry with Face Labels')
    subplot(1,2,2)
    pdegplot(thermalmodel,'EdgeLabels','on');
    axis equal
end 

                           
for i=1:faceMax
    if ismember(i,face_domain)
        thermalProperties(thermalmodel,'Face',i,'ThermalConductivity',k_low);
    else
        thermalProperties(thermalmodel,'Face',i,'ThermalConductivity',k_high);
    end
end
                           
%% Set the boundary conditions   
thermalBC(thermalmodel,'Edge',EdgeN,'Temperature',Tcold);

%% Initial conditions
% only used for transient
%thermalIC(thermalmodel,100);
%tlist = 0:0.5:5;

%% source term
internalHeatSource(thermalmodel,Qin);

%% Generate the Mesh
generateMesh(thermalmodel,'Hmax',MeshSize);
if isFigure==1
figure 
pdeplot(thermalmodel)
title('Mesh')
end
%% Solve

thermalresults = solve(thermalmodel);


%% Heat Rate on the Boundary
if isEvaluate
    HeatRate = evaluateHeatRate(thermalresults,'Edge',EdgeN);
    X0=0;
    Y0=0;
    [qx,qy] = evaluateHeatFlux(thermalresults,X0,Y0);
    Qflux=[qx,qy];
end
end

