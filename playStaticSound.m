clear all;
close all;

tic
%% CHOOSE/CHANGE HERE ONLY
% Insert PXI1Slot3, data = 1, for vertical arm
% Put PXI1Slot2, data =0, for horizontal arm
AOLR=analogoutput('nidaq','PXI1Slot2');
data = 0;

%Marc's recordings
recordingNb = 1;
recordingfrontal = 1;
recordingleft = 0;
recordingright = 0;

%% define other parameters
%numberof speakers
nbSpeakers = 31;
%the intensity of sound
soundAmp = 1;
% initial gap in sec
initGap = 0.25;
samplingFrequency = 44100;

%% DO NOT CHANGE HERE!
out_AO=daqhwinfo(AOLR);
set(AOLR, 'SampleRate', 44100);
addchannel(AOLR,0:30);

%% digital switch between horizontal and vertical arm
dio = digitalio('nidaq', 'PXI1Slot3');
addline (dio, 0:7, 'out');

putvalue(dio.Line(1),data);
value = getvalue(dio);

%% Analog channel settings
out_ranges=get(AOLR.Channel,'OutputRange');
setverify(AOLR.Channel,'OutputRange', [-5 5]);
setverify(AOLR.Channel,'UnitsRange', [-5 5]);
set(AOLR,'TriggerType', 'Manual');

%% SOUND FILES
% set sound input path
soundFileName = {};
soundArray={};

%find the correct input folder
inputPath = fullfile(fileparts(mfilename('fullpath')),'..',...
    'LePoulpe_input_sound');

inputFolder = fullfile(inputPath,'stim_frontal',['recording',...
                                                num2str(recordingNb)]);

if recordingleft == 1
    inputFolder = fullfile(inputPath,'stim_-90',...
        ['recording',num2str(recordingNb)]);

elseif recordingright == 1
    inputFolder = fullfile(inputPath,'stim_+90',...
        ['recording',num2str(recordingNb)]);
end

% Read the content of the target folder
soundFileNamesList = dir(inputFolder);

% Remove the directories and keep only files
soundFileNamesList(~[soundFileNamesList.isdir]) = [];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% I GUES YOU WANT TO START YOUR LOOP FROM HERE

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% for iSound = 1:nbSpeakers

soundFileName = fulfile(inputFolder, filesep, soundFileNamesList(iSound).name)

% load/read sounds

% soundFileName = fullfile(inputFolder,'noiseburst_bp_1.wav');
[soundArray{1}, Fs] = audioread(soundFileName);

% define speakers to be used
% 1:15 31 and 16:30
speakerArray = [1:15 31 16:30];


%% define other parameters
%numberof speakers
nbSpeakers = 31;
%the intensity of sound
soundAmp = 1;
% initial gap in sec
initGap = 5;
samplingFrequency = Fs;

AOLR.SampleRate = samplingFrequency;
initGap = initGap * AOLR.SampleRate;

soundToChoose = ones(1,length(speakerArray));
%preallocate with burst sound
speakerSoundCouple = [speakerArray;soundToChoose];

%% initialise wav matrix
wav_length=0;
for ch=1:size(speakerSoundCouple,2)
    wav_length= length(soundArray{speakerSoundCouple(2,ch)});
end

data=[];
data= zeros(wav_length,nbSpeakers);
iniz=0;
fin=0;

%% make wav matrix with gaps and sounds and designated speakers
for j = 1:length(speakerArray)

    ch = speakerArray(j);
    % if ch == 31
        nloop = 1;
        soundToChoose(j) = 1;
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
            gap = initGap;
        else
            gap = 0.0;
        end
        fin=iniz+length(soundArray{soundToChoose(j)})-1+ gap;
        data(iniz:(fin-gap),speakerArray(j))=soundAmp*soundArray{soundToChoose(j)};   %*2 looks like amplifier here
    end
end

% mini plot to check matrix is OK
figure;imagesc(data)
dur = size(data,1)/44100;

%% START Analog channels == play sounds in the speakers
% to queue the obj
putdata(AOLR,data)

% Start AO, issue a manual trigger, and wait for
% the device object to stop running.
start(AOLR)

%when to start exp
%pause(1)
trigger(AOLR)

% terminates the execution
%stop(AO)

%wait before doing anything else
wait(AOLR, dur+1)
toc

%clear digital channel
delete(dio)
clear dio

%clear analog channels
delete(AOLR)
clear AOLR
