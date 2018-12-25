close all
clear all

addpath(genpath('library'))

MSEtotal=zeros(100,1);
for i=1:100

radiuss=100;
electrodeCount=32;
elect = elposition(radiuss,electrodeCount,'h');
scatter3(elect(:,1),elect(:,2),elect(:,3));
hold on

source=elect*0.5;
scatter3(source(:,1),source(:,2),source(:,3),'*r');

orientation=elect-source;
quiver3(source(:,1),source(:,2),source(:,3),orientation(:,1),orientation(:,2),orientation(:,3),'r');

orientationShiffted=(rand(size(source,1),3)*2)-1;
quiver3(source(:,1),source(:,2),source(:,3),orientationShiffted(:,1),orientationShiffted(:,2),orientationShiffted(:,3),'g');

sk=1;
C=1;
A=ILFgeometricalModel(elect,source,orientationShiffted,sk,C);
% figure,
% imagesc(A)

sk=1;
Ap=ILFplanarModel(elect,source,sk);
% figure,
% imagesc(Ap)

S=rand(32,100);
X=A*S;
% affichage(X,256)
% scalpmap(X(:,10),elect)

S_hat=inv(Ap)*X;

errors=(S-S_hat);
MSE=mean( mean(errors.^2))

MSEtotal(i)=MSE;
end

MSEmean=mean(MSEtotal)
figure,
plot(MSEtotal)
