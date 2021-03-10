% (C) Copyright 2020 CPP_PTB developers

function pressSpaceForMeOrWait(pacedByUser, waitForAWhile)

  % pressSpaceForMe()
  %
  % Use that to stop your script and only restart when the space bar is pressed.
  %

  if pacedByUser

    fprintf('\nPress space to continue.\n');

    while 1

      WaitSecs(0.1);

      [~, keyCode, ~] = KbWait(-1);

      if strcmp(KbName(find(keyCode)), 'space')
        fprintf('starting the experiment...\n');
        break
      end

    end

  else

    WaitSecs(waitForAWhile)

  end
