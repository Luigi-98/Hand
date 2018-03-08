import java.lang.Math;

PVector y=new PVector(0,-1);
PVector F,A,B,C,d;
PVector F0,A0,B0,C0;
PVector F1,A1,B1,C1;
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
  
  F0=F.copy();
  A0=PVector.mult(d,A.y);
  A0.rotate(A.x*0);
  A0.add(F0);
  B0=PVector.mult(PVector.sub(A0,F0).normalize(),B.y);
  B0.rotate(B.x*0);
  B0.add(A0);
  C0=PVector.mult(PVector.sub(B0,A0).normalize(),C.y);
  C0.rotate(C.x*0);
  C0.add(B0);
  
  nFA1=nFA2=nAB1=nAB2=nBC1=nBC2=y;
}

void draw()
{
  background(0,255,255);
  //A.x+=(float)java.lang.Math.PI/200;
  //C.x+=(float)java.lang.Math.PI/800;
  drawSkeleton();
  addVertices();
  computeRealVertices();
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

void computeRealVertices()
{
  PVector nF0=nFA1.copy(),nA0=nFA1.copy(),nA1=nAB1.copy(),nB0=nAB2.copy(),nB1=nBC1.copy(),nC0=nBC2.copy();
  F1=F;
  A1=PVector.mult(d,A.y);
  A1.rotate(A.x);
  nA0.rotate(A.x);
  nA1.rotate(A.x);
  nB0.rotate(A.x);
  nB1.rotate(A.x);
  nC0.rotate(A.x);
  B1=PVector.mult(A1.copy().normalize(),B.y); // Aggiungere F a tutte cose
  B1.rotate(B.x);
  nB0.rotate(B.x);
  nB1.rotate(B.x);
  nC0.rotate(B.x);
  C1=PVector.mult(B1.copy().normalize(),C.y);
  C1.rotate(C.x);
  nC0.rotate(C.x);
  A1.add(F);
  B1.add(A1);
  C1.add(B1);
  nF=nF0; nA=PVector.mult(PVector.add(nA0,nA1),0.5); nB=PVector.mult(PVector.add(nB0,nB1),0.5); nC=nC0;
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
    //if (i>0) line(P[i-1].x,P[i-1].y,P[i].x,P[i].y);
  }
}

void flex()
{
  for (int i=0; i<n; i++)
  {
    float R=PVector.dot(PVector.sub(A0,F0),PVector.sub(P[i],F0))/PVector.sub(A0,F0).magSq(); //calcolato su F1A1
    /**
      NOTA1 B1ENE: VERIF1IC1A1RE C1HE |X-0.5|<=0.5 È EQUIVA1LENTE A1 VERIF1IC1A1RE C1HE X\IN[0,1]
    **/
    
    if (R>=0&&R<=1){
      P1[i]=PVector.add(PVector.add(F1,PVector.mult(PVector.sub(A1,F1).normalize(),R)),PVector.mult(normal(R,nF,nA),thickness));}
    else if (java.lang.Math.abs((R=PVector.dot(PVector.sub(B0,A0),PVector.sub(P[i],A0))/PVector.sub(B0,A0).magSq())-0.5)<=0.5) //calcolato su A1B1
      P1[i]=PVector.add(PVector.add(A1,PVector.mult(PVector.sub(B1,A1).normalize(),R)),PVector.mult(normal(R,nA,nB),thickness));
    else if (java.lang.Math.abs((R=PVector.dot(PVector.sub(C0,B0),PVector.sub(P[i],B0))/PVector.sub(C0,B0).magSq())-0.5)<=0.5) //calcolato su B1C1
      P1[i]=PVector.add(PVector.add(B1,PVector.mult(PVector.sub(C1,B1).normalize(),R)),PVector.mult(normal(R,nB,nC),thickness));
    else
      {println("MA COSA HAI SCRITTO? C'È UN PEZZO DI MESH FUORI DALLO SCHELETRO!");}
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



// PROBLEMA! PER QUALCHE MOTIVO I PUNTI VENGONO MESSI TUTTI IN CIRCA 3 PUNTI