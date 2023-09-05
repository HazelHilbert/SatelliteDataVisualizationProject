
// Michal Bronicki and Hazel Hilbert: FilterMenu class to implement data filtering and user interface

class FilterMenu implements Widget {
  private int xpos, ypos;
  private int height, buffer, radii;
  private color filterColor, filterHoverColor, filterClickedColor;
  private PFont filterFont;
  private ClickableRectangleWidget nameButton, dateButton, statusButton, stateButton, massButton, diameterButton, perigeeButton, apogeeButton, satcatButton, resetButton;
  private RectangleWidget box;
  private TextWidget satcatTextBox, nameTextBox, statusTextBox, stateTextBox;
  private RangeInputWidget yearTextBox, massTextBox, diameterTextBox, perigeeTextBox, apogeeTextBox;
  private ClickableRectangleWidget currentlySelectedButton;
  private Widget currentlyDisplayedFilterWidget;
  private String satcatFilter, nameFilter, statusFilter, stateFilter;
  private double minYear, maxYear;
  private double minMass, maxMass;
  private double minDiameter, maxDiameter;
  private double minPerigee, maxPerigee;
  private double minApogee, maxApogee;

  public FilterMenu(int xpos, int ypos, int height, int buffer, int radii, color normalColor, color hoverColor, color clickedColor, PFont font){
    this.xpos = xpos; this.ypos = ypos; this.height = height; this.buffer = buffer; this.radii = radii;
    filterColor = normalColor; filterHoverColor = hoverColor; filterClickedColor = clickedColor; filterFont = font;
    
    resetFilters();
 
    satcatButton = new ClickableRectangleWidget(xpos, ypos, 60+buffer*3/2, height, radii, filterColor, filterHoverColor, filterClickedColor, filterFont, "Satcat");
    nameButton = new ClickableRectangleWidget(satcatButton.xPosition+satcatButton.width+buffer*3/4, ypos, 40+buffer*3/2, height, radii, filterColor, filterColor, filterClickedColor, filterFont, "Name");
    dateButton = new ClickableRectangleWidget(nameButton.xPosition+nameButton.width+buffer*3/4, ypos, 40+buffer*3/2, height, radii, filterColor, filterHoverColor, filterClickedColor, filterFont, "Date");
    statusButton = new ClickableRectangleWidget(dateButton.xPosition+dateButton.width+buffer*3/4, ypos, 60+buffer*3/2, height, radii, filterColor, filterHoverColor, filterClickedColor, filterFont, "Status");
    stateButton = new ClickableRectangleWidget(statusButton.xPosition+statusButton.width+buffer*3/4, ypos, 50+buffer*3/2, height, radii, filterColor, filterHoverColor, filterClickedColor, filterFont, "State");
    massButton = new ClickableRectangleWidget(stateButton.xPosition+stateButton.width+buffer*3/4, ypos, 40+buffer*3/2, height, radii, filterColor, filterHoverColor, filterClickedColor, filterFont, "Mass");
    diameterButton = new ClickableRectangleWidget(massButton.xPosition+massButton.width+buffer*3/4, ypos, 80+buffer*3/2, height, radii, filterColor, filterHoverColor, filterClickedColor, filterFont, "Diameter");
    perigeeButton = new ClickableRectangleWidget(diameterButton.xPosition+diameterButton.width+buffer*3/4, ypos, 70+buffer*3/2, height, radii, filterColor, filterHoverColor, filterClickedColor, filterFont, "Perigee");
    apogeeButton = new ClickableRectangleWidget(perigeeButton.xPosition+perigeeButton.width+buffer*3/4, ypos, 63+buffer*3/2, height, radii, filterColor, filterHoverColor, filterClickedColor, filterFont, "Apogee");
    resetButton = new ClickableRectangleWidget(apogeeButton.xPosition+apogeeButton.width+buffer*3/4, ypos, height, height, height/2, filterColor, filterHoverColor, filterClickedColor, filterFont, "");

    satcatTextBox = new TextWidget(xpos, ypos+height+buffer, scrollableTextArea.width-1, height+buffer, filterColor, filterHoverColor, "Satcat: ", filterFont, 30, new Callback() { void call() {
      satcatFilter = satcatTextBox.getText();
      applyFilter();
    }});
    satcatTextBox.hide();
    nameTextBox = new TextWidget(xpos, ypos+height+buffer, scrollableTextArea.width-1, height+buffer, filterColor, filterHoverColor, "Name: ", filterFont, 30, new Callback() { void call() {
      nameFilter = nameTextBox.getText();
      applyFilter();
    }});
    currentlyDisplayedFilterWidget = nameTextBox;
    statusTextBox = new TextWidget(xpos, ypos+height+buffer, scrollableTextArea.width-1, height+buffer, filterColor, filterHoverColor, "Status: ", filterFont, 30, new Callback() { void call() {
      statusFilter = statusTextBox.getText();
      applyFilter();
    }});
    statusTextBox.hide();
    stateTextBox = new TextWidget(xpos, ypos+height+buffer, scrollableTextArea.width-1, height+buffer, filterColor, filterHoverColor, "State: ", filterFont, 30, new Callback() { void call() {
      stateFilter = stateTextBox.getText();
      applyFilter();
    }});
    stateTextBox.hide();
    yearTextBox = new RangeInputWidget(xpos, ypos+height+buffer, scrollableTextArea.width-1, height+buffer, filterColor, filterHoverColor, "Min year: ", "Max year: ", filterFont, 30, new Callback() { void call() {
      minYear = yearTextBox.getMinValue();
      maxYear = yearTextBox.getMaxValue();
      applyFilter();
    }});
    yearTextBox.hide();
    massTextBox = new RangeInputWidget(xpos, ypos+height+buffer, scrollableTextArea.width-1, height+buffer, filterColor, filterHoverColor, "Min mass: ", "Max mass: ", filterFont, 30, new Callback() { void call() {
      minMass = massTextBox.getMinValue();
      maxMass = massTextBox.getMaxValue();
      applyFilter();
    }});
    massTextBox.hide();
    diameterTextBox = new RangeInputWidget(xpos, ypos+height+buffer, scrollableTextArea.width-1, height+buffer, filterColor, filterHoverColor, "Min diameter: ", "Max diameter: ", filterFont, 30, new Callback() { void call() {
      minDiameter = diameterTextBox.getMinValue();
      maxDiameter = diameterTextBox.getMaxValue();
      applyFilter();
    }});
    diameterTextBox.hide();
    perigeeTextBox = new RangeInputWidget(xpos, ypos+height+buffer, scrollableTextArea.width-1, height+buffer, filterColor, filterHoverColor, "Min perigee: ", "Max perigee: ", filterFont, 30, new Callback() { void call() {
      minPerigee = perigeeTextBox.getMinValue();
      maxPerigee = perigeeTextBox.getMaxValue();
      applyFilter();
    }});
    perigeeTextBox.hide();
    apogeeTextBox = new RangeInputWidget(xpos, ypos+height+buffer, scrollableTextArea.width-1, height+buffer, filterColor, filterHoverColor, "Min apogee: ", "Max apogee: ", filterFont, 30, new Callback() { void call() {
      minApogee = apogeeTextBox.getMinValue();
      maxApogee = apogeeTextBox.getMaxValue();
      applyFilter();
    }});
    apogeeTextBox.hide();
    
    box = new RectangleWidget(nameButton.xPosition, ypos+height/2, nameButton.width, height+radii, normalColor, normalColor);
    currentlySelectedButton = nameButton;
    satcatButton.setOnClickCallback(setFilterButtonCallback(satcatButton));
    nameButton.setOnClickCallback(setFilterButtonCallback(nameButton));
    dateButton.setOnClickCallback(setFilterButtonCallback(dateButton));
    statusButton.setOnClickCallback(setFilterButtonCallback(statusButton));
    stateButton.setOnClickCallback(setFilterButtonCallback(stateButton));
    massButton.setOnClickCallback(setFilterButtonCallback(massButton));
    diameterButton.setOnClickCallback(setFilterButtonCallback(diameterButton));
    perigeeButton.setOnClickCallback(setFilterButtonCallback(perigeeButton));
    apogeeButton.setOnClickCallback(setFilterButtonCallback(apogeeButton));
    resetButton.setOnClickCallback(new Callback() { void call() {
      resetFilters();
      provider.setSortingComparator(COMPARATOR_SATCAT_ASCENDING);
      provider.setFilter(new Predicate<DataPoint>() { public boolean test(DataPoint dataPoint){ return true;}});
      satcatTextBox.setDefaultInput(); nameTextBox.setDefaultInput(); statusTextBox.setDefaultInput(); stateTextBox.setDefaultInput();
      yearTextBox.setDefaultInput(); massTextBox.setDefaultInput(); diameterTextBox.setDefaultInput(); perigeeTextBox.setDefaultInput(); apogeeTextBox.setDefaultInput();
    }});
  }
  
  public void draw(){
    if(currentlySelectedButton == satcatButton) drawRightCurve(satcatButton);
    
    box.draw();
    nameButton.draw(); dateButton.draw(); statusButton.draw(); stateButton.draw(); massButton.draw(); diameterButton.draw(); perigeeButton.draw(); apogeeButton.draw(); satcatButton.draw(); resetButton.draw();
    image(resetIcon, resetButton.xPosition+resetIcon.width/2, resetButton.yPosition+resetIcon.height/2);
    satcatTextBox.draw(); nameTextBox.draw(); statusTextBox.draw(); stateTextBox.draw();
    yearTextBox.draw(); massTextBox.draw(); diameterTextBox.draw(); perigeeTextBox.draw(); apogeeTextBox.draw();
    fill(filterColor);
  }
  
  private void resetFilters(){
    satcatFilter = "";
    nameFilter = "";
    statusFilter = "";
    stateFilter = "";
    minYear = Double.NEGATIVE_INFINITY; maxYear = Double.POSITIVE_INFINITY;
    minMass = Double.NEGATIVE_INFINITY; maxMass = Double.POSITIVE_INFINITY;
    minDiameter = Double.NEGATIVE_INFINITY; maxDiameter = Double.POSITIVE_INFINITY;
    minPerigee = Double.NEGATIVE_INFINITY; maxPerigee = Double.POSITIVE_INFINITY;
    minApogee = Double.NEGATIVE_INFINITY; maxApogee = Double.POSITIVE_INFINITY;
  }
   
  public void applyFilter() {
    provider.setFilter(new Predicate<DataPoint>() {
      public boolean test(DataPoint dataPoint) {
        // NaN values are displayed only if no filter is applied to that field
        return ((satcatFilter.equals("") || dataPoint.getSatcat().equals(satcatFilter)) &&
                 dataPoint.getName().toLowerCase().contains(nameFilter.toLowerCase()) &&
                 dataPoint.getStatus().toLowerCase().contains(statusFilter.toLowerCase()) &&
                 (dataPoint.getState().toLowerCase().contains(stateFilter.toLowerCase()) || dataPoint.getStateValue().toLowerCase().contains(stateFilter.toLowerCase())) &&
                 dataPoint.getLaunchDate().getYear() >= minYear && dataPoint.getLaunchDate().getYear() <= maxYear &&
                 ((dataPoint.getMass() >= minMass && dataPoint.getMass() <= maxMass) || 
                 (Double.isNaN(dataPoint.getMass()) && minMass == Double.NEGATIVE_INFINITY && maxMass == Double.POSITIVE_INFINITY)) &&
                 ((dataPoint.getDiameter() >= minDiameter && dataPoint.getDiameter() <= maxDiameter) || 
                 (Double.isNaN(dataPoint.getDiameter()) && minDiameter == Double.NEGATIVE_INFINITY && maxDiameter == Double.POSITIVE_INFINITY)) &&
                 ((dataPoint.getPerigee() >= minPerigee && dataPoint.getPerigee() <= maxPerigee) || 
                 (Double.isNaN(dataPoint.getPerigee()) && minPerigee == Double.NEGATIVE_INFINITY && maxPerigee == Double.POSITIVE_INFINITY)) &&
                 ((dataPoint.getApogee() >= minApogee && dataPoint.getApogee() <= maxApogee) ||
                 (Double.isNaN(dataPoint.getApogee()) && minApogee == Double.NEGATIVE_INFINITY && maxApogee == Double.POSITIVE_INFINITY)));
      }
    });
  }
  
  public Callback setFilterButtonCallback(ClickableRectangleWidget button) {
    final ClickableRectangleWidget buttonFinal = button;
    return (new Callback() { public void call() {
        currentlySelectedButton.setHoverColor(filterHoverColor);
        currentlySelectedButton = buttonFinal;
        box = new RectangleWidget(buttonFinal.xPosition, buttonFinal.yPosition+buttonFinal.height/2, buttonFinal.width, buttonFinal.height+buttonFinal.radiusTopLeft, buttonFinal.primaryColor, buttonFinal.primaryColor);
        currentlySelectedButton.setHoverColor(filterColor);
        currentlyDisplayedFilterWidget.hide();
        if(currentlySelectedButton == satcatButton)
          currentlyDisplayedFilterWidget = satcatTextBox;
        else if(currentlySelectedButton == nameButton)
          currentlyDisplayedFilterWidget = nameTextBox;
        else if(currentlySelectedButton == statusButton)
          currentlyDisplayedFilterWidget = statusTextBox;
        else if(currentlySelectedButton == stateButton)
          currentlyDisplayedFilterWidget = stateTextBox;
        else if(currentlySelectedButton == dateButton)
          currentlyDisplayedFilterWidget = yearTextBox;
        else if(currentlySelectedButton == massButton) {
          currentlyDisplayedFilterWidget = massTextBox; 
          scrollableTextArea.setExtraDataType(MASS);
        }
        else if(currentlySelectedButton == diameterButton) {
          currentlyDisplayedFilterWidget = diameterTextBox;
           scrollableTextArea.setExtraDataType(DIAMETER);
        }
        else if(currentlySelectedButton == perigeeButton) {
          currentlyDisplayedFilterWidget = perigeeTextBox;
           scrollableTextArea.setExtraDataType(PERIGEE);
        }
        else if(currentlySelectedButton == apogeeButton) {
          currentlyDisplayedFilterWidget = apogeeTextBox;
           scrollableTextArea.setExtraDataType(APOGEE);
        }
        currentlyDisplayedFilterWidget.display();
      }});
  }

  // Hazel Hilbert: methods to draw curves on the widget that connects the buttons and search bar
  public void drawRightCurve(ClickableRectangleWidget button){
    fill(filterColor);
    rect(button.xPosition+button.width, ypos+height+buffer*3/2-radii, radii-buffer/2, radii-buffer/2);
    fill(BACKGROUND_CLR);
    arc(button.xPosition+button.width+(radii-buffer/2), ypos+height+buffer*3/2-radii, (radii-buffer/2)*2, (radii-buffer/2)*2, radians(90), radians(180));
  }
  public void drawLeftCurve(ClickableRectangleWidget button){
    fill(filterColor);
    rect(button.xPosition-(radii-buffer/2), ypos+height+buffer*3/2-radii, radii-buffer/2, radii-buffer/2);
    fill(BACKGROUND_CLR);
    arc(button.xPosition-(radii-buffer/2), ypos+height+buffer*3/2-radii, (radii-buffer/2)*2, (radii-buffer/2)*2, radians(0), radians(90));
  }

  public void display() {} 
  public void hide() {}
}
