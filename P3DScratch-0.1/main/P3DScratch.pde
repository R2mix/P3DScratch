public class P3DSprite extends Thread {
  public float x, y, z, direction, angleRadian, sized = 100;                  // basics informations of the P3DSprite
  private boolean display = true;                                       // boolean for rotation, dragable and is displaying, (private) call it by the named functions
  private PShape costumes;                                              // costumes is an array of images

  public P3DSprite(String file ) {                                      // initialize the P3DSprite
    x = width/2;
    y = 0;
    z = 0;
    costumes = loadShape(file);
  }

  public void display() {
    //-------------------------- start style and transformations------------------------------------------------------------
    push();

    translate(x, y, z);                                                // move to x and y, using translate cause rotation
    rotateY(angleRadian);
    rotateX(radians(90));
    scale(sized*0.01);
    if (display)shape(costumes);                                       // showing the image (can be hiding and disable the color detection)
    pop();
    //-------------------------- end style and transformations------------------------------------------------------------
  }
  //====================================== Motion =====================================================================================================================

  public void move(float a) {
    x += cos(angleRadian) * a;                                          // trigonometric calcul for go to the angle of the direction of the P3DSprite
    z += sin(angleRadian) * a;
  }
  public void turnRight(float a) {
    direction += a;
    direction = direction%360;                                          // rotation with reset on 360 degree then converted in radian
    angleRadian = radians(direction);
  }
  public void turnLeft(float a) {
    direction -= a;
    direction = direction%-360;
    angleRadian = radians(direction);
  }

  public void goTo(P3DSprite o) {
    x = o.x;
    y = o.y;
    z = o.z;
  }
  public void goTo(float xx, float yy, float zz) {
    x = xx;
    y = yy;
    z = zz;
  }
  public void pointInDirection(float a) {
    direction = a;
    angleRadian = radians(direction);
  }
  public  void pointTowards(float xx, float zz) {
    angleRadian = atan2(zz - z, xx - x);                                // transform a matrix of position to an angle (in radians)
    direction = degrees(angleRadian);
  }
  public void pointTowards(P3DSprite o) {
    pointTowards(o.x, o.z);
  }
  //====================================== Looks =====================================================================================================================

  public void changeSizeBy(int t) {                                     // for all costumes
    sized += t;
    if (sized < 1) sized = 1;
  }

  public void setSizeTo(int t) {
    sized += t;
    if (sized < 1) sized = 1;
  }
  //====================================== sensor =====================================================================================================

  public boolean touch(float xx, float yy, float zz, float l, float h, float p) {              // square hitbox comparing two position and size
    if ( x + sized * costumes.width > xx &&
      x < xx + l &&
      y + sized * costumes.height > yy &&
      y < yy + h &&
      z + sized * costumes.width > zz &&
      z < zz + p && display) {
      return true;
    } else {
      return false;
    }
  }
  public boolean touch(P3DSprite other) {
    if (other.display) {                                                    // square hitbox comparing to a sprite
      return touch(other.x, other.y, other.z, other.costumes.width * other.sized, other.costumes.height * other.sized, other.costumes.width * other.sized);
    } else {
      return false;
    }
  }
  public float distanceTo(P3DSprite o) {
    return dist(x, y, z, o.x, o.y, o.z);
  }
  public float distanceTo(float xx, float yy, float zz) {
    return dist(x, y, z, xx, yy, zz);
  }
}

//----------------------------------------------------------KEYISDOWN------------------------------------------------------------------
private ArrayList<Character> keyStored = new ArrayList<Character>();         // for qwerty key
private ArrayList<Integer> keyStoredCoded = new ArrayList<Integer>();        // for coded key as arrow...
public void keyIsDown() {                                                    //call it into keyPressed void
  if (!keyStored.contains(key) && key != CODED) keyStored.add(key);        // store in array if not already and not coded, different array for coded
  if (!keyStoredCoded.contains(int(keyCode)) && key == CODED) keyStoredCoded.add(int(keyCode));
}
public void keyIsUp() {                                                      //call it into keyReleased void and remove from arrays
  if (keyStored.contains(key) && key != CODED) keyStored.remove(keyStored.indexOf(key));
  if (keyStoredCoded.contains(int(keyCode)) && key == CODED) keyStoredCoded.remove(keyStoredCoded.indexOf(int(keyCode)));
}

public boolean keyIsPressed(char k) {                                        // call this boolean for interact width key

  if (keyStored.contains(k)) {                                               // if array contain the letter of the keyBoard
    return true;
  } else {
    return false;
  }
}
public boolean keyIsPressed(String k) {                                     // call this boolean for interact width keycoded

  if (k == "upArrow" && keyStoredCoded.contains(38) ) {                     // if array contain the keycod of the keyBoard
    return true;
  } else if (k == "leftArrow" && keyStoredCoded.contains(37)) {
    return true;
  } else if (k == "rightArrow" && keyStoredCoded.contains(39)) {
    return true;
  } else if (k == "downArrow" && keyStoredCoded.contains(40)) {
    return true;
  } else {
    return false;
  }
}
//-----------------------------------------------------------END of KEY-------------------------------------------------------------------



public class P3Dcamera {

  float rY, rZ, rX, tX, tY, tZ, zoom = 1;
  P3Dcamera() {
  }
  void display(float w, float h, float p) {
    background(#3DAAC4);
    lights();
    translate(w + tX, h + tY, p + tZ);
    if ( mousePressed && mouseButton == CENTER) {
      rY += mouseX - pmouseX;
      rZ += mouseY - pmouseY;
      rZ = constrain(rZ, -10, 10);
    }
    if ( mousePressed && mouseButton == RIGHT) {
      tX += mouseX - pmouseX;
      tZ += mouseY - pmouseY;
    }

    rotateY(radians(rY));
    rotateZ(radians(rZ));
    scale(zoom);
  }
  void ground(color col, int l, int h, int p) {
    noStroke();
    fill(col);
    box(l, h, p);
  }
  void zoom(MouseEvent event) {
    float e = event.getCount();
    zoom -= e * 0.1;
    zoom = constrain(zoom, 0.1, 4);
  }
}


import processing.sound.*;                                                 //sound lib


public void Wait(float time) {                                             // wait in sec to millis
  delay(int(time * 1000));
}

// This function returns all the files in a directory as an array of Strings
private String[] listFileNames(String dir) {                               // called in sprite class, scene class and sound void
  File file = new File(dir);
  if (file.isDirectory()) {
    String names[] = file.list();
    return names;
  } else {                                                                 // If it's not a directory
    return null;
  }
}
//--------------------------------------------------------import sounds ---------------------------------------------------------------------
private SoundFile[] sounds;                                                // array of sounds look in sprite and work the same but with sounds
private int totalNumberOfSounds, loadedSound;
private AudioIn input;
private Amplitude amplitude;
public int loudness;
public boolean openMic;
//private float pitch = 1, volume = 1, pan = 0;                            //defaut sounds values
private float[] pitch, volume, pan;

public void soundFolder(String folder) {
  try {
    String path = sketchPath()+ "/data/" + folder;
    String[] filenames = listFileNames(path);
    java.util.Arrays.sort(filenames);
    println(folder + " sounds : ");
    printArray(filenames);
    for (int i = 0; i < filenames.length; i++) {
      String extention = filenames[i].substring(filenames[i].indexOf("."));
      if (extention.equals(".wav") || extention.equals(".mp3") || extention.equals(".aiff") ) {
        totalNumberOfSounds ++;
      }
    }
    sounds = new SoundFile[totalNumberOfSounds];
    pitch = new float[totalNumberOfSounds];
    volume = new float[totalNumberOfSounds];
    pan = new float[totalNumberOfSounds];

    for (int i = 0; i < filenames.length; i++) {
      String extention = filenames[i].substring(filenames[i].indexOf("."));
      if (extention.equals(".wav") || extention.equals(".mp3") || extention.equals(".aiff") ) {
        sounds[loadedSound] =  new SoundFile(this, path +"/"+ filenames[i], false);
        loadedSound++;
      }
    }
  }
  catch(Exception e) {
    println("!!---- Caution ! There is no SoundFolder at this name : " +folder+" ----!!");
    exit();
  }
  openMicrophone();
  clearSoundEffects();
}
//-----------------------------------------------------END import sounds ---------------------------------------------------------------------

void openMicrophone() {                                                         // call it inside setup void
  try {
    input = new AudioIn(this, 0);                                               // new default mic
    input.start();                                                              // start mic
    amplitude = new Amplitude(this);                                            // new analyser
    amplitude.input(input);                                                     // attach input to analyzer
    openMic = true;
  }
  catch(Exception e) {
    openMic = false;
    println("---!! no microphone detected  !!---");
  }
}
void microphone() {                                                             // call it inside draw void
  if (openMic) {
    loudness = int(amplitude.analyze() * 100);                                  // analyze the sound and convert to 100
  }
}

//--------------------------------------------------------------------------------------------

public void playSound(int numeroSon) {                                       // play a sound from 0 with pitch[i] value and volume value
  sounds[numeroSon].play(pitch[numeroSon], volume[numeroSon] );
  if (sounds[numeroSon].channels() == 1) sounds[numeroSon].pan(pan[numeroSon]);
}
public void playSoundUntilDown(int numeroSon) {                              //wait the sound is over before go to the next code ling, better using is into run void
  playSound( numeroSon);
  while ( sounds[numeroSon].isPlaying() && sounds[numeroSon].percent() < 100 );
  sounds[numeroSon].stop();
}
public void stopSound(int numeroSon) {                                       // stop a sound
  sounds[numeroSon].stop();
}
public void stopAllSound() {                                                 // stop all sounds
  for (int i =0; i < totalNumberOfSounds; i++) {
    sounds[i].stop();
  }
}
public void changePitchEffectBy(float p) {                                   // change pitch[i] of a sound by changing it rate (like on scratch)
  for (int i =0; i < totalNumberOfSounds; i++) {
    pitch[i] += p * 0.01;
    pitch[i] = constrain(pitch[i], 0, 100);
    sounds[i].rate(pitch[i]);
  }
}
public void setPitchEffectTo(float p) {
  for (int i =0; i < totalNumberOfSounds; i++) {
    pitch[i] = p * 0.01;
    pitch[i] = constrain(pitch[i], 0, 100);
    sounds[i].rate(pitch[i]);
  }
}
public void changePanEffectBy(float pa) {                                    // -1 left, +1 right 0 center (don't work with stereo sounds)
  for (int i =0; i < totalNumberOfSounds; i++) {
    pan[i] += (pa * 0.01);
    pan[i] = constrain(pan[i], -1, 1);
    if (sounds[i].channels() == 1) sounds[i].pan(pan[i]);
  }
}
public void setPanEffectTo(float pa) {
  for (int i =0; i < totalNumberOfSounds; i++) {
    pan[i] = pa * 0.01;
    pan[i] = constrain(pan[i], -1, 1);
    if (sounds[i].channels() == 1) sounds[i].pan(pan[i]);
  }
}
public void changePitchEffectBy(float p, int s) {                            // change pitch[i] of a sound by changing it rate (like on scratch)
  pitch[s] += p * 0.01;
  pitch[s] = constrain(pitch[s], 0, 100);
  sounds[s].rate(pitch[s]);
}
public void setPitchEffectTo(float p, int s) {
  pitch[s] = p * 0.01;
  pitch[s] = constrain(pitch[s], 0, 100);
  sounds[s].rate(pitch[s]);
}
public void changePanEffectBy(float pa, int s) {                             // -1 left, +1 right 0 center (don't work with stereo sounds)
  pan[s] += (pa * 0.01);
  pan[s] = constrain(pan[s], -1, 1);
  if (sounds[s].channels() == 1) sounds[s].pan(pan[s]);
}
public void setPanEffectTo(float pa, int s) {
  pan[s] = pa * 0.01;
  pan[s] = constrain(pan[s], -1, 1);
  if (sounds[s].channels() == 1) sounds[s].pan(pan[s]);
}
public void clearSoundEffects() {                                            // restore default sounds values
  for (int i =0; i < totalNumberOfSounds; i++) {
    pitch[i] = 1;
    volume[i] = 1;
    pan[i] = 0;
    sounds[i].amp(volume[i]);
    sounds[i].rate(pitch[i]);
    if (sounds[i].channels() == 1)sounds[i].pan(pan[i]);
  }
}
public void changeVolumeBy( float v) {                                       // work on the volume of the sound
  for (int i =0; i < totalNumberOfSounds; i++) {
    volume[i] += (v * 0.01);
    volume[i] = constrain(volume[i], 0, 1);
    sounds[i].amp(pan[i]);
  }
}
public void setVolumeTo(float v) {
  for (int i =0; i < totalNumberOfSounds; i++) {
    volume[i] = v * 0.01;
    volume[i] = constrain(volume[i], 0, 1);
    sounds[i].amp(volume[i]);
  }
}
public void changeVolumeBy( float v, int s) {                                // work on the volume of the sound
  volume[s] += (v * 0.01);
  volume[s] = constrain(volume[s], 0, 1);
  sounds[s].amp(volume[s]);
}
public void setVolumeTo(float v, int s) {
  volume[s] = v * 0.01;
  volume[s] = constrain(volume[s], 0, 1);
  sounds[s].amp(volume[s]);
}

public void pick() {                                                        // call it if you want to get the color of a pixel with you mouse when you click
  if (mousePressed)println(get(mouseX, mouseY), "mouseX : "+ mouseX, "mouseY : " + mouseY, "width : " + width, "height : " + height, "frameRate : " + int(frameRate ));
}

private long previousMillis = 0;
public float timer;

public void timer() {
  timer =  (millis() - previousMillis) * 0.001;
}
public void resetTimer() {
  previousMillis =  millis();
}
//================================================================ END MAIN FUNCTIONS ==========================================================================
