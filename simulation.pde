import controlP5.*;

ControlP5 cp5;

public Slider floor_slide;
public int floors = 5;

public int simulation_state = initial;
public int simulation_state_pre = initial;

ArrayList<person> List = new ArrayList();

MyThread person_produce;
void setup() {
  size(600, 800);
  cp5 = new ControlP5(this);
  floor_slide = cp5.addSlider("floors")
    .setRange(1, 10)
    .setValue(5)
    .setPosition(10, 10)
    .setSize(180, 20)
    .setNumberOfTickMarks(9)
    .setSliderMode(Slider.FLEXIBLE)
    ;
  cp5.addButton("PLAY")
    .setValue(1)
    .setPosition(440, 10)
    .setSize(40, 30)
    ;
  cp5.addButton("STOP")
    .setValue(2)
    .setPosition(490, 10)
    .setSize(40, 30)
    ;
  cp5.addButton("RESET")
    .setValue(3)
    .setPosition(540, 10)
    .setSize(40, 30)
    ;
  simulation_state = initial;
}

void draw() {
  background(255);
  fill(0, 0, 0, 100);
  noStroke();
  rect(0, 0, control_W, control_H);

  if (simulation_state==reset 
    && (simulation_state_pre==stop||simulation_state_pre==start))
  {
    //person_produce.stop();
    simulation_state_pre = reset;
    List.clear();
    return;
  } else if (simulation_state==start)
  {
    if (simulation_state_pre==reset || simulation_state_pre==initial)
    {
      floor_slide.lock();
      person_produce = new MyThread();
      person_produce.start();
    } else if (simulation_state_pre==stop)
    {
      person_produce.resume();
    }
    simulation_state_pre = start;
  } else if (simulation_state==stop && simulation_state_pre==start)
  {
    person_produce.suspend();
    simulation_state_pre = stop;
  } else if(simulation_state == initial || simulation_state == reset){
    floor_slide.unlock();
    return;
  }
  draw_floor();
  stroke(0);
  for (int i=0; i<List.size(); i++)
  {
    //if(List.get(i).upDown == -1)
    //  fill(238, 118, 0);
    //else
    //  fill(0, 0, 0);
    fill(List.get(i).R,List.get(i).G,List.get(i).B);
    ellipse(List.get(i).x, List.get(i).y, 10, 10);
    if (simulation_state != stop)
      List.get(i).changesite();
  }
}

public void draw_floor()
{
  stroke(0);
  for (int i=1; i<=floors; i++)
  {
    if (i%2 == 0) {
      line(0, H-i*floor_step, floor_L, H-i*floor_step);
      line(floor_L, H-i*floor_step, 2*floor_L, H-(i-1)*floor_step);
    } else {
      line(W, H-i*floor_step, W-floor_L, H-i*floor_step);
      line( W-floor_L, H-i*floor_step, floor_L, H-(i-1)*floor_step);
    }
  }
}

public void PLAY(int theValue) {
  simulation_state = theValue;
}
public void STOP(int theValue) {
  simulation_state = theValue;
}
public void RESET(int theValue) {
  simulation_state = theValue;
}