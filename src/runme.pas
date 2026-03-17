program Runme;

{$G+}

uses crt, gfx, mouse;

const
  LEFT_BUTTON = 1;
  RIGHT_BUTTON = 2;

var 
  mouseX, mouseY : word;


begin

  OpenGraphics;

  if InitMouse = 0 then
  begin
    CloseGraphics;
    writeln('Mouse not detected!');
    halt(1);
  end;

  repeat
    GetMouseStatus(mouseX, mouseY);
    if LeftButtonPressed then
      SetPixel(mouseX, mouseY, 15); {Draw a pixel when the left mouse button is pressed}
    
    WaitRetrace;

  until RightButtonPressed; {Exit when the right mouse button is pressed}

  CloseGraphics;

end.
