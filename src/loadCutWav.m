% (C) Copyright 2021 CPP LePoulpe developers

function [soundArray] = loadCutWav(soundPath)

  fileNamesList = dir(fullfile(soundPath, '*.wav' ));
  
  nbWavsToUpload = length(fileNamesList);

  % load the audio files in an array
  for iSound = 1:nbWavsToUpload
      
    fileName = fileNamesList(iSound).name(1:max(find(fileNamesList(iSound).name == '-'))); %#ok<MXFND>

    [soundArray{iSound}, ~] = audioread(fullfile(soundPath, [ fileName num2str(iSound) '.wav' ])); %#ok<*AGROW>

  end


end
