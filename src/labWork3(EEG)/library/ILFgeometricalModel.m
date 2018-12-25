function lf=ILFgeometricalModel(elect,source,orientation,sk,C)
lf=zeros(size(source,1),size(source,1));
for i=1:size(source,1)
    vectorI=orientation(i,:);
    for j=1:size(elect,1)
        vectorIJ=elect(j,:)-source(i,:);
        
        dotProduct=dot(vectorI,vectorIJ);
        vectorMagnitude=norm(vectorI)*norm(vectorIJ);
        cosA=dotProduct./vectorMagnitude;
        
        distanceJi=norm(vectorIJ);
        
        lf(j,i)=(sk*cosA)./(C*(distanceJi.^2));
    end
end
