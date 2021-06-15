classdef fp_nouns   
    methods (Static)        
        function [ParOrden,ang] = calcula_parametro_orden(index,F_TIMELINE,desde,hasta,OSC)


            Nyears=length(desde:hasta); %length(F_TIMELINE(1).years);
            Nwords=length(index); %length(word);


            %las fases de cada palabra en la comunidad
            tita=zeros(Nyears,Nwords);
            for wordnum=1:Nwords
                index2=index(wordnum);
                y=zeros(Nyears);
                y=OSC(index2,desde:hasta)';
                tita(:,wordnum)=angle(hilbert(y));
            end
            
            
            %módulo y fase total 
            ParOrden=zeros(1,Nyears);
            ang=zeros(1,Nyears);

            for i = 1:Nyears
                rhox = sum(sin(tita(i,:)));
                rhoy = sum(cos(tita(i,:)));
                [theta,rho]=cart2pol(rhox,rhoy);    
                ang(i)=theta;
                ParOrden(i)=rho/Nwords;             
            end
 
        end
        function [paramorden,cis] = integro_palabras_comunidad(C,F_TIMELINE,init,indc,contrend)
            t0=init.t0;
            tspan=init.tspan;
            years=init.years;
            desde=init.desde;
            hasta=init.hasta;
            
            Ncom=C(indc).n_palabras;
            
            opts = odeset('RelTol',1e-10,'AbsTol',1e-10);

            %zz=zeros(length(t0));
            comp=zeros(Ncom,length(t0));
            phaseexp=nan(size(comp));

            time_perturbation=C(indc).time_perturbation;
            dur_perturbation=C(indc).dur_perturbation;
            amplitude= C(indc).amplitude;    
        %     figure(indc);clf;hold all
            cis=[];
            for indp=1:Ncom

                r=C(indc).rs(indp);
                alpha=C(indc).alphas(indp);

                ind_palabra=C(indc).i_palabras(indp);
                
                if contrend==1
                    trend=1000*F_TIMELINE(ind_palabra).trend(desde:hasta);%trend real
                else
                    trend=600*ones(1,length(desde:hasta));%trend constante
                end

                trend(trend<0.0001)=0.0001;%pues si trend es negativo, nos trae problemas

                ci=trend(1) * (1+0.8*([rand();rand();rand()]-.5)); %esto da una amplitud razonable para K=500
                cis=[cis ci];                
                sk=@(t,y,trend,alpha,r,years) [r*y(1)*(1-y(3)/(interp1(years,trend,t)*(1-amplitude*exp(-(t-time_perturbation)^2/dur_perturbation)))); ...
                    alpha*(y(1)-y(2)); ...
                    alpha*(y(2)-y(3))];        

                [t,y] = ode45(@(t,y) sk(t,y,trend,alpha,r,years),tspan,ci,opts); %control de paso


                y0 = interp1(t,y(:,1),t0);
                %y1 = interp1(t,y(:,2),t0);
                %y2 = interp1(t,y(:,3),t0);

                y0=y0-interp1(years,trend,t0);%le resto 

                times=ones(1,length(y0));

                %calculo fases:
                y0norm=y0-mean(y0);
                phaseexp(indp,:)=angle(hilbert(y0norm));

%                 if any(isnan(angle(hilbert(y0norm))))
%                     fprintf(2,'\n\n\n   OOPS!!!!!!!!!!!!!!!! %d %d %d\n\n\n   ',indamp,indc,indp)
%                 end            

        %         plot(t0,y0,years,trend)
%                  fprintf('\b\b\b%3d',indp)
            end


            paramorden=sqrt((sum(sin(phaseexp)).^2+sum(cos(phaseexp)).^2))/Ncom; 
%             mean_par(indc)=mean(paramorden);
%             max_par(indc)=max(paramorden);
%             size_com(indc)=Ncom;            
        end
        
        function C=integro_comunidades(T,F_TIMELINE,init,amplitud,contrend)
            
            C=struct([]);
            for indc=1:max(T)
                index=find(T==indc);
                C(indc).n_palabras=length(index);
                C(indc).i_palabras=index;
                C(indc).time_perturbation=randi(init.tmax,1,1);
                C(indc).dur_perturbation=init.dur_perturbation;
                C(indc).amplitude= amplitud;      %amplitud de la patada
            end
            C=C([C.n_palabras]>7);
            [sorted,indsorted]=sort([C.n_palabras],'descend');
            C=C(indsorted);

            tic
            for indc=1:length(C)

                Ncom=C(indc).n_palabras;   %tamaño de la comunidad    
                    % distribución en el espacio de fases    
                alphas=nan(1,Ncom);
                rs=nan(1,Ncom);
                for indp=1:Ncom
                    good=0;
                    while good==0
                        r = init.rdev.*randn +  init.rmean;
                        alpha = init.alphadev.*randn + init.alphamean;            
                        [theta,rho] = cart2pol(r,alpha);                        
                        good=tan(abs(theta))<0.58 & tan(abs(theta))>0.49;
                    end
                    alphas(indp)=alpha;
                    rs(indp)=r;
                end

                C(indc).alphas=alphas;
                C(indc).rs=rs;

                [paramorden,cis]=fp_nouns.integro_palabras_comunidad(C,F_TIMELINE,init,indc,contrend);

                C(indc).cis=cis;
                %C(indc).phaseexp=phaseexp;
                C(indc).mean_par=mean(paramorden);
                C(indc).max_par=max(paramorden);

                porcentaje=100*sum([C(1:indc).n_palabras])/sum([C.n_palabras]);
                fprintf('\t%3d %3d %2.2f\t%2.1f%%\t%2.0fs/%2.0fs\n',indc,Ncom,mean(paramorden),porcentaje,toc,toc*100/porcentaje)
                drawnow
            end            
            
        end
    end
end