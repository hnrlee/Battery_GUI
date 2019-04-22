import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.Arrays; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Battery_GUI extends PApplet {

/*

*/


Subpack[] subpacks = new Subpack[6];


public void setup() {
  
  //size(1500,1000);
  frameRate(1);
  background(0);
    for(int i = 0; i < subpacks.length; i++){
    subpacks[i] = new Subpack();
    subpacks[i].subpackNumber = i+1;
    subpacks[i].drawSubpack(!(i>2) ? 0 : width/2, ((i%3) * (height/3-100)), width/2, height/3-100);
    
  }
}

public void draw() {
  background(0);
  for(int i = 0; i < subpacks.length; i++){
    subpacks[i] = new Subpack();
    subpacks[i].subpackNumber = i+1;
    subpacks[i].drawSubpack(!(i>2) ? 0 : width/2, ((i%3) * (height/3-100)), width/2, height/3-100);
    
  }
  
  
}
public static class Stats{
  public static float mean(float[] vals){
    float sum = 0;
    for(int i = 0; i < vals.length; i++){
      sum+= vals[i];
    }
    return sum/vals.length;
  }
  
  public static float median(float[] vals){
    return vals[vals.length/2];
  }
  
  public static float min(float[] vals){
    float[] tempArr = Arrays.copyOf(vals, vals.length);
    Arrays.sort(tempArr);
    return tempArr[0];
  }
    public static float max(float[] vals){
    float[] tempArr = Arrays.copyOf(vals, vals.length);
    Arrays.sort(tempArr);
    return tempArr[tempArr.length - 1];
  }
  
  public static float firstQuartile(float[] vals){
    float[] tempArr = Arrays.copyOf(vals, vals.length);
    Arrays.sort(tempArr);
    return tempArr[vals.length/4];
  }
  
  public static float thirdQuartile(float[] vals){
    float[] tempArr = Arrays.copyOf(vals, vals.length);
    
    Arrays.sort(tempArr);
    return tempArr[vals.length*3/4];
  }
  
  public static float findIQR(float[] vals){
    return thirdQuartile(vals) - firstQuartile(vals);
  }
  public static boolean isOutlier(int index, float[] vals){
    if(vals[index] > 1.5f * findIQR(vals)){
      return true;
    }
    return false;
  }
  
  public static boolean isOutlier(float value, float[] vals){
    if(value > 1.5f * findIQR(vals)){
      return true;
    }
    return false;
  }
}
public class Subpack{
  public static final float AMBIENTTEMP = 25.0f;
  public int subpackNumber;
  public float[] cellTemps = new float[15];//0-4 first subsubpack, 5-9 second subsubpack, 10-14 third subsubpack
  public float[] boardTemps = new float[9];//0-2 first BMS Slave Board Temp, 3-5 second BMS Slave Board Temp, 6-8 third BMS Slave Board Temp
  public float[] cellVoltages = new float[28];
  
  float acceptableVoltageDifference = 0.014f;
  float worryingVoltageDifference = 0.03f;
  
  final int CYAN = color(0xff00FFFF);
  final int PURPLE = color(0xffFFA0FF);
  final int ORANGE = color(0xffFFE090);
  
  public Subpack(){
    //for testing
    for(int i = 0; i < cellTemps.length; i++){
     cellTemps[i] = random(AMBIENTTEMP-10, 30); 
    }
    for(int i = 0; i < boardTemps.length; i++){
     boardTemps[i] = random(AMBIENTTEMP - 10,30); 
    }
    for(int i = 0; i < cellVoltages.length; i++){
     cellVoltages[i] = random(3,3.08f); 
    }
  }
  
  public Subpack(float[] cellTemperatures, float[] boardTemperatures, float[] cellVoltages, int subpackNumber){
    this.cellTemps = cellTemperatures;
    this.boardTemps = boardTemperatures;
    this.cellVoltages = cellVoltages;
    this.subpackNumber = subpackNumber;
  }
  public void drawSubpack(int xPos, int yPos, int subpackWindowWidth, int subpackWindowHeight){
    //
    //FRAME SETUP
    //
    int subpackWidth = subpackWindowWidth * 2;
    int subpackHeight = subpackWindowHeight * 3;
    stroke(255);
    fill(0);
    strokeWeight(4);
    rect(xPos, yPos, subpackWidth/2, subpackHeight/3);
    strokeWeight(1);
    line(xPos + subpackWindowWidth*25/100, yPos, xPos + subpackWindowWidth*25/100, yPos + subpackWindowHeight);
    line(xPos + subpackWindowWidth*65/100, yPos, xPos + subpackWindowWidth*65/100, yPos + subpackWindowHeight);
    fill(255);
    textSize(subpackHeight/(3*17));
    text("Subpack " + subpackNumber, xPos + subpackWindowWidth * 90/100, yPos + subpackHeight/(3*17));
    
    //
    //BOARD TEMPERATURES
    //
    
    int boardTempTextSize = subpackHeight/(3*17);
    int boardTempTextX;
    int boardTempTextY;
    fill(255);
    
    text("Board Temps", xPos + subpackWidth/200, yPos + boardTempTextSize);
    
    int index;
    int greenBlueValue = 255;
    for(int i = 0; i < 3; i++){
      for(int j = 0; j < 3; j++){
        index = i * 3 + j;
        if(boardTemps[index] > AMBIENTTEMP){
          greenBlueValue = 255-(int)map(boardTemps[index], AMBIENTTEMP, 60, 150,255);
        }
        else{
          greenBlueValue = 255;
        }
        boardTempTextY = i * subpackHeight/13 + boardTempTextSize * j + subpackHeight/11 + yPos;
        boardTempTextX = subpackWidth/50 + xPos;
        
        fill(greenBlueValue == 255 ? color(0,255,0) : color(255, greenBlueValue, greenBlueValue));
        rect(boardTempTextX - boardTempTextSize - boardTempTextSize/2, boardTempTextY - boardTempTextSize, boardTempTextSize, boardTempTextSize);
        
        textSize(boardTempTextSize);
        if(index < 3){
          fill(CYAN);
        }
        else if(index < 6){
          fill(PURPLE);
        }
        else{
          fill(ORANGE);
        }
        try{
          text("Board Temp " + (i*2 + j + 1) + ": " + str(boardTemps[i*3 +j]).substring(0,5), boardTempTextX, boardTempTextY);
        }
        catch(Exception e){
          System.out.println("Oh man it didn't like that float");
        }
      }
    }
    
    //
    //CELL VOLTAGES
    //
    
    int cellVoltageTextSize = subpackHeight/(3*17);
    int cellVoltageTextXPos = xPos + subpackWidth/6;
    textSize(cellVoltageTextSize);
    fill(255);
    text("Cell Voltages",cellVoltageTextXPos, yPos + cellVoltageTextSize);
    line(xPos, yPos + cellVoltageTextSize + 2, xPos + subpackWidth/2, yPos + cellVoltageTextSize + 2);
    for(int i = 0; i < cellVoltages.length; i++){
      int textX = (i < cellVoltages.length /2) ? (cellVoltageTextXPos): (10 + cellVoltageTextXPos + subpackWidth*8/100);
      int textY = yPos + cellVoltageTextSize * 2 + i%(cellVoltages.length/2) * cellVoltageTextSize + 15;
      if(i < 9){
        fill(CYAN);
      }
      else if(i < 18){
        fill(PURPLE);
      }
      else{
        fill(ORANGE);
      }
      try{
        text("Cell " + (i+1) + ": " + (i < 9 ? "  " : "") + str(cellVoltages[i]).substring(0,5), textX, textY);
      }
      catch(Exception e){
        System.out.println("Oh man it didn't like that float");
      }
      
      //draw boxes
      if(cellVoltages[i] - Stats.min(cellVoltages) > worryingVoltageDifference){
        fill(255,0,0);
      }
      else if(cellVoltages[i] - Stats.min(cellVoltages) > acceptableVoltageDifference){
        fill(255,255,0);
      }
      else{
        fill(0,255,0);
      }
      rect(textX - 25, textY - cellVoltageTextSize, cellVoltageTextSize, cellVoltageTextSize);
    }
    
    //
    //CELL TEMPERATURES
    //
    
    int cellTempTextSize = subpackHeight/(3*17);
    int cellTempTextX;
    int cellTempTextY;
    fill(255);
    text("Cell Temps", xPos + subpackWidth*37/100, yPos + cellTempTextSize);
    
    for(int i = 0; i < cellTemps.length; i++){
      
      if(cellTemps[i] > AMBIENTTEMP){
        greenBlueValue = 255-(int)map(cellTemps[i], AMBIENTTEMP, 60, 150, 255);
      }
      else{
        greenBlueValue = 255;
      }
      cellTempTextY = yPos + cellTempTextSize * i + cellTempTextSize*5/2;
      cellTempTextX = xPos + subpackWidth*37/100;
      fill(greenBlueValue == 255 ? color(0,255,0) : color(255, greenBlueValue, greenBlueValue));
      rect(cellTempTextX - cellTempTextSize - subpackWidth/200, cellTempTextY - cellTempTextSize, cellTempTextSize, cellTempTextSize);
      
      if(i < 5){
        fill(CYAN);
      }
      else if(i < 10){
        fill(PURPLE);
      }
      else{
        fill(ORANGE);
      }
      
      try{
        text("Cell Temp " + (i+1) + ": " + str(cellTemps[i]).substring(0, 5), cellTempTextX, cellTempTextY);
      }
      catch(Exception e){
        System.out.println("Oh man it didn't like that float");
      }
    }
  }
}
  public void settings() {  fullScreen(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Battery_GUI" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
