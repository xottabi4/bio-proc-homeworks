function lf=ILFplanarModel(elect,source,sk)
lf=zeros(size(source,1),size(source,1));
for i=1:size(source,1)
    vectorI=source(i,:)-elect(i,:);
    distanceKK=norm(vectorI);
    for j=1:size(elect,1)
        distanceXjk=norm(elect(i,:)-elect(j,:));
        hp=(1/(distanceKK.^2))/(((distanceXjk.^2)/(distanceKK.^2))+1).^(3/2);
        lf(j,i)=(sk*hp);
    end
end