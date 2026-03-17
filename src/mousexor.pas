program XorMouseCursor;

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
  mov ax, 0
  int 33h

  mov ax, 7
  mov cx, 0
  mov dx, SCREEN_WIDTH * 2 - 1
  int 33h

  mov ax, 8
  mov cx, 0
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


procedure XorCursor(x, y: word); assembler;
asm

  mov  si, offset cursor

  les  di, ScreenTarget
  mov  ax, [y] 
  mov  dx, ax
  shl  ax, 2
  add  ax, dx
  shl  ax, 6
  add  ax, [x]
  add  di, ax

  mov  cx, CURSOR_SIZE

@xorLoop:
  push cx
  mov  cx, CURSOR_SIZE

@xorInnerLoop:
  lodsb
  test al, al
  jz   @skipPixel

  mov  ax, [es:di]
  xor  ax, 0Fh
  mov  [es:di], ax

@skipPixel:
  inc  di
  loop @xorInnerLoop
  add  di, SCREEN_WIDTH - CURSOR_SIZE

  pop  cx
  loop @xorLoop

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
