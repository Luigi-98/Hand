PVector F,A,B,C,d;

void setup()
{
  size(1024,768);
  background(0);
  stroke(255,255,0);
  fill(255);
  
  F=new PVector(0,0);
  A=new PVector(0,250);
  B=new PVector(0,250);
  C=new PVector(0,250);
  d=new PVector(1,0);
}

void draw()
{
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
  
}