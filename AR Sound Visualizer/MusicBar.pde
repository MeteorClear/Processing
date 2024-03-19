class MusicBar {
  float x=0, y=0, z=0;
  float barX=0, barY=0, barZ=0;
  float smoothingFactor=0.2, scaleFactor=5;
  float _r=255, _g=0, _b=150, _a=80;
  
  MusicBar(float tx, float ty, float tz, float bx, float by, float bz){
    this.x = tx;
    this.y = ty;
    this.z = tz;
    this.barX = bx;
    this.barY = by;
    this.barZ = bz;
  }
  
  MusicBar(float tx, float ty, float tz, 
           float bx, float by, float bz, 
           int r, int g, int b, int a){
    this.x = tx;
    this.y = ty;
    this.z = tz;
    this.barX = bx;
    this.barY = by;
    this.barZ = bz;
    this._r = r;
    this._g = g;
    this._b = b;
    this._a = a;
  }
  
  void setBarColor(int r, int g, int b, int a) {
    this._r = r;
    this._g = g;
    this._b = b;
    this._a = a;
  }
  
  void drawBar() {
    fill(_r, _g, _b, _a);
    strokeWeight(1);
    stroke(30);
    
    pushMatrix();
      translate(x, y, z);
      box(barX, barY, barZ);
    popMatrix();
  }
  
  void step() {
    y += barY;
  }
}