import java.lang.Math;

PVector y=new PVector(0,-1);
PVector F,A,B,C;                        // posizioni finali (polari relative) (tranne F che è cartesiano)
PVector d;
PVector F0,A0,B0,C0;                    // posizioni iniziali (cartesiane)
PVector F1,A1,B1,C1;                    // posizioni finali (cartesiane)
PVector nFA1,nFA2,nAB1,nAB2,nBC1,nBC2;  // normali iniziali (cartesiane)
PVector nF,nA,nB,nC;                    // normali finali mediate (cartesiane)

float thickness=85;
int n=50;
float thicknesses[]=new float[2*n];
PVector P[]=new PVector[2*n], P1[]=new PVector[2*n];

long time=0;

void setup()
{
  size(1024,768);
  background(255,255,255);
  stroke(0,0,0);
  fill(255,255,255);
  
  F=new PVector(200,130);
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
  time=millis();
}

void draw()
{
  background(255,255,255);
  /*A.x+=(float)java.lang.Math.PI/12000;
  B.x+=(float)java.lang.Math.PI/1800;
  C.x+=(float)java.lang.Math.PI/2000;*/
  
  // SIN^2 è periodico di periodo 2pi ed è compreso tra 0 e 1.
  
  A.x=(float)(java.lang.Math.PI/4*pow((float)java.lang.Math.sin((millis()-time)*java.lang.Math.PI/5000),2));
  B.x=(float)(java.lang.Math.PI/1.8*pow((float)java.lang.Math.sin((millis()-time)*java.lang.Math.PI/5000),2));
  C.x=(float)(java.lang.Math.PI/2*pow((float)java.lang.Math.sin((millis()-time)*java.lang.Math.PI/5000),2));
  addVertices();
  computeRealVertices();
  flex();
  drawMesh();
  drawSkeleton();
  //for (int i=0; i<A.y+B.y+C.y; i++) println(dito(i));
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
  ellipse(F.x,F.y,5,5);
  ellipse(FA.x,FA.y,5,5);
  ellipse(AB.x,AB.y,5,5);
  ellipse(BC.x,BC.y,5,5);
  line(F.x,F.y,FA.x,FA.y);
  line(FA.x,FA.y,AB.x,AB.y);
  line(AB.x,AB.y,BC.x,BC.y);
}

void addVertices()
{
  for (int i=0; i<n; i++)
  {
    P[i]=PVector.mult(d,(A.y+B.y+C.y)*i/n); // stiamo accorciando la mesh per farla finire con lo scheletro in modo che $\exists R\in[0,1]:$ carino.
    P[i].add(PVector.mult(y,thickness*dito((A.y+B.y+C.y)*i/n,8.0)));
    P[i].add(F);
    //if (i>0) line(P[i-1].x,P[i-1].y,P[i].x,P[i].y);
  }
  for (int i=0; i<n; i++)
  {
    P[n+i]=PVector.mult(d,(A.y+B.y+C.y)*(n-i)/n); // stiamo accorciando la mesh per farla finire con lo scheletro in modo che $\exists R\in[0,1]:$ carino.
    P[n+i].add(PVector.mult(y,-thickness*dito((A.y+B.y+C.y)*(n-i)/n,1.8)));
    P[n+i].add(F);
    //if (i>0) line(P[i-1].x,P[i-1].y,P[i].x,P[i].y);
  }
  
  for (int i=0; i<2*n; i++)
  {
    thicknesses[i]=PVector.dot(y,PVector.sub(PVector.sub(P[i],F0),PVector.mult(d,PVector.dot(PVector.sub(P[i],F0),d))));
  }
}

float dito(float x, float param)
{
  if (x<A.y+B.y+C.y*(param-1)/param)
    return 1;
  else
    return 1/5.0*(6.0*pow(param/C.y*(A.y+B.y+C.y-x),1/3.0)-pow(param/C.y*(A.y+B.y+C.y-x),2.0));
}

void computeRealVertices()
{
  PVector nF0=nFA1.copy(),nA0=nFA2.copy(),nA1=nAB1.copy(),nB0=nAB2.copy(),nB1=nBC1.copy(),nC0=nBC2.copy();
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
  nA1.rotate(B.x);
  nB0.rotate(B.x);
  nB1.rotate(B.x);
  nC0.rotate(B.x);
  C1=PVector.mult(B1.copy().normalize(),C.y);
  C1.rotate(C.x);
  nB1.rotate(C.x);
  nC0.rotate(C.x);
  A1.add(F);
  B1.add(A1);
  C1.add(B1);
  nF=nF0; nA=PVector.add(nA0,nA1).normalize(); nB=PVector.add(nB0,nB1).normalize(); nC=nC0;
}

void flex()
{
  for (int i=0; i<2*n; i++)
  {
    float R=PVector.dot(PVector.sub(A0,F0),PVector.sub(P[i],F0))/PVector.sub(A0,F0).magSq(); //calcolato su F1A1
    /**
      NOTA1 B1ENE: VERIF1IC1A1RE C1HE |X-0.5|<=0.5 È EQUIVA1LENTE A1 VERIF1IC1A1RE C1HE X\IN[0,1]
    **/
    
    if (R>=0&&R<=1){
      P1[i]=PVector.add(PVector.add(F1,PVector.mult(PVector.sub(A1,F1),R)),PVector.mult(normal(R,nF,nA),thicknesses[i]));}
    else if (java.lang.Math.abs((R=PVector.dot(PVector.sub(B0,A0),PVector.sub(P[i],A0))/PVector.sub(B0,A0).magSq())-0.5)<=0.5) {//calcolato su A1B1
      P1[i]=PVector.add(PVector.add(A1,PVector.mult(PVector.sub(B1,A1),R)),PVector.mult(normal(R,nA,nB),thicknesses[i]));}
    else if (java.lang.Math.abs((R=PVector.dot(PVector.sub(C0,B0),PVector.sub(P[i],B0))/PVector.sub(C0,B0).magSq())-0.5)<=0.5) {//calcolato su B1C1
      P1[i]=PVector.add(PVector.add(B1,PVector.mult(PVector.sub(C1,B1),R)),PVector.mult(normal(R,nB,nC),thicknesses[i]));}
    else
      {println(R,"MA COSA HAI SCRITTO? C'È UN PEZZO DI MESH FUORI DALLO SCHELETRO!");}
  }
}

void drawMesh()
{
  beginShape();
  curveVertex(P1[0].x,P1[0].y);
  for (int i=0; i<2*n; i++)
  {
    curveVertex(P1[i].x,P1[i].y);
    //point(P1[i].x,P1[i].y);
  }
  curveVertex(P1[2*n-1].x,P1[2*n-1].y);
  endShape();
}

PVector normal(float R, PVector n1, PVector n2)
{
  float pD=0.1, pP=0.9;
  if (R<=pD)
    return n1;
  else if (R>=pP)
    return n2;
  else
    return PVector.add(n1,PVector.mult(PVector.sub(n2,n1),(R-pD)/(pP-pD)));
}