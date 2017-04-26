class person
{
  private int i = 0; //for stop person, when add to 100, accelerate
  public int R, G, B;
  public float x;  //x coordinates
  public float y;  //y coordinates
  public float v;  //speed
  public int dir;  //the forward direction of person
  public float vInit;
  public int upDown; //up = 1, down = -1
  private int site;  // site from 1,2...10*2
  private int id;    //the generate order in arraylist
  private int state; //normal = 0, collision = 1, stop = 2, accelerate = 3
  /*
   the forward direction of person
   1: -------->
   2: <--------
   3: ----\\\\>
   4: <///-----
   */
  public person(int _id, int _site, float _x, float _y, float _v, int _dir) {
    id = _id;
    site = _site;
    x = _x;
    y = _y;
    v = _v;
    dir = _dir;
    vInit = _v;
    upDown = 0;
    state = 0;
    R = 0;
    G = 0;
    B = 0;
  }
  public void changesite() {
    
    if (dir == 1 && x >= floor_L) {
      x = floor_L;
      y = H - site/2*floor_step;
      dir = 3; 
      upordown(site-1);
    } else if (dir == 2 && x <= 2*floor_L)
    {
      x=2*floor_L;
      y = H - site/2*floor_step;
      dir = 4; 
      upordown(site-1);
    } else if (dir == 3 && x >= 2*floor_L)
    {
      x=2*floor_L;
      y = H - (site-1)/2*floor_step - upDown*radius;
      dir = 4; 
      site-=2;
    } else if (dir == 4 && x <= floor_L)
    {
      x = floor_L;
      y = H - (site-1)/2*floor_step - upDown*radius;
      dir = 3; 
      site-=2;
    }
    switch(dir) {
    case 1:
      x += v;  
      break;
    case 2:
      x -= v; 
      break;
    case 3:
      x += v*slopeX;
      y += v*slopeY;
      break;
    case 4:
      x -= v*slopeX;
      y += v*slopeY;
      break;
    }
    collisionDetect();//detect collision
    stateInfluence(); //change the color or speed according current state
  }

  public void upordown(int _site) {
    int res = 1;
    float minDist = 10000;
    for (int i=0; i<List.size(); i++)
    {
      if (List.get(i).site == _site)
      {
        float dis = pow(List.get(i).x-(site/2%2+1)*floor_L, 2)+pow(List.get(i).y+floor_step*site/2-H, 2);
        if (dis < minDist)
        {
          minDist = dis;
          res = - List.get(i).upDown;
        }
      }
    }
    this.site = _site;
    if (res == 1)
      y -= radius;
    else
      y += radius;
    upDown = res;
    if(state == 1)
      state = 3;
  }

  public void collisionDetect()
  {
    boolean flag1 = false;
    boolean flag2 = true;
    for (int i = 0; i < List.size(); i++)
    {
      if (List.get(i).site == site && List.get(i).id != id)
      {
        if(dir == 1 && v > List.get(i).v 
        && List.get(i).x - radius <= x && List.get(i).x > x)
        {
          x = List.get(i).x - 2*radius;//Fine tune
          v = List.get(i).v;
          state = 1;
          break;
        }
        else if(dir == 2 && v > List.get(i).v 
        && List.get(i).x >= x - radius && List.get(i).x < x)
        {
          x = List.get(i).x + 2*radius;//Fine tune
          v = List.get(i).v;
          state = 1;
          break;
        }
        else if(dir == 3 || dir == 4)
        {
          if(List.get(i).upDown == upDown 
          && List.get(i).y > y && (List.get(i).y-y) <= 2*radius*slopeY+0.1)
          {
            flag1 = true;
            //Fine tune
            y = List.get(i).y - 2*radius*slopeY;
            if(dir == 3)
              x = List.get(i).x - 2*radius*slopeX;
            else
              x = List.get(i).x + 2*radius*slopeX;
            v = List.get(i).v;
          }
          else if(List.get(i).upDown == -upDown 
          && (pow(List.get(i).y-y,2) + pow(List.get(i).x-x,2)) <= 2*pow(2*radius,2))
          {
            flag2 = false;
          }
        }
      }
    }
    if((dir == 3 || dir == 4) && !flag1 && state == 1)
      state = 3;
    if(flag1 && flag2)
    {
      state = 3;
      if(dir==3)
        x = x - upDown*2*radius*slopeY;
      else if(dir==4)
        x = x + upDown*2*radius*slopeY;
      y = y + upDown*2*radius*slopeX;
      upDown = -upDown;
    }
    else if(flag1 && !flag2)
    {
      state = 4;
    }
  }
  
  public void stateInfluence()
  {
    if(state == 0)
    {
      R = G = B = 0;  //dark:normal
    }
    else if(state == 1)
    {
      R = 255; G = B = 0; //red:collision
    }
    else if(state == 2)
    {
      R = 255; G = 0; B = 255;  //purple:stop
      if(i == 0)
        v = 0;
      i++;
      if(i >= 50)
      {
        state = 3;
        i = 0;
      }
    }
    else if(state == 3)
    {
      R = G = 0; B = 255;  //blue:accelerate
      if(v < vInit)
        v +=  accV;
      else
        state = 0;
    }
    else if(state == 4)
    {
      R = 255; G = B = 0; //red:collision
      if((int)random(10)==1)
        state = 2;
    }
  }
}