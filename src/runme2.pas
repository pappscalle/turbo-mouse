program Runme;

{$G+}

uses crt, gfx;

const
  LEFT_BUTTON = 1;
  RIGHT_BUTTON = 2;

  CURSOR_SIZE = 8;

  cursor: array[0..CURSOR_SIZE-1, 0..CURSOR_SIZE-1] of byte = 
  ((0,0,0,0,0,0,0,0),
   (0,1,1,1,1,1,1,0),
   (0,1,1,1,1,1,0,0),
   (0,1,1,1,1,0,0,0),
   (0,1,1,1,1,0,0,0),
   (0,1,1,0,0,1,0,0),
   (0,1,0,0,0,0,1,0),
   (0,0,0,0,0,0,0,0));

var 
  mouseX, mouseY : word;
  mouseButtons : byte;
  oldMouseX, oldMouseY : word;


function InitMouse: word; assembler;
asm
  mov ax,0
  int 33h

  mov ax,7
  mov cx,0
  mov dx, SCREEN_WIDTH * 2 - 1
  int 33h

  mov ax,8
  mov cx,0
  mov dx, SCREEN_HEIGHT - 1
  int 33h

end;

procedure GetMouseStatus(var x, y: word; var buttons: byte); assembler;
asm
  mov ax, 3
  int 33h
  lds di, [x]
  mov ds:[di], cx   {Store x coordinate}
  lds di, [y]
  mov ds:[di], dx   {Store y coordinate}
  lds di, [buttons]
  mov ds:[di], bl   {Store button status}
end;

function LeftButtonPressed: boolean;
begin
  LeftButtonPressed := (mouseButtons and LEFT_BUTTON) <> 0;
end;

function RightButtonPressed: boolean;
begin
  RightButtonPressed := (mouseButtons and RIGHT_BUTTON) <> 0;
end;


procedure DrawCursor(x, y: word);
var
  i, j: integer;    
begin
  for i := 0 to CURSOR_SIZE - 1 do
    for j := 0 to CURSOR_SIZE - 1 do
      if cursor[i, j] <> 0 then
        SetPixel(x + j, y + i, cursor[i, j]); 
end;

procedure DeleteCursor(x, y: word);
var
  i, j: integer;    
begin
  for i := 0 to CURSOR_SIZE - 1 do
    for j := 0 to CURSOR_SIZE - 1 do
      if cursor[i, j] = 1 then
        SetPixel(x + j, y + i, 0); 
end;

procedure XorCursor(x, y: word);
var
  i, j: integer;  
  p: word;
begin
  for i := 0 to CURSOR_SIZE - 1 do
    for j := 0 to CURSOR_SIZE - 1 do
      if cursor[i, j] <> 0 then
      begin
        p := (y+i)*320 + (x+j);
        mem[$A000:p] := mem[$A000:p] xor $0F;
      end;
end;


begin

  OpenGraphics;

  if (InitMouse = 0) then
  begin
    CloseGraphics;
    writeln('Mouse not detected!');
    halt(1);
  end;



  oldMouseX := 0;
  oldMouseY := 0;

  repeat
    GetMouseStatus(mouseX, mouseY, mouseButtons);
    mouseX := mouseX shr 1; {Scale down the mouse coordinates to fit the 320x200 resolution}

    XorCursor(oldMouseX, oldMouseY);
    XorCursor(mouseX, mouseY);

    oldMouseX := mouseX;
    oldMouseY := mouseY;

    if LeftButtonPressed then
      SetPixel(mouseX, mouseY, 15); {Draw a pixel when the left mouse button is pressed}
    
    WaitRetrace;

  until RightButtonPressed; {Exit when the right mouse button is pressed}

  CloseGraphics;

end.
