function varargout = affichage(varargin)
%SYNTAXE :
%           affichage(matrice,Fech)
%        ou affichage(matrice,Fech,64)
%        ou affichage(matrice,Fech,'fichier_noms_electrodes')
%
% Cette fonction permet l'affichage des voies de la variable pass�e en 1er argument.
% Chaque LIGNE de cette matrice correspond � UNE VOIE.
%
% Le second argument est la fr�quence d'�chantillonnage.
%
% Un troisi�me argument est facultatif:
% - Lorsque cet argument est absent, les noms des voies � afficher sont num�rot�s � partir de 1
% - Lorsque l'argument vaut 64, les voies affich�es ont pour noms :
%      {'Fp2';'F2';'FC2';'C2';'CP2';'P2';'O2';'AF4';'F4';'FC4';'C4';'CP4';'P4';'PO4';...
%     'F6';'FC6';'C6';'CP6';'P6';'AF8';'F8';'FT8';'T4';'TP8';'T6';'PO8';'FT10';'P10';'AFz';...
%     'Fz';'FCz';'Cz';'CPz';'Pz';'POz';'Oz';'Fp1';'F1';'FC1';'C1';'CP1';'P1';'O1';'AF3';'F3';...
%     'FC3';'C3';'CP3';'P3';'PO3';'F5';'FC5';'C5';'CP5';'P5';'AF7';'F7';'FT7';'T3';'TP7';'T5';'PO7';'FT9';'P9'}
% - Cet argument peut �galement d�signer un fichier dans lequel sont contenus les noms des voies � afficher 
%   (les noms doivent �tre s�par�s par des espaces ou des tabulations, ou alors se situer sur des lignes diff�rentes)
%
% Le nombre de voies doit �tre inf�rieur ou �gal � 64 lorsque le troisi�me argument vaut 64.
% Dans le cas o� il y a moins de 64 voies � afficher et que varargin{3} vaut 64, seuls les premiers noms de la liste s'affichent.


couleur=[1 1 1];

if nargin==2
    for ind=1:size(varargin{1},1)
        electrodes{ind,1}=num2str(ind);
        Fech=varargin{2};
    end
elseif nargin==3
    Fech=varargin{2};
    if iscell(varargin{3})
        electrodes=varargin{3};
    else
        if varargin{3}==64
            % noms des electrodes affich�es dans cette ordre (possibilit� de les modifier selon le montage utilis�)
            electrodes= {'Fp2';'F2';'FC2';'C2';'CP2';'P2';'O2';'AF4';'F4';'FC4';'C4';'CP4';'P4';'PO4';...
            'F6';'FC6';'C6';'CP6';'P6';'AF8';'F8';'FT8';'T4';'TP8';'T6';'PO8';'FT10';'P10';'AFz';...
            'Fz';'FCz';'Cz';'CPz';'Pz';'POz';'Oz';'Fp1';'F1';'FC1';'C1';'CP1';'P1';'O1';'AF3';'F3';...
            'FC3';'C3';'CP3';'P3';'PO3';'F5';'FC5';'C5';'CP5';'P5';'AF7';'F7';'FT7';'T3';'TP7';'T5';'PO7';'FT9';'P9'};
        elseif exist(varargin{3},'file')
            try
                electrodes=textread(varargin{3},'%s','delimiter',['\t' ' ']);
            catch
                disp('ERREUR de lecture du fichier contenant le nom des �lectrodes!!');
                return;
            end
        else
            disp('ERREUR dans le 3�me argument de la fonction "affichage"!!');
            return;
        end
    end
else
    disp('ERREUR dans le nombre d''arguments de la fonction!!');
    return;
end

sig=varargin{1}; % signal � afficher

facteur_echelle=1; % valeur par d�faut du facteur d'�chelle pour modifier l'ordonn�e des courbes

if size(sig,1)>length(electrodes)
    disp('ERREUR: il manque des noms d''�lectrodes!!');
    return;
end

f = figure('Units','normalized',...
    'Position',[.1 .05 0.7 0.75],...
    'Renderer','painters',...
    'Toolbar','figure','NumberTitle','off',...
    'Name',['EEGviewer : ' inputname(1)],'Color',couleur);


bouton_precedent = uicontrol(f,'Style','pushbutton','FontSize',14,'String','<<','Units','normalized',...
    'Position',[.04 .02 .04 .04],'Callback',{@precedent},'ToolTipString','reculer de 10 secondes','ForegroundColor',[.1 .1 .9]);

bouton_suivant = uicontrol(f,'Style','pushbutton','FontSize',14,'String','>>','Units','normalized','Position',...
    [.93 .02 .04 .04],'Callback',{@suivant},'ToolTipString','avancer de 10 secondes','ForegroundColor',[.1 .1 .9]);

bouton_courbes_precedentes = uicontrol(f,'Style','pushbutton','FontSize',10,'FontWeight','bold','String','/\','Units','normalized','Position',...
    [.93 .87 .04 .04],'Callback',{@courbes_prec},'ToolTipString','reculer de 5 courbes','ForegroundColor',[.0 .3 .0]);

bouton_courbes_suivantes = uicontrol(f,'Style','pushbutton','FontSize',10,'FontWeight','bold','String','\/','Units','normalized','Position',...
    [.93 .12 .04 .04],'Callback',{@courbes_suiv},'ToolTipString','avancer de 5 courbes','ForegroundColor',[.0 .3 .0]);

texte_facteur=uicontrol(f,'Style','text','FontSize',8,'String','facteur d''�chelle','Units','normalized',...
    'Position',[.908 .6 .09 .03],'BackgroundColor',couleur,'HorizontalAlignment','center','ToolTipString','Facteur d''�chelle > 0');

valeur_facteur_echelle = uicontrol(f,'Style','edit','String','1','Units','normalized','Position',[.93 .58 .04 .025],...
    'BackgroundColor',[1 1 1],'HorizontalAlignment','left','Callback',{@valeur_facteur},'FontSize',9);

bouton_affichage_temps_total = uicontrol(f,'Style','pushbutton','FontSize',10,'String','Afficher toute la dur�e','Units','normalized','Position',...
    [.63 .02 .16 .04],'Callback',{@courbe_entiere},'ForegroundColor',[0 0 1]);


Temps_sig=0; % temps correspondant au d�but du signal affich� (en secondes)
Voie_affich=1; % n� de la premi�re voie affich�e
trace(1,1);

% trace les voies prem_voie � (prem_voie+15) sur 20 s � partir du point n� ti (ou trace toute la dur�e)
function trace(prem_voie,ti)
    nb_voies_affichees=16;
    if strcmp(get(bouton_affichage_temps_total,'String'),'Afficher 20s') % Attention : c'est le contraire qui s'affiche
        temps_affich=(size(sig,2)-1)/Fech;
    else
        temps_affich=20;
    end
    if size(sig,1)<16 % cas o� il y a moins de 16 voies
        nb_voies_affichees=size(sig,1);
        set(bouton_courbes_suivantes,'Enable','off');
        set(bouton_courbes_precedentes,'Enable','off');
    end
    if size(sig,2)<20*Fech+1 % cas o� il y a moins de 20 s
        temps_affich=(size(sig,2)-1)/Fech;
        set(bouton_suivant,'Enable','off');
        set(bouton_precedent,'Enable','off');
    end
    
    redim_ymax=0; % variable d�finissant si le nom de la premi�re voie s'affiche correctement
    redim_ymin=0; % variable d�finissant si le nom de la derni�re voie s'affiche correctement
    
    % affichage des courbes:
    amplitude_max=max(max(abs(sig)));
    for k=prem_voie:prem_voie+nb_voies_affichees-1
        delta_y=nb_voies_affichees-k+prem_voie-1;
        if k==prem_voie % teste si toutes le valeurs de la 1�re voie sont <0, auquel cas 
                        % il faudra modifier l'affichage du nom de la voie en ordonn�e
            if ~any(sig(k,ti:ti+Fech*temps_affich)>=0)
                redim_ymax=1;
            end
            Ymax=max(sig(k,ti:ti+Fech*temps_affich)+delta_y*amplitude_max*facteur_echelle); % valeur maximale � afficher
        elseif k==prem_voie+nb_voies_affichees-1 % teste si toutes le valeurs de la derni�re voie sont >0, auquel 
                                                % cas il faudra modifier l'affichage du nom de la voie en ordonn�e
            if ~any(sig(k,ti:ti+Fech*temps_affich)<=0)
                redim_ymin=1;
            end
            Ymin=min(sig(k,ti:ti+Fech*temps_affich)+delta_y*amplitude_max*facteur_echelle); % valeur minimale � afficher
        end
        if mod(k,5)==1
            plot((ti-1)/Fech:1/Fech:(ti-1)/Fech+temps_affich,sig(k,ti:ti+Fech*temps_affich)+delta_y*amplitude_max*facteur_echelle,'k');
        elseif mod(k,5)==2
            plot((ti-1)/Fech:1/Fech:(ti-1)/Fech+temps_affich,sig(k,ti:ti+Fech*temps_affich)+delta_y*amplitude_max*facteur_echelle,'k');
        elseif mod(k,5)==3
            plot((ti-1)/Fech:1/Fech:(ti-1)/Fech+temps_affich,sig(k,ti:ti+Fech*temps_affich)+delta_y*amplitude_max*facteur_echelle,'k');
        elseif mod(k,5)==4
            plot((ti-1)/Fech:1/Fech:(ti-1)/Fech+temps_affich,sig(k,ti:ti+Fech*temps_affich)+delta_y*amplitude_max*facteur_echelle,'k');
        elseif mod(k,5)==0
            plot((ti-1)/Fech:1/Fech:(ti-1)/Fech+temps_affich,sig(k,ti:ti+Fech*temps_affich)+delta_y*amplitude_max*facteur_echelle,'k');
        end
        hold on;
    end
     
    % des espaces sont ajout�s dans les noms d'�lectrodes pour que tous les
    % noms contiennent le m�me nombre de caract�res:
    long_nom=0;
    for i=1:length(electrodes)
        if length(electrodes{i})>long_nom;
            long_nom=length(electrodes{i});
        end
    end
    for i=1:length(electrodes)
        while length(electrodes{i})<long_nom;
            electrodes{i}=[' ' electrodes{i}];
        end
    end
    
    for j=prem_voie:prem_voie+nb_voies_affichees-1 
        noms_voies(j+1-prem_voie,:)=electrodes{j};
    end
    % affichage des noms des voies:
    set(gca,'YTick',(0:nb_voies_affichees-1)*facteur_echelle*amplitude_max,'YTickLabel',noms_voies(end:-1:1,:));
    % l'�chelle des ordonn�es est adapt�e aux donn�es trac�es, pour pouvoir afficher les noms de toutes les voies:
    
    if strcmp(get(bouton_affichage_temps_total,'String'),'Afficher 20s') % Attention : c'est le contraire qui s'affiche
        axis([0 temps_affich+1/Fech (1-redim_ymin)*Ymin redim_ymax*(nb_voies_affichees-1)*facteur_echelle*amplitude_max+(1-redim_ymax)*Ymax]);
    elseif size(sig,2)<20*Fech % cas o� il y a moins de 20 s
        axis([0 20+1/Fech (1-redim_ymin)*Ymin redim_ymax*(nb_voies_affichees-1)*facteur_echelle*amplitude_max+(1-redim_ymax)*Ymax]);
    else
        axis([Temps_sig Temps_sig+temps_affich+1/Fech (1-redim_ymin)*Ymin redim_ymax*(nb_voies_affichees-1)*facteur_echelle*amplitude_max+(1-redim_ymax)*Ymax]);
    end
        
    grid on;
    xlabel('Temps (s)');
    hold off;
    clear noms_voies; % au cas o� il y aura moins de voies � afficher suite � un clic sur un bouton
end


% affichage des valeurs temporelles pr�c�dentes:  
function precedent(hObject, eventdata, handles)
    Temps_sig=Temps_sig-10;
    if mod(Temps_sig,10)
        Temps_sig=round(Temps_sig/10)*10;
    end
    if Temps_sig<0
        Temps_sig=0;
    end
    trace(Voie_affich,1+Temps_sig*Fech);
end


% affichage des valeurs temporelles suivantes:
function suivant(hObject, eventdata, handles)
    Temps_sig=Temps_sig+10;
    if Temps_sig>(size(sig,2)-1)/Fech-20
        Temps_sig=(size(sig,2)-1)/Fech-20;
    end
    trace(Voie_affich,1+Temps_sig*Fech);
end


% affichage des courbes suivantes:
function courbes_suiv(hObject, eventdata, handles)
    Voie_affich=Voie_affich+5;
    if Voie_affich > size(sig,1)-15 % cas o� les derni�res courbes sont atteintes
        Voie_affich=size(sig,1)-15;
        if Voie_affich < 1
            Voie_affich=1;
        end
    end
    if strcmp(get(bouton_affichage_temps_total,'String'),'Afficher 20s')
        trace(Voie_affich,1); % affichage de la dur�e totale
    else
        trace(Voie_affich,1+Temps_sig*Fech);
    end
end


% affichage des courbes pr�c�dentes:
function courbes_prec(hObject, eventdata, handles)
    Voie_affich=Voie_affich-5;
    if Voie_affich < 1 % cas o� les premi�res courbes sont atteintes
        Voie_affich=1;
    end
    if strcmp(get(bouton_affichage_temps_total,'String'),'Afficher 20s')
        trace(Voie_affich,1); % affichage de la dur�e totale
    else
        trace(Voie_affich,1+Temps_sig*Fech);
    end
end


% utilisation de la valeur du facteur d'�chelle
function valeur_facteur(hObject, eventdata, handles)
    facteur_echelle=str2num(get(hObject,'String'));
    if facteur_echelle<=0  % valeur <0 impossible pour le facteur d'�chelle
        facteur_echelle=1;
        set(hObject,'String','1');
    elseif ~isequal(size(facteur_echelle),[1 1]) % le facteur d'�chelle ne doit pas �tre vide (ou un caract�re)
        facteur_echelle=1;
        set(hObject,'String','1');
    end
    if strcmp(get(bouton_affichage_temps_total,'String'),'Afficher 20s')
        trace(Voie_affich,1); % affichage de la dur�e totale
    else
        trace(Voie_affich,1+Temps_sig*Fech);
    end
end

% affichage des courbes sur toute leur dur�e
function courbe_entiere(hObject, eventdata, handles)
    if strcmp(get(hObject,'String'),'Afficher toute la dur�e')
        set(hObject,'String','Afficher 20s');
        set(bouton_precedent,'Enable','off');
        set(bouton_suivant,'Enable','off');
        trace(Voie_affich,1);
    elseif strcmp(get(hObject,'String'),'Afficher 20s')
        set(hObject,'String','Afficher toute la dur�e');
        if size(sig,2)>=20*Fech
            set(bouton_precedent,'Enable','on');
            set(bouton_suivant,'Enable','on');
        end
        trace(Voie_affich,1+Temps_sig*Fech);
    end
end

end