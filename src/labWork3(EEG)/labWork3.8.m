close all;
clear all;

addpath(genpath('library'))

[V,m,h,n,t]=hhrun(10.5, 200, -70, 0.4, 0.2, 0.5, 0.1);
plot(V)

%% My implementation (not finished)
ExNa=115;
ExK=-12;
ExL=10.6;

gxNa=120;
gxK=-36;
gxL=0.3;

axN=@(u)(0.1-0.01*u)/(exp(1-0.1*u)-1);
axM=@(u)(2.5-0.1*u)/(exp(2.5-0.1*u)-1);
axH=@(u)0.07*(exp(-(u)/20));

bxN=@(u)0.125*(exp(-u/80));
bxM=@(u)4*(exp(-u/18));
bxH=@(u)1/(exp(3-0.1*u)+1);

m=0;
n=0;
h=0;

u=5;

% dt = 0.001;               % time step for forward euler method
% loop  = ceil(tspan/dt);   % no. of iterations of euler
I(1)=0;
for i=1:10000
    Ik=gxNa*m(i)^3*h(i)*(u-ExNa)+gxK*n(i)^4*(u-ExK)+gxL*(u-ExL);

    I(i+1)=I(i)+Ik;

    m(i+1)=axM(u)*(1-m(i))-bxM(u)*m(i);
    n(i+1)=axN(u)*(1-n(i))-bxN(u)*n(i);
    h(i+1)=axH(u)*(1-h(i))-bxH(u)*h(i);
end

plot(I)
