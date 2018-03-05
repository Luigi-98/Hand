import java.lang.Math;

PVector y=new PVector(0,-1);
PVector F,A,B,C,d;
PVector nFA1,nFA2,nAB1,nAB2,nBC1,nBC2;
PVector nF,nA,nB,nC;
float thickness=70;

int n=50;
PVector P[]=new PVector[n],P1[]=new PVector[n];

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
  
  nFA1=nFA2=nAB1=nAB2=nBC1=nBC2=y;
}

void draw()
{
  background(0,255,255);
  /*B.x+=(float)java.lang.Math.PI/200;
  C.x+=(float)java.lang.Math.PI/800;*/
  drawSkeleton();
  addVertices();
  flex();
  drawMesh();
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

void drawMesh()
{
  for (int i=0; i<n; i++)
  {
    point(P1[i].x,P1[i].y);
  }
}

void addVertices()
{
  for (int i=0; i<n; i++)
  {
    P[i]=PVector.mult(d,(A.y+B.y+C.y)*i/n); // stiamo accorciando la mesh per farla finire con lo scheletro in modo che $\exists R\in[0,1]:$ carino.
    P[i].add(PVector.mult(y,thickness));
    P[i].add(F);
    if (i>0) line(P[i-1].x,P[i-1].y,P[i].x,P[i].y);
  }
}

void flex()
{
  for (int i=0; i<n; i++)
  {
    float R=PVector.dot(PVector.sub(A,F),PVector.sub(P[i],A))/PVector.sub(A,F).magSq(); //calcolato su FA
    if (R>=0&&R<=1)
      P1[i]=PVector.add(PVector.add(F,PVector.mult(PVector.sub(A,F).normalize(),R)),PVector.mult(normal(R,nF,nA),thickness));
    else if ((R=PVector.dot(PVector.sub(B,A),PVector.sub(P[i],B))/PVector.sub(B,A).magSq())>=0&&R<=1) //calcolato su AB
      P1[i]=PVector.add(PVector.add(A,PVector.mult(PVector.sub(B,A).normalize(),R)),PVector.mult(normal(R,nA,nB),thickness));
    else if ((R=PVector.dot(PVector.sub(C,B),PVector.sub(P[i],C))/PVector.sub(C,B).magSq())>=0&&R<=1) //calcolato su BC
      P1[i]=PVector.add(PVector.add(B,PVector.mult(PVector.sub(C,B).normalize(),R)),PVector.mult(normal(R,nB,nC),thickness));
    else
      println("MA COSA HAI SCRITTO? C'È UN PEZZO DI MESH FUORI DALLO SCHELETRO!");
  }
}

PVector normal(float R, PVector n1, PVector n2)
{
  float pD=0.2, pP=0.8;
  if (R<=pD)
    return n1;
  else if (R>=pD)
    return n2;
  else
    return PVector.add(n1,PVector.mult(PVector.sub(n2,n1),(R-pD)/(pP-pD)));
}