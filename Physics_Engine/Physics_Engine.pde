Mover m;
float mass;
float gravitational_acceleration = 10;   //중력가속도 = 9.8m/s^2

void setup() {
  size(800, 800);
  frameRate(60);

  mass = 10;
  m = new Mover(width/2, 50, mass);
  
}

void draw() {
  background(255);
  
  PVector gravity = new PVector(0, mass * gravitational_acceleration);

  m.applyForce(gravity);
  m.update();
  m.display();

  if( millis() >= 1000 && millis() <= 1050 ) {
    println(millis());
    println(m.position.y-50);
  }
  
}

