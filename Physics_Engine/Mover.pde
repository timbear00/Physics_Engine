class Mover {
    PVector position;           // Object의 x, y좌표
    PVector velocity;           // Object의 속력 - vector, m/s
    PVector acceleration;       // Object의 가속도 - vector, m/s^2
    float mass;

    Mover(float _x, float _y, float _mass) {
        position = new PVector(_x, _y);
        velocity = new PVector(0,0);
        acceleration = new PVector(0,0);
        mass = _mass;
    }

    void applyForce(PVector force) {        // Object에 힘을 적용
        PVector a =  PVector.div(force, mass);
        acceleration.add(a);                //가속도 적용
    }

    void update() {
        velocity.add( PVector.div(acceleration, frameRate) );         //Delta Time 적용
        position.add( velocity );

        println("Frame: "+ frameCount + velocity );

        acceleration.mult(0);
    }

    void display() {
        stroke(0);
        strokeWeight(2);
        fill(127);
        ellipse(position.x, position.y, 50, 50);
    }

}
