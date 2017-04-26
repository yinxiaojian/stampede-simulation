import java.util.Random;
class MyThread extends Thread {
  private int size = 0;
  private float randX;
  private float randY;
  private float randV;
  private int randDir;
  @Override
    public void run() {
    while (simulation_state==start)
    {
      Random random = new Random();
      int randFloorNum = random.nextInt(floors)+1;
      randY = H - randFloorNum*floor_step;
      int randSpeed = random.nextInt(20)+10;
      randV = (float)randSpeed/10;
      if (randFloorNum % 2 == 0) {
        randX = 0;
        randDir = 1;
      } else {
        randX = W;
        randDir = 2;
      }
      
      List.add(new person(size++, 2*randFloorNum,randX, randY, randV, randDir));
      try {
        Thread.sleep(500);                 //stop 1 second
      } 
      catch(InterruptedException ex) {
        Thread.currentThread().interrupt();
      }
    }
  }
}