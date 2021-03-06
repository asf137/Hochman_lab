% Function takes a vertical array of strings with various filenames
% Use strvcat to add filenames in string array definition

function [IV]=compareiv(files)

[R,C]=size(files);
IV=struct('voltage',{},'avg',{},'peak',{});
holding=-80; %holding potential, in mV

for i=1:C
    name=files{i};
    
    file=readabf(name);
    time=file.data.time;
    Im= file.data.v_clamp./10;

    [voltage,avg,peak,end_time,base_start,base_end,Im_base]=vclamp(name,holding,0);
%     figure(10);  plot(voltage,avg,'*-'); hold all
%     figure(20); plot(voltage,peak,'*-'); hold all
    IV(i).avg=avg;
    IV(i).peak=peak;
    IV(i).voltage=voltage;
       
%     subplot(2,1,2); plot(voltage,peak,'.'); hold all
% figure(100*i); plot(time,Im); title(name); xlabel('Time (ms)'),ylabel('Im(pA)');
   
end

% figure(10);legend(files); title('Steady State Current')
% xlabel('Vm (mV)')
% ylabel('Current (pA)')
% figure(20); title('Peak Inward Current'); xlabel('Vm (mV)'); ylabel('Current (pA)'); legend(files)



end