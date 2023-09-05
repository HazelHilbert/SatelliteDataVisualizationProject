
// Udit Jain

class LineChart extends RectangleWidget implements DataDependentWidget {
  private ArrayList<Double> values;
  private ArrayList<String> labels;
  private double maxValue;
  private color barColor;
  private DataGeneratorHolder chartDataGeneratorHolder;

  LineChart(int xPosition, int yPosition, int width, int height, int radii, color backgroundColor, DataGeneratorHolder chartDataGeneratorHolder) {
    super(xPosition, yPosition, width, height, radii, backgroundColor, backgroundColor);
    values = new ArrayList<Double>();
    labels = new ArrayList<String>();
    barColor = BAR_CLR;
    this.chartDataGeneratorHolder = chartDataGeneratorHolder;
    eventManager.registerDataDependentWidget(this);
    update();
  }
  // updates the values on the line chart.
  public void update() {
    ChartData newData = chartDataGeneratorHolder.getCurrentGenerator().generate();
    values = newData.values;
    labels = newData.labels;
  }
  // draws the line chart
  public void draw() {
    super.draw();
    noStroke();
    
    textFont(courier15);
    maxValue = 0;
    for(Double value : values)
      if(value > maxValue) maxValue = value;
    int barSpacing = 0;
    if(values.size() > 0) barSpacing = (width-BARCHART_LEFT_BORDER_MARGIN-BARCHART_LEFT_AXIS_MARGIN)/values.size();
    for(int i=0; i<values.size(); i++) {
      textAlign(CENTER, CENTER);
      float barLength = (float)((values.get(i)/maxValue)*(height-BARCHART_TOP_MARGIN-BARCHART_BOTTOM_MARGIN));
      // for(int j=i+1; j<values.size(); j++) {
     
      fill(barColor);
      ellipse(BARCHART_LEFT_BORDER_MARGIN+BARCHART_LEFT_AXIS_MARGIN+xPosition+barSpacing*i,yPosition+height-barLength-BARCHART_BOTTOM_MARGIN,5,5);
      if(i<values.size()-1){
        stroke(barColor);
        float barLength2=(float)((values.get(i+1)/maxValue)*(height-BARCHART_TOP_MARGIN-BARCHART_BOTTOM_MARGIN));
        line(BARCHART_LEFT_BORDER_MARGIN+BARCHART_LEFT_AXIS_MARGIN+xPosition+barSpacing*i,yPosition+height-barLength-BARCHART_BOTTOM_MARGIN,BARCHART_LEFT_BORDER_MARGIN+BARCHART_LEFT_AXIS_MARGIN+xPosition+barSpacing*(i+1),yPosition+height-barLength2-BARCHART_BOTTOM_MARGIN);
      }
      fill(AXIS_CLR);
      text(labels.get(i), BARCHART_LEFT_BORDER_MARGIN+2+xPosition+barSpacing*i-10, yPosition+height-BARCHART_BOTTOM_MARGIN, 40, BARCHART_BOTTOM_MARGIN);
      textAlign(RIGHT,CENTER);
      text("0",xPosition+BARCHART_LEFT_BORDER_MARGIN-8,yPosition+height-BARCHART_BOTTOM_MARGIN);
      text(String.valueOf((int)maxValue),xPosition+BARCHART_LEFT_BORDER_MARGIN-8,yPosition+BARCHART_TOP_MARGIN);
    }
    fill(AXIS_CLR);
    noStroke();
    rect(xPosition+BARCHART_LEFT_BORDER_MARGIN-1, yPosition+BARCHART_BOTTOM_MARGIN, 3, height-2*BARCHART_BOTTOM_MARGIN);
    rect(xPosition+BARCHART_LEFT_BORDER_MARGIN, yPosition+height-BARCHART_BOTTOM_MARGIN-1, width-10-BARCHART_LEFT_BORDER_MARGIN, 3);
  }
}
