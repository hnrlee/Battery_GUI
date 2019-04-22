/*

*/

import java.util.Arrays;
import processing.serial.*;

Subpack[] subpacks = new Subpack[6];


void setup() {
  //fullScreen();
  size(1500,1000);
  frameRate(1);
  background(0);
    for(int i = 0; i < subpacks.length; i++){
    subpacks[i] = new Subpack();
    subpacks[i].subpackNumber = i+1;
    subpacks[i].drawSubpack(!(i>2) ? 0 : width/2, ((i%3) * (height/3-100)), width/2, height/3-100);
    
  }
}

void draw() {
  background(0);
  for(int i = 0; i < subpacks.length; i++){
    subpacks[i] = new Subpack();
    subpacks[i].subpackNumber = i+1;
    subpacks[i].drawSubpack(!(i>2) ? 0 : width/2, ((i%3) * (height/3-100)), width/2, height/3-100);
    
  }
  
  
}
void serialEvent (Serial myPort) {
  // get the ASCII string:
  String inString = myPort.readStringUntil('\n');
  
  if (inString != null) {
    // trim off any whitespace:
    inString = trim(inString);
    for(int j = 0; j < subpacks.length; j++){
      int offset = j * (subpacks[j].cellVoltages.length + subpacks[j].boardTemps.length + subpacks[j].cellTemps.length) * 4;
      
      for(int i = 0; i < subpacks[j].cellVoltages.length; i+=4){
        subpacks[j].cellVoltages[i] = int(inString.substring( offset + i, i+4 + offset));
      }
      for(int i = subpacks[j].cellVoltages.length; i < subpacks[j].cellVoltages.length + subpacks[j].boardTemps.length; i+=4){
        subpacks[j].boardTemps[i-subpacks[j].cellVoltages.length] = int(inString.substring(i + offset, i + 4 + offset));
      }
      for(int i = subpacks[j].cellVoltages.length + subpacks[j].boardTemps.length; i < subpacks[j].cellVoltages.length + subpacks[j].boardTemps.length + subpacks[j].cellTemps.length; i++){
        subpacks[j].cellTemps[i - subpacks[j].cellVoltages.length - subpacks[j].boardTemps.length] = int(inString.substring(i + offset, i + 4 + offset));
      }
    }
  }
}
