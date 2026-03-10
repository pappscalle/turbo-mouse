program Runme;

{$G+}

uses crt, gfx;

const
  LEFT_BUTTON = 1;
  RIGHT_BUTTON = 2;

var 
  mouseX, mouseY : word;
  mouseButtons : byte;


function InitMouse: word; assembler;
asm
  mov ax, 0
  int 33h
end;

procedure GetMouseStatus(var x, y: word; var buttons: byte); assembler;
asm
  mov ax, 3
  int 33h
  les di, [x]
  mov es:[di], cx
  les di, [y]
  mov es:[di], dx
  les di, [buttons]
  mov es:[di], bl
end;


function LeftButtonPressed: boolean;
begin
  LeftButtonPressed := (mouseButtons and LEFT_BUTTON) <> 0;
end;

function RightButtonPressed: boolean;
begin
  RightButtonPressed := (mouseButtons and RIGHT_BUTTON) <> 0;
end;

begin

  if (InitMouse = 0) then
  begin
    writeln('Mouse not detected!');
    halt(1);
  end;


  OpenGraphics;

  repeat
    GetMouseStatus(mouseX, mouseY, mouseButtons);

    if LeftButtonPressed then
      SetPixel(mouseX div 2, mouseY, 15); {Draw a pixel when the left mouse button is pressed}
    
    WaitRetrace;

  until RightButtonPressed; {Exit when the right mouse button is pressed}

  CloseGraphics;

end.
