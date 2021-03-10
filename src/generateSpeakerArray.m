% (C) Copyright 2021 CPP LePoulpe developers

function speakerIdx = generateMotionnDirecetionSpeakerArray(input)

  % map the arms with directions

  % horizontal
  horCenter = 31;
  % rightward
  horLeftToCenterMinusOne = 1:15;
  horCenterPlusOneToRight = 30:-1:16;
  % leftward
  horRightToCenterMinusOne = 16:30;
  horCenterPlusOneToLeft = 15:-1:1;

  % vertical
  vertCenter = 31;
  % downward
  vertUptoCenterMinusOne = 1:15;
  vertCenterPlusOneToDown = 30:-1:16;
  % upward
  vertDownToCenterMinusOne = 16:30;
  vertCenterPlusOnetoUp = 15:-1:1;

  %  create the entire

  switch input

    case 'rightward'

        speakerIdx = [ horRightToCenterMinusOne horCenter horCenterPlusOneToLeft ];

    case 'leftward'

        speakerIdx = [ horLeftToCenterMinusOne horCenter horCenterPlusOneToRight ];

    case 'downward'

        speakerIdx = [ vertUptoCenterMinusOne vertCenter vertCenterPlusOneToDown ];

    case 'upward'

        speakerIdx = [ vertDownToCenterMinusOne vertCenter vertCenterPlusOnetoUp ];

  end

end
