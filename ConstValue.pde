static final float H = 800;
static final float W = 600;
static final float control_H = 50;
static final float control_W = 600;
static final int initial = 0;
static final int start = 1;
static final int stop = 2;
static final int reset = 3;
static final float floor_step = 70;
static final float floor_L = 200;
static final float radius = 5;
static final float accV = 0.01;
static final float slopeX = floor_L/(float)Math.sqrt(floor_step*floor_step+floor_L*floor_L);
static final float slopeY = floor_step/(float)Math.sqrt(floor_step*floor_step+floor_L*floor_L);