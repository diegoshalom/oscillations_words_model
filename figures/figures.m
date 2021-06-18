%% Chech files exist
close all
if ~exist('clusters_trend.mat','file') || ...
   ~exist('clusters_osc.mat','file') || ...
   ~exist('stat_true.mat','file') || ...
   ~exist('TrendPendienteFase.mat','file') 
    fprintf(2,'Some needed mat files are missing. \n  Please run clusters.m first, to generate them.\n')
    return
end

%% Figure 1

clear all

figure(1);clf
set(gcf,'color','w')
set(gcf,'position',[680 298 556 680])
bordeizq = 0.1;
ancho1 = .45;
seph = .08; 
ancho2 = .3;
bordeinf = .1;
alto =.35;
sepv =.1;

clear handles
handles(1)=axes('position',[bordeizq             bordeinf+alto+sepv ancho1 alto]);
handles(2)=axes('position',[bordeizq             bordeinf ancho1 alto]);
handles(3)=axes('position',[bordeizq+ancho1+seph bordeinf+alto+sepv ancho2 alto]);
handles(4)=axes('position',[bordeizq+ancho1+seph bordeinf ancho2 alto]);

load F_TIMELINE_con_trend
desde=50;
hasta=300;

gpalabras={ 'time' 'year' 'war'}; 

index=arrayfun(@(x) find(ismember({F_TIMELINE.word},x)),gpalabras);

ventanasmooth=2; 

h={};
set(gcf,'currentaxes',handles(2)); hold all
line([1700 2000],[0 0],'color',[.5 .5 .5])
line([1750 1750], [-1.5e-4 2.5e-4],'color','k');
for indp=1:length(gpalabras)
    set(gcf,'currentaxes',handles(1))
    hold all
    
    years=F_TIMELINE(index(indp)).years;
    freqrel=F_TIMELINE(index(indp)).freqrel;
    firstsmooth=smooth(F_TIMELINE(index(indp)).freqrel,ventanasmooth); %primer smooth, vuelvo a calcular
    smoothed=F_TIMELINE(index(indp)).smoothed;%smooth + primer paso de autotrend. densidad
    trend=F_TIMELINE(index(indp)).trend;%segundo paso de autotrend
    osc=smoothed-trend;%oscilaciones
    
    plot(years,F_TIMELINE(index(indp)).freqrel,'.','Color',[0 0 0]+0.05*10)
    plot(years,smoothed,'linewidth',.5,'color','b');
    plot(years,trend,'linewidth',.5,'color','r');
    line([1750 1750], ylim,'color','k')
    ylabel('Word density x')
    xlabel('Year')
    xlim([1700 2000])
    ylim([0 2.5e-3])

    indexpos=300;
    text(years(indexpos),smoothed(indexpos)+.00027,gpalabras{indp},'horizontalalignment','right')
    
    set(gcf,'currentaxes',handles(2))
    hold all
    h{indp}=plot(years,osc,'linewidth',.5);
    ylabel('Oscillatory components')
    xlabel('Year')
    xlim([1700 2000])
    
   drawnow
end
set(gcf,'currentaxes',handles(2))
legend([h{1:3}],gpalabras,'location','north')

% %%%%%%%%%%%%%%%%%%% PANEL 4
set(gcf,'currentaxes',handles(4))

DATA=reshape([F_TIMELINE.smoothed],309,length(F_TIMELINE))';
TREND=reshape([F_TIMELINE.trend],309,length(F_TIMELINE))';
OSC=DATA-TREND;

redmat=OSC(:,desde:hasta)';
vec=redmat(:);

[picos,indpicos]=findpeaks(vec);
periodososc=diff(indpicos);

hhh=histogram(periodososc,65);
hhh.EdgeColor='none';

xlim([0 50]);
title('Oscillations');
xlabel('Period (years)');
ylabel('Counts');

% %%%%%%%%%%%%%%%%%%% PANEL 3
set(gcf,'currentaxes',handles(3))
redmat=TREND(:,desde:hasta)';
for i=1:length(F_TIMELINE)
    redmat(:,i)=redmat(:,i)-mean(redmat(:,i));
end
periodos=[];
for ind=1:length(F_TIMELINE)
    [picos,indpicos]=findpeaks(redmat(:,ind));
    periodos=[periodos; diff(indpicos)];    
end
hhh=histogram(periodos,0:4:size(redmat,1));
hhh.EdgeColor='none';
xlim([0 250]);
ylim([0 310]);
title('Trends');
xlabel('Period (years)');
ylabel('Counts');

% letters
AxesH = axes('Parent', gcf, ...
  'Units', 'normalized', ...
  'Position', [0, 0, 1, 1], ...
  'Visible', 'off', ...
  'XLim', [0, 1], ...
  'YLim', [0, 1], ...
  'NextPlot', 'add');
letras='abdc'    ;
for indp=1:4
    pos=get(handles(indp),'position');
    posx=pos(1)+.01;
    posy=pos(2)+pos(4)-.03;
    text(posx,posy,letras(indp),'fontsize',20)
end

%% Figure 2

clear all

figure(2);clf

set(gcf,'color','w')

set(gcf,'position',[30 148 800 800])

bordeizq = 0.08;
ancho1 = .27; 
ancho2 = .27;
seph = .08; 
seph2 = .01; 
bordeinf = .08;
alto1 =.39;
alto2 =alto1/3;
sepv=0.1;


clear handles
handles(1)=axes('position',[bordeizq             bordeinf+alto1+sepv ancho1 alto1]);
handles(2)=axes('position',[bordeizq             bordeinf ancho1 alto1]);

handles(3)=axes('position',[bordeizq+ancho1+seph bordeinf+5*alto2+sepv ancho2 alto2]);
handles(4)=axes('position',[bordeizq+ancho1+seph bordeinf+4*alto2+sepv ancho2 alto2]);
handles(5)=axes('position',[bordeizq+ancho1+seph bordeinf+3*alto2+sepv ancho2 alto2]);

handles(6)=axes('position',[bordeizq+ancho1+seph bordeinf+2*alto2 ancho2 alto2]);
handles(7)=axes('position',[bordeizq+ancho1+seph bordeinf+1*alto2 ancho2 alto2]);
handles(8)=axes('position',[bordeizq+ancho1+seph bordeinf+0*alto2 ancho2 alto2]);

handles(9)=axes('position',[bordeizq+ancho1+seph+ancho2+seph2 bordeinf+5*alto2+sepv ancho2 alto2]);
handles(10)=axes('position',[bordeizq+ancho1+seph+ancho2+seph2 bordeinf+4*alto2+sepv ancho2 alto2]);
handles(11)=axes('position',[bordeizq+ancho1+seph+ancho2+seph2 bordeinf+3*alto2+sepv ancho2 alto2]);

handles(12)=axes('position',[bordeizq+ancho1+seph+ancho2+seph2 bordeinf+2*alto2 ancho2 alto2]);
handles(13)=axes('position',[bordeizq+ancho1+seph+ancho2+seph2 bordeinf+1*alto2 ancho2 alto2]);
handles(14)=axes('position',[bordeizq+ancho1+seph+ancho2+seph2 bordeinf+0*alto2 ancho2 alto2]);

elegidastrend = [116 113];

elegidasosc = [66 54];

% %%%%%%%%%%% FIGURA 2B. SIMILARIDAD SEMANTICA
load DataTrendSSA

set(gcf,'currentaxes',handles(2))
[~, ind_tam]=sort(tamanio,'descend');
x=0:(cuantascom+1);
x2=[x,fliplr(x)];
q1=mean(shuffle(:,ind_tam))+std(shuffle(:,ind_tam));
q3=mean(shuffle(:,ind_tam))-std(shuffle(:,ind_tam));
q1=[q1(1) q1 q1(end)];
q3=[q3(1) q3 q3(end)];
q=[q1,fliplr(q3)];
h=fill(x2,q,[.7 .7 .7]);
h.EdgeColor='none';
x=1:cuantascom;
y=promedio(ind_tam);
hold on
yyaxis left
scatter(x,y,10,'k','filled')

elegidas_rango=find(ismember(ind_tam,elegidastrend));
scatter(x(elegidas_rango),y(elegidas_rango),30,'r') 

xlim([0 cuantascom+1])
ylim([0.08 0.4])
xlabel('Rank')
ylabel('Semantic similarity')
title(strcat('Trend clusters'))
xticks([10 20 30 40 50 60 70 80 90 100 110])
yyaxis right
plot(1:cuantascom,tamanio(ind_tam),'.-')
set(gca,'YScale','log')
ylh = ylabel('Community Size');
set(ylh,'rotation',-90,'VerticalAlignment','middle')
yticks(10:30:250)
yticks([1 2 5 10 20 50 100 200 500 1000])
ylim([5 max(tamanio)])

load DataOscSSA
set(gcf,'currentaxes',handles(1))
[~, ind_tam]=sort(tamanio,'descend');

x=0:(cuantascom+1);
x2=[x,fliplr(x)];
q1=mean(shuffle(:,ind_tam))+std(shuffle(:,ind_tam));
q3=mean(shuffle(:,ind_tam))-std(shuffle(:,ind_tam));
q1=[q1(1) q1 q1(end)];
q3=[q3(1) q3 q3(end)];
q=[q1,fliplr(q3)];
h=fill(x2,q,[.7 .7 .7]);
h.EdgeColor='none';
hold on
yyaxis left
x=1:cuantascom;
y=promedio(ind_tam);

scatter(x,y,10,'k','filled')

elegidas_rango=find(ismember(ind_tam,elegidasosc));
scatter(x(elegidas_rango),y(elegidas_rango),30,'r')

xticks([10 20 30 40 50 60 70 80 90])
xlim([0 cuantascom+1])
ylim([0.08 0.4])
ylabel('Semantic similarity')
title(strcat('Oscillation Clusters'))
yyaxis right
plot(1:cuantascom,tamanio(ind_tam),'.-')
set(gca,'YScale','log')
ylh = ylabel('Community Size');
set(ylh,'rotation',-90,'VerticalAlignment','middle')
yticks(10:30:250)
yticks([1 2 5 10 20 50 100 200 500 1000])
ylim([5 250])

% %%%%%%%%%%%%%%%%%%%% FIGURA 2 clusters trend
load clusters_trend
load('stat_true','S')
load F_TIMELINE_con_trend
DATA=reshape([F_TIMELINE.smoothed],309,length(F_TIMELINE))';
TREND=reshape([F_TIMELINE.trend],309,length(F_TIMELINE))';
OSC=DATA-TREND;
yearsincro=[S.yearsincro];

ind_sinc=find(~isnan(yearsincro));

Ncom=zeros(1,length(ind_sinc));
max_par=zeros(1,length(ind_sinc));
mean_par=zeros(1,length(ind_sinc));
max_phase=zeros(1,length(ind_sinc));

elegidas=elegidastrend;
paneles=[[6 7 8];[12  13 14]];

for indcomunidad=1:length(elegidas)

    comunidad=elegidas(indcomunidad); 

    index=find(T==megustan(comunidad));
    [ParOrden,ang] = fp_nouns.calcula_parametro_orden(index,F_TIMELINE,desde,hasta,OSC);
    Nyears=length(desde:hasta);    
    Nwords=length(index);        
    ZZ=OSC(index,desde:hasta)';    

    [maxpico,indmaxpico]=max(ParOrden);    
    angmax=ang(indmaxpico);
    yearmax=indmaxpico+desde-1;    
    
    palabras={F_TIMELINE(index).word};
    PAL=struct('palabra',palabras,'count',num2cell([F_TIMELINE(index).tot]));
    if indcomunidad==1
        wordcloud({PAL.palabra},[PAL.count],'position',[.46 .37 .16 .1]);                
    elseif indcomunidad==2
        wordcloud({PAL.palabra},[PAL.count],'position',[.75 .34 .16 .1]);                        
    end    
       
    Ncom(indcomunidad)=length(index);
    max_par(indcomunidad)=max(ParOrden);
    mean_par(indcomunidad)=mean(ParOrden);
    max_phase(indcomunidad)=angmax;
    
    set(gcf,'currentaxes',handles(paneles(indcomunidad,1)));
    for i=1:length(index)
        yplot=TREND(index((i)),desde:hasta);
        yplot=yplot/max(yplot);
        plot(F_TIMELINE(1).years(desde:hasta),yplot); hold on; 
    end 
    box off
    set(gca,'xcolor','none')
    set(gca,'ytick',[])
    if indcomunidad==1
        ylabel('Trends')
    end
    ylim([0 1])    
    line(F_TIMELINE(1).years([ yearmax yearmax]),ylim,'linestyle','--','color',[.5 .5 .5])
    yticks([0 1])
    set(gca,'ytick',[])
    set(gca,'xtick',[])
    
    set(gcf,'currentaxes',handles(paneles(indcomunidad,2)));
    hold all   
    hh=line(F_TIMELINE(1).years([desde hasta]),[0 0],'color','k','linewidth',1);
    nomuestraenlegend(hh);
    for i=1:Nwords
        plot(F_TIMELINE(1).years(desde:hasta),ZZ(:,i)/max(abs(ZZ(:,i)))); hold on;
    end        
    box off
    set(gca,'xcolor','none')
    ylim([-1 1])
    line(F_TIMELINE(1).years([ yearmax yearmax]),ylim,'linestyle','--','color',[.5 .5 .5])
    if indcomunidad==1
        ylabel('Oscilations')
    end    
    yticks([0])
    set(gca,'ytick',[])
    set(gca,'xtick',[])    

    set(gcf,'currentaxes',handles(paneles(indcomunidad,3)));
    plot(F_TIMELINE(1).years(desde:hasta),smooth(ParOrden,4),'k');hold on;
    plot(F_TIMELINE(1).years(desde:hasta),max(ParOrden)*ones(1,Nyears),'r--'); hold on;
    plot(F_TIMELINE(1).years(desde:hasta),mean(ParOrden)*ones(1,Nyears),'b--');
    ylim([0 1])
    box off    
    xlabel('Year')
    if indcomunidad==1
        ylabel('Coherence \rho')
    else
        set(gca,'yticklabel',[])
    end
    ylim([0 1])
    yticks([0 1])
    line(F_TIMELINE(1).years([ yearmax yearmax]),ylim,'linestyle','--','color',[.5 .5 .5])
    
    linkaxes(handles(paneles(indcomunidad,:)),'x')
    
    xlim([1750 1999])    
end

% %%%%%%%%%%%%%%%%%%%%%%%% FIGURA 2 CLUSTERS OSC
load clusters_osc
load('stat_true','S')
load F_TIMELINE_con_trend
elegida=7; 
DATA=reshape([F_TIMELINE.smoothed],309,length(F_TIMELINE))';
TREND=reshape([F_TIMELINE.trend],309,length(F_TIMELINE))';
OSC=DATA-TREND;
yearsincro=[S.yearsincro];

ind_sinc=find(~isnan(yearsincro));

Ncom=zeros(1,length(ind_sinc));
max_par=zeros(1,length(ind_sinc));
mean_par=zeros(1,length(ind_sinc));
max_phase=zeros(1,length(ind_sinc));

elegidas=elegidasosc;
paneles=[[3 4 5];[9 10 11]];

for indcomunidad=1:length(elegidas)
    comunidad=elegidas(indcomunidad); 
  
    index=find(T==megustan(comunidad));
    [ParOrden,ang] = fp_nouns.calcula_parametro_orden(index,F_TIMELINE,desde,hasta,OSC);
    Nyears=length(desde:hasta);    
    Nwords=length(index);        
    ZZ=OSC(index,desde:hasta)';    

    [maxpico,indmaxpico]=max(ParOrden);    
    angmax=ang(indmaxpico);
    yearmax=indmaxpico+desde-1;    
    
    palabras={F_TIMELINE(index).word};
    PAL=struct('palabra',palabras,'count',num2cell([F_TIMELINE(index).tot]));    
    PAL=struct('palabra',palabras,'count',num2cell([F_TIMELINE(index).tot]));
    if indcomunidad==1
        wordcloud({PAL.palabra},[PAL.count],'position',[.47 .82 .16 .1]);                
    elseif indcomunidad==2
        wordcloud({PAL.palabra},[PAL.count],'position',[.77 .82 .16 .1]);                        
    end  
        
    Ncom(indcomunidad)=length(index);
    max_par(indcomunidad)=max(ParOrden);
    mean_par(indcomunidad)=mean(ParOrden);
    max_phase(indcomunidad)=angmax;
    
    set(gcf,'currentaxes',handles(paneles(indcomunidad,1)));
    for i=1:length(index)
        yplot=TREND(index((i)),desde:hasta);
        yplot=yplot/max(yplot);
        plot(F_TIMELINE(1).years(desde:hasta),yplot); hold on;       % data
    end 
    box off
    set(gca,'xcolor','none')
    set(gca,'ytick',[])
    if indcomunidad==1
        ylabel('Trends')
    end
    ylim([-.5 1])
    yticks([0 1])
    set(gca,'ytick',[])
    set(gca,'xtick',[])

    set(gcf,'currentaxes',handles(paneles(indcomunidad,2)));
    hold all   
    for i=1:Nwords
        plot(F_TIMELINE(1).years(desde:hasta),ZZ(:,i)/max(abs(ZZ(:,i)))); hold on;
    end        
    box off
    set(gca,'xcolor','none')
    ylim([-1 1])
    if indcomunidad==1
        ylabel('Oscilations')
    end
    yticks([0])
    set(gca,'ytick',[])
    set(gca,'xtick',[])

    set(gcf,'currentaxes',handles(paneles(indcomunidad,3)));
    plot(F_TIMELINE(1).years(desde:hasta),smooth(ParOrden,4),'k');hold on;
    ylim([0 1])
    box off
    xlabel('Year')
    if indcomunidad==1
        ylabel('Coherence \rho')
    else
        set(gca,'yticklabel',[])
    end
    ylim([0 1])
    yticks([0 1])
    linkaxes(handles(paneles(indcomunidad,:)),'x')
    xlim([1750 1999])
end

% letters
AxesH = axes('Parent', gcf, ...
  'Units', 'normalized', ...
  'Position', [0, 0, 1, 1], ...
  'Visible', 'off', ...
  'XLim', [0, 1], ...
  'YLim', [0, 1], ...
  'NextPlot', 'add');
letras='adb  e  c  f'    ;
for indp=1:12
    pos=get(handles(indp),'position');
    posx=pos(1)+.01;
    posy=pos(2)+pos(4)+.02;
    text(posx,posy,letras(indp),'fontsize',20)
end
for i=1:14
    set(handles(i),'color','none')
end
children=get(gcf,'children');
set(gcf,'Children', children(end:-1:1));

%% Figure 3
clear all

figure(3);clf
set(gcf,'color','w')

x0=30;
y0=200;
width=1100;
height=400;
set(gcf,'position',[x0,y0,width,height])

bordeizq = 0.05;
ancho1 = .4; 
ancho2 = .2;
ancho3 = .22;
seph1 = .04; 
seph2 = .06; 
bordeinf = .12;
alto1 =.82;
alto2 =alto1 /2;


clear handles
handles(1)=axes('position',[bordeizq              bordeinf ancho1 alto1]);
handles(2)=axes('position',[bordeizq+ancho1+seph1 bordeinf+alto2 ancho2 alto2]);
handles(3)=axes('position',[bordeizq+ancho1+seph1 bordeinf ancho2 alto2]);
handles(4)=axes('position',[bordeizq+ancho1+seph1+ancho2+seph2 bordeinf ancho3 alto1]);


% %%%%%%%%%%%% FIGURA 3 pendientes
load Datos_Fig2_Pendientes

set(gcf,'currentaxes',handles(4))
lightblue = [0.4 0.4 1];

colores=get(gca,'colormap');
orange=colores(55,:);
violet=colores(1,:);

hold on
loglog(mediasmax,desviosmax,'.','color',orange)
loglog(mediasmin,desviosmin,'.','color',violet)
loglog(mediasexp,desviosexp,'.','Color','k')
xlim([1e-8 1e-2])
ylim([1e-10 1e-2])
set(gca,'xscale','log')
set(gca,'yscale','log')

line(xlim,10.^polyval(pmax,log10(xlim)),'Color',orange)
line(xlim,10.^polyval(pmin,log10(xlim)),'Color',violet)
line(xlim,10.^polyval(pexp,log10(xlim)),'Color','k')
xlabel('Mean trend')
ylabel('Mean oscillation amplitude')

% %%%%%%%%%%%%%%%%% FIGURA 3 graficar los ajustes
load AjustesIndividuales
load F_TIMELINE_con_trend
F_TIMELINE(1610)=[]; %elimino la palabra porque el integrador no converge

DATA=reshape([F_TIMELINE.smoothed],309,length(F_TIMELINE))';
TREND=reshape([F_TIMELINE.trend],309,length(F_TIMELINE))';
OSC=DATA-TREND;

indicesusar=50:300;

pal1=3997;
pal2=2926;
set(gcf,'currentaxes',handles(2))
ind=pal1;
plot(indicesusar+1700,DATA(ind,indicesusar),'k')
hold on
plot(indicesusar+1700,soluciones(ind).SumaCODT,'r')
ylabel('Relative Frequency')
text(1870,7e-5,F_TIMELINE(ind).word)
set(gca,'xticklabel',[])
xlim([1750 2000])

set(gcf,'currentaxes',handles(3))
ind=pal2;
plot(indicesusar+1700,DATA(ind,indicesusar),'k')
hold on
plot(indicesusar+1700,soluciones(ind).SumaCODT,'r')
ylabel('Relative Frequency')
xlabel('Years')
text(1870,2.7e-4,F_TIMELINE(ind).word)
ylim([min(ylim) 3e-4])
xlim([1750 2000])
h=legend({'Experimental','Model'},'Position',[0.6 0.2 0.01 0.02]);
h.EdgeColor='none';
set(h,'color','none')

% %%%%%%%%%%%%%%%%%%%%% FIGURA 3 curvas de nivel
load datos_para_fig2
rrange=[min(rs(:)) max(rs(:))];
taurange=[min(2./alphas(:)),max(2./alphas(:))];
set(gcf,'currentaxes',handles(1));
hold all
pendientes=reshape([R.pendiente],[size(alphas,1) size(alphas,2)]);
[C,h] =contourf(rs,2./alphas,pendientes,8);
set(h,'LineColor','none')
colorbar

ylabel('\tau (years)')
xlabel('r (years^{-1})')
xx=.1:.01:2;
plot(xx,4./xx,'k','linewidth',4)
plot(xx,8./(27*xx),'k','linewidth',4)
xlim([.2 1.01])
ylim([1.01 11.99])

cota=2;
indice=[Razon.corrosc]>1/cota & [Razon.corrosc]<cota & ...
       [Razon.disttotal]>1/cota & [Razon.disttotal]<cota;
x=rsajustes([posmaximos.SumaCODT]);
y=tausajustes([posmaximos.SumaCODT]);
scatter(x(indice),y(indice), 5,'o', 'MarkerFaceColor', 'r','markeredgecolor','r')
scatter(x(pal1),y(pal1), 40, 'k')
scatter(x(pal2),y(pal2), 40, 'k')

imagedir='./imagenes/';
%AMORTIGUADO
axes('position',[.13 .25 .09 .19]);
I=importdata([imagedir 'Imagen1.png']);
h=image(I.cdata);
set(gca,'xcolor','none','ycolor','none','color','none')
set(h, 'AlphaData', I.alpha);

%HOPF
axes('position',[.25 .7 .09 .19]);
I=importdata([imagedir 'Imagen3.png']);
h=image(I.cdata);
set(gca,'xcolor','none','ycolor','none','color','none')
set(h, 'AlphaData', I.alpha);

%REALES
axes('position',[.005 .01 .09 .19]);
I=importdata([imagedir 'Imagen2.png']);
h=image(I.cdata);
set(gca,'xcolor','none','ycolor','none','color','none')
set(h, 'AlphaData', I.alpha);

colormap('default')

% letters
AxesH = axes('Parent', gcf, ...
  'Units', 'normalized', ...
  'Position', [0, 0, 1, 1], ...
  'Visible', 'off', ...
  'XLim', [0, 1], ...
  'YLim', [0, 1], ...
  'NextPlot', 'add');
letras='abcd'    ;
for indp=1:4
    pos=get(handles(indp),'position');
    posx=pos(1)+.01;
    posy=pos(2)+pos(4)-.04;
    text(posx,posy,letras(indp),'fontsize',20)
end

%% Figure 4
clear all

figure(4);clf
set(gcf,'position',[174         292        1402         600])
set(gcf,'color','w')

bordeizq = 0.05;
ancho1 = .15; 
seph = .04; 
ancho2 = 2* ancho1;
ancho3 =.22;
bordeinf1 = .08;
bordeinf2 = .25;
alto1 =.4;
alto2 =.6;
sepv =.07;

clear handles
handles(1)=axes('position',[bordeizq bordeinf2 ancho3 alto2]);
handles(2)=axes('position',[bordeizq+ancho3+seph bordeinf1+alto1+sepv ancho1 alto1]);
handles(3)=axes('position',[bordeizq+ancho3+seph+ancho1+seph bordeinf1+alto1+sepv ancho1 alto1]);
handles(4)=axes('position',[bordeizq+ancho3+seph+2*ancho1+2*seph bordeinf1+alto1+sepv ancho2 alto1]);
handles(5)=axes('position',[bordeizq+ancho3+seph bordeinf1 ancho1 alto1]);
handles(6)=axes('position',[bordeizq+ancho3+seph+ancho1+seph bordeinf1 ancho1 alto1]);
handles(7)=axes('position',[bordeizq+ancho3+seph+2*ancho1+2*seph bordeinf1 ancho2 alto1]);

load data_para_figura_4

x=0:0.005:.3;
mmean=zeros(length(MS),length(x));
mmax=zeros(length(MS),length(x));
for indf=1:length(MS)
    indini=min([MS(indf).amplitud])/0.005;
    mmean(indf,indini+(1:length(MS(indf).amplitud)))=[MS(indf).pmean];
    mmax(indf,indini+(1:length(MS(indf).amplitud)))=[MS(indf).pmax];
end
y=[MS.dur];

mM=mmax; mm=mmean;
mM(mM>0.05)=1; mM(mM<0.05)=0;
mm(mm>0.05)=1; mm(mm<0.05)=0;

mediatrendreset=mmean(find((mm+mM)==2));
maxitrendreset=mmax(find((mm+mM)==2));

load stat_true
mediasreal=meantrue;
maxireal=maxtrue;

load stat_sin_trend
mediasintrend=[C.mean_par];
maxisintrend=[C.max_par];

load stat_con_trend
mediacontrend=[C.mean_par];
maxicontrend=[C.max_par];

load stat_simulaciones_dur2
mediatrendreset=[CS{21}.mean_par];
maxitrendreset=[CS{21}.max_par];

load stat_shuffle_contrend
mediashuffle=[C.mean_par];
maxishuffle=[C.max_par];

grupos1=[0*ones(size(mediasreal)) 1*ones(size(mediasreal)) 2*ones(size(mediasreal)) 3*ones(size(mediasreal)) 4*ones(size(mediasreal))];
datos1=[mediasreal' mediashuffle' mediasintrend' mediacontrend' mediatrendreset'];
datos2=[maxireal' maxishuffle' maxisintrend' maxicontrend' maxitrendreset'];

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Panel A
set(gcf,'currentaxes',handles(1))
hold all

medias=[mean(mediasreal) nanmean(mediashuffle) mean(mediasintrend) mean(mediacontrend) mean(mediatrendreset)];
err=[sem(mediasreal) nansem(mediashuffle') sem(mediasintrend) sem(mediacontrend) sem(mediatrendreset)];
sd=[std(mediasreal) nanstd(mediashuffle) std(mediasintrend) std(mediacontrend) std(mediatrendreset)];
errorbar((1:5),medias,err,'b','linestyle','none','linewidth',3,'capsize',0)

medias=[mean(maxireal) nanmean(maxishuffle) mean(maxisintrend) mean(maxicontrend) mean(maxitrendreset)];
err=[sem(maxireal) nansem(maxishuffle') sem(maxisintrend) sem(maxicontrend) sem(maxitrendreset)];
errorbar((1:5),medias,err,'r','linestyle','none','linewidth',3,'capsize',0)
ylabel('Coherence \rho')
xlim([.5 5.5])
ylim([.2 .95])

hhh=plot([1 1 5 5],[.79 .85 .85 .79],'color',[.5 .5 .5]);
nomuestraenlegend(hhh)
xpos=[min(xlim) 2.5] ;
ypos=ylim;
x = xpos([1 2 2 1 1]);
y = ypos([1 1 2 2 1]);
p=patch(x,y,'k');
set(p,'FaceAlpha',0.1,'linestyle','none');

xpos = [1:5];
row1 = {'Exp' '   Exp' '    Sim' '  Sim' '       Sim' };
row2 = {'' 'Shuffled' 'no trend' 'trend' 'trend reset' };
labelArray = [row1; row2]; 
tickLabels = (sprintf('%s\\newline%s\n', labelArray{:}));
set(gca,'xtick',xpos,'xticklabel',tickLabels )
set(gca, 'YGrid', 'on', 'XGrid', 'off','ytick',[.2 .4 .6 .8 ])
box on

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Panel E
load TrendPendienteFase
set(gcf,'currentaxes',handles(5))

hhh=histogram(pendiente,16);
line([0 0],ylim,'linestyle','--','color',[.5 .5 .5])
hhh.EdgeColor='none';
xlabel('Trend slope at peak [1/year]')
ylabel('Counts')
ylim([0 max(hhh.Values)+10])
xlim([-.02 .02])
set(handles(5),'color',[.9 .9 .9])

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Panel F
set(gcf,'currentaxes',handles(6))

xs=linspace(-pi,pi,10);
h=histogram(phaselock,xs);
line([0 0],ylim,'linestyle','--','color',[.5 .5 .5])

h.EdgeColor='none';
xticks([-pi -pi/2 0 pi/2 pi])
xticklabels({'-\pi','-\pi/2','0','\pi/2','\pi'})
xlim([-pi pi])
ylim([0 max(h.Values)+1])
xlabel('\psi at peak')
ylabel('Counts')
set(handles(6),'color',[.9 .9 .9])

N=180;        
tmax=150;    

K=600;
rmean=0.6;
rdev=0.07;
alphamean=0.3;
alphadev=0.05;
time_perturbation=112;

rs = rdev.*randn(N,1) +  rmean;
alphas = alphadev.*randn(N,1) + rs/2;

points=[rs(:) alphas(:)];
[theta,rho] = cart2pol(rs(:),alphas(:)); 
good=find(tan(abs(theta))<0.58 & tan(abs(theta))>0.49);
points=points(good,:);  
sizecomm=length(good);

t0=0:0.05:tmax; 
opts = odeset('RelTol',1e-10,'AbsTol',1e-10);

zz=zeros(length(t0));  
comp=zeros(sizecomm,length(t0));
phaseexp=nan(size(comp));

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Panel B
set(gcf,'currentaxes',handles(2))
hold on;
for indpunto=1:size(points,1)
    plot(points(indpunto,1),2./points(indpunto,2),'o','MarkerSize',4,'markerfacecolor','k'); 
end
x= linspace(0,1,100); 
y= 4./x; 
plot(x,y,'lineWidth',1,'Color','k');hold on;
xlim([0.4 .8]);
ylim([4 10]);
xlabel('r (years^{-1})');
ylabel('\tau (years)');
box on

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Panel C
set(gcf,'currentaxes',handles(3));cla

hold all
x=0:0.005:.3;
mmean=zeros(length(MS),length(x));
mmax=zeros(length(MS),length(x));
for indf=1:length(MS)
    indini=min([MS(indf).amplitud])/0.005;
    mmean(indf,indini+(1:length(MS(indf).amplitud)))=[MS(indf).pmean];
    mmax(indf,indini+(1:length(MS(indf).amplitud)))=[MS(indf).pmax];
end
y=[MS.dur];

mM=mmax; mm=mmean;
mM(mM>0.05)=1; mM(mM<0.05)=0;
mm(mm>0.05)=1; mm(mm<0.05)=0;

imagesc(x,1:length(y),mm+mM)
set(gca, 'Layer', 'top')
caxis([1 2])
xlim([0.05 0.25])
ylim([.5 7.5])
xlabel('Relative kick amplitude')  
ylabel('kick duration (years)')
axis xy
plot(.15,2,'w*')

colorList = get(gca,'ColorOrder');
histColor = colorList(1,:);
color=[0 .447 .741]*.6+[1 1 1]*.4;
colormap([[1 1 1];color])
    
box on

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Panel D
set(gcf,'currentaxes',handles(4))
hold on;
for ind=1:sizecomm
    ci=K+400*([rand();rand();rand()]-.5); 
    r=points(ind,1);
    alpha=points(ind,2);

      sk=@(t,y,K,alpha,r) [r*y(1)*(1-y(3)/(K*(1-0.15*exp(-(t-time_perturbation)^2/10)))); ...
                         alpha*(y(1)-y(2)); ...
                         alpha*(y(2)-y(3))];

    [t,y] = ode45(@(t,y) sk(t,y,K,alpha,r),[0 tmax],ci,opts);
  
    y0 = interp1(t,y(:,1),t0);
    y1 = interp1(t,y(:,2),t0);
    y2 = interp1(t,y(:,3),t0);
        
    times=ones(1,length(y0));

    y0norm=y0-mean(y0);    
    phaseexp(ind,:)=angle(hilbert(y0norm));
  
    plot(t0,y0,'lineWidth',1);
end
xlim([0 tmax])
ylim([0 2*K])
ylabel('Simulated');
set(gca,'Yticklabel',[])
line(time_perturbation*[1 1],ylim,'linestyle','--','color',[.5 .5 .5])
box on

paramorden=sqrt((sum(sin(phaseexp)).^2+sum(cos(phaseexp)).^2))/sizecomm;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Panel g
set(gcf,'currentaxes',handles(7))

load clusters_trend
load('stat_true','S')
load F_TIMELINE_con_trend

DATA=reshape([F_TIMELINE.smoothed],309,length(F_TIMELINE))';
TREND=reshape([F_TIMELINE.trend],309,length(F_TIMELINE))';
OSC=DATA-TREND;
yearsincro=[S.yearsincro];

ind_sinc=find(~isnan(yearsincro));
year_sinc=yearsincro(ind_sinc)+1700;

Ncom=zeros(1,length(ind_sinc));
max_par=zeros(1,length(ind_sinc));
mean_par=zeros(1,length(ind_sinc));
max_phase=zeros(1,length(ind_sinc));


comunidad=103; 
indcomunidad=comunidad;

index=find(T==megustan(comunidad));
[ParOrden,ang] = fp_nouns.calcula_parametro_orden(index,F_TIMELINE,desde,hasta,OSC);
Nyears=length(desde:hasta);
Nwords=length(index);
ZZ=OSC(index,desde:hasta)';

[maxpico,indmaxpico]=max(ParOrden);
angmax=ang(indmaxpico);
yearmax=indmaxpico+desde-1;

palabras={F_TIMELINE(index).word};
Ncom(indcomunidad)=length(index);
max_par(indcomunidad)=max(ParOrden);
mean_par(indcomunidad)=mean(ParOrden);
max_phase(indcomunidad)=angmax;


desde=40;
hasta=290;

hh=line(F_TIMELINE(1).years([desde hasta]),[0 0],'color','k','linewidth',1);
nomuestraenlegend(hh);
for i=1:Nwords
    plot(F_TIMELINE(1).years(desde:hasta),ZZ(:,i)/max(abs(ZZ(:,i)))); hold on;
end
ylim([-1.1 1.1])
set(gca,'Yticklabel',[])
xlim([1800 1950])
line(F_TIMELINE(1).years([ yearmax yearmax]),ylim,'linestyle','--','color',[.5 .5 .5])
ylabel('Experimental')
set(handles(7),'color',[.9 .9 .9])


% letters
AxesH = axes('Parent', gcf, ...
  'Units', 'normalized', ...
  'Position', [0, 0, 1, 1], ...
  'Visible', 'off', ...
  'XLim', [0, 1], ...
  'YLim', [0, 1], ...
  'NextPlot', 'add');
letras='abcdefg'    ;
for indp=1:7
    pos=get(handles(indp),'position');
    posx=pos(1)+.01;
    posy=pos(2)+pos(4)-.025;
    text(posx,posy,letras(indp),'fontsize',20)
end
    
    