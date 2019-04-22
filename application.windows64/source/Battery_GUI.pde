/*

*/

import java.util.Arrays;
Subpack[] subpacks = new Subpack[6];


void setup() {
  fullScreen();
  //size(1500,1000);
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
