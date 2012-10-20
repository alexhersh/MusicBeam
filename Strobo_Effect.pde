/*
 * Copyright (c) 2012 Zepp Lab UG (haftungsbeschränkt) <www.zepplab.net>, Johannes Hoppe <info@johanneshoppe.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
 * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

public class Strobo_Effect extends Effect
{  
  public String getName()
  {
    return "Strobo";
  }
  
  public Strobo_Effect(MusicBeam controller)
  {

    super(controller);


    manualButton = cp5.addButton("manual").setSize(85, 95).setPosition(10, 45).moveTo(win);
    manualButton.getCaptionLabel().set("Manual Trigger").align(ControlP5.CENTER, ControlP5.CENTER);

    hatToggle = cp5.addToggle("hat").setSize(90, 20).setPosition(100, 45).moveTo(win);
    hatToggle.getCaptionLabel().set("Hat").align(ControlP5.CENTER, ControlP5.CENTER);

    snareToggle = cp5.addToggle("snare").setSize(90, 20).setPosition(100, 70).moveTo(win);
    snareToggle.getCaptionLabel().set("Snare").align(ControlP5.CENTER, ControlP5.CENTER);

    kickToggle = cp5.addToggle("kick").setSize(90, 20).setPosition(100, 95).moveTo(win);
    kickToggle.getCaptionLabel().set("Kick").align(ControlP5.CENTER, ControlP5.CENTER);
    kickToggle.setState(true);

    onsetToggle = cp5.addToggle("onset").setSize(90, 20).setPosition(100, 120).moveTo(win);
    onsetToggle.getCaptionLabel().set("OnSet").align(ControlP5.CENTER, ControlP5.CENTER);
    onsetToggle.setState(true);

    delaySlider = cp5.addSlider("delay").setRange(20, stg.refreshRate/2).setValue(stg.refreshRate/2-2).setPosition(10, 145).setSize(180, 20).moveTo(win);
    delaySlider.getCaptionLabel().set("Hz").align(ControlP5.RIGHT, ControlP5.CENTER);

    hueSlider = cp5.addSlider("hue"+getName()).setRange(0, 360).setSize(130, 20).setPosition(35, 170).moveTo(win);
    hueSlider.getCaptionLabel().set("hue").align(ControlP5.RIGHT, ControlP5.CENTER);
    hueSlider.setValue(0);

    aHueToggle = cp5.addToggle("ahue"+getName()).setPosition(10, 170).setSize(20, 20).moveTo(win);
    aHueToggle.getCaptionLabel().set("A").align(ControlP5.CENTER, ControlP5.CENTER);
    aHueToggle.setState(true);

    bwToggle = ctrl.cp5.addToggle("bw"+getName()).setPosition(170, 170).setSize(20, 20).moveTo(win);
    bwToggle.getCaptionLabel().set("BW").align(ControlP5.CENTER, ControlP5.CENTER);
    bwToggle.setState(true);
  }

  boolean state = false;

  int timer = 0;

  Button manualButton;

  Slider delaySlider, hueSlider;

  Toggle hatToggle, snareToggle, kickToggle, onsetToggle, aHueToggle, bwToggle;

  boolean isTriggered()
  {
    if (manualButton.isPressed())
      return true;
    else if ((!onsetToggle.getState() && hatToggle.getState() && isHat()) || (onsetToggle.getState() && isOnset() && hatToggle.getState() && isHat()))
      return true;
    else if ((!onsetToggle.getState() && snareToggle.getState() && isSnare()) || (onsetToggle.getState() && isOnset() && snareToggle.getState() && isSnare()))
      return true;
    else if ((!onsetToggle.getState() && kickToggle.getState() && isKick()) || (onsetToggle.getState() && isOnset() && kickToggle.getState() && isKick()))
      return true;
    else if (onsetToggle.getState() && isOnset())
      return true;
    else
      return false;
  }

  void draw() {
    if (state && timer == 0) {
      state = false;
      timer = int(stg.refreshRate/2-delaySlider.getValue());
    } 
    else if (!state && isTriggered() && timer == 0) {
      state = true;
      timer = int(stg.refreshRate/2-delaySlider.getValue());
    }

    if (timer > 0)
      timer--;

    if (aHueToggle.getState())
      hueSlider.setValue((hueSlider.getValue()+1)%360);

    stg.fill(hueSlider.getValue(), bwToggle.getState()?0:50, 100);
    if (state)
      stg.rect(-stg.maxRadius/2, -stg.maxRadius/2, stg.maxRadius, stg.maxRadius);
  }
}
