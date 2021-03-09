% (C) Copyright 2017 Stephanie Cattoir
% (C) Copyright 2021 CPP LePoulpe developers

% This script shows visual motion (rightward + leftward) lighting up subsequent LEDes
% in the horizontal arm with different speeds

% if jump 2
% 1) use the second line of three_speed and comment the first.
% 2) first line of RIGHTWARDS and LEFTWARDS, replace the values of jump by -2 and 2. (lines 17 and 56)
% 3) comment twice the WaitSecs lines 46 and 85 (comments are: wait for the central led)

two_speeds = [0.0085 0.018];  %  0.0077 0.012]; %correspond to [EVENT  TARGET200%  TARGET150%]
repetitions = 2;
% three_speeds=2*[0.0163 0.0077 0.013]; %jump of 2
for s = 1:length(two_speeds)
    speed = two_speeds(s);
    fprintf ('\n\nSpeed is %f', speed);

    %% RIGHTWARDS
    jump = -1; % 1 = towards left & -1 = towards right
    for k = 1:repetitions  % :2;
        loop_start = GetSecs();
        for part = 2:-1:1
            if part == 1
                pin_start = 32;
                pin_end = 63; % 24
            elseif part == 2
                pin_start = 64; % 31 if central led has to light on, 32 if not.
                pin_end = 95; % 63;
            end
            nb_pin = pin_end - pin_start;
            if jump > 0
                a = min(pin_start, pin_end - 1);
                b = max(pin_start, pin_end - 1);
            elseif jump < 0
                a = max(pin_start, pin_end - 1);
                b = min(pin_start, pin_end - 1);
            end

            dio = digitalio('nidaq', 'PXI1Slot4');
            addline(dio, pin_start:pin_end - 1, 'out');
            for i = a:jump:b % 0:jump:nb_pin-1; %pin_start:jump:pin_end-1;% i=0:2:9
                data = dec2binvec(2^(i - min(a, b)), nb_pin); % 2^0 = 1, 2^1 = 2
                putvalue(dio, data); % ONLY one pin is open! putvalue(dio,pin)
                time = 0;
                t = GetSecs();
                while time < speed
                    time = GetSecs() - t;
                end
            end
            if part == 2
                WaitSecs(speed - 0.0025); % wait for the central LED
            end
            putvalue(dio, 0);
        end

        loop_time = GetSecs() - loop_start;
        delete(dio);
        clear dio;
        fprintf('\nRightwards duration time %f is %f', k, loop_time);
        WaitSecs(1);
    end

    %% LEFTWARDS
    jump = 1; % 1 = towards left & -1 = towards right
    for k = 1:repetitions
        loop_start = GetSecs();
        for part = 1:2  % 1:2 for leftwards, 2:-1:1 for rightwards

            if part == 1
                pin_start = 32;
                pin_end = 63; % 24
            elseif part == 2
                pin_start = 64; % 31 if central led has to light on, 32 if not.
                pin_end = 95; % 63;
            end
            nb_pin = pin_end - pin_start;
            if jump > 0
                a = min(pin_start, pin_end - 1);
                b = max(pin_start, pin_end - 1);
            elseif jump < 0
                a = max(pin_start, pin_end - 1);
                b = min(pin_start, pin_end - 1);
            end
            dio = digitalio('nidaq', 'PXI1Slot4');
            addline(dio, pin_start:pin_end - 1, 'out');
            for i = a:jump:b % 0:jump:nb_pin-1; %pin_start:jump:pin_end-1;% i=0:2:9
                data = dec2binvec(2^(i - min(a, b)), nb_pin); % 2^0 = 1, 2^1 = 2
                putvalue(dio, data); % ONLY one pin is open! putvalue(dio,pin)
                time = 0;
                t = GetSecs();
                while time < speed
                    time = GetSecs() - t;
                end
                % puts zero == turn off %putvalue(dio.Line(pin),0)
            end
            if part == 1
                WaitSecs(speed - 0.0025); % wait for the central LED
            end
            putvalue(dio, 0);
        end
        delete(dio);
        clear dio;
        loop_time = GetSecs() - loop_start;
        fprintf('\nLeftwards duration time %f is %f', k, loop_time);
        WaitSecs(1);
    end
end
