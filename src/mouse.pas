unit Mouse;

{$G+}

interface


const
  LEFT_BUTTON = 1;
  RIGHT_BUTTON = 2;

function InitMouse: word; 
procedure GetMouseStatus(var x, y: word);
function LeftButtonPressed: boolean;
function RightButtonPressed: boolean;

implementation

var 
  mouseButtons : byte;

function InitMouse: word; assembler;
asm
  mov  ax, 0
  int  33h

  mov  ax, 7
  mov  cx, 0
  mov  dx, 639
  int  33h

  mov  ax, 8
  mov  cx, 0
  mov  dx, 199
  int  33h

end;


procedure GetMouseStatus(var x, y: word); assembler;
asm
  mov  ax, 3
  int  33h
  lds  di, [x]
  shr  cx, 1
  mov  ds:[di], cx   {Store x coordinate}
  lds  di, [y]
  mov  ds:[di], dx   {Store y coordinate}
  mov  di, offset mouseButtons
  mov  ds:[di], bl   {Store button status}
end;

function LeftButtonPressed: boolean;
begin
  LeftButtonPressed := (mouseButtons and LEFT_BUTTON) <> 0;
end;

function RightButtonPressed: boolean;
begin
  RightButtonPressed := (mouseButtons and RIGHT_BUTTON) <> 0;
end;

end.