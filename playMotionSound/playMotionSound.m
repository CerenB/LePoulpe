% (C) Copyright 2017 Stephanie Cattoir
% (C) Copyright 2021 CPP LePoulpe developers

% This script play a provided sound (cut in chunks one per each speaker) in subsequent speakers
% to create motion a motionn perception inn both the horizontal and vertical axes
%
% NativeInstrument to Matlab arm/speaker correspondance:
%
%  Horizontal arm (left to right)
%  - NI: 'PXI1Slot2' ao0-14  ; Matlab: 1:15 left arm (left to center)
%  - NI: 'PXI1Slot2' ao15-30 ; Matlab: 31:16 right arm (center to right)
%
%  Vertical arm (up to down)
%  - NI: 'PXI1Slot3' ao0-14  ; Matlab: 1:14 upper arm (up to center)
%  - NI: 'PXI1Slot3' ao30-15 ; Matlab: 31:16 lower arm (center to down)

WaitSecs(5);

% set sound intensity
amp = 1;

% set how many speakers are supposed to be played
nbSpeakers = 31;

% sec
gap_init = 0.25;
gap_init = gap_init * AOLR.SampleRate;

% map the arms with directions

% horizontal
horCenter = 31;
% rightward
horLeftToCenterMinusOne = 1:15;
horCenterPlusOneToRight = 30:-1:16;
% leftward
horRightToCenterMinusOne = 16:30;
horCenterPlusOneToLeft = 15:-1:1;

% vertical
vertCenter = 31;
% downward
vertUptoCenterMinusOne = 1:15;
vertCenterPlusOneToDown = 30:-1:16;
% upward
vertDownToCenterMinusOne = 16:30;
vertCenterPlusOnetoUp = 15:-1:1;

% this loop plays:
%  optionn 1 : right-ward direction 'long' file
%  optionn 2 : down-ward direction 'long' file
%  optionn 3 : right-ward direction 'short' file
%  optionn 4 : down-ward direction 'short' file

for option = 1:4

    switch option

        % name: NI analog card slot
        % value: make the switch between arms (0 = horizontal ; 1 = vertical)

        % EVENT HORIZONTAL
        case 1
            name = 'PXI1Slot2';
            value = 0;

        % EVENT VERTICAL
        case 2
            name = 'PXI1Slot3';
            value = 1;

        % TARGET HORIZONTAL
        case 3
            name = 'PXI1Slot2';
            value = 0;

        % TARGET VERTICAL
        case 4
            name = 'PXI1Slot3';
            value = 1;
    end

    % -------------------------------------- HELP NEEDED HERE --------------------------------------

    %% init the NI analog card
    AOLR = analogoutput('nidaq', name);
    out_AO = daqhwinfo(AOLR);
    set(AOLR, 'SampleRate', 44100);
    addchannel(AOLR, 0:30);

    dio = digitalio('nidaq', 'PXI1Slot3');
    addline (dio, 0:7, 'out');
    putvalue(dio.Line(1), value);

    % AnalogLeftRight
    out_ranges = get(AOLR.Channel, 'OutputRange'); %%% this seems to be unused %%%
    setverify(AOLR.Channel, 'OutputRange', [-5 5]);
    setverify(AOLR.Channel, 'UnitsRange', [-5 5]);
    set(AOLR, 'TriggerType', 'Manual');

    AOLR.SampleRate = 44100; %%% this could be a repetition of `set(AOLR, 'SampleRate', 44100);` %%%

    % ----------------------------------------------------------------------------------------------

    %% load chunk audio files
    fileNamesList = {};
    soundArray = {};

    soundPath = 'sounds';

    switch option
        case 1 % EVENT RECORDINGS HORIZONTAL
            speakerIdx = [1:15 31 16 17 valueSpeakerHor 19:30 30:-1:19 valueSpeakerHor 17 16 31 15:-1:1];
            for i = 1:nbSpeakers
                fileNamesList{i} = fullfile(soundPath, strcat(['pn_event_speak', num2str(i), '_31.wav'])); % 2s
                [soundArray{i}, ~] = audioread(fileNamesList{i});
            end

        case 2 % EVENT RECORDINGS VERT
            speakerIdx = [1:15 31 valueSpeakerVert 29:-1:16 16:29 valueSpeakerVert 31 15:-1:1];
            for i = 1:nbSpeakers
                fileNamesList{i} = fullfile(soundPath, strcat(['pn_event_speak', num2str(i), '_31.wav'])); % 2s
                [soundArray{i}, ~] = audioread(fileNamesList{i});
            end

        case 3 % TARGET RECORDINGS HORIZONTAL
            speakerIdx = [1:15 31 16 17 valueSpeakerHor 19:30 30:-1:19 valueSpeakerHor 17 16 31 15:-1:1];
            for i = 1:nbSpeakers
                fileNamesList{i} = fullfile(soundPath, strcat(['pn_target_speak', num2str(i), '_31.wav'])); % 2s
                [soundArray{i}, ~] = audioread(fileNamesList{i});
            end

        case 4 % TARGET RECORDINGS VERT
            speakerIdx = [1:15 31 valueSpeakerVert 29:-1:16 16:29 valueSpeakerVert 31 15:-1:1];
            for i = 1:nbSpeakers
                fileNamesList{i} = fullfile(soundPath, strcat(['pn_target_speak', num2str(i), '_31.wav'])); % 2s
                [soundArray{i}, ~] = audioread(fileNamesList{i});
            end
    end
    %%

    soundIdx = repmat(1:nbSpeakers, [1 2]);

    seq_CH = [speakerIdx; soundIdx]; % first raw for the speaker, second raw for the sounds/audio

    wav_length = 0;
    for ch = 1:size(seq_CH, 2)
        wav_length = length(soundArray{seq_CH(2, ch)});
    end

    data = [];
    data = zeros(wav_length, nbSpeakers); % zeros(righe,4) %out_AO.TotalChannels
    iniz = 0;
    fin = 0;

    for j = 1:length(speakerIdx)
        ch = speakerIdx(j);
        so = soundIdx(j);

        if mod(j, nbSpeakers) == 0 % not give gap beside between 2 directions.
            gap = gap_init;
        else
            gap = 0.0;
        end

        iniz = fin + 1;
        fin = iniz + length(soundArray{soundIdx(j)}) - 1 + gap;
        data(iniz:(fin - gap), speakerIdx(j)) = amp * soundArray{soundIdx(j)};   % *2 looks like amplifier here
    end

    % figure;imagesc(data) % GRAPH of the speaker order
    dur = size(data, 1) / 44100; % in sec
    %% START
    putdata(AOLR, data); % to queue the obj
    % Start AO, issue a manual trigger, and wait for
    % the device object to stop running.

    start(AOLR);
    % pause(1) %when to start exp
    trigger(AOLR);
    % stop(AO) terminates the execution

    wait(AOLR, dur + 1); % wait before doing anything else

    delete(dio);
    clear dio;

    delete(AOLR);
    clear AO;

    WaitSecs(0.5);

end
toc;
