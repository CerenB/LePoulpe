function createNoise(whichNoise, fs, duration, saveToWav)

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



%%
AttenuationRange = linspace(0.05, 0.4, 10);

soundCell = {};

%% Regular Beep
TargetFreq = 440;
TargetDuration = 0.1;
TargetSound = sin(2 * pi * TargetFreq * (0:TargetDuration * samplingRate) / samplingRate);
TukeyWin = tukeywin(length(TargetSound), 0.35)';
TargetSound = TargetSound .* TukeyWin;
plot(TargetSound);
sound(TargetSound, samplingRate);
TargetSound = [TargetSound' TargetSound'];
audiowrite(TargetSound, samplingRate, strcat('TargetSound_', num2str(TargetFreq), '_Hz.wav'));

%%
% Original sound
sound = randn(1, stimDuration * samplingRate)';

% Pink Noise
a = zeros(1, length(sound));
a(1) = 1;
for i = 2:length(sound)
    a(i) = (i - 2.5) * a(i - 1) / (i - 1);
end
PinkNoise = filter(1, a, sound);
sound(PinkNoise, samplingRate);

% Brown Noise
a = zeros(1, length(sound));
a(1) = 1;
for i = 2:length(sound)
    a(i) = (i - 2.5) * a(i - 1) / (i - 1)^2;
end

BrownNoise = filter(1, a, sound);
sound(BrownNoise, samplingRate);

%% Creates looming sounds
% Original sound
sound = randn(1, StimDuration * samplingRate)';

% Looming parameters
x = 1:length(sound);
y = x' / length(sound); % linear looming
z = exp(x' / length(sound)) - 1; % exponential looming

% Tukey window
TukeyWin = tukeywin(length(sound), 0.05)';

% White Noise
Whitenoise = sound;
soundCell{1, 1} = 'Whitenoise';
soundCell{1, 2} = Whitenoise;

% Pink Noise
a = zeros(1, length(sound));
a(1) = 1;
for i = 2:length(sound)
    a(i) = (i - 2.5) * a(i - 1) / (i - 1);
end
PinkNoise = filter(1, a, sound);
soundCell{2, 1} = 'PinkNoise';
soundCell{2, 2} = PinkNoise;

% Brown Noise
a = zeros(1, length(sound));
a(1) = 1;
for i = 2:length(sound)
    a(i) = (i - 2.5) * a(i - 1) / (i - 1)^2;
end
BrownNoise = filter(1, a, sound);
soundCell{3, 1} = 'BrownNoise';
soundCell{3, 2} = BrownNoise;

%% Save sounds
for SoundInd = 1:size(soundCell, 1)

    TEMP = soundCell{SoundInd, 2};
    TEMP = TEMP / max(abs(TEMP));
    TEMP2 = [TEMP  TEMP];
    audiowrite(TEMP2, samplingRate, strcat(soundCell{SoundInd, 1}, '.wav'));
    TEMP = TEMP .* TukeyWin';
    TEMP2 = [TEMP  TEMP];
    audiowrite(TEMP2, samplingRate, strcat(soundCell{SoundInd, 1}, '_Tukey.wav'));

    TEMPLinear =  TEMP .* y;
    TEMPLinear = TEMPLinear / max(abs(TEMPLinear));
    TEMP2 = [TEMPLinear  TEMPLinear];
    audiowrite(TEMP2, samplingRate, strcat(soundCell{SoundInd, 1}, '_Linear.wav'));
    TEMPLinear = TEMPLinear .* TukeyWin';
    TEMP2 = [TEMPLinear  TEMPLinear];
    audiowrite(TEMP2, samplingRate, strcat(soundCell{SoundInd, 1}, '_Linear_Tukey.wav'));

    TEMPExp =  TEMP .* z;
    TEMPExp = TEMPExp / max(abs(TEMPExp));
    TEMP2 = [TEMPExp  TEMPExp];
    audiowrite(TEMP2, samplingRate, strcat(soundCell{SoundInd, 1}, '_Exp.wav'));
    TEMPExp = TEMPExp .* TukeyWin';
    TEMP2 = [TEMPExp  TEMPExp];
    audiowrite(TEMP2, samplingRate, strcat(soundCell{SoundInd, 1}, '_Exp_Tukey.wav'));

end

%%
for i = 1:5
    Looming_Sound_And_Target = audioread('Whitenoise_Exp_Tukey.wav');
    Target_alone = zeros(size(Looming_Sound_And_Target));
    A = 1 + (i - 1) * length(TargetSound);
    B = (i) * length(TargetSound);
    if B > length(Looming_Sound_And_Target)
        B = length(Looming_Sound_And_Target);
    end

    for AttenuationIndex = 1:length(AttenuationRange)
        Looming_Sound_And_Target(A:B - 1, :) = Looming_Sound_And_Target(A:B - 1, :) + TargetSound(1:B - A, :) * AttenuationRange(AttenuationIndex);
        Target_alone = zeros(size(Looming_Sound_And_Target));
        Target_alone(A:B - 1, :) = Target_alone(A:B - 1, :) + TargetSound(1:B - A, :) * AttenuationRange(AttenuationIndex);
        Target_alone = Target_alone / max(max(Target_alone));

        % sound(Looming_Sound_And_Target,samplingRate)
        % sound(Target_alone,samplingRate)

        audiowrite(Looming_Sound_And_Target, samplingRate, strcat('Looming_Noise_And_Target_', num2str(i), '_Attenuation_', num2str(AttenuationIndex), '.wav'));
        audiowrite(Target_alone, samplingRate, strcat('Target_alone_', num2str(i), '_Attenuation_', num2str(AttenuationIndex), '.wav'));
    end

end

%% frequency modulated (FM) sound
clc;

samplingRate = 44100;
StimDuration = 0.5;

% BaseFreq = [220 330 440 660 880 990 1110 880*2];
% FreqRange = 1;
% FreqRange = (FreqRange * BaseFreq)'
% mrate = 1;    % modulation rate
% mindex = 110; % modulation index (for fm = max_freq_change/modulation rate)
%
% for FreqInd = 1 :length(FreqRange)
%     fc = FreqRange(FreqInd);
%     mindex = FreqRange(FreqInd)/2.5;
%     f_fm(FreqInd,1:length(t))  = sin((2 * pi * fc * t) + (-mindex * sin(2 * mrate * pi * t))) ;
% end

BaseFreq = [55 110 150 220 330 380 440 660 880 990 1110 1500 2500 3000];
% FreqRange = [0.25 0.5 linspace(1,6,4)];
FreqRange = 1;
FreqRange = (FreqRange * BaseFreq)';

mrate = 1;    % modulation rate
mindex = 440;   % modulation index (for fm = max_freq_change/modulation rate)

t = 0:1 / samplingRate:StimDuration;

y = t' / length(t); % linear looming
z = exp(15000 * t' / length(t)) - 1; % exponential looming
TukeyWin = tukeywin(length(t), 0.05)'; % Tukey window

for FreqInd = 1:length(FreqRange)
    fc = FreqRange(FreqInd);
    mindex = FreqRange(FreqInd) / 1.5;
    f_fm(FreqInd, 1:length(t))  = sin((2 * pi * fc * t) + (-mindex * sin(2 * mrate * pi * t))) ;
end

Final = sum(f_fm, 1)';
Final  =  Final .* z;
Final = Final .* TukeyWin';
Final = Final / max(abs(Final));

% subplot(211)
plot(Final);

% Spectrum = abs( fft(Final) );
% Spectrum = Spectrum / sum(Spectrum);
%
% subplot(212)
% semilogx(Spectrum(1:fix(length(Spectrum)/2)))
% axis([20 20000 0 max(Spectrum)])

% sound(Final,samplingRate)

% Looming_Sound = [Final'; Final'];
% wavwrite(Final,samplingRate,strcat('Looming_Sound.wav'));

%%
for i = 1:5
    Looming_Sound_And_Target = Looming_Sound';
    Target_alone = zeros(size(Looming_Sound_And_Target));
    A = 1 + (i - 1) * length(TargetSound);
    B = (i) * length(TargetSound);
    if B > length(Looming_Sound_And_Target)
        B = length(Looming_Sound_And_Target);
    end

    for AttenuationIndex = 1:length(AttenuationRange)
        Looming_Sound_And_Target(A:B - 1, :) = Looming_Sound_And_Target(A:B - 1, :) + TargetSound(1:B - A, :) * AttenuationRange(AttenuationIndex);

        % sound(Looming_Sound_And_Target,samplingRate)

        wavwrite(Looming_Sound_And_Target, samplingRate, strcat('Looming_Sound_And_Target_', num2str(i), '_Attenuation_', num2str(AttenuationIndex), '.wav'));
    end

end

%%
SoundList = dir('*.wav');

% Reads the sounds
% for SoundInd=1:size(SoundList,1)
%     [Y,FS,NBITS]=wavread(SoundList(SoundInd).name);
%     sound(Y,FS);
% end

%% creates names list
B = [];
A = char({SoundList(:).name});
for i = 1:size(A, 1)
    B(i, :) = strrep(A(i, :), '.wav', ' ');
end
[repmat(['sound {wavefile { filename = "'], size(SoundList, 1), 1) A repmat(['"; } ; } '], size(SoundList, 1), 1) B repmat(';', size(SoundList, 1), 1)];
fprintf('\n');

% for SoundInd=1:size(SoundList,1)
%     fprintf(['sound {wavefile { filename = "' char({SoundList(SoundInd).name}) '"; } ; } '  SoundList(SoundInd).name(1:end-4) ';']);
%     fprintf('\n')
% end
