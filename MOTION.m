clear all;
close all;

%%%%%% TEST TEST TEST TEST
%%%%%%%
%%%%%
%%%%

% START the AO
% Slot2 ao0-14 is left arm
% Slot2 ao15-30 is right arm (center speaker included here), ao30 is center
% Slot3 ao0-14 upper arm
% Slot3 ao15-29 below arm
% all 4 arms, the direction is approaching to the center
tic
%% CHOOSE/CHANGE HERE ONLY 
AOLR=analogoutput('nidaq','PXI1Slot2'); % Put Slot2 data =0; Put Slot3 data = 1,
data = 0; %0 1

%% DO NOT CHANGE HERE!
out_AO=daqhwinfo(AOLR);
set(AOLR, 'SampleRate', 44100);
addchannel(AOLR,0:30);
condition = 99;
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

%% SOUND FILES
addpath(genpath(pwd));
pathname = '/new_sounds';
files_sound = {};
array_sound={};

for i = 1:15 %31

        files_sound{i} = fullfile(pathname,strcat('pn1250ms_50ms_15spe_',sprintf('%d',i),'.wav')); %pn_10s_speak
        [array_sound{i}, ~] = audioread(files_sound{i});
     
end

totspeaker = 31;
amp = 1; %the intensity of sound, max 1
gap_init = 0.25; %in sec
AOLR.SampleRate = 44100;
gap_init = gap_init * AOLR.SampleRate;
%%
state = 1;
switch state
    case 1 %%% continuous direction but uses 15 speaker (skips 1out of 2)
       %option1 - OLD 03.11.2016
        %array_speaker = [1:2:15 29:-2:17 17:2:29 15:-2:1];
       %option2  
      % array_speaker = [1:2:15 30:-2:18 18:2:30 15:-2:1];
      %correct
        %array_speaker = [2:2:14 31 29:-2:17 17:2:29 31 14:-2:1];
        %test test
   % array_speaker = [2:2:14 31 17:2:29 29:-2:17 31 14:-2:1]
       array_speaker = [1:2:15, 16:2:30 28:-2:16 15:-2:3]
       %%%%array_speaker = [2:2:14 31 30:-2:18 18:2:30 15:-2:1];

            % array_speaker = [31 1 31 30 31 1 31 30 31 31 31 31 31 31 31 31 31 31 31 31      31 31 31 31 31 31 31 31 31 31 31];
            %array_speaker = [31 1 31 30 31 1 31 30 31 1 31 30 31 1 31 30 31 1 31 30     31 1 31 30 31 1 31 30 31 1 31];
          %   array_speaker = [ 30 29 28 29 30 29 28 29 30 29 28 29 30 29 28 29 30 29 28 29 30 29 28 29 30 29 28 29 30 29];
           % array_speaker = [1:15 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17];
        %  array_speaker = [1:15 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17];
         %   array_speaker = [ 30 29 28 27 26 30 29 28 27 26 30 29 28 27 26 30 29 28 27 26 30 29 28 27 26 30 29 28 27 26];
          %  array_speaker = [ 30 29 28 27 26 30 29 28 27 26 30 29 28 27 26 30 29 28 27 26 30 29 28 27 26 30 29 28 27 26];


        chosen_sound = repmat(1:15,[1 2]);
        %chosen_sound = 1:31;
        
        
    case 2 %60 speakers, LD to RU, RU to LD
        array_speaker = [1:15 30:-1:16 16:30 15:-1:1];
        % 31 is center, thus omitted
        chosen_sound = repmat(1:30,[1 2]); %stack of 4 times 1:15
        
    case 3 %%% one arm approaching & receding
        array_speaker = [1:15 15:-1:1];
        chosen_sound = repmat(1:15,[1 2]); %chosen audio
        
    case 4 %%% left and right arm, both approaching
        array_speaker = 1:30; % starts from leftdown goes to center, then start from right up goes to center
        chosen_sound = repmat(1:15,[1 2]); %chosen audio, from beginning till end  
        
    case 5 %%% similar to case 1, starting from 2nd speaker instead 1st
        array_speaker = [2:2:14 31 29:-2:17 17:2:29 31 14:-2:2];
        
        %[1:2:15 30:-2:16 16:2:30 15:-2:1]; % starts from leftdown goes to center, then start from right up goes to center
        chosen_sound = repmat(1:15,[1 2]); %chosen audio, from beginning till end
end
%%
seq_CH = [array_speaker; chosen_sound]; %first raw for the speaker, second raw for the sounds/audio

wav_length=0;
for ch=1:size(seq_CH,2)
    wav_length= length(array_sound{seq_CH(2,ch)});
end

data=[];
data= zeros(wav_length,totspeaker); %zeros(righe,4) %out_AO.TotalChannels
iniz=0;
fin=0;

for j = 1:length(array_speaker)
    ch = array_speaker(j);
    so = chosen_sound(j);
    
    if mod(j,15) == 0 % not give gap beside only every 30 speakers
        gap = 0.0;
    else
        gap = 0.0;
    end
    
    iniz= fin+1;
    fin=iniz+length(array_sound{chosen_sound(j)})-1+ gap;
    data(iniz:(fin-gap),array_speaker(j))=amp*array_sound{chosen_sound(j)};   %*2 looks like amplifier here
    
end

figure;imagesc(data);
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
clear AO

