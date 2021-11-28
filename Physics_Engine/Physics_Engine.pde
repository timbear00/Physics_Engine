Mover m;
float mass;
float radius;
float gravitational_acceleration = 10;   //중력가속도 = 9.8m/s^2
float time;
int mode;                               // 실험 모드, default = 1, 1 : 자유 / 2 : 포물선 운동
boolean obj_cliked = false;
float angle;
float move = 0;

void setup() {
  size(1600, 800);
  frameRate(60.0);

  mode = 1;

  mass = 1;
  radius = 50;
  m = new Mover(width/4, 50, mass, radius);   // x, y, mass, radius

  time = millis();
  println("time : "+time);
}

void draw() {
  background(255);

  defaultText();
  if (mode==1) text1();
  else if (mode==2) text2();

  if ( mousePressed==true && mode==2 && obj_cliked ) {
    cal_angle();    
  }

  PVector gravity = new PVector(0, mass * gravitational_acceleration);

  if ( m.position.y >= (height-(radius/2)) ) gravity.mult(0);   // 수직항력 적용됨.
  m.applyForce(gravity);

  m.update();
  checkCollide();
  m.display(); 
  // println("Frame : "+ frameCount +", time : "+ (millis()-time) +", gravity : "+ gravity +", position.y : "+ (m.position.y-50));
}

void keyPressed() {
  // mode 설정
  if (keyCode==49) {
    mode=1;
    m = new Mover(width/4, 50, mass, radius);   // x, y, mass, radius
  }
  if (keyCode==50) {
    mode=2;
    move = 0;
    m = new Mover(radius/2 + 50, height-(radius/2), mass, radius);
  }


  // 각각의 mode에서의 행동
  if (mode==1) {
    PVector user_force = new PVector(0,0);
    if( keyCode==RIGHT ) user_force.x += 30;
    if (keyCode==LEFT) user_force.x -= 30;
    if (keyCode==UP) user_force.y -= 100 * mass;
    if (keyCode==DOWN) user_force.y += 30;

    if ( keyCode==32 ) m.velocity.mult(0);      // 32 => SPAEC, 속도를 0으로


    m.applyForce(user_force);
  }
  else if ( mode==2 ) {
    if ( keyCode==32 ) {                        // space : reset key
      m = new Mover(radius/2 + 50, height-(radius/2), mass, radius);   
      
    }
  }

}

void mousePressed() {
  if ( mode==2) {
    float distance = dist(mouseX, mouseY, radius/2 + 50, height-(radius/2));    // Object와 마우스 사이의 거리 측정

    if ( mouseButton == LEFT && distance <= radius && m.position.x==(radius/2 + 50) ) obj_cliked = true;
  }
}

void mouseReleased() {
  if (mode==2 && obj_cliked==true) {
    PVector force = new PVector( 350*cos(radians(angle)), 350*sin(radians(angle)) );
  
    m.applyForce(force);
  }
  obj_cliked = false;
}


void defaultText() {
  // physics_engine 설명, mode 설명
  // 속도, 위치 등

  fill(0);
  textSize(75);
  textAlign(CENTER, CENTER);
  text("<Physics Engine>", width/2, 50);

  textAlign(CENTER, CENTER);
  textSize(30);
  text("by. 20804 Min Gyeong Jin", width/2 + 450, 75);

  textAlign(LEFT, CENTER);
  textSize(30);
  if (m.velocity.y == 0) text("Velocity_x : "+m.velocity.x+"  |  Velocity_y : "+m.velocity.y, 50, 150);
  else text("Velocity_x : "+m.velocity.x+"  |  Velocity_y : "+(m.velocity.y*-1), 50, 150);

  textAlign(LEFT, CENTER);
  textSize(30);
  text("Position_x : "+m.position.x+"  |  position_y : "+m.position.y, 50, 200);

  noFill();
  rectMode(CENTER);
  rect(150, 55, 200, 50, 10);

  textAlign(CENTER, CENTER);
  textSize(50);
  text("Mode : "+mode, 150, 50);

  if (mode==1) {
    textAlign(CENTER, BOTTOM);
    textSize(25);
    text("Press 1,2 to change mode / Press Space to stop", width/2, height);
  }
  else if (mode==2) {
    textAlign(CENTER, BOTTOM);
    textSize(25);
    text("Press 1,2 to change mode / Press Space to reset", width/2, height);
  }

}

void text1() {
  textAlign(CENTER, CENTER);
  textSize(50);
  text("'Press Arrow key to move'", width/2, height/2);
}

void text2() {
  textAlign(LEFT, CENTER);
  textSize(40);
  text("[Shifting distance : "+round(move/360*10)/10.0+"m]", 1150, 160);    // round(move/360*10)/10.0

  if ( obj_cliked==false ) {
    textAlign(CENTER, CENTER);
    textSize(50);
    text("'Click and drag the object to throw'", width/2, height/2);
  }

  if( move!= 0 ) {
    stroke(0, 0, 255);
    strokeWeight(10);
    line(radius/2 + 50 + move, height, radius/2 + 50 + move, height-30);

    textAlign(CENTER, BOTTOM);
    textSize(25);
    text("(previous distance : "+round(move/360*10)/10.0+"m)", radius/2 + 50 + move, height-40);
  }
}

void cal_angle() {
  float start_x = radius/2 + 50;
  float start_y = height-(radius/2);
  float distance = dist(mouseX, mouseY, start_x, start_y);    // Object와 마우스 사이의 거리 측정
  noFill();
  stroke(0);
  strokeWeight(3);
  ellipse(start_x, start_y, radius*4, radius*4);

  angle = round(degrees( atan2(mouseY-start_y, mouseX-start_x) ));
  // println(angle);
  if ( angle <= -90 ) angle = -90;
  if ( angle >=0 ) angle = -0;

  stroke(255,0,0);
  line(start_x, start_y, start_x + radius*2*cos(radians(angle)), start_y + radius*2*sin(radians(angle)));

  textAlign(LEFT, CENTER);
  textSize(20);
  if (angle==0) text(angle+"˚", start_x + (radius*2 + 15)*cos(radians(angle)), start_y + (radius*2 + 15)*sin(radians(angle)));
  else text(-angle+"˚", start_x + (radius*2 + 15)*cos(radians(angle)), start_y + (radius*2 + 15)*sin(radians(angle)));

}

void checkCollide() {

  if( m.position.y >= (height-(radius/2)) ) {
    m.position.y = height - (radius/2);

    if(mode==1) {
      m.velocity.y = m.velocity.y * (-0.8);                   // 반발 계수
      if( abs(m.velocity.y) < 0.5 ) m.velocity.y = 0;
    }
    else if (mode==2) {
      if (m.velocity.x != 0) move =( m.position.x - (radius/2 + 50));

      m.velocity.mult(0);
    }
  }

  if ( (m.position.x < (0 + (radius/2))) || (m.position.x > (width - (radius/2))) ) m.velocity.x *= -1;

}