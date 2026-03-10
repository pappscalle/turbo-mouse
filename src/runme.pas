program Runme;

{$G+}

uses crt, gfx;

begin

  OpenGraphics;

  repeat

    SetPixel(random(320), random(200), random (256));

  until KeyPressed;

  CloseGraphics;

end.
