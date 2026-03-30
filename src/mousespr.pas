program SpriteMouseCursor;

{$G+}

uses crt, gfx, mouse;
const 
  CURSOR_SIZE = 8;

type TCursor = array[0..CURSOR_SIZE-1, 0..CURSOR_SIZE-1] of byte;

const
  cursor: TCursor = 
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
  oldMouseX, oldMouseY : word;
  background: TCursor;


procedure SaveBackground(x, y: word); assembler;
asm
  les  si, ScreenTarget  

  mov  ax, [y]
  mov  dx, ax
  shl  ax, 2
  add  ax, dx
  shl  ax, 6
  add  ax, [x]
  add  si, ax           

  push ds               {swap ds and es to access video memory}
  mov ax, es
  mov ds, ax
  pop ax 
  mov es, ax

  lea  di, background   

  mov  cx, CURSOR_SIZE  
@loop:
  mov  bx, cx               
  mov  cx, CURSOR_SIZE  
  rep  movsb              
  add  si, SCREEN_WIDTH - CURSOR_SIZE  
  mov  cx, bx          
  loop @loop           

  push es
  pop ds
end;


procedure RestoreBackground(x, y: word); assembler;
asm
  lea si, background
  les di, ScreenTarget
  mov ax, [y]
  mov dx, ax
  shl ax, 2
  add ax, dx  
  shl ax, 6
  add ax, [x]
  add di, ax

  mov cx, CURSOR_SIZE
@loop:
  mov  bx, cx          
  mov  cx, CURSOR_SIZE 
  rep  movsb           
  add  di, SCREEN_WIDTH - CURSOR_SIZE 
  mov  cx, bx          
  loop @loop
end;

procedure DrawSprite(x, y: word); assembler;
asm
  lea si, cursor
   
  les  di, ScreenTarget
  mov  ax, [y] 
  mov  dx, ax
  shl  ax, 2
  add  ax, dx
  shl  ax, 6
  add  ax, [x]
  add  di, ax
  mov  cx, CURSOR_SIZE
@loop:
  mov  bx, cx
  mov  cx, CURSOR_SIZE
@innerLoop:
  lodsb
  test al, al
  jz   @skipPixel
  mov  [es:di], al
@skipPixel:
  inc  di
  loop @innerLoop
  add  di, SCREEN_WIDTH - CURSOR_SIZE
  mov  cx, bx
  loop @loop
end;



begin

  OpenGraphics;

  if InitMouse = 0 then
  begin
    CloseGraphics;
    writeln('Mouse not detected!');
    halt(1);
  end;

  oldMouseX := 0;
  oldMouseY := 0;

  SaveBackground(0, 0);

  repeat
    RestoreBackground(oldMouseX, oldMouseY); {Restore the background at the old cursor position}
    GetMouseStatus(mouseX, mouseY);
    if LeftButtonPressed then
      SetPixel(mouseX, mouseY, 15); {Draw a pixel when the left mouse button is pressed}

    SaveBackground(mouseX, mouseY); {Save the background under the cursor}
    DrawSprite(mouseX, mouseY); {Draw the cursor sprite at the current mouse position}
    oldMouseX := mouseX;
    oldMouseY := mouseY;  

    
    WaitRetrace;

  until RightButtonPressed; {Exit when the right mouse button is pressed}

  CloseGraphics;

end.
