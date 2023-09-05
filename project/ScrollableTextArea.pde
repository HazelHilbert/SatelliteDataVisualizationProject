
// Michal Bronicki and Hazel Hilbert: ScrollableTextArea to display the data of the difreent space objects

final int ROW_HEIGHT = 20;
final int TEXT_MARGIN_LEFT = 10;
final String MASS = "Mass", DIAMETER = "Diameter", PERIGEE = "Perigee", APOGEE = "Apogee";

class ScrollableTextArea implements ScrollableWidget, DataDependentWidget {
  private int xPosition;
  private int yPosition;
  private int width;
  private int height;
  private int startingIndex;
  private VerticalSlider slider;
  private ArrayList<ClickableRectangleWidget> rowWidgets;
  private ArrayList<DataPoint> selectedDataPoints;
  private int numberOfRows;
  private String currentExtraDataType;
  private ClickableRectangleWidget satcatWidget, nameWidget, dateWidget, statusWidget, stateWidget, otherWidget;
  
  // provides a constructor for the scrollable text area and creates a vertical slider
  ScrollableTextArea(int xPosition, int yPosition, int width, int height) {
    this.xPosition = xPosition;
    this.yPosition = yPosition;
    this.width = width;
    this.height = height;
    numberOfRows = height/ROW_HEIGHT;
    startingIndex = 0;
    currentExtraDataType = MASS;
    slider = new VerticalSlider(xPosition+width-21, yPosition, 20, height);
    slider.setUpArrowButtonCallback(new Callback() { void call() {setStartingIndexAndSlider(getStartingIndex()-1);}});
    slider.setDownArrowButtonCallback(new Callback() { void call() {setStartingIndexAndSlider(getStartingIndex()+1);}});
    slider.setSliderCallback(new Callback() { void call() {setStartingIndex((int) (slider.getValue()*(provider.filteredDataPoints.size()-numberOfRows)));}});
    eventManager.registerDataDependentWidget(this);  
    eventManager.registerScrollableWidget(this);
    selectedDataPoints = new ArrayList<DataPoint>();
    rowWidgets = new ArrayList<ClickableRectangleWidget>();
    for(int rowIndex=0; rowIndex*ROW_HEIGHT < height; rowIndex++) {
      color fillColor = (rowIndex%2 == 0) ? ROW_CLR_1: ROW_CLR_2;
      rowWidgets.add(new ClickableRectangleWidget(xPosition, yPosition+rowIndex*ROW_HEIGHT, (slider.isVisible()) ? width-slider.width : width, ROW_HEIGHT, fillColor, BUTTON_HOVER_TEXT_CLR));
    }
    satcatWidget = new ClickableRectangleWidget(xPosition+5, yPosition-ROW_HEIGHT-5, (int) textWidth("satcat")+10, 20, 15, TEXTBOX_CLR, BUTTON_HOVER_CLR, courierBold15, "satcat");
    nameWidget = new ClickableRectangleWidget(xPosition+77, yPosition-ROW_HEIGHT-5, (int) textWidth("Name")+10, 20, 15, TEXTBOX_CLR, BUTTON_HOVER_CLR, courierBold15, "Name");
    dateWidget = new ClickableRectangleWidget(xPosition+348, yPosition-ROW_HEIGHT-5, (int) textWidth("Launch Date")+10, 20, 15, TEXTBOX_CLR, BUTTON_HOVER_CLR, courierBold15, "Launch Date");
    statusWidget = new ClickableRectangleWidget(xPosition+491, yPosition-ROW_HEIGHT-5, (int) textWidth("Status")+10, 20, 15, TEXTBOX_CLR, BUTTON_HOVER_CLR, courierBold15, "Status");
    stateWidget = new ClickableRectangleWidget(xPosition+564, yPosition-ROW_HEIGHT-5, (int) textWidth("State")+10, 20, 15, TEXTBOX_CLR, BUTTON_HOVER_CLR, courierBold15, "State");
    otherWidget = new ClickableRectangleWidget(xPosition+635, yPosition-ROW_HEIGHT-5, (int) textWidth(currentExtraDataType)+10, 20, 15, TEXTBOX_CLR, BUTTON_HOVER_CLR, courierBold15, currentExtraDataType);
    satcatWidget.setOnClickCallback(new Callback() { void call() {
      if (provider.getSortingComparator() == COMPARATOR_SATCAT_ASCENDING) provider.setSortingComparator(COMPARATOR_SATCAT_DESCENDING);
      else provider.setSortingComparator(COMPARATOR_SATCAT_ASCENDING);
    }});
    nameWidget.setOnClickCallback(new Callback() { void call() {
      if (provider.getSortingComparator() == COMPARATOR_NAME_ASCENDING) provider.setSortingComparator(COMPARATOR_NAME_DESCENDING);
      else provider.setSortingComparator(COMPARATOR_NAME_ASCENDING);
    }});
    dateWidget.setOnClickCallback(new Callback() { void call() {
      if (provider.getSortingComparator() == COMPARATOR_LAUNCHDATE_ASCENDING) provider.setSortingComparator(COMPARATOR_LAUNCHDATE_DESCENDING);
      else provider.setSortingComparator(COMPARATOR_LAUNCHDATE_ASCENDING);
    }});
    statusWidget.setOnClickCallback(new Callback() { void call() {
      if (provider.getSortingComparator() == COMPARATOR_STATUS_ASCENDING) provider.setSortingComparator(COMPARATOR_STATUS_DESCENDING);
      else provider.setSortingComparator(COMPARATOR_STATUS_ASCENDING);
    }});
    stateWidget.setOnClickCallback(new Callback() { void call() {
      if (provider.getSortingComparator() == COMPARATOR_STATE_ASCENDING) provider.setSortingComparator(COMPARATOR_STATE_DESCENDING);
      else provider.setSortingComparator(COMPARATOR_STATE_ASCENDING);
    }});
    otherWidget.setOnClickCallback(new Callback() { void call() {
      if (provider.getSortingComparator() == COMPARATOR_MASS_ASCENDING) provider.setSortingComparator(COMPARATOR_MASS_DESCENDING);
      else provider.setSortingComparator(COMPARATOR_MASS_ASCENDING);
    }});
}
  
  // draws the scroallable text area, veritical slider, and header and footer
  void draw() {
    noStroke();
    for(int rowIndex=0; rowIndex*ROW_HEIGHT < height; rowIndex++) {
      if (provider.getData().size() > rowIndex+startingIndex) {
        final DataPoint currentDataPoint = provider.getData().get(rowIndex+startingIndex);
        if(chartPanel.getCurrentGraphChartSelection().equals(TYPE_DROPDOWN_LABEL_3DORBIT)) {
          rowWidgets.get(rowIndex).setOnClickCallback(new Callback() { public void call() { 
            if(isDataPointSelected(currentDataPoint)) removeSelectedDataPoint(currentDataPoint);
            else addSelectedDataPoint(currentDataPoint);
          }});
        } else {
          rowWidgets.get(rowIndex).setOnClickCallback(new Callback() { public void call() {chartPanel.setCurrentDataPoint(currentDataPoint);}});
        }
        if(chartPanel.getCurrentGraphChartSelection().equals(TYPE_DROPDOWN_LABEL_3DORBIT) && isDataPointSelected(currentDataPoint)) {
          rowWidgets.get(rowIndex).setPrimaryColor(BUTTON_SELECTED_TEXT_CLR);
          rowWidgets.get(rowIndex).setHoverColor(BUTTON_HOVER_TEXT_CLR);
        } else {
          rowWidgets.get(rowIndex).setPrimaryColor((rowIndex%2 == 0) ? ROW_CLR_1 : ROW_CLR_2);
          rowWidgets.get(rowIndex).setHoverColor(BUTTON_HOVER_TEXT_CLR);
        }
      } else {
        rowWidgets.get(rowIndex).setOnClickCallback(EMPTY_CALLBACK);  
        rowWidgets.get(rowIndex).setPrimaryColor((rowIndex%2 == 0) ? ROW_CLR_1 : ROW_CLR_2); //CLR
        rowWidgets.get(rowIndex).setHoverColor(BUTTON_HOVER_TEXT_CLR);
      }
      rowWidgets.get(rowIndex).draw();
      textAlign(LEFT, CENTER);
      fill(ROW_TEXT_CLR);
      if (provider.getData().size() > rowIndex+startingIndex) text(provider.getData().get(rowIndex+startingIndex).getDescription(currentExtraDataType), xPosition+TEXT_MARGIN_LEFT, yPosition+rowIndex*ROW_HEIGHT+ROW_HEIGHT/2);
    }
    strokeWeight(1);
    stroke(SLIDER_CLR);
    fill(ROW_CLR_1);
    rect(xPosition+width-21, yPosition-1, 20, height+2);
    noStroke();
    slider.draw();

    fill(SLIDER_CLR);
    rect(xPosition, yPosition-ROW_HEIGHT*3/2, width, ROW_HEIGHT*3/2, 15, 15, 0, 0);
    rect(xPosition, yPosition+height, width, ROW_HEIGHT, 0, 0, 15, 15);
    
    satcatWidget.draw(); nameWidget.draw(); dateWidget.draw(); statusWidget.draw(); stateWidget.draw(); otherWidget.draw();

    fill(DARK_TEXT_CLR);
    textAlign(RIGHT, CENTER);
    text("number of space objects: " + provider.getData().size(), xPosition-slider.width+width, yPosition+ROW_HEIGHT/2+height);
    textFont(courier15);
  }

  public ArrayList<DataPoint> getSelectedDataPoints() {
    return selectedDataPoints;
  }
  private boolean isDataPointSelected(DataPoint dataPoint) {
    for(DataPoint currentDataPoint : selectedDataPoints) {
      if(currentDataPoint == dataPoint) return true;
    }
    return false;
  }
  private void removeSelectedDataPoint(DataPoint dataPoint) {
    for(int i=0; i<selectedDataPoints.size(); i++) {
      if(selectedDataPoints.get(i) == dataPoint) {
        selectedDataPoints.remove(i);
        break;
      }
    }
  }
  private void addSelectedDataPoint(DataPoint dataPoint) {
    if(selectedDataPoints.size() < 50)
      selectedDataPoints.add(dataPoint);
  }
  
  // gets called every time the data is updated
  @Override
  void update() {
    setStartingIndexAndSlider(0);
    selectedDataPoints.clear();
  }
  
  int getStartingIndex() {
    return startingIndex;  
  }
  // sets staring and slider index
  void setStartingIndexAndSlider(int startingIndex) {
    setStartingIndex(startingIndex);
    if(provider.getData().size() > numberOfRows) {
      slider.display();
      if(startingIndex >= 0 && startingIndex < provider.getData().size()-numberOfRows+1)
        slider.setValue(map(startingIndex, 0, provider.getData().size()-numberOfRows, 0.0, 1.0));
    } 
    else slider.hide();
  }
  // sets staring index if the new starting index is within bounds
  void setStartingIndex(int startingIndex) {
    if(startingIndex>=0 && startingIndex<provider.getData().size()-(provider.getData().size() > numberOfRows ? numberOfRows : 0)+1) {
      this.startingIndex = startingIndex;
    }
  }
  // returns false if there are not enough elements to require scrolling
  boolean requireScrolling(){
    return (provider.getData().size() > numberOfRows);
  }
  // sets the extra data type to be displayed
  void setExtraDataType(String dataType){
    if (dataType.equals(MASS) || dataType.equals(DIAMETER) || dataType.equals(PERIGEE) || dataType.equals(APOGEE)) {
      currentExtraDataType = dataType;
      otherWidget.hide();
      textFont(courierBold15);
      otherWidget = new ClickableRectangleWidget(xPosition+635, yPosition-ROW_HEIGHT-5, (int) textWidth(currentExtraDataType)+10, 20, 15, TEXTBOX_CLR, BUTTON_HOVER_CLR, courierBold15, currentExtraDataType);
      final String finalDataType = dataType;
      otherWidget.setOnClickCallback(new Callback() { public void call() {
        if (finalDataType.equals(MASS)) {
          if (provider.getSortingComparator() == COMPARATOR_MASS_ASCENDING) provider.setSortingComparator(COMPARATOR_MASS_DESCENDING);
          else provider.setSortingComparator(COMPARATOR_MASS_ASCENDING);
        }
        else if (finalDataType.equals(DIAMETER)) {
          if (provider.getSortingComparator() == COMPARATOR_DIAMETER_ASCENDING) provider.setSortingComparator(COMPARATOR_DIAMETER_DESCENDING);
          else provider.setSortingComparator(COMPARATOR_DIAMETER_ASCENDING);
        }
        else if (finalDataType.equals(PERIGEE)) {
          if (provider.getSortingComparator() == COMPARATOR_PERIGEE_ASCENDING) provider.setSortingComparator(COMPARATOR_PERIGEE_DESCENDING);
          else provider.setSortingComparator(COMPARATOR_PERIGEE_ASCENDING);
        }
        else if (finalDataType.equals(APOGEE)) {
          if (provider.getSortingComparator() == COMPARATOR_APOGEE_ASCENDING) provider.setSortingComparator(COMPARATOR_APOGEE_DESCENDING);
          else provider.setSortingComparator(COMPARATOR_APOGEE_ASCENDING);
        }
      }});
    }
  }

  @Override
  public boolean isHovered() {
    return (mouseX >= xPosition && mouseX < xPosition + width && mouseY >= yPosition && mouseY < yPosition + height);
  }
  @Override
  public void invokeMouseWheelUsed(MouseEvent event) {
    float e = event.getCount();
    if (requireScrolling()) {
      if(e > 0) setStartingIndexAndSlider(scrollableTextArea.getStartingIndex()+1);
      else if(e < 0) setStartingIndexAndSlider(scrollableTextArea.getStartingIndex()-1);
    }
  }

  public void display() {} 
  public void hide() {}
}
