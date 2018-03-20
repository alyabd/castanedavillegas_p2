import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
PImage img,img1,img2,img3,img4,img5,img6, img7, img8, img9;
int value=0, value2=0, value3=0, value4=0, value5=0, value6=0, value7=0, value8=0;
Pajaro una;

Box2DProcessing box2d;

ArrayList <Copo> coposNieve;
ArrayList <Pajaro> pajaros;
ArrayList <Lluvia> gotas;

class Copo{
  
  float x,y,w,h;
  Body c;
  
  Copo (float x_, float y_, float w_, float h_){
    x= x_;
    y = y_;
    w = w_;
    h = h_;
    
    
    BodyDef cn = new BodyDef(); 
    
    cn.type = BodyType.DYNAMIC;
    Vec2 xyEnBox2 = box2d.coordPixelsToWorld(new Vec2(x,y));
    cn.position.set(xyEnBox2);
   
    c = box2d.createBody(cn);
    
    
    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);
    sd.setAsBox(box2dW,box2dH);
    
    
    FixtureDef fd = new FixtureDef();
   
    fd.shape = sd;
    fd.density = 1;
    fd.friction = 2;
    fd.restitution = 0.5;
    
    
    
    c.createFixture(fd);    
    
    
  }
  
  void display(){
    
    Vec2 pos = box2d.getBodyPixelCoord(c);
    
    pushMatrix();
    translate(pos.x,pos.y);
    scale (0.02,0.02);
    image (img1,x,y);
    popMatrix();
  }  
}

class Pajaro
{
  
  float x,y,dx,dy;
  
 
  Pajaro(float x_, float y_, float dx_, float dy_)
  {
    x = x_;
    y= y_;
    dx = dx_;
    dy = dy_;
  }
  
 
  void movimiento(){
    x += dx;
    y += dy;
  }
  
 
  void display()
  {
  pushMatrix();
  translate(x,y);
  scale (0.020,0.020);
  image (img2,0,0);
  popMatrix();
  }
  //w=anch0 h=largo
  
  void rebota()
  {
    if (x > width)
    {
      x = width;
      dx= dx* -1;
    }
    if (x<0){
      x = 0;
      dx= dx* -1;
    }
    if (y<0){
      y = 0;
      dy*= -1;
    }
    if (y>height*1/4){
      y = height*1/4;
      dy*= -1;
    }
  }  
}

class Lluvia  {

  ArrayList <Particula> Particulas;    
  PVector o;         
  Lluvia (int num, PVector v) {
    Particulas = new ArrayList<Particula>();             
    o = v.get();                       

      for (int i = 0; i < num; i++) {
      Particulas.add(new Particula(o.x,o.y));    
    }
  }

  void caida() {

    for (Particula p: Particulas) {
      p.display();
    }

    
    for (int i = Particulas.size()-1; i >= 0; i--) {
      Particula p = Particulas.get(i);
      if (p.done()) {
        Particulas.remove(i);
      }
    }
  }

  void addParticulas(int n) {
    for (int i = 0; i < n; i++) {
      Particulas.add(new Particula(o.x,o.y));
    }
  }

  
  boolean dead() {
    if (Particulas.isEmpty()) {
      return true;
    } 
    else {
      return false;
    }
  }

}

class Particula {

  
  Body body;

  PVector[] trail;

  
  Particula(float x_, float y_) {
    float x = x_;
    float y = y_;
    trail = new PVector[6];
    for (int i = 0; i < trail.length; i++) {
      trail[i] = new PVector(x, y);
    }

    
    makeBody(new Vec2(x, y), 0.2f);
  }

  
  void killBody() {
    box2d.destroyBody(body);
  }

  
  boolean done() {
    
    Vec2 pos = box2d.getBodyPixelCoord(body);
   
    if (pos.y > height+20) {
      killBody();
      return true;
    }
    return false;
  }

  
  void display() {
    
    Vec2 pos = box2d.getBodyPixelCoord(body);

    
    for (int i = 0; i < trail.length-1; i++) {
      trail[i] = trail[i+1];
    }
    trail[trail.length-1] = new PVector(pos.x, pos.y);

    
    beginShape();
    fill(#34CCF5);
    strokeWeight(2);
    stroke(#34CCF5, 150);
  
    for (int i = 0; i < trail.length; i++) {
      vertex(trail[i].x, trail[i].y);
    }
    endShape();
  }

void makeBody(Vec2 center, float r) 
  {
   
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;

    bd.position.set(box2d.coordPixelsToWorld(center));
    body = box2d.createBody(bd);

   
    body.setLinearVelocity(new Vec2(random(-1, 1), random(-1, 1)));

    
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);

    FixtureDef fd = new FixtureDef();
    fd.shape = cs;

    fd.density = 1;
    fd.friction = 5;  
    fd.restitution = 0.5;

    
    body.createFixture(fd);
  }
}


void setup()
{
  size(900,600);
  img =loadImage ("FONDO.jpg");
  img1 =loadImage ("coponieve.png");
  img2 =loadImage ("PAJARO.png");
  img3 =loadImage ("MUJER.png");
  img4 =loadImage ("NIÑO.png");
  img5 =loadImage ("FuenteNueva.png");
  img6 =loadImage ("boton.png");
  img7 =loadImage ("salida.png");
  img8 =loadImage ("titulo.jpg");

  
  una= new Pajaro (0,0,10,15);
  
  pajaros = new ArrayList <Pajaro>();
  for (int i=0; i<5; i++)
  {
    pajaros.add (new Pajaro (random(400),random(400),random(5),random(10)));
  }
  
  
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0,-10);
  
  coposNieve = new ArrayList<Copo>();
  gotas = new ArrayList<Lluvia>();
}


void draw(){
  
  box2d.step();
 
  image (img8,0,0,width,height);
  
  
  //SALIR DEL JUEGO
  if (mousePressed && (mouseX>700) && (mouseX<=700+160) && (mouseY>308) && (mouseY<=308+240))
  {
    value3=2;
  }
  
  if (value3==2)
  {
    exit();
  }
 
  
  //PANTALLA DE JUEGO
  if (mousePressed && (mouseX>485) && (mouseX<=485+160) && (mouseY>308) && (mouseY<=308+240))
  {
    value3=1;
  }
  
  if (value3==1)
  {
    
  image (img,0,0,width,height);
  seleccion();
  }
  
  //LIMPIAR PANTALLA rect (330,550,50,50);
  if ((mousePressed) && (mouseX>330) && (mouseX<=330+50) && (mouseY>550) && (mouseY<=550+50))
  {
    value7=1;
  }
  
  if (value7==1)
  {
  println ("Limpieza de pantalla");
  
  value=0;
  value2=0;
  value4=0;
  value5=0;
  value6=0;
  value7=0;

  }
  
  //COPOS DE NIEVE
  if ((mousePressed) && (mouseX>0) && (mouseX<=0+50) && (mouseY>=550) && (mouseY<=550+50))
  {
    value=1;
    println (value);
  }
    if (value==1)
    {
      
      if (random(1) < 0.1)
  {
    Copo p = new Copo (random(width),random(height),5,5);
    coposNieve.add(p);
  }
  
  println ("Impresion de lluvia");
  for (Copo c:coposNieve){
    c.display();
  }
    }
    
  //IMPRESION DE PAJAROS
  if (mousePressed && (mouseX>75) && (mouseX<=75+50) && (mouseY>550) && (mouseY<=550+50))
  {
    value2=1;
  }
  if (value2==1)
  {
  println ("Impresion de pájaro");
  una.rebota();
 
  una.movimiento();
 
  una.display();
  
  
  for(Pajaro p:pajaros){
    p.display();
    p.movimiento();
    p.rebota();
  }
  
  }
  
  
  //IMPRESION DE MUJER
  if ((mousePressed) && (mouseX>140) && (mouseX<=140+50) && (mouseY>550) && (mouseY<=550+50))
  {
    value4=1;
  }
  
  if (value4==1)
  {
  println ("Impresion de mujer");
  
  mujer();
  
  }
  
   //IMPRESION DE NIÑO
  if ((mousePressed) && (mouseX>200) && (mouseX<=200+50) && (mouseY>550) && (mouseY<=550+50))
  {
    value5=1;
  }
  
  if (value5==1)
  {
  println ("Impresion de niño");
  
  nino();
  
  }
  
  //IMPRESION DE FUENTE
  if ((mousePressed) && (mouseX>255) && (mouseX<=255+50) && (mouseY>550) && (mouseY<=550+50))
  {
    value6=1;
  }
  
  if (value6==1)
  {
  println ("Impresion de fuente");
  
  fuente();
  }
  
  //SALIDA
  if ((mousePressed) && (mouseX>830) && (mouseX<=830+50) && (mouseY>550) && (mouseY<=550+50))
  {
    value8=1;
  }
  
  if (value8==1)
  {
  exit();
  }
  
}


void mujer()
{
  pushMatrix();
  scale (0.05,0.05);
  image (img3,2900,5800);
  popMatrix();
}

void nino()
{
  pushMatrix();
  scale (0.025,0.025);
  image (img4,20000,15000);
  popMatrix();
}

void fuente()
{ 
  for (Lluvia system: gotas) {
    system.caida();

    int n = (int) random(0,2);
    system.addParticulas(n);
  }
  //900x600
  gotas.add(new Lluvia(0, new PVector(590,330)));
  gotas.add(new Lluvia(0, new PVector(727,330)));
  
   pushMatrix();
  scale (0.15,0.15);
  image (img5,3700,2000);
  popMatrix();
  
  fill (0);
  noStroke();
  rect (430,550,250,50);
  
}



void seleccion()
{
  fill (0);
  noStroke();
  rect (0,550,900,60);

  //  COPO DE NIEVE
  pushMatrix();
  scale (0.06,0.06);
  image (img1,150,9280);
  popMatrix();
  
  //  PAJAROS
  pushMatrix();
  scale (0.020,0.020);
  image (img2,3800,27960);
  popMatrix();
  
  
  //  MUJER
  pushMatrix();
  scale (0.015,0.015);
  image (img3,9500,36800);
  popMatrix();
  
  //  NIÑO
  pushMatrix();
  scale (0.013,0.013);
  image (img4,15500,42700);
  popMatrix();
  
  //  FUENTE
  pushMatrix();
  scale (0.03,0.02);
  image (img5,8500,27800);
  popMatrix();
  
  //BOTON
  pushMatrix();
  scale (0.090,0.090);
  image (img6,3650,6150);
  popMatrix();
  
  //SALIDA
  pushMatrix();
  scale (0.080,0.080);
  image (img7,10250,6800);
  popMatrix();
}