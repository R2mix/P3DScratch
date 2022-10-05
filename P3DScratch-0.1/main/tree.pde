class Tree extends P3DSprite {           // create the sprite instance named "Cat"

  Tree() {
    super("tree/tinker.obj");
  }

  void draw() {                      // call it into the main draw void or just call sprite.display into main draw void
    display();                       // for showing and using the sprite
  }

  void run() {                       // thread where you can code without screen frameRate
  }
}
