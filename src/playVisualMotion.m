% (C) Copyright 2017 Stephanie Cattoir
% (C) Copyright 2021 CPP LePoulpe developers

function playVisualMotion(direction, speed, speakerToJump, nbRepetition)

% This script shows visual motion (rightward + leftward) lighting up subsequent LEDes
% in the horizontal arm with different speeds



%%% if jump 2
%%% 1) use the second line of three_speed and comment the first.
%%% 2) first line of RIGHTWARDS and LEFTWARDS, replace the values of jump by -2 and 2. (lines 17 and 56)
%%% 3) comment twice the WaitSecs lines 46 and 85 (comments are: wait for the central led)
%%% three_speeds=2*[0.0163 0.0077 0.013]; %jump of 2

switch direction

    case 'rightward'

        % set the interval between LEDs to be considered
        % - +/-1 = all of them; +/-2 = 1 every thwo etc.
        % - positive = towards left; negative = towards right
        jump = speakerToJump * (- 1);

        % set the order about which horizontal arm (left or right) should be considered
        % - 1:2 for leftwards; 2:-1:1 for rightwards
        armOrder = 2:-1:1;

        pin_start_part1 = 32;
        pin_end_part1 = 63;

        pin_start_part2 = 64;
        pin_end_part2 = 95;

    case 'leftward'

        jump = speakerToJump * (1);

        armOrder = 1:2;

        pin_start_part1 = 32;
        pin_end_part1 = 63;

        pin_start_part2 = 64;
        pin_end_part2 = 95;

    case 'downward'

        jump = speakerToJump * (1);

        armOrder = 1:2;

        pin_start_part1 = 1;
        pin_end_part1 = 16;

        pin_start_part2 = 17;
        pin_end_part2 = 32;

    case 'upward'

        jump = speakerToJump * (- 1);

        armOrder = 2:-1:1;

        pin_start_part1 = 1;
        pin_end_part1 = 16;

        pin_start_part2 = 17;
        pin_end_part2 = 32;

end

fprintf ('\n\nSpeed is %f\n', speed);

for k = 1:nbRepetition

    % get a time stamp to check whether the motion display was on time
    loop_start = GetSecs();

    for part = armOrder

        if part == 1

            pin_start = pin_start_part1;

            pin_end = pin_end_part1;

        elseif part == 2

            pin_start = pin_start_part2; % 31 if central led has to light on, 32 if not.

            pin_end = pin_end_part2; % 63;

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

        loop_time = GetSecs() - loop_start;

        delete(dio);

        clear dio;

        fprintf('\n duration time %f is %f', k, loop_time);



    end

    WaitSecs(1);
end
