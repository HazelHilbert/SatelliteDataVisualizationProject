
// Udit Jain, Mark Doyle, and Hazel Hilbert

final int PIECHART_SIDE_MARGIN = 10;
final int[] COLORS_10 = {lerpColor(FIRST_COLOR, 0, 0.3),lerpColor(FIRST_COLOR, 0, 0.2),lerpColor(FIRST_COLOR, 0, 0.1), lerpColor(FIRST_COLOR, OTHER_COLOR, 0), lerpColor(FIRST_COLOR, OTHER_COLOR, 0.2), lerpColor(FIRST_COLOR, OTHER_COLOR, 0.4), lerpColor(FIRST_COLOR, OTHER_COLOR, 0.6), lerpColor(FIRST_COLOR, OTHER_COLOR, 0.8), lerpColor(FIRST_COLOR, OTHER_COLOR, 1), color(255,240,150)};
final int[] COLORS_6 = {lerpColor(FIRST_COLOR, OTHER_COLOR, 0), lerpColor(FIRST_COLOR, OTHER_COLOR, 0.2), lerpColor(FIRST_COLOR, OTHER_COLOR, 0.4), lerpColor(FIRST_COLOR, OTHER_COLOR, 0.6), lerpColor(FIRST_COLOR, OTHER_COLOR, 0.8), lerpColor(FIRST_COLOR, OTHER_COLOR, 1)};

class PieChart extends RectangleWidget implements DataDependentWidget {
  private ArrayList<Double> values;
  private ArrayList<String> labels;
  private ArrayList<Double> valueAngles;
  private DataGeneratorHolder chartDataGeneratorHolder;
  private RectangleWidget infoBox;
  private RectangleWidgetBuilder infoBoxBuilder;
  private boolean isRangeFreq;
  
  PieChart (int xPosition, int yPosition, int width, int height, int radii, color backgroundColor, DataGeneratorHolder chartDataGeneratorHolder, boolean isRangeFreq){
    super(xPosition, yPosition, width, height, radii, backgroundColor, backgroundColor);
    values = new ArrayList<Double>();
    labels = new ArrayList<String>();
    this.chartDataGeneratorHolder = chartDataGeneratorHolder;
    this.isRangeFreq = isRangeFreq;
    eventManager.registerDataDependentWidget(this);
    update();
    infoBoxBuilder = new RectangleWidgetBuilder()
                         .cornersRadii(15)
                         .primaryColor(BUTTON_CLR)
                         .hoverColor(BUTTON_CLR)
                         .labelTextColor(DARK_TEXT_CLR)
                         .labelTextFont(courier15);
     }
  
  // updates values on the pieChart
  public void update(){
    ChartData newData = chartDataGeneratorHolder.getCurrentGenerator().generate();
    values = newData.values;
    labels = newData.labels;
    valueAngles = myAngles(values);
  }

  // returns an arrayList of angles for the pieChart
  private  ArrayList<Double> myAngles(ArrayList <Double> values) {
    ArrayList <Double> myAngles = new ArrayList<Double>();  
    double sum=0;
    for(int i=0; i<values.size();i++) sum =( sum +values.get(i));
    for (int i=0;i<values.size();i++) {
      double angles =0;
      angles= (values.get(i)/sum)*360;
      myAngles.add(angles);
    }
    return myAngles;
  }
  
  // draws the pieChart
  void draw() {
    super.draw();
    if(valueAngles.size() == 0) {
      textFont(courier30); fill(LIGHT_TEXT_CLR); textAlign(CENTER, CENTER);
      text("no data to graph", xPosition+width/2, yPosition+height/2);
      textFont(courier15);
    }
    else {
      if (isRangeFreq) rangePieChart(0.7 * (width <= height ? width : height), valueAngles);
      else pieChart(0.7 * (width <= height ? width : height), valueAngles);
    }
  }
  
  // creates the segments of the pie chart and gives them different colours
  void pieChart(float diameter, ArrayList <Double> valueAngles) {
    float lastAngle = -HALF_PI;
    textAlign(LEFT, TOP); textFont(courier15); fill(BUTTON_CLR);
    int verticalBuffer = -120;
    for(int i = 0; i < valueAngles.size(); i++) {
      fill((valueAngles.size() > 6) ? COLORS_10[i] : COLORS_6[i]);
      float newAngle = lastAngle+radians(valueAngles.get(i).floatValue());
      if(isArcHovered((int) (xPosition+diameter/2+PIECHART_SIDE_MARGIN*2), yPosition+height/2, diameter/2, lastAngle+PI/2, newAngle+PI/2)) {
        infoBox = infoBoxBuilder
                        .size(140, 60)
                        .leftCornerPosition(mouseX, mouseY)
                        .labelText(labels.get(i) + "\n" + String.format("%.2f", (float)(valueAngles.get(i)*100/360)) + "%")
                        .build();
        arc((float) (xPosition+diameter/2+PIECHART_SIDE_MARGIN*2), yPosition+height/2, diameter+15, diameter+15, lastAngle, newAngle);
      }
      else arc(xPosition+diameter/2+PIECHART_SIDE_MARGIN*2, yPosition+height/2, diameter, diameter, lastAngle, newAngle);
      rect(xPosition+height-diameter/10-40, yPosition+height/2+verticalBuffer, 10, 10);
      fill(WHITE_TEXT_CLR);
      text(labels.get(i), xPosition+height-diameter/10-20, yPosition+height/2+verticalBuffer);
      verticalBuffer += 25;
      lastAngle += radians(valueAngles.get(i).floatValue());
    }
    if(isArcHovered((int) (xPosition+diameter/2+PIECHART_SIDE_MARGIN*2), yPosition+height/2, diameter/2, 0, TWO_PI)) infoBox.draw();
  }
  
  // creates the segments of the range pie chart and gives them different colours
  void rangePieChart(float diameter, ArrayList <Double> valueAngles) {
    float lastAngle = -HALF_PI;
    textAlign(LEFT, CENTER); textFont(courier15); fill(BUTTON_CLR);
    int verticalBufferRange = 0;
    int horizontalBufferRange = 27;
    for(int i = 0; i < valueAngles.size(); i++) {
      fill(COLORS_6[i]);
      float newAngle = lastAngle+radians(valueAngles.get(i).floatValue());
      if(isArcHovered(xPosition+width/2, (int) (yPosition+diameter/2+PIECHART_SIDE_MARGIN*2), diameter/2, lastAngle+PI/2, newAngle+PI/2)) {
         infoBox = infoBoxBuilder
                        .size(180, 60)
                        .leftCornerPosition(mouseX, mouseY)
                        .labelText(labels.get(i) + "\n" + String.format("%.2f", (float)(valueAngles.get(i)*100/360)) + "%")
                        .build();
         arc(xPosition+width/2, yPosition+diameter/2+PIECHART_SIDE_MARGIN*2, diameter+15, diameter+15, lastAngle, newAngle);
      }     
      else arc(xPosition+width/2, yPosition+diameter/2+PIECHART_SIDE_MARGIN*2, diameter, diameter, lastAngle, newAngle);
      rect(xPosition+horizontalBufferRange-15, yPosition+height-78+verticalBufferRange, 10, 10);
      fill(WHITE_TEXT_CLR);
      text(labels.get(i), xPosition+horizontalBufferRange, yPosition+height-75+verticalBufferRange);
      if (valueAngles.size() != 0) horizontalBufferRange += width/(ceil(valueAngles.size()/2.0));
      if (i == ceil(valueAngles.size()/2.0)-1) {
        verticalBufferRange = 30;
        horizontalBufferRange = 27;
      }
      lastAngle += radians(valueAngles.get(i).floatValue());
    }
    if(isArcHovered(xPosition+width/2, (int) (yPosition+diameter/2+PIECHART_SIDE_MARGIN*2), diameter/2, 0, TWO_PI)) infoBox.draw();
  }

  // checks whether the mouse cursor is over the specified arc of a circle
  // by Michal Bronicki
  private boolean isArcHovered(int centerX, int centerY, float radius, float minAngle, float maxAngle) {
    if((mouseX-centerX)*(mouseX-centerX) + (mouseY-centerY)*(mouseY-centerY) > radius*radius)
      return false;
    if(mouseX == centerX && mouseY == centerY)
      return false;

    float cursorAngle = 0;
    if(mouseX < centerX)
      cursorAngle = 3*PI/2 + atan((float)(mouseY-centerY)/(mouseX-centerX));
    else if(mouseX > centerX)
      cursorAngle = PI/2 + atan((float)(mouseY-centerY)/(mouseX-centerX));
    else if(mouseY < centerY)
      cursorAngle = 0;
    else if(mouseY > centerY)
      cursorAngle = PI;

    return (cursorAngle >= minAngle && cursorAngle <= maxAngle);
  }
}
