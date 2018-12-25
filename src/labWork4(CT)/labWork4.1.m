clear all
close all

addpath(genpath('library'))

N=100;
x=-N:N;
y=-N:N;
z=Phantom(x,y);

figure,imshow(z)

for i=1:180
    rotatedZ=imrotate(z,i,'bicubic','crop');
    zSummed(i,:)=sum(rotatedZ);
end
figure,imshow(zSummed,[])

[h,n]=CBPFilter(N);

zRestored=zeros(401,401);
for i=1:180
    projection=zSummed(i,:);
    projection=conv(projection,h);
    tempZ=repmat(projection,401,1);
    tempZ=imrotate(tempZ,i,'bicubic','crop');
    zRestored=zRestored+tempZ;
end
figure,imshow(zRestored,[])

%% No filtration
zRestored=zeros(size(z));
for i=1:180
    projection=zSummed(i,:);
    tempZ=repmat(projection,201,1);
    tempZ=imrotate(tempZ,i,'bicubic','crop');
    zRestored=zRestored+tempZ;
end
figure,imshow(zRestored,[])