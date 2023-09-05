final int BARCHART_BOTTOM_MARGIN = 20;
final int BARCHART_TOP_MARGIN = 40;
final int BARCHART_LEFT_BORDER_MARGIN = 75;
final int BARCHART_LEFT_AXIS_MARGIN = 25;
final int MAXIMUM_NUMBER_OF_BARS = 10;

// Udit Jain and Mark Doyle

class BarChart extends RectangleWidget implements DataDependentWidget {
  private ArrayList<Double> values;
  private ArrayList<String> labels;
  private double maxValue;
  private color barColor;
  private DataGeneratorHolder chartDataGeneratorHolder;

  BarChart(int xPosition, int yPosition, int width, int height, int radii, color backgroundColor, DataGeneratorHolder chartDataGeneratorHolder) {
    super(xPosition, yPosition, width, height, radii, backgroundColor, backgroundColor);
    values = new ArrayList<Double>();
    labels = new ArrayList<String>();
    barColor = BAR_CLR;
    this.chartDataGeneratorHolder = chartDataGeneratorHolder;
    eventManager.registerDataDependentWidget(this);
    update();
  }
  // updates the values on the barChart
  public void update() {
    ChartData newData = chartDataGeneratorHolder.getCurrentGenerator().generate();
    values = newData.values;
    labels = newData.labels;
  }
  // draws the BarChart labels and columns.
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
      RectangleWidget bar = new RectangleWidget(BARCHART_LEFT_BORDER_MARGIN+BARCHART_LEFT_AXIS_MARGIN+xPosition+barSpacing*i, (int)(yPosition+height-barLength-BARCHART_BOTTOM_MARGIN), 20, (int)barLength, barColor, ORANGE2);
      if(bar.isHovered()) {
        bar = new RectangleWidget(BARCHART_LEFT_BORDER_MARGIN+BARCHART_LEFT_AXIS_MARGIN+xPosition+barSpacing*i-3, (int)(yPosition+height-barLength-BARCHART_BOTTOM_MARGIN)-6, 20+6, (int)barLength+6, barColor, ORANGE2);
        String label = labels.get(i).toString();
        String value = values.get(i).toString();
        if (value.equals("OTH")) value = "other";
        RectangleWidget infoBox= new RectangleWidget(xPosition+width-100, yPosition+20, 100, 50, 15, BUTTON_CLR, BUTTON_CLR);
        infoBox.draw();
        fill(BACKGROUND_CLR);
        text(label + "\n" + value, infoBox.xPosition+infoBox.width/2, infoBox.yPosition+infoBox.height/2);
      }
      bar.draw();
      fill(AXIS_CLR);
      text(labels.get(i), BARCHART_LEFT_BORDER_MARGIN+BARCHART_LEFT_AXIS_MARGIN+xPosition+barSpacing*i-10, yPosition+height-BARCHART_BOTTOM_MARGIN, 40, BARCHART_BOTTOM_MARGIN);
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
