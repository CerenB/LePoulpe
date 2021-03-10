% (C) Copyright 2017 Stephanie Cattoir
% (C) Copyright 2021 CPP LePoulpe developers

% This script shows visual motion (rightward + leftward) lighting up subsequent LEDes
% in the horizontal arm with different speeds
%
%%% if jump 2
%%% 1) use the second line of three_speed and comment the first.
%%% 2) first line of RIGHTWARDS and LEFTWARDS, replace the values of jump by -2 and 2. (lines 17 and 56)
%%% 3) comment twice the WaitSecs lines 46 and 85 (comments are: wait for the central led)
%%% three_speeds=2*[0.0163 0.0077 0.013]; %jump of 2


% set a vector with the speeds to display
two_speeds = [0.0085 0.018]*2;

% set how many times a directions should be display
repetitions = 2;

% set the interval between LEDs to be considered
% - +/-1 = all of them; +/-2 = 1 every thwo etc.
% - positive = towards left; negative = towards right
jump = [1, -1];

% set the order about which horizontal arm (left or right) should be considered
% - 1:2 for leftwards; 2:-1:1 for rightwards
armOrder = [1:2; 2:-1:1];

% loop through speeds
for iSpeed = 1:length(two_speeds)

  speed = two_speeds(iSpeed);

  fprintf ('\n\nSpeed is %f', speed);

  % loop
  for iDirection = 1:2

    for k = 1:repetitions

      % get a time stamp to check whether the motion display was on time
      loop_start = GetSecs();

      for part = armOrder(iDirection, :)

        if part == 1

          pin_start = 1;

          pin_end = 16; % 24

        elseif part == 2

          pin_start = 17; % 31 if central led has to light on, 32 if not.

          pin_end = 32; % 63;

        end

        nb_pin = pin_end - pin_start;

        if jump(iDirection) > 0

          a = min(pin_start, pin_end - 1);

          b = max(pin_start, pin_end - 1);

        elseif jump(iDirection) < 0

          a = max(pin_start, pin_end - 1);

          b = min(pin_start, pin_end - 1);

        end

        dio = digitalio('nidaq', 'PXI1Slot4');

        addline(dio, pin_start:pin_end - 1, 'out');

        for i = a:jump(iDirection):b % 0:jump:nb_pin-1; %pin_start:jump:pin_end-1;% i=0:2:9

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

      fprintf('\n duration time %f is %f', k, loop_time);

      WaitSecs(1);

    end

  end

end
