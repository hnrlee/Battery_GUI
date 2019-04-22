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
    if(vals[index] > 1.5 * findIQR(vals)){
      return true;
    }
    return false;
  }
  
  public static boolean isOutlier(float value, float[] vals){
    if(value > 1.5 * findIQR(vals)){
      return true;
    }
    return false;
  }
}
