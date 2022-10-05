P3Dcamera Pcam;
Tree tree;

void setup() {
  size(800, 600, P3D);
  Pcam = new P3Dcamera();
  soundFolder("sounds");         // loadSounds into soundsFolder (can be renamed)
  tree = new Tree();
}

void draw() {
  Pcam.display(width/2, height/1.1, -500);
  Pcam.ground(#40EA47, 1000, 1, 1000);
  tree.draw();
}


void mouseWheel(MouseEvent event) {
  Pcam.zoom(event);
}

void keyPressed() {              // called when a key is pressed
  keyIsDown();                   // check if all keys are pressed or not
}

void keyReleased() {             // called when a key is released
  keyIsUp();                     // check if all keys are released or not
}
