/*

 */

import java.util.Arrays;
import processing.serial.*;

Subpack[] subpacks = new Subpack[6];
Serial myPort;

void setup() {
  //fullScreen();
  size(1500, 1000);
  frameRate(0.2);
  background(0);
  
  for (int i = 0; i < subpacks.length; i++) {
    subpacks[i] = new Subpack();
    subpacks[i].subpackNumber = i+1;
    subpacks[i].drawSubpack(!(i>2) ? 0 : width/2, ((i%3) * (height/3-100)), width/2, height/3-100);
  }
  printArray(Serial.list());
  
  myPort = new Serial(this, Serial.list()[1],115200); // might have to change this later
 // myPort.bufferUntil('\n');
}

void draw() {
  background(0);
  for (int i = 0; i < subpacks.length; i++) {
    //subpacks[i] = new Subpack();
    //subpacks[i].subpackNumber = i+1;
    subpacks[i].drawSubpack(!(i>2) ? 0 : width/2, ((i%3) * (height/3-100)), width/2, height/3-100);
  }
}
void serialEvent (Serial myPort) {
  // get the ASCII string:
  String inString = myPort.readStringUntil('\n');

  if (inString != null) {
    // trim off any whitespace:
    inString = trim(inString);
    //print(inString + "\n");
    String parts[] = inString.split("-");
    char code;
    int subpack;
    int index; 
    float value; 
    
    try {
      code = parts[0].charAt(0);
      subpack = Integer.parseInt(parts[1]);
      index =  Integer.parseInt(parts[2]);
      value = Integer.parseInt(parts[3]);
    } catch(Exception ex){
      print("Invalid data: " +  inString);
      return;
    }

    //print("code" + code + "-subpack" + subpack + "-index" + index + "-value" + value);

    try {
      switch(code) {
      case 'c':
        subpacks[subpack].cellVoltages[index] = value;
        break;
      case 'b':
        subpacks[subpack].boardTemps[index] = value;
        break;
      case 't':
        subpacks[subpack].cellTemps[index] = value;
        break;
      }
    }
    catch(Exception ex) {
      print("Invalid bounds: " + inString);
    }

    //for(int j = 0; j < subpacks.length; j++){
    //  int offset = j * (subpacks[j].cellVoltages.length + subpacks[j].boardTemps.length + subpacks[j].cellTemps.length) * 4;

    //  for(int i = 0; i < subpacks[j].cellVoltages.length; i+=4){
    //    subpacks[j].cellVoltages[i] = int(inString.substring( offset + i, i+4 + offset));
    //  }
    //  for(int i = subpacks[j].cellVoltages.length; i < subpacks[j].cellVoltages.length + subpacks[j].boardTemps.length; i+=4){
    //    subpacks[j].boardTemps[i-subpacks[j].cellVoltages.length] = int(inString.substring(i + offset, i + 4 + offset));
    //  }
    //  for(int i = subpacks[j].cellVoltages.length + subpacks[j].boardTemps.length; i < subpacks[j].cellVoltages.length + subpacks[j].boardTemps.length + subpacks[j].cellTemps.length; i++){
    //    subpacks[j].cellTemps[i - subpacks[j].cellVoltages.length - subpacks[j].boardTemps.length] = int(inString.substring(i + offset, i + 4 + offset));
    //  }
    //}
  }
}
