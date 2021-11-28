class Mover {
    PVector position;           // Object의 x, y좌표
    PVector velocity;           // Object의 속력 - vector, m/s
    PVector acceleration;       // Object의 가속도 - vector, m/s^2
    float mass;                 // Object의 질량
    float radius;               // Object의 반지름

    Mover(float _x, float _y, float _mass, float _radius) {
        position = new PVector(_x, _y);
        velocity = new PVector(0,0);
        acceleration = new PVector(0,0);
        mass = _mass;
        radius = _radius;
    }

    void applyForce(PVector force) {        // Object에 힘을 적용
        PVector a =  PVector.div(force, mass);
        acceleration.add(a);                //가속도 적용
    }

    void update() {
        velocity.add( PVector.div(acceleration, 60) );         //Delta Time 적용
        position.add( PVector.mult(velocity, 6) );              //PVector.div(velocity, 60),  너무 느려서 *360 해줌.       

        acceleration.mult(0);
    }

    void display() {
        stroke(0);
        strokeWeight(2);
        fill(127);
        ellipse(position.x, position.y, radius, radius);
    }

}
