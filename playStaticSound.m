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
nbSpeakers = 31;

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
soundFileNamesList([soundFileNamesList.isdir]) = [];


% load/read sounds
for iwav = 1:nbSpeakers

    soundFileName = fullfile(inputFolder, filesep, ...
                            soundFileNamesList(iwav).name);

    [soundArray{iwav}, Fs] = audioread(soundFileName);

end

% define speakers to be used
% 1:15 31 and 16:30
speakerArray = [1:15 31 16:30];

% when one has many sounds
chosenSound = 1:31;
%chosenSound = ones(1,length(speakerArray));

%% define other parameters
%the intensity of sound
soundAmp = 1;
% initial gap in sec
initGap = 5;
samplingFrequency = Fs;

AOLR.SampleRate = samplingFrequency;
initGap = initGap * samplingFrequency;
%% initialise wav matrix
wav_length=0;
%preallocate with burst sound
speakerSoundCouple = [speakerArray;chosenSound]; 

for ch=1:size(speakerSoundCouple,2)
    wav_length = length(soundArray{speakerSoundCouple(2,ch)});
end

data = [];
data = zeros(wav_length,nbSpeakers);
startPoint = 0;
endPoint = 0;

%% make wav matrix with gaps and sounds and designated speakers
for iSpeaker = 1:length(speakerArray)

    startPoint= endPoint+1;
    gap = initGap;
    
    currentSound = soundArray{chosenSound(iSpeaker)};
    chosenSoundLength = length(soundArray{chosenSound(iSpeaker)});
    
    endPoint = startPoint + chosenSoundLength -1 + gap;
    
    %put into a matrix
    data(startPoint:(endPoint-gap),speakerArray(iSpeaker)) = soundAmp * currentSound;   %*2 looks like amplifier here
    
end

% mini plot to check matrix is OK
figure;imagesc(data)
dur = size(data,1)/Fs;

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
