close all
clear all

addpath(genpath('library'))

radiuss=100;
electrodeCount=72;
elect = elposition(radiuss,electrodeCount,'h');
dip = elposition(65,electrodeCount,'h');
source=dip;

hold on
scatter3(elect(:,1),elect(:,2),elect(:,3),'b');
scatter3(dip(:,1),dip(:,2),dip(:,3),'*r');
orientation=elect-dip;
quiver3(dip(:,1),dip(:,2),dip(:,3),orientation(:,1),orientation(:,2),orientation(:,3),'r');
hold off

sk=1;
C=1;
A=ILFgeometricalModel(elect,source,orientation,sk,C);

S=zeros(72,100);
activeSources=[1,5,10];

% perfect precision resut using ones activation
S(activeSources,:)=ones(3,100);

% not that precise resut using rand activation
% S(activeSources,:)=rand(3,100);

X=A*S;

for ii = 1:size(A,1)
   A(:,ii) = A(:,ii)./norm(A(:,ii));
end

%% My implementation (doesn't work correctly)
maximumCoefficients=zeros(size(S,2),1);
maximumCoefficientIndices=zeros(size(S,2),1);
threshold=0.00001;
for i=1:size(S,2)
    residual=X(:,i);
    for n=1:size(S,2)
%         scalarproducts are coeficients
        scalarproducts=zeros(size(S,1),1);
        for j=1:size(S,1)
            scalarproducts(j)=dot(residual,(A(:,j)'));
        end

        [M,I]=max(scalarproducts);
        maximumCoefficients(i,n)=M;
        maximumCoefficientIndices(i,n)=I;

%         residual=residual-M*A(:,I);
        residual=residual-A(:,I);
        if mean(abs(residual))<threshold
            break;
        end
    end
end

%% Code from https://github.com/seunghwanyoo/omp/blob/master/mp.m (this method also doesn't work)
maximumCoefficients=zeros(size(S,1),1);
for i=1:size(S,2)
    maximumCoefficients(:,i)= mp(A,X(:,i),3)
end
%% Gundars code (this works)
maximumCoefficientIndices=zeros(size(S,1),3);
for i=1:size(S,2)
      maximumCoefficientIndices(i,:)= mpGundars(X(:,i)', A, 3 )'
end