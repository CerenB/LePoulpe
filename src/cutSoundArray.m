% (C) Copyright 2017 Stephanie Cattoir
% (C) Copyright 2021 CPP LePoulpe developers

function [soundArray] = cutSoundArray(inputSound, inputName, sampleRate, nbSpeakers, saveAsWav)

% Cut a long file audio in x nb of chunks corresponding to the nb spekears in which it will be
% played. Then they can be saved as separate `.wav` files or in a structure as output
%
% USAGE::
%
%   [argout1, argout2] = cutSounds(nbSpeakers == 31, [saveAsWav == 0])
%
% :param nbSpeakers: the number of speakers (chunks) in which the file audio should be divided
% :type argin1: integer
% :param saveAsWav: boolean to save the audio chunks as .wav files in a subfolder where
% input audio file is
%
% :returns: - :soundChunks: (matrix) (nbSpeakers, x) a matrix with the audio chunks ready to be used
outputPath = fullfile(fileparts(mfilename('fullpath')), '..', ...
                        'inputSounds');

if ~isdir(outputPath)
                        
   mkdir(outputPath);
                    
end

% set default
if isempty(saveAsWav)

    saveAsWav = 0;

end


% check the input sound length in seconds
audioLength = length(inputSound)/sampleRate;

% number of samples in a segment
nbSamplePerSpeaker = floor(sampleRate / (1 / (audioLength / nbSpeakers)));

% pre-allocate space in the output matrix
soundArray = cell(1, nbSpeakers);

% get the index on the chunks and solve an issue that could happen if the last inndex correspond
% to the length of the audio file
startIdx = 1:(nbSamplePerSpeaker):(length(inputSound) - nbSamplePerSpeaker);

endIdx = nbSamplePerSpeaker:nbSamplePerSpeaker:length(inputSound);

if length(startIdx) ~= length(endIdx)

    startIdx(end+1) = (length(inputSound) - nbSamplePerSpeaker) + 1; %#ok<*AGROW>

end

% loop through the audiofiles, extract each chunk and save as `*.wav` if necessary
for iSpeaker = 1:nbSpeakers

    soundArray{iSpeaker} = inputSound(startIdx(iSpeaker):endIdx(iSpeaker))';

    if saveAsWav        
        
        
        fileChunkName = [num2str(audioLength*1000), ...
            'ms_' inputName, ...
            '_nbSpeaker-' num2str(iSpeaker), ...
            '.wav'];
        
        fileChunkFolder = fullfile(outputPath, ...
            ['cut_nbSpeakers-' ...
            num2str(nbSpeakers) '_' ...
            num2str(audioLength*1000) 'ms',...
            inputName ]);
        
        if ~isdir(fileChunkFolder)
            
            mkdir(fileChunkFolder);
            
        end
        
        audiowrite(fullfile(fileChunkFolder,fileChunkName), ...

            soundArray{iSpeaker}, ...
            sampleRate);

    end

end



end
