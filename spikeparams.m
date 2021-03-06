%function calculates spike properties from current clamp mode for 1 sweep,

function [amp,peak,dur,dur2,AHPdur,AHPmag,Vth,spikes2]=spikeparams(time,Vm,clampon,clampoff)

spikes=[];
spikes2=[];
amp=[];
peak=[];
dur=[];
dur2=[];
AHPdur=[];
AHPmag=[];
Vth=[];

ltemp=[];
first=[];
last=[];

%User defined variables
Fs=1/time(2);   %calculates sample frequency

[spikes2,Vth]=findspikes(time,Vm,Fs,clampon);

[~,Cth]=size(Vth);

for i=1:Cth
        ftemp=[];
        if ((i+1)<=length(spikes2))  % For repeated spiking, ignores end of train
            endpoint=spikes2(i+1);
        else
            endpoint=clampoff;    % For end of train or single spike
        end
        
        [Vmax,samplemax]=max(Vm(spikes2(i):(endpoint-1)));
        smax=spikes2(i)+samplemax;
        ftemp=find(Vm(smax:endpoint)<Vth(i),1);
        ftemp2=find(Vm(smax:endpoint)<((Vmax-Vth(i))./3+Vth(i)),1);
        ftemp3=find(Vm(spikes2(i):smax)>((Vmax-Vth(i))./3+Vth(i)),1);
                
        if (isempty(ftemp)~=1)
            dur(i)=(ftemp+samplemax)/Fs;  %defines duration as time spent over threshold
            if(isempty(ftemp2)~=1 && isempty(ftemp3)~=1)
                dur2(i)=(ftemp2+samplemax-ftemp3)/Fs;  %defines duration at 1/3 peak amplitude
            end
            
            [Vmin,samplemin]=min(Vm(smax:(endpoint-1)));
            if(isempty(samplemin)~=1)
                 AHPmag(i)=Vmin-Vth(i);
            else
                AHPmag(i)=NaN;
            end
            
            if(isempty(samplemax)~=1)
            amp(i)=Vmax-Vth(i);
            peak(i)=smax;
            else
                amp(i)=NaN; peak(i)=NaN;
            end
            % defines first and last sample when signal is below threshold for preceding spike
            AHP=find(Vm(smax:endpoint)<(0.1*AHPmag(i)+Vth(i)));   %finds time of AHP beneath 10% of AHPmag             
            
            if (AHP(end)==endpoint)
                AHPdur(i)=NaN;
                
            elseif (isempty(AHP)~=1)
                AHPdur(i)=(AHP(end)-AHP(1))./Fs;
            end
        end
     
end
    
      


   
end