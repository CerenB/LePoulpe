function [outSound] = generateNoise(whichNoise, duration, saveAsWav, fs)

% create pink, white, brown noise with a given duration and sampling rate. 
% Then they can be saved as separate `.wav` files or in a array as output
%
% USAGE::
%
%   [argout1] = createNoise(whichNoise == 'white', duration == 0.5, saveAsWav == 0, fs == 44100)
%
% :param whichNoise: type of noise (e.g. white, pink, brown)
% :type argin1: string
% :param duration: duration of the sound
% :type argin1: integer
% :param saveAsWav: boolean to save the audio  as .wav files in a subfolder where
% input audio file is
% :param fs: sampling rate of the sound
% :type argin1: integer
%
% :returns: - :outSound: (array) an array with the audio ready to be used

typeNoise = whichNoise;

cfg.fs = fs ;
cfg.stimDuration = duration;
cfg.amp = 0.95;

% onset ramp duration  _/
cfg.eventRampon          = 0.010; % s
% offset ramp duration       \_
cfg.eventRampoff         = 0.010; % s
  
  

switch typeNoise
    case 'white'
        
        outSound = makeWhiteNoise(cfg);
        
    case 'pink'
        outSound = makePinkNoise(cfg);
        
    case 'brown'
        outSound = makeBrownNoise(cfg);
   
end

 
if saveAsWav
    
    outputPath = fullfile(fileparts(mfilename('fullpath')), '..', ...
                        'inputSounds');
    outputFileName = [num2str(cfg.stimDuration*1000),'ms_', ...
                     typeNoise, 'noise_',...
                     'ramp',num2str(cfg.eventRampon*1000),'ms.wav'];

    audiowrite(fullfile(outputPath,outputFileName), ...
        outSound, ...
        cfg.fs);
    
end

end

function outSound = makeWhiteNoise(cfg)

% make white noise sound
outSound = randn(1, cfg.stimDuration * cfg.fs);

% limit amplitude to [-1 to 1]
outSound = outSound/max(outSound);

% apply ramp
outSound = applyRamp(outSound,cfg);

% apply amp to avoid chirping 
outSound = cfg.amp .* outSound;

%%listen
% clear sound
% sound(outSound,cfg.fs)


end


function outSound = makePinkNoise(cfg)

% let's start with white noise
outSound = randn(1, cfg.stimDuration * cfg.fs);

% limit amplitude to [-1 to 1] aka normalize
outSound = outSound/max(outSound);

% create q vector for filtering
pinkFilter = zeros(1, length(outSound));
pinkFilter(1) = 1;
for i = 2:length(outSound)
    pinkFilter(i) = (i - 2.5) * pinkFilter(i - 1) / (i - 1);
end

%filter the white noise
outSound = filter(1, pinkFilter, outSound);

% apply ramp
outSound = applyRamp(outSound,cfg);

% limit amplitude to [-1 to 1] aka normalize again
outSound = outSound/max(outSound);

% apply amp to avoid chirping 
outSound = cfg.amp .* outSound;

end



function outSound = makeBrownNoise(cfg)

% let's start with white noise
outSound = randn(1, cfg.stimDuration * cfg.fs);

% limit amplitude to [-1 to 1] aka normalize
outSound = outSound/max(outSound);

% create q vector for filtering
brownFilter = zeros(1, length(outSound));
brownFilter(1) = 1;
for i = 2:length(sound)
    brownFilter(i) = (i - 2.5) * brownFilter(i - 1) / (i - 1)^2;
end

%filter the white noise
outSound = filter(1, brownFilter, outSound);

% apply ramp
outSound = applyRamp(outSound,cfg);

% limit amplitude to [-1 to 1] aka normalize again
outSound = outSound/max(outSound);

% apply amp to avoid chirping 
outSound = cfg.amp .* outSound;

end

  
function outSound = applyRamp(outSound,cfg)

  % number of samples for the onset ramp
  ramponSamples   = round(cfg.eventRampon * cfg.fs);

  % number of samples for the offset ramp
  rampoffSamples  = round(cfg.eventRampoff * cfg.fs);

  % individual sound event duration 
  envEvent = ones(1, round(cfg.stimDuration * cfg.fs));

  % make the linear ramps
  envEvent(1:ramponSamples) = envEvent(1:ramponSamples) .* linspace(0, 1, ramponSamples);
  envEvent(end - rampoffSamples + 1:end) = envEvent(end - rampoffSamples + 1:end) .* linspace(1, 0, rampoffSamples);
  
  % apply the ramp onto the sound
  outSound = outSound .* envEvent;
  
end  




