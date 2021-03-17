
pacedByUser = false;

waitForAWhile = 0;

waitForSwtich = 1;

waitAfter = 1;

nbRepetitions = 1;

nbCycles = 1;

soundPath = 'C:\Users\local-admin\Documents\MATLAB\Google\inputMotion';

% build the speaker arrays for each direction
speakerIdxRightward = generateMotionSpeakerArray('rightward');

speakerIdxLeftward = generateMotionSpeakerArray('leftward');

speakerIdxDownward = generateMotionSpeakerArray('downward');

speakerIdxUpward = generateMotionSpeakerArray('upward');

%% 1.2

% loadAudio

[outSound, fs] = audioread(fullfile(soundPath, 'pink_1p2_ramp100ms.wav'));

% cutAudio

[soundArray] = cutSoundArray(outSound, 'pinknoise', fs, nbSpeakers, 0);

pressSpaceForMeOrWait(pacedByUser, waitForAWhile)

for i = 1:nbCycles

playMotionSound('horizontal', ...
                speakerIdxRightward, ...
                soundArray, ...
                nbRepetitions, ...
                waitForSwtich);

WaitSecs(waitAfter)

playMotionSound('horizontal', ...
                speakerIdxLeftward, ...
                soundArray, ...
                nbRepetitions, ...
                waitForSwtich);

WaitSecs(waitAfter)

playMotionSound('vertical', ...
                speakerIdxDownward, ...
                soundArray, ...
                nbRepetitions, ...
                waitForSwtich);

WaitSecs(waitAfter)

playMotionSound('vertical', ...
                speakerIdxUpward, ...
                soundArray, ...
                nbRepetitions, ...
                waitForSwtich);

WaitSecs(waitAfter)

end


%% 0.6

% loadAudio

[outSound, fs] = audioread(fullfile(soundPath, 'pink_0p6_ramp100ms.wav'));

% cutAudio

[soundArray] = cutSoundArray(outSound, 'pinknoise', fs, nbSpeakers, 0);

pressSpaceForMeOrWait(pacedByUser, waitForAWhile)

for i = 1:nbCycles

playMotionSound('horizontal', ...
                speakerIdxRightward, ...
                soundArray, ...
                nbRepetitions, ...
                waitForSwtich);

WaitSecs(waitAfter)

playMotionSound('horizontal', ...
                speakerIdxLeftward, ...
                soundArray, ...
                nbRepetitions, ...
                waitForSwtich);

WaitSecs(waitAfter)

playMotionSound('vertical', ...
                speakerIdxDownward, ...
                soundArray, ...
                nbRepetitions, ...
                waitForSwtich);

WaitSecs(waitAfter)

playMotionSound('vertical', ...
                speakerIdxUpward, ...
                soundArray, ...
                nbRepetitions, ...
                waitForSwtich);

WaitSecs(waitAfter)

end


%% 0.85

% loadAudio

[outSound, fs] = audioread(fullfile(soundPath, 'pink_0p85_ramp100ms.wav'));

% cutAudio

[soundArray] = cutSoundArray(outSound, 'pinknoise', fs, nbSpeakers, 0);

pressSpaceForMeOrWait(pacedByUser, waitForAWhile)

for i = 1:nbCycles

playMotionSound('horizontal', ...
                speakerIdxRightward, ...
                soundArray, ...
                nbRepetitions, ...
                waitForSwtich);

WaitSecs(waitAfter)

playMotionSound('horizontal', ...
                speakerIdxLeftward, ...
                soundArray, ...
                nbRepetitions, ...
                waitForSwtich);

WaitSecs(waitAfter)

playMotionSound('vertical', ...
                speakerIdxDownward, ...
                soundArray, ...
                nbRepetitions, ...
                waitForSwtich);

WaitSecs(waitAfter)

playMotionSound('vertical', ...
                speakerIdxUpward, ...
                soundArray, ...
                nbRepetitions, ...
                waitForSwtich);

WaitSecs(waitAfter)

end

%% 0.425
% loadAudio

[outSound, fs] = audioread(fullfile(soundPath, 'pink_0p425_ramp100ms.wav'));

% cutAudio

[soundArray] = cutSoundArray(outSound, 'pinknoise', fs, nbSpeakers, 0);

pressSpaceForMeOrWait(pacedByUser, waitForAWhile)

for i = 1:nbCycles

playMotionSound('horizontal', ...
                speakerIdxRightward, ...
                soundArray, ...
                nbRepetitions, ...
                waitForSwtich);

WaitSecs(waitAfter)

playMotionSound('horizontal', ...
                speakerIdxLeftward, ...
                soundArray, ...
                nbRepetitions, ...
                waitForSwtich);

WaitSecs(waitAfter)

playMotionSound('vertical', ...
                speakerIdxDownward, ...
                soundArray, ...
                nbRepetitions, ...
                waitForSwtich);

WaitSecs(waitAfter)

playMotionSound('vertical', ...
                speakerIdxUpward, ...
                soundArray, ...
                nbRepetitions, ...
                waitForSwtich);

WaitSecs(waitAfter)

end
