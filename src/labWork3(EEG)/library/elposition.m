function elec=elposition(rsc,nbe,sphcomp)
% generates cartesian coordinates for a sphere of radius rsc, according to
% the chosen number of electrodes nbe
% the electrodes are subsets of the 10-10 montage (figure 10-20_complet.gif)
% 
% inputs :   rsc = scalp radius
%            nbe = must belong to {8 16 24 32 48 64 72}
%            sphcomp = 's' or 'h' (default = 'h') to generate a complete
%            sphere (s) or just the upper part (h)
% output :   elec = cartesian coordinates
% example : if nbe = 72 we have the 10-10 without the nasion Nz
%           if nbe = 24 we have the 10-20 from CHU Nancy
%           if nbe = 8 we have sleep electrodes
% etc.
% if nbe is not given, it returns 73 electrodes (72 + Nz)

if nargin==0,
    rsc=1;nbe=72;
elseif nargin==1,
    nbe=72;
elseif ~ismember(nbe,[8 16 24 32 48 64 72])
    error('Wrong number of electrodes, unknown montage');
end
if nargin<3,
    sphcomp='h';
end

%Nz
alpha=pi/2;beta=0;
%Fp
alphac=pi/2-pi/10;
gammac=-pi/2+pi/4:pi/4:pi/2-pi/4;
alphat=acos(cos(alphac).*cos(gammac));
alpha=[alpha alphat];
betat=acos(sin(alphac)./sin(alphat));betat(ceil(length(betat)/2):end)=2*pi-betat(ceil(length(betat)/2):end);
beta=[beta betat];
%AF
alphac=pi/2-2*pi/10;
gammac=-pi/2+pi/6:pi/6:pi/2-pi/6;
alphat=acos(cos(alphac).*cos(gammac));
alpha=[alpha alphat];
betat=acos(sin(alphac)./sin(alphat));betat(ceil(length(betat)/2):end)=2*pi-betat(ceil(length(betat)/2):end);
beta=[beta betat];
%F
alphac=pi/2-3*pi/10;
gammac=-pi/2:pi/10:pi/2;
alphat=acos(cos(alphac).*cos(gammac));
alpha=[alpha alphat];
betat=acos(sin(alphac)./sin(alphat));betat(ceil(length(betat)/2):end)=2*pi-betat(ceil(length(betat)/2):end);
beta=[beta betat];
%FT,FC
alphac=pi/2-4*pi/10;
gammac=-pi/2:pi/10:pi/2;
alphat=acos(cos(alphac).*cos(gammac));
alpha=[alpha alphat];
betat=acos(sin(alphac)./sin(alphat));betat(ceil(length(betat)/2):end)=2*pi-betat(ceil(length(betat)/2):end);
beta=[beta betat];
%T,C
alphac=pi/2-5*pi/10;
gammac=-pi/2:pi/10:pi/2;
alphat=acos(cos(alphac).*cos(gammac));
alpha=[alpha alphat];
betat=acos(sin(alphac)./sin(alphat));betat(ceil(length(betat)/2):end)=2*pi-betat(ceil(length(betat)/2):end);
betat(alphat==0)=0;
beta=[beta betat];
%TP,CP
alphac=pi/2-6*pi/10;
gammac=-pi/2:pi/10:pi/2;
alphat=acos(cos(alphac).*cos(gammac));
alpha=[alpha alphat];
betat=acos(sin(alphac)./sin(alphat));betat(ceil(length(betat)/2):end)=2*pi-betat(ceil(length(betat)/2):end);
beta=[beta betat];
%P
alphac=pi/2-7*pi/10;
gammac=-pi/2:pi/10:pi/2;
alphat=acos(cos(alphac).*cos(gammac));
alpha=[alpha alphat];
betat=acos(sin(alphac)./sin(alphat));betat(ceil(length(betat)/2):end)=2*pi-betat(ceil(length(betat)/2):end);
beta=[beta betat];
%PO
alphac=pi/2-8*pi/10;
gammac=-pi/2+pi/6:pi/6:pi/2-pi/6;
alphat=acos(cos(alphac).*cos(gammac));
alpha=[alpha alphat];
betat=acos(sin(alphac)./sin(alphat));betat(ceil(length(betat)/2):end)=2*pi-betat(ceil(length(betat)/2):end);
beta=[beta betat];
%O
alphac=pi/2-9*pi/10;
gammac=-pi/2+pi/4:pi/4:pi/2-pi/4;
alphat=acos(cos(alphac).*cos(gammac));
alpha=[alpha alphat];
betat=acos(sin(alphac)./sin(alphat));betat(ceil(length(betat)/2):end)=2*pi-betat(ceil(length(betat)/2):end);
beta=[beta betat];
%Iz
alpha=[alpha pi/2];beta=[beta pi];


re=rsc;

% cartesian coordinates

xe=zeros(1,73);
ye=xe;ze=xe;
for iel=1:length(beta),
    xe(iel)=re*sin(alpha(iel))*cos(beta(iel));
    ye(iel)=re*sin(alpha(iel))*sin(beta(iel));
    ze(iel)=re*cos(alpha(iel));
end

elec=[xe;ye;ze];

switch nbe
    case 8
        indkeep=[3 33:2:41 70 72]; % fig sleep_eeg
    case 16
        indkeep=[13 15 17 33:2:41 55:2:63 65 69 71]; % fig eeg16_BCI
    case 24
        indkeep=[2 4 11:2:19 21 31 33:2:41 54 55:2:63 64 70:72]; % fig 10-20 nancy
    case 32
        indkeep= [2 4 11:2:19 22:2:30 33:2:41 43 44:2:52 53 55:2:63 70:72];% fig eeg32
    case 48
        indkeep=[2:9 11:2:19 22:2:30 33:41 43 44:2:52 53 55:2:63 65:73];% fig eeg48radu
    case 64
        indkeep=[2 4:9 11:19 21:31 33:41 43:53 55:63 65:72]; % radu
    case 72
        indkeep=2:73;
    otherwise
        indkeep=1:73;
end
elec=elec(:,indkeep)';

if sphcomp=='s',
    elecd=elec(elec(:,3)~=0,:);
    elecd(:,3)=-elecd(:,3);
    elec=[elec;elecd]; 
end



%xe(ne)=0;ye(ne)=0;ze(ne)=1;
%plot3(elec(1,:),elec(2,:),elec(3,:),'*');