unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OpenGL, Menus;

type

  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key:Word;
      Shift: TShiftState);
    procedure FormResize(Sender: TObject);
  private
    DC: HDC;
    hrc: HGLRC;
    ry : GLfloat;
    tx : GLfloat;
end;

var
  frmGL: TForm1;
  mode : (POINT, LINE, FILL) = FILL;
  glutobj: (CUBE, SPHERE, CONE, TORUS, DODECAHEDRON,
    ICOSAHEDRON, TETRAHEDRON, TEAPOT) = CUBE;
  Form1: TForm1;

implementation

uses DGLUT;
{$R *.dfm}

procedure TForm1.FormPaint(Sender: TObject);
begin
  glClear (GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
  glPushMatrix;
  glRotatef (ry, 0.0,1.0, 0.0);
  glTranslatef (tx, 0.0, 0.0);

           glColor3f(1,1,0);
           glTranslatef(0,0,0.2);              //tail
           glutSolidSphere(0.15,20,20);
           glPopMatrix;

           glTranslatef(0,0,1.3);            //mid
           glutSolidSphere(1,30,30);
           glPopMatrix;

           glTranslatef(0,0,1);             //head
           glutSolidSphere(0.6,30,30);
           glPopMatrix;

           glColor3f(1,1,0);              //leg

           glBegin(GL_LINES);
           glVertex3f(-0.7,-0.9,-1.2);
           glVertex3f(-1.2,-1.9,-1);
           glEnd;

           glBegin(GL_LINES);
           glVertex3f(-0.7,-0.9,-1.7);
           glVertex3f(-1,-1.9,-1.5);
           glEnd;

           //right eye
           glColor3f(0,0,0);
           glPushMatrix;
           glTranslatef(0.2,-1.3,-0.1);
           glutSolidSphere (0.05, 20, 20);
           glPopMatrix;

           // beak
           glColor3f(1,0,0);
           glpushMatrix;
           glTranslatef(0,0.2,0.2);
           glutSolidCone (0.2, 1, 10, 10);
           glPopmatrix;

          //plate
           glRotatef(-90, 0, 0,1);
           glRotatef(-70, 1, 0,0);
           glColor3f(0.8,0.8,0.5) ;
           glpushMatrix;
           glTranslatef(0.7,3.5,-3);
           glutSolidTorus(0.5, 0.5, 20, 20);
           glPopmatrix;

         //glRotatef(-90, 0, 0,1);
           glColor3f(1,1,1);
           glTranslatef(0.9,3.5,-1.8);            //egg
           glutSolidSphere(0.8,30,30);
           glPopMatrix;

  SwapBuffers(DC);
end;

procedure SetDCPixelFormat (hdc : HDC);
var
  pfd : TPixelFormatDescriptor;
  nPixelFormat: Integer;
begin
  FillChar (pfd, SizeOf (pfd), '0');
  pfd.dwFlags := PFD_DRAW_TO_WINDOW or PFD_SUPPORT_OPENGL or PFD_DOUBLEBUFFER;
  nPixelFormat := ChoosePixelFormat (hdc, @pfd);
  SetPixelFormat (hdc, nPixelFormat, @pfd);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  DC := GetDC (Handle);
  SetDCPixelFormat(DC);
  hrc := wglCreateContext(DC);
  wglMakeCurrent(DC, hrc);
  glClearColor (0.5, 0.5,0.75,	1.0); // ???? ????
  glLineWidth (1.5);
  glEnable (GL_LIGHTING); //включает режим освещенности
  glEnable (GL_LIGHT0);   //задает первый источник света
  glEnable (GL_DEPTH_TEST);  //    позволяет работать в 3д
  glEnable (GL_COLOR_MATERIAL); //при включенном свете учитывает исходный цвет фигуры
  glColor3f (0, 0.0,1.0);
  ry := 0.0;
  tx := 0.0;
end;

procedure TForm1.FormDestroy (Sender: TObject);
begin
  wglMakeCurrent(0, 0);
  wglDeleteContext(hrc);
  ReleaseDC (Handle, DC);
  DeleteDC (DC);
end;

procedure TForm1.FormKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  If Key = VK_ESCAPE then Close;

  If Key = VK_LEFT then begin
    ry:= ry + 2.0;
    InvalidateRect(Handle, nil, False);
  end;

  If Key = VK_RIGHT then begin
    ry := ry - 2.0;
    InvalidateRect(Handle, nil, False);
  end;

  If Key = VK_UP then begin
    tx := tx - 0.1;
    InvalidateRect(Handle, nil, False);
  end;

  If Key = VK_DOWN then begin
    tx := tx + 0.1;
    InvalidateRect(Handle, nil, False);
  end;

  If Key = 49 then begin
    mode := POINT;
    InvalidateRect(Handle, nil, False);
  end;

  If Key = 50 then begin
    mode := LINE;
    InvalidateRect(Handle, nil, False);
  end;

  If Key = 51 then begin
    mode := FILL;
    InvalidateRect(Handle, nil,	False);
  end;

  If Key = 52 then begin
    Inc (glutobj);
    If glutobj > High(glutobj) then glutobj := Low(glutobj);
    InvalidateRect(Handle, nil, False);
  end;
end;

procedure TForm1.FormResize (Sender: TObject);
begin
  glViewport(0, 0, ClientWidth, ClientHeight);
  glMatrixMode (GL_PROJECTION);
  glLoadIdentity;
  glFrustum (-1,1, -1, 1,2, 9);
  glMatrixMode (GL_MODELVIEW);
  glLoadIdentity;

  glTranslatef(0.0, 0.0, -8);
  glRotatef(-90.0, 1.0, 0.0, 0.0);
  glRotatef(-90.0, 0.0, 1,0.0);
  InvalidateRect(Handle, nil, False);
end;

end.

 