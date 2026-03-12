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

  mov ax, 7
  mov cx, 0
  mov dx, SCREEN_WIDTH-1
  int 33h
end;

procedure GetMouseStatus(var x, y: word; var buttons: byte); assembler;
asm
  mov ax, 3
  int 33h
  les di, [x]
  mov es:[di], cx     {Store x coordinate}
  mov es:[di+2], dx   {Store y coordinate}
  mov es:[di+4], bl   {Store button status}
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

  OpenGraphics;

  if (InitMouse = 0) then
  begin
    CloseGraphics;
    writeln('Mouse not detected!');
    halt(1);
  end;

  repeat
    GetMouseStatus(mouseX, mouseY, mouseButtons);

    if LeftButtonPressed then
      SetPixel(mouseX, mouseY, 15); {Draw a pixel when the left mouse button is pressed}
    
    WaitRetrace;

  until RightButtonPressed; {Exit when the right mouse button is pressed}

  CloseGraphics;

end.
