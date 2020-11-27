clear all;
close all;

tic
%% CHOOSE/CHANGE HERE ONLY
AOLR=analogoutput('nidaq','PXI1Slot2'); %Put 3, data = 1, Put 2, data =0;
data = 0; %0 1

%% DO NOT CHANGE HERE!
out_AO=daqhwinfo(AOLR);
set(AOLR, 'SampleRate', 44100);
addchannel(AOLR,0:30);
% condition = 99;
%%
 dio = digitalio('nidaq', 'PXI1Slot3');
 addline (dio, 0:7, 'out');
 %data = 0;
 putvalue(dio.Line(1),data);
 value = getvalue(dio);

%AnalogLeftRight
out_ranges=get(AOLR.Channel,'OutputRange');
setverify(AOLR.Channel,'OutputRange', [-5 5]);
setverify(AOLR.Channel,'UnitsRange', [-5 5]);
set(AOLR,'TriggerType', 'Manual');
%

%% SOUND FILES
addpath(genpath(pwd)); %'E:\MEGAQuaTRON'
files_sound = {};
array_sound={};

files_sound = 'pn_150ms_5msfadeinout.wav';
[array_sound{1}, Fs] = audioread(files_sound);

% array_speaker = [1,2,8,16,17,23,31]; with middle sounds included (2 & 8)
% array_speaker = [1,2,16,17,31]; %old version
% update 03/05/2018
% 31 is the center, but the numbers go 1:15 31 and 16:30
% array_speaker = [1,2,14,15,17,29,30,31]; new conversion
array_speaker = [29,29,30,30,28,28,30,30]; % CB edited 3.10.2019
% CB edited 06.06.2019
%array_speaker = [1:15];

totspeaker = 31;
amp = 1; %the intensity of sound
gap_init = 0.25; %sec
AOLR.SampleRate = 44100;
gap_init = gap_init * AOLR.SampleRate;

nburst = 19;

chosen_sound = ones(1,length(array_speaker));
seq_CH = [array_speaker;chosen_sound]; %preallocate with burst sound

%%
wav_length=0;
for ch=1:size(seq_CH,2)
    wav_length= length(array_sound{seq_CH(2,ch)});
end

data=[];
data= zeros(wav_length,totspeaker);
iniz=0;
fin=0;

%%
for j = 1:length(array_speaker)

    ch = array_speaker(j);
    % if ch == 31
        nloop = 1;
        chosen_sound(j) = 1;
    %
    % elseif ch == 1 || ch == 16
    %     nloop = 1;
    %     chosen_sound(j) = 2;
    % else
    %     nloop = nburst;
    % end

    for aa = 1:nloop
        iniz= fin+1;
        %seq_CH(2,ch) = chosen_sound(j)
        %seq_CH(1,ch) = array_speaker(j)
        if aa == nloop
            gap = gap_init;
        else
            gap = 0.0;
        end
        fin=iniz+length(array_sound{chosen_sound(j)})-1+ gap;
        data(iniz:(fin-gap),array_speaker(j))=amp*array_sound{chosen_sound(j)};   %*2 looks like amplifier here
    end
end

figure;imagesc(data)
dur = size(data,1)/44100; %in sec
%% START
putdata(AOLR,data) % to queue the obj
% Start AO, issue a manual trigger, and wait for
% the device object to stop running.
start(AOLR)
%pause(1) %when to start exp
trigger(AOLR)
%stop(AO) terminates the execution

wait(AOLR, dur+1) %wait before doing anything else
toc
delete(dio)
clear dio

delete(AOLR)
clear AOLR
