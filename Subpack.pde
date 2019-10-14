public class Subpack{
  public static final float AMBIENTTEMP = 25.0;
  public int subpackNumber;
  public float[] cellTemps = new float[15];//0-4 first subsubpack, 5-9 second subsubpack, 10-14 third subsubpack
  public float[] boardTemps = new float[9];//0-2 first BMS Slave Board Temp, 3-5 second BMS Slave Board Temp, 6-8 third BMS Slave Board Temp
  public float[] cellVoltages = new float[28];
  
  float acceptableVoltageDifference = 0.150;
  float worryingVoltageDifference = 0.300;
  
  final color CYAN = color(#00FFFF);
  final color PURPLE = color(#FFA0FF);
  final color ORANGE = color(#FFE090);
  
  public Subpack(){
    //for testing
    for(int i = 0; i < cellTemps.length; i++){
     cellTemps[i] = random(AMBIENTTEMP-10, 30); 
    }
    for(int i = 0; i < boardTemps.length; i++){
     boardTemps[i] = random(AMBIENTTEMP - 10,30); 
    }
    for(int i = 0; i < cellVoltages.length; i++){
     cellVoltages[i] = random(3,3.08); 
    }
  }
  
  public Subpack(float[] cellTemperatures, float[] boardTemperatures, float[] cellVoltages, int subpackNumber){
    this.cellTemps = cellTemperatures; //<>//
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
          text("Board Temp " + (i*2 + j + 1) + ": " + str(boardTemps[i*3 +j]), boardTempTextX, boardTempTextY);
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
        text("Cell " + (i+1) + ": " + (i < 9 ? "  " : "") + str(cellVoltages[i]), textX, textY);
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
        text("Cell Temp " + (i+1) + ": " + str(cellTemps[i]), cellTempTextX, cellTempTextY);
      }
      catch(Exception e){
      }
    }
  }
}
