clear all
close all
format long

addpath(genpath('library'))
load ecgdemodata1.mat

drawFourierSpecter(ecg,length(ecg),samplingrate);
% affichage(ecg,samplingrate)

% filterDesigner
filteredEcg=filter(customFilter4(),ecg);
drawFourierSpecter(filteredEcg,length(ecg),samplingrate);
% affichage(filteredEcg,samplingrate)


ecgMean=mean(ecg);
filteredEcgPeaks=filteredEcg.*(filteredEcg>500);
[pks,locs]=findpeaks(filteredEcgPeaks,samplingrate);

bps=[];
for i=1:(length(locs)-1)
    bps(i)=locs(i+1)-locs(i);
end
bpm=mean(bps).*60