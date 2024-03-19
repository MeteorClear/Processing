/*
 * NyARToolkit for proce55ing/3.0.5
 * (c)2008-2017 nyatla
 * https://nyatla.jp/nyartoolkit/wp/?page_id=198
 *
 * Processing Java
 * AR sound visualizer
 * Not running on this site
 * The execution of this code was tested on processing 3.5.4
 */
import processing.video.*;
import processing.sound.*;
import jp.nyatla.nyar4psg.*;

Capture cam;
MultiMarker nya;
FFT fft;
SoundFile sample;
BeatDetector beatDetector;

int cam_width=640;
int cam_height=480;
int mkSize = 300;
int bands = 16;
int act_bands = 8;
int lineScaleFactor = 1;
int beatColorCnt = 0;
int switch_color = 0;
int cr=50, cg=255, cb=50, ca=100;
float[] sum = new float[bands];
float smoothingFactor = 0.05;
float scale = 6;
float barWidth = 0;
boolean switch_line = false;
boolean switch_box = false;
ArrayList<MusicBar> mbs;

void setup() {
  size(1280, 960, P3D);
  colorMode(RGB, 100);
  println(MultiMarker.VERSION);
  sample = new SoundFile(this, "write_in_your_music_path");
  if(sample.isPlaying()) sample.pause();
  barWidth = mkSize/float(act_bands);
  fft = new FFT(this, bands);
  fft.input(sample);
  beatDetector = new BeatDetector(this);
  beatDetector.input(sample);
  beatDetector.sensitivity(100);
  mbs = new ArrayList<MusicBar>();
  cam=new Capture(this, cam_width, cam_height, "pipeline:autovideosrc");
  nya=new MultiMarker(this, cam_width, cam_height, "./libraries/nyar4psg/data/camera_para.dat", NyAR4PsgConfig.CONFIG_PSG);
  nya.addARMarker("./libraries/nyar4psg/data/patt.hiro", mkSize);
  cam.start();
}

void draw() {
  if(cam.available() != true) return;
  cam.read();
  nya.detect(cam);
  background(0);
  nya.drawBackground(cam);
  
  // undetected
  if((!nya.isExist(0))) {
    if(sample.isPlaying()) sample.pause();
    return;
  }
  nya.beginTransform(0);
    if (switch_box) drawGuideBox();
    translate(mkSize*1/2, mkSize*1/2, 0);
    rotateZ(PI/2);
    rotateY(PI);
    if (switch_line) drawGuideLine();
    translate(-barWidth/2, -barWidth/2, 0);

    if(!(sample.isPlaying())) sample.play();

    if (beatDetector.isBeat()) {
      beatColorCnt = (beatColorCnt + 1) % 6;
      scale = 12;
    } else { 
      if (scale > 6) scale -= 0.5;
      if (scale < 6) scale = 6;
    }

    switch(switch_color) {
      case 0:
        cr=255; cg=255; cb=255; ca=100;
        strokeWeight(1);
        stroke(30);
        scale = 6;
        break;
      case 1:
        cr=0; cg=0; cb=0; ca=100;
        strokeWeight(2);
        stroke(230);
        scale = 6;
        break;
      case 2:
        strokeWeight(1);
        stroke(30);
        switch(beatColorCnt) {
          case 0:
            cr=255; cg=50; cb=50; ca=80;
            break;
          case 1:
            cr=50; cg=255; cb=50; ca=80;
            break;
          case 2:
            cr=50; cg=50; cb=255; ca=80;
            break;
          case 3:
            cr=255; cg=255; cb=50; ca=80;
            break;
          case 4:
            cr=50; cg=255; cb=255; ca=80;
            break;
          case 5:
            cr=255; cg=50; cb=255; ca=80;
            break;
        }
        break;
    }
    
    fft.analyze();
    for (int i=1; i<=act_bands; i++) {
      sum[i] += (fft.spectrum[i] - sum[i]) * smoothingFactor;
      float barHeight = -sum[i] * mkSize * scale;
      if (barHeight < -mkSize*3) barHeight = -mkSize*3;
      
      mbs.add(new MusicBar(i*barWidth, barWidth, barHeight/2, 
                           barWidth, barWidth, barHeight,
                           cr, cg, cb, ca));
    }
	
    for(MusicBar mb : mbs) {
      mb.drawBar();
      mb.step();
    }
	
    while(mbs.size() > act_bands*(act_bands-1)*lineScaleFactor) mbs.remove(0);
	
  nya.endTransform();
}

void drawGuideLine(){
  strokeWeight(5);
  stroke(255,255,255);
  fill(255,255,255);
  box(mkSize/4);
  
  stroke(0,0,255);
  line(mkSize,0,0,-mkSize,0,0);
  fill(0,0,255);
	
  pushMatrix();
    translate(mkSize,0,0);
    box(mkSize/4);
  popMatrix();
	
  pushMatrix();
    translate(-mkSize,0,0);
    box(mkSize/4);
  popMatrix();
  
  stroke(0,255,0);
  line(0,mkSize,0,0,-mkSize,0);
  fill(0,255,0);
	
  pushMatrix();
    translate(0,mkSize,0);
    box(mkSize/4);
  popMatrix();
	
  pushMatrix();
    translate(0,-mkSize,0);
    box(mkSize/4);
  popMatrix();
  
  stroke(255,0,0);
  line(0,0,mkSize,0,0,-mkSize);
  fill(255,0,0);
	
  pushMatrix();
    translate(0,0,mkSize);
    box(mkSize/4);
  popMatrix();
	
  pushMatrix();
    translate(0,0,-mkSize);
    box(mkSize/4);
  popMatrix();
}

void drawGuideBox() {
  pushMatrix();
    translate(0,0,mkSize/2);
    noFill();
    strokeWeight(3);
    stroke(255,255,0);
    box(mkSize);
    translate(0,0,mkSize);
    box(mkSize);
    translate(0,0,mkSize);
    box(mkSize);
  popMatrix();
}

void keyPressed() {
  if (key == 'p') {
    act_bands = 8;
    barWidth = mkSize/float(act_bands);
  } else if (key == 'q') {
    switch_line = !switch_line;
  } else if (key == 'w') {
    switch_box = !switch_box;
  } else if (key == 'e') {
    switch_color = (switch_color + 1) % 3;
  } else if (key == 'a') {
    act_bands = min(act_bands+1, bands-1);
    barWidth = mkSize/float(act_bands);
  } else if (key == 's') {
    act_bands = max(act_bands-1, 1);
    barWidth = mkSize/float(act_bands);
  }
}