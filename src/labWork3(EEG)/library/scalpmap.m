function scalpmap(velec,re,dip,mom)
% re = electrode positions
% dip= dipoles (standard format: position + projections), one dipole per
% row
% velec = potentials on electrodes

nel=length(velec);

numOfLinspacePoints = 300;
sensorSize = 25;

% if complete sphere, split in two, it does not work otherwise (improve !!)
% assumes that the electrodes are almost symetric on z
if abs(sum(re(:,3)))<10^-5, 
%     % first half
%     xe=re(1:ceil(nel/2),1);
%     ye=re(1:ceil(nel/2),2);
%     ze=re(1:ceil(nel/2),3);
%     
%     F = TriScatteredInterp(xe,ye,ze);
%     xi=linspace(min(xe),max(xe),numOfLinspacePoints);
%     yi=linspace(min(ye),max(ye),numOfLinspacePoints);
%     [qx,qy]=meshgrid(xi,yi);
%     qz=F(qx,qy);
%     Fc = TriScatteredInterp(xe,ye,velec(1:ceil(nel/2)));
%     qc=Fc(qx,qy);
%     mesh(qx,qy,qz,qc);
%     %[Xi,Yi,Ci]=griddata(xe,ye,velec,unique(xe),unique(ye)');
%     %surface(Xi,Yi,Zi,Ci);
%     hold on
%     
%     % second half
%     xe=re(ceil(nel/2)+1:end,1);
%     ye=re(ceil(nel/2)+1:end,2);
%     ze=re(ceil(nel/2)+1:end,3);
%     
%     F = TriScatteredInterp(xe,ye,ze);
%     xi=linspace(min(xe),max(xe),numOfLinspacePoints);
%     yi=linspace(min(ye),max(ye),numOfLinspacePoints);
%     [qx,qy]=meshgrid(xi,yi);
%     qz=F(qx,qy);
%     Fc = TriScatteredInterp(xe,ye,velec(ceil(nel/2)+1:end));
%     qc=Fc(qx,qy);
%     mesh(qx,qy,qz,qc);
else
    xe=re(:,1);
    ye=re(:,2);
    ze=re(:,3);
    
    F = TriScatteredInterp(xe,ye,ze);
    xi=linspace(min(xe),max(xe),numOfLinspacePoints);
    yi=linspace(min(ye),max(ye),numOfLinspacePoints);
    [qx,qy]=meshgrid(xi,yi);
    qz=F(qx,qy);
    Fc = TriScatteredInterp(xe,ye,velec);
    qc=Fc(qx,qy);
    mesh(qx,qy,qz,qc);
    hold on
end
% caxis([-max(abs(velec)) max(abs(velec))])

% electrodes
% idx = cfg.idx;%[36 35 34 33 32 31];
% plot3(re(idx,1)*1.01,re(idx,2)*1.01,re(idx,3)*1.01,'ro','MarkerSize',10,'MarkerFaceColor','r')
% cfg.line = 28:36;

% ============================================================================
% plot sensors and labels
% % % plot3(re(:,1),re(:,2),re(:,3),'.g','markersize',sensorSize);
% % % 
% % % cellArray = strcat({' '},int2str((1:nel).')).';
% % % tre = re*1.1;
% % % text(tre(:,1),tre(:,2),tre(:,3),cellArray,'FontSize',12,'FontWeight','bold');

% ============================================================================
% view(-120,50);
view(0,90);

% plot dipole
if nargin>=3,
    disp('tarara')
    ft_plot_dipole(dip(:,1:3),mom','units','mm')
    
%     cmap = hsv(length(dip(:,1)));
%     [nbdip,~]=size(dip);
%     for idip=1:nbdip,
% %         line([xd(idip) xd(idip)+amd(idip)*sin(dip(5,idip))*cos(dip(4,idip))], [yd(idip) yd(idip)+amd(idip)*sin(dip(5,idip))*sin(dip(4,idip))], [zd(idip) zd(idip)+amd(idip)*cos(dip(5,idip))],'LineWidth',2,'Color','k');
%         darr=dip(idip,1:3);
%         orr=dip(idip,4:6)*10;
%         farr=[darr(1)+orr(1) darr(2)+orr(2) darr(3)+orr(3)];
%         arrow(darr, farr,'LineWidth',4,'Length',4,'TipAngle',25,'Color','k');
% 
% %         arrow(darr, farr,'LineWidth',4,'Length',1,'TipAngle',25,'Color',cmap(idip,:));
% %         
% %         ft_plot_dipole([dip(idip,1),dip(idip,2),dip(idip,3)],...
% %             [dip(idip,4),dip(idip,5),dip(idip,6)], 'diameter',2, 'length', 5)
%     end
end

% colorbar
grid