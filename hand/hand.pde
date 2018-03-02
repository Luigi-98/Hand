import java.lang.Math;

PVector F,A,B,C,d;

void setup()
{
  size(1024,768);
  background(0);
  stroke(255,255,0);
  fill(255);
  
  F=new PVector(100,100);
  A=new PVector(0,250);
  B=new PVector((float)java.lang.Math.PI/2,250);
  C=new PVector(0,250);
  d=new PVector(1,0);
}

void draw()
{
  drawSkeleton();
}

void drawSkeleton()
{
  PVector FA=PVector.mult(d,A.y);
  FA.rotate(A.x);
  PVector AB=PVector.mult(FA.copy().normalize(),B.y); // Aggiungere F a tutte cose
  AB.rotate(B.x);
  PVector BC=PVector.mult(AB.copy().normalize(),C.y);
  FA.add(F);
  AB.add(FA);
  BC.add(AB);
  line(F.x,F.y,FA.x,FA.y);
  line(FA.x,FA.y,AB.x,AB.y);
  line(AB.x,AB.y,BC.x,BC.y);
}