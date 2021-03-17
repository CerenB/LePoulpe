
soundPath = 'C:\Users\local-admin\Documents\MATLAB\Google\song\technologic.wav';

% soundPath = 'C:\Users\local-admin\Documents\MATLAB\Google\song\belgian_anthem.wav';

% sec
chunkLength = 3;

[longSong, sampleRate] = audioread(soundPath);

% check the input sound length in seconds
audioLength = length(longSong);

% number of samples in a segment
nbSamplePerChunk = chunkLength * sampleRate;

% pre-allocate space in the output matrix
songArray = cell(1, floor(audioLength / nbSamplePerChunk));

% get the index on the chunks and solve an issue that could happen if the last inndex correspond
% to the length of the audio file
startIdx = 1:(nbSamplePerChunk):(audioLength - nbSamplePerChunk);

endIdx = nbSamplePerChunk:nbSamplePerChunk:audioLength;

if length(startIdx) ~= length(endIdx)

   startIdx(end+1) = (audioLength - nbSamplePerChunk) + 1; %#ok<*AGROW>

end

% loop through the audiofiles, extract each chunk and save as `*.wav` if necessary
for iChunks = 1:floor(audioLength / nbSamplePerChunk)

   songArray{iChunks} = longSong(startIdx(iChunks):endIdx(iChunks))';

end

soundArray = cell(floor(audioLength / nbSamplePerChunk), 31);

for iChunk = 1:floor(audioLength / nbSamplePerChunk)

    soundChunkArray = cutSoundArray(songArray{iChunk}, 'technologic', 44100, 31, 0);

    for iSpeaker = 1:size(soundChunkArray, 2)

        soundArray{iChunk, iSpeaker} = soundChunkArray{iSpeaker};

    end
end


speakerIdxRightward = generateMotionSpeakerArray('rightward');

speakerIdxLeftward = generateMotionSpeakerArray('leftward');

speakerIdxDownward = generateMotionSpeakerArray('downward');

speakerIdxUpward = generateMotionSpeakerArray('upward');


speakersArray = [ speakerIdxRightward; ...
                  speakerIdxLeftward; ...
                  speakerIdxDownward; ...
                  speakerIdxUpward ];

axes = { 'horizontal', ...
         'horizontal', ...
         'vertical', ...
         'vertical' };

visualDirection = { 'rightward', ...
                    'leftward', ...
                    'downward', ...
                    'upward' };

jummp = [ 2 2 1 1 ];

for iChunk = 1:20 %size(songArray, 2)

    casualDirection = Randi(4);

    disp(axes{casualDirection});

    disp(speakersArray(casualDirection));

    disp(visualDirection{casualDirection});

    playMotionSound(axes{casualDirection}, ...
                speakersArray(casualDirection, :), ...
                soundArray(iChunk, :), ...
                1, ...
                0);

%     playVisualMotion(visualDirection{casualDirection}, ...
%                  0.0387, ...
%                  jummp(casualDirection), ...
%                  1)


end
