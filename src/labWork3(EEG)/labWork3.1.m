close all
clear all

addpath(genpath('library'))

radiuss=100;
electrodeCount=32;
elect = elposition(radiuss,electrodeCount,'h');

scatter3(elect(:,1),elect(:,2),elect(:,3));
hold on
source=elect*0.6;
lf = inf_medium_leadfield(source,elect, 1);

orientation=elect-source;
for i=1:size(orientation,1)
    orientation(i,:)=orientation(i,:)/norm(orientation(i,:));
end

quiver3(source(:,1),source(:,2),source(:,3),orientation(:,1),orientation(:,2),orientation(:,3));

counter=1;
for i=1:size(lf,1)
    A(:,i)=lf(:,counter:counter+2)*orientation(i,:)';
    counter=counter+3;
end
hold off
imagesc(A)

randomSignal=rand(32,4);
randomSignal=repmat(randomSignal,1, 256/4);

S=zeros(32,256);
% for i=1:
S(1:5,1:4)=ones(5,4);
S(6:10,5:8)=ones(5,4);
S(11:15,9:12)=ones(5,4);
S(16:20,13:16)=ones(5,4);
S(21:25,17:20)=ones(5,4);
S(26:30,21:24)=ones(5,4);

S=S.*randomSignal;
% S 32x256 1s

X=A*S;
% X=32x256
affichage(X,256)

% movie creation
for i=1:256
scalpmap(X(:,i),elect)
pause(0.5)
end