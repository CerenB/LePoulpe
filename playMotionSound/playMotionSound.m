% (C) Copyright 2017 Stephanie Cattoir
% (C) Copyright 2021 CPP LePoulpe developers

% This script play a provided sound (cut in chunks one per each speaker) in subsequent speakers
% to create motion a motionn perception inn both the horizontal and vertical axes


%WaitSecs(5)

% set sound intensity
amp = 1;

% START the AO
% Slot2 ao0-14 is left arm
% Slot2 ao15-30 is right arm (center speaker included here), ao30 is center
% Slot3 ao0-14 upper arm
% Slot3 ao15-29 below arm
% all 4 arms, the direction is approaching to the center
% WaitSecs(0)
tic
for option = 1:4;
    %% CHOOSE/CHANGE HERE ONLY
    switch option
        case 1 % EVENT HORIZONTAL
            name = 'PXI1Slot2'; % Put Slot2 value =0; Put Slot3 value = 1,
            value = 0; %0 1 (change value of central led: hor or vert sound bar)

        case 2 % EVENT VERTICAL
            name = 'PXI1Slot3';
            %AOLR=analogoutput('nidaq','PXI1Slot3'); % Put Slot2 value =0; Put Slot3 value = 1,
            value = 1;

        case 3 % TARGET HORIZONTAL
            name = 'PXI1Slot2';
            value = 0;

        case 4 % TARGET VERTICAL
            name = 'PXI1Slot3';
            value = 1;
    end

AOLR=analogoutput('nidaq',name);
target_sound_dur = 1200;
event_sound_dur = 600;
%% DO NOT CHANGE HERE!
out_AO=daqhwinfo(AOLR);
set(AOLR, 'SampleRate', 44100);
addchannel(AOLR,0:30);
%%
 dio = digitalio('nidaq', 'PXI1Slot3');
 addline (dio, 0:7, 'out');
 putvalue(dio.Line(1),value);

%AnalogLeftRight
out_ranges=get(AOLR.Channel,'OutputRange');
setverify(AOLR.Channel,'OutputRange', [-5 5]);
setverify(AOLR.Channel,'UnitsRange', [-5 5]);
set(AOLR,'TriggerType', 'Manual');

%% SOUND FILES
addpath(genpath(pwd)); %'E:\MEGAQuaTRON'
files_sound = {};
array_sound={};

totspeaker = 31;

gap_init = 0.25; %sec
AOLR.SampleRate = 44100;
gap_init = gap_init * AOLR.SampleRate;



%%
nspeaker = 31;
chosen_sound = repmat(1:nspeaker,[1 2]);

switch option
    case 1 % EVENT RECORDINGS HORIZONTAL
        pathname = 'sounds';
        array_speaker = [ 1:15 31 16 17 valueSpeakerHor 19:30 30:-1:19 valueSpeakerHor 17 16 31 15:-1:1 ];
        for i = 1:nspeaker
            files_sound{i} = fullfile(pathname,strcat(['pn_event_speak',num2str(i),'_31.wav'])); %2s
            [array_sound{i}, ~] = audioread(files_sound{i});
        end

    case 2 % EVENT RECORDINGS VERT
        pathname =  'sounds';
        array_speaker = [1:15 31 valueSpeakerVert 29:-1:16 16:29 valueSpeakerVert 31 15:-1:1];
        for i = 1:nspeaker
            files_sound{i} = fullfile(pathname,strcat(['pn_event_speak',num2str(i),'_31.wav'])); %2s
            [array_sound{i}, ~] = audioread(files_sound{i});
        end

    case 3 % TARGET RECORDINGS HORIZONTAL
        pathname = 'sounds';
        array_speaker = [1:15 31 16 17 valueSpeakerHor 19:30 30:-1:19 valueSpeakerHor 17 16 31 15:-1:1];
        for i = 1:nspeaker
            files_sound{i} = fullfile(pathname,strcat(['pn_target_speak',num2str(i),'_31.wav'])); %2s
            [array_sound{i}, ~] = audioread(files_sound{i});
        end

    case 4 % TARGET RECORDINGS VERT
        pathname =  'sounds';
        array_speaker = [1:15 31 valueSpeakerVert 29:-1:16 16:29 valueSpeakerVert 31 15:-1:1];
        for i = 1:nspeaker
            files_sound{i} = fullfile(pathname,strcat(['pn_target_speak',num2str(i),'_31.wav'])); %2s
            [array_sound{i}, ~] = audioread(files_sound{i});
        end
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

    if mod(j,nspeaker) == 0 % not give gap beside between 2 directions.
        gap = gap_init;
    else
        gap = 0.0;
    end

    iniz= fin+1;
    fin=iniz+length(array_sound{chosen_sound(j)})-1+ gap;
    data(iniz:(fin-gap),array_speaker(j))=amp*array_sound{chosen_sound(j)};   %*2 looks like amplifier here
end

% figure;imagesc(data) % GRAPH of the speaker order
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

delete(dio)
clear dio

delete(AOLR)
clear AO

WaitSecs(0.5)

end
toc
