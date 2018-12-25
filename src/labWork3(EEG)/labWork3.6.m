close all
clear all

addpath(genpath('library'))

radiuss=100;
electrodeCount=72;
elect = elposition(radiuss,electrodeCount,'h');
cort = elposition(75,electrodeCount,'h');
dip = elposition(65,electrodeCount,'h');
source=dip;

hold on
scatter3(elect(:,1),elect(:,2),elect(:,3),'b');
scatter3(cort(:,1),cort(:,2),cort(:,3),'k');
scatter3(dip(:,1),dip(:,2),dip(:,3),'*r');
orientation=elect-dip;
quiver3(dip(:,1),dip(:,2),dip(:,3),orientation(:,1),orientation(:,2),orientation(:,3),'r');

% Shift position in random direction
randNumber=repmat(rand(size(source,1),1)*5,[1,3]);

sourceShifted=source+randNumber;
scatter3(sourceShifted(:,1),sourceShifted(:,2),sourceShifted(:,3),'*g');

orientationShiffted=(rand(size(source,1),3)*2)-1;
quiver3(sourceShifted(:,1),sourceShifted(:,2),sourceShifted(:,3),orientationShiffted(:,1),orientationShiffted(:,2),orientationShiffted(:,3),'g');

hold off

sk=1;
C=1;
Ah=ILFgeometricalModel(elect,sourceShifted,orientationShiffted,sk,C);
Ac=ILFgeometricalModel(cort,sourceShifted,orientationShiffted,sk,C);

S=rand(72,100);
Xh=Ah*S;
Xc=Ac*S;
% affichage(X,256)
% scalpmap(X(:,10),elect)
% imagesc(Ac)

electDistance=squareform(pdist(elect));
% imagesc(electDistance)

estimatedXc=Xh;
for i=1:electrodeCount
    [closestElectPoints,indices]=sort(electDistance(i,:));
    closestIndices=indices(closestElectPoints<40);
    closestElectPointLocations=closestIndices;
    if (length(closestIndices)>5)
        closestElectPointLocations=closestIndices(1:5);
    end
    closestElectPointLocations(closestElectPointLocations==i) = [];

    XhMean=mean(Xh(closestElectPointLocations,:));
    estimatedXc(i,:)=estimatedXc(i,:)-XhMean;
end

corrcoef(Xh(:,1),Xc(:,1))

errors=(Xc-estimatedXc);
MSE=mean(mean(errors.^2))
RMSE=sqrt(MSE)

i=5;
figure,
scalpmap(Xh(:,i),cort)
figure,
scalpmap(estimatedXc(:,i),cort)