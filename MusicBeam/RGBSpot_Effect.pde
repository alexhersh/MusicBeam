class RGBSpot_Effect extends Effect
{
  String getName() {
    return "RGB Spot";
  }

  char triggeredByKey() {
    return '4';
  }

  RGBSpot_Effect(MusicBeam ctrl, int y)
  {
    super(ctrl, y);

    radiusSlider = cp5.addSlider("radius"+getName()).setRange(0, 1).setValue(0.5).setPosition(0, 5).setSize(395, 45).setGroup(controlGroup);
    radiusSlider.getCaptionLabel().set("Radius").align(ControlP5.RIGHT, ControlP5.CENTER);

    weightSlider = cp5.addSlider("weight"+getName()).setRange(1, 50).setValue(15).setPosition(0, 55).setSize(395, 45).setGroup(controlGroup);
    weightSlider.getCaptionLabel().set("Weight").align(ControlP5.RIGHT, ControlP5.CENTER);

    speedSlider = cp5.addSlider("delay"+getName()).setRange(0.01,.99).setValue(0.1).setPosition(0, 105).setSize(395, 45).setGroup(controlGroup);
    speedSlider.getCaptionLabel().set("Speed").align(ControlP5.RIGHT, ControlP5.CENTER);

    hueSlider = cp5.addSlider("hue"+getName()).setRange(0, 360).setSize(295, 45).setPosition(50, 155).setGroup(controlGroup);
    hueSlider.getCaptionLabel().set("hue").align(ControlP5.RIGHT, ControlP5.CENTER);
    hueSlider.setValue(0);
    HueControlListener hL = new HueControlListener();
    hueSlider.addListener(hL);

    aHueToggle = cp5.addToggle("ahue"+getName()).setPosition(0, 155).setSize(45, 45).setGroup(controlGroup);
    aHueToggle.getCaptionLabel().set("A").align(ControlP5.CENTER, ControlP5.CENTER);
    aHueToggle.setState(true);

    bwToggle = ctrl.cp5.addToggle("bw"+getName()).setPosition(350, 155).setSize(45, 45).setGroup(controlGroup);
    bwToggle.getCaptionLabel().set("BW").align(ControlP5.CENTER, ControlP5.CENTER);
    bwToggle.setState(false);

  }

  float[] rx = {0,0};
  float[] ry = {0,0};
  float[] rc = {0,0};

  float rotation = 0;
  int direction = 1;

  float timer = 0;

  float fader = 0;

  Button manualButton;

  Toggle aHueToggle, bwToggle, inverseToggle;

  Slider radiusSlider, weightSlider, hueSlider, rotationSpeedSlider, speedSlider;

  float radius = 0;

  void draw()
  {
    radius = stg.getMinRadius()*radiusSlider.getValue();

    // translate(stg.width/2, stg.height/2);

    if (timer<=0 && isTriggeredByBeat())
    {
      rx[1] = rx[0];
      ry[1] = ry[0];
      rc[1] = rc[0];
      rx[0] = random(-(stg.width - radius)/2, (stg.width - radius)/2);
      ry[0] = random(0, (stg.height - height)/2);
      rc[0] = hueSlider.getValue();
      timer = speedSlider.getValue() * frameRate * 3;
      fader = frameRate/4;
      if (aHueToggle.getState())
      {
        hueSlider.setValue((hueSlider.getValue()+60)%360);
        direction *= -1;
      }
    }

    stg.noFill();
    stg.strokeWeight(weightSlider.getValue());
    rotation = rotation + 0.01 * (direction / (1 - speedSlider.getValue())) % (PI * 2);
    rotate(rotation);


    stg.stroke(rc[0], bwToggle.getState()?0:100, 100);
    stg.ellipse(rx[0], ry[0], radius, radius);

    stg.stroke((rc[0] + 180) % 360, bwToggle.getState()?0:100, 100);
    stg.ellipse(-rx[0], -ry[0], radius, radius);

    // Shadows
    stg.stroke(rc[1], bwToggle.getState()?0:100, 5*fader);
    stg.ellipse(rx[1], ry[1], radius, radius);

    stg.stroke((rc[1] + 180) % 360, bwToggle.getState()?0:100, 5*fader);
    stg.ellipse(-rx[1], -ry[1], radius, radius);

    if (timer>0)
      timer--;
    if (fader>0)
      fader--;
  }

  boolean isTriggeredByBeat()
  {
    return
      isHat() ||
      isSnare() ||
      isKick();
  }
}
