Mover m;
float mass;

void setup() {
  size(500, 500);
  mass = 10;
  m = new Mover(width/2, 50, mass);
  
  
}

void draw() {
  background(255);
  
  PVector gravity = new PVector(0, 1);

  m.applyForce(gravity);
  m.update();
  m.display();
}
