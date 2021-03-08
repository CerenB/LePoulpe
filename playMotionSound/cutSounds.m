% (C) Copyright 2017 Stephanie Cattoir
% (C) Copyright 2021 CPP LePoulpe developers

function [soundChunks] = cutSounds(nbSpeakers, saveAsWav)

% Cut a long file audio in x nb of chunks corresponding to the nb spekears in which it will be
% played. Then they can be saved as separate `.wav` files or in a structure as output
%
% USAGE::
%
%   [argout1, argout2] = cutSounds(nbSpeakers == 31, [saveAsWav == 0])
%
% :param nbSpeakers: the nnumber of speakers (chunks) in which the file audio should be divided
% :type argin1: integer
% :param saveAsWav: boolean to save the chinkns in separate audio files in a subfolder at the same 
%                   location of the input adio files 
%
% :returns: - :soundChunks: (matrix) (nbSpeakers, x) a matrix with the audio chunks ready to be used

% directory with this script becomes the current directory
WD = fileparts(mfilename('fullpath'));

% set defautks
if isempty(saveAsWav)
        
    saveAsWav = 0;
    
end

% get the path of the audio files
inputPath = fullfile(WD, 'input');

% get the files to cut
filesToCut = dir([inputPath '/*.wav']);

for iFile = 1:length(filesToCut)
    
    % prepare in case we need to save the files
    if saveAsWav
        
        fileName = filesToCut(iFile).name(1:find(filesToCut(iFile).name == '.') - 1);
        
        outputPath = fullfile(inputPath, [ 'cut_nbSpeakers-' num2str(nbSpeakers) '_' fileName]);
        
        if ~isdir(outputPath)
            
            mkdir(outputPath);
            
        end
        
    end
    
    % read the audio file and get some information
    [audio, sampleRate] = audioread(fullfile(inputPath, filesToCut(iFile).name));
    
    audioLength = length(audio)/sampleRate;
    
    % number of samples in a segment
    nbSamplePerSpeaker = floor(sampleRate / (1 / (audioLength / nbSpeakers)));
    
    % pre-allocate space in the output matrix
    soundChunks = zeros(nbSpeakers, nbSamplePerSpeaker);
    
    % get the index on the chunks and solve an issue that could happen if the last inndex correspond
    % to the length of the audio file
    startIdx = 1:(nbSamplePerSpeaker):(length(audio) - nbSamplePerSpeaker);

    endIdx = nbSamplePerSpeaker:nbSamplePerSpeaker:length(audio);
    
    if length(startIdx) ~= length(endIdx)
        
        startIdx(end+1) = (length(audio) - nbSamplePerSpeaker) + 1; %#ok<*AGROW>
        
    end
    
    % loop thruogh the audiofiles, extract each chunk and save as `*.wav` if necessary
    for iSpeaker = 1:nbSpeakers
        
        soundChunks(iSpeaker,:) = audio(startIdx(iSpeaker):endIdx(iSpeaker));
        
        if saveAsWav
            
            fileChunkName = fullfile(outputPath, ...
                [fileName '_speaker-' num2str(iSpeaker) '.wav']);
            
            audiowrite(fileChunkName, ...
                soundChunks(iSpeaker, :), ...
                sampleRate);
            
        end
        
    end
    
end

end
