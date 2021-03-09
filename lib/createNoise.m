function [outSound] = createNoise(whichNoise, fs, duration, saveAsWav)

% whichNoise - indicate which type of sound user wants. Options are white,
% pink, brown and pure. has to be lower case input. 
% fs - sampling rate 
% duration - length of the audio file in seconds
% saveToWav - boolean for saving into .wav files or keeping them as array.

typeNoise = whichNoise;

cfg.fs = fs ;
cfg.stimDuration = duration;

amp = 0.95;

%% ramping
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
    
    outputPath = addpath(fullfile(fileparts(mfilename('fullpath')), '..',...
                        'inputSounds'));
    outputFileName = [outputPath,num2str(cfg.stimDuration*1000),'ms', ...
    typeNoise, 'noise.wav'];

    audiowrite(outputFileName, ...
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
outSound = amp .* outSound;

% listen
% clear sound
% sound(outSound,cfg.fs)


end
  
function outSound = applyRamp(outSound,cfg)


  % number of samples for the onset ramp (proportion of gridIOI)
  ramponSamples   = round(cfg.eventRampon * cfg.fs);

  % number of samples for the offset ramp (proportion of gridIOI)
  rampoffSamples  = round(cfg.eventRampoff * cfg.fs);

  % individual sound event duration defined as proportion of gridIOI
  envEvent = ones(1, round(cfg.stimDuration * cfg.fs));

  % make the linear ramps
  envEvent(1:ramponSamples) = envEvent(1:ramponSamples) .* linspace(0, 1, ramponSamples);
  envEvent(end - rampoffSamples + 1:end) = envEvent(end - rampoffSamples + 1:end) .* linspace(1, 0, rampoffSamples);
  
  % apply the ramp onto the sound
  outSound = outSound .* envEvent;
  
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

end


