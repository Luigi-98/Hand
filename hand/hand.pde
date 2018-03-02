import java.lang.Math;

PVector F,A,B,C,d;
PVector nFA1,nFA2,nAB1,nAB2,nBC1,nBC2;
PVector nF,nA,nB,nC;

int n=50;
PVector P[]=new PVector[n];

void setup()
{
  size(1024,768);
  background(255);
  stroke(255,0,0);
  fill(0,255,255);
  
  F=new PVector(100,100);
  A=new PVector(0,250);
  B=new PVector(0,250);
  C=new PVector(0,250);
  d=new PVector(1,0);
}

void draw()
{
  background(0,255,255);
  /*B.x+=(float)java.lang.Math.PI/200;
  C.x+=(float)java.lang.Math.PI/800;*/
  drawSkeleton();
  addVertices();
}

void drawSkeleton()
{
  PVector FA=PVector.mult(d,A.y);
  FA.rotate(A.x);
  PVector AB=PVector.mult(FA.copy().normalize(),B.y); // Aggiungere F a tutte cose
  AB.rotate(B.x);
  PVector BC=PVector.mult(AB.copy().normalize(),C.y);
  BC.rotate(C.x);
  FA.add(F);
  AB.add(FA);
  BC.add(AB);
  line(F.x,F.y,FA.x,FA.y);
  line(FA.x,FA.y,AB.x,AB.y);
  line(AB.x,AB.y,BC.x,BC.y);
}

void addVertices()
{
  float thickness=70;
  for (int i=0; i<n; i++)
  {
    P[i]=PVector.mult(d,F.x+((A.y+B.y+C.y)*7/6)*i/n);
    P[i].add(new PVector(0,thickness));
    if (i>0) line(P[i-1].x,P[i-1].y,P[i].x,P[i].y);
  }
}

void flex()
{
  
}