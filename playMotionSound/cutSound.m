eventFilename = '1300_pn_25speaker_event.wav';
targetFilename = '600_pn_25speaker_target.wav';
filePath = 'C:\Users\Steph\Documents\MATLAB\Stephanie\Steph_sounds';

num_speakers = 31;
lengthEvent = 1.2;
lengthTarget = 0.6;


 %% cut EVENT sounds
[Y,FS] = audioread(eventFilename);
num_samp = floor(FS/(1/(lengthEvent/num_speakers))); % Number of samples in a segment

for sound=1:num_speakers
    if sound==1;
        audiowrite(['pn_event_speak',num2str(sound),'_31.wav'], Y(1:num_samp), FS); % if 1 second removed from end
    else
        audiowrite(['pn_event_speak',num2str(sound),'_31.wav'], Y((sound-1)*num_samp:sound*num_samp), FS); % if 1 second removed from end
    end
end
fprintf('Cut Event Pink Noise: Done\n')

%% cut TARGET souncs
[Y,FS] = audioread(targetFilename);
num_samp = floor(FS/(1/(lengthTarget/num_speakers))); % Number of samples in a segment

for sound=1:num_speakers
    if sound==1;
        audiowrite(['pn_target_speak',num2str(sound),'_31.wav'], Y(1:num_samp), FS); % if 1 second removed from end
    else
        audiowrite(['pn_target_speak',num2str(sound),'_31.wav'], Y((sound-1)*num_samp:sound*num_samp), FS); % if 1 second removed from end
    end
end
fprintf('Cut Target Pink Noise: Done\n')
