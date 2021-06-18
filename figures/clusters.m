%% armar clusters
clear all; 

load F_TIMELINE_con_trend

minword=7;
maxword=3400;
desde=40;
hasta=290; 

DATA=reshape([F_TIMELINE.smoothed],length(F_TIMELINE(1).years),length(F_TIMELINE))';
TREND=reshape([F_TIMELINE.trend],length(F_TIMELINE(1).years),length(F_TIMELINE))';
OSC=DATA-TREND;

DATAshort=DATA(:,desde:hasta);
OSCshort=OSC(:,desde:hasta);
TRENDshort=TREND(:,desde:hasta);

%armar clusters osc
cutoff=0.5;         
PD= pdist(OSCshort,'correlation');
Z= linkage(PD,'average');
T=cluster(Z,'Cutoff',cutoff,'Criterion','distance');

for ind=1:max(T)
    size_com(ind)=length(find(T==ind));
end
    
megustan=find(size_com>minword & size_com<maxword); 

save clusters_osc T megustan F_TIMELINE desde hasta

%armar clusters trend
cutoff=0.045;         
PD= pdist(TRENDshort,'correlation');
Z= linkage(PD,'average');
T=cluster(Z,'Cutoff',cutoff,'Criterion','distance');

for ind=1:max(T)
    size_com(ind)=length(find(T==ind));
end
    
megustan=find(size_com>minword & size_com<maxword); 

save clusters_trend T megustan F_TIMELINE desde hasta

%% analizar clusters
clear all; 

load clusters_trend
% load clusters_osc

maxrhos= 0.6; 
meanrho= 0.4 ;

DATA=reshape([F_TIMELINE.smoothed],309,length(F_TIMELINE))';
TREND=reshape([F_TIMELINE.trend],309,length(F_TIMELINE))';
OSC=DATA-TREND;

dim=zeros(1,length(megustan));
for ind=1:length(megustan)
    a=find(T==megustan(ind));
    dim(ind)=length(a); 
end
[dimsort,sorted]=sort(dim,'descend');


phaselock=nan(size(megustan));
meantrue=mediaParOrden(sorted);
maxtrue=maxParOrden(sorted);

S=struct([]);
for indc=1:length(megustan)

    index=find(T==megustan(indc));
    [ParOrden,ang] = fp_nouns.calcula_parametro_orden(index,F_TIMELINE,desde,hasta,OSC);
    Nyears=length(desde:hasta); 
    
    condicion=maxrho;
    [maxpico,indmaxpico]=max(ParOrden);
    
    if (maxpico>condicion && mean(ParOrden)<meanrho) 
        phaselock(indc)=ang(indmaxpico);
        yearsincro(indc)=indmaxpico;
    end

    mediaParOrden(indc)=mean(ParOrden);
    devParOrden(indc)=std(ParOrden);
    maxParOrden(indc)=max(ParOrden);

    S(indc).index=index;
    S(indc).comsize=length(index);
    S(indc).mediaParOrden=mean(ParOrden);
    S(indc).devParOrden=std(ParOrden);
    S(indc).maxParOrden=max(ParOrden);  
    S(indc).phaselock=phaselock(indc);
    S(indc).yearsincro=yearsincro(indc);    
end
sum(~isnan([S.phaselock]))

ind_sinc=find(~isnan(yearsincro));
year_sinc=yearsincro(ind_sinc)+1750;


pendiente=[];

for indcomunidad=1:length(ind_sinc)
    comunidad=ind_sinc(indcomunidad);
            
    index=find(T==megustan(comunidad));
    [ParOrden,ang] = fp_nouns.calcula_parametro_orden(index,F_TIMELINE,desde,hasta,OSC);
    
    [~,indmaxpico]=max(ParOrden);
    
    for indpal=1:length(index)
        
        mytrend=TREND(index(indpal),desde:hasta);
        mytrend=mytrend/max(mytrend);
        der=diff(mytrend);
        if indmaxpico==length(mytrend)
            pendiente(end+1)=der(indmaxpico-1);
        else
            pendiente(end+1)=der(indmaxpico);
        end
    end
end


save stat_true meantrue maxtrue dimsort S;  

save('TrendPendienteFase','phaselock','pendiente')
