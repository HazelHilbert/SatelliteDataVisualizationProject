
// Michal Bronicki and Hazel Hilbert: VerticalSlider class

final int SLIDER_HEIGHT = 50;

class VerticalSlider {
  private int xPosition;
  private int yPosition;
  private int width;
  private int height;
  private int currentPosition;
  private color backgroundColor;
  private color sliderColor;
  private color buttonColor;
  private UpArrowButton upArrow;
  private DownArrowButton downArrow;
  private VerticallyDraggableRectangleWidget slider;
  private boolean isVisible;
  
  VerticalSlider(int xPosition, int yPosition, int width, int height) {
    this.xPosition = xPosition;
    this.yPosition = yPosition;
    this.width = width;
    this.height = height;
    currentPosition = yPosition+width+1;
    backgroundColor = ROW_CLR_1;
    sliderColor = SLIDER_CLR;
    buttonColor = ROW_CLR_2;
    upArrow = new UpArrowButton(xPosition, yPosition, width, width, buttonColor, sliderColor);
    downArrow = new DownArrowButton(xPosition, yPosition+height-width, width, width, buttonColor, sliderColor);
    slider = new VerticallyDraggableRectangleWidget(xPosition+3, currentPosition, width-5, SLIDER_HEIGHT, 30, yPosition+width+1, yPosition+height-width, sliderColor, sliderColor);
    isVisible = true;  
  }
  
  // draws the vertical scroll bar, the slider, and the up and down arrows
  void draw() {
    if(isVisible) {
      upArrow.draw();
      downArrow.draw();
      slider.draw();
    }
  }
  
  // hides and displays the slider and buttons depending on the value of the boolean isVisable
  void display() {
    if(!isVisible) {
      eventManager.registerClickableWidget(upArrow);
      eventManager.registerClickableWidget(downArrow);
      eventManager.registerDraggableWidget(slider);
      isVisible = true;
    }
  }
  void hide() {
    if(isVisible) {
      eventManager.removeClickableWidget(upArrow);
      eventManager.removeClickableWidget(downArrow);
      eventManager.removeDraggableWidget(slider);
      isVisible = false;
    }
  }
  
  public boolean isVisible() {
    return isVisible;  
  }
  
  // set the callbacks for when the up or down arrows are clicked, or the slider is dragged
  void setUpArrowButtonCallback(Callback upArrowButtonCallback) {
    upArrow.setOnClickCallback(upArrowButtonCallback);  
  }
  void setDownArrowButtonCallback(Callback downArrowButtonCallback) {
    downArrow.setOnClickCallback(downArrowButtonCallback);  
  }
  void setSliderCallback(Callback sliderCallback) {
    slider.setOnDragCallback(sliderCallback);  
  }
  
  public double getValue() {
    return slider.getValue();
  }
  public void setValue(double value) {
    slider.setValue(value);  
  }
}

 // Michal Bronicki and Hazel Hilbert: defines an UpArrowButton class that draws an up arrow and returns a callback when clicked
  class UpArrowButton extends ClickableRectangleWidget {
    private color borderColor;
    
    UpArrowButton(int xPosition, int yPosition, int width, int height, color primaryColor, color borderColor) {
      super(xPosition, yPosition, width, height, primaryColor);
      this.borderColor = borderColor;
    }
    
    public void draw() {
      stroke(borderColor);
      fill(primaryColor);
      rect(xPosition, yPosition, width, height);
      triangle(xPosition+width/2, yPosition+width/4, xPosition+width/4, yPosition+width/4*3, xPosition+width/4*3, yPosition+width/4*3);
    }
  }
  
// Michal Bronicki and Hazel Hilbert: defines an DownArrowButton class that draws an down arrow and returns a callback when clicked
  class DownArrowButton extends ClickableRectangleWidget {
    private color borderColor;
    
    DownArrowButton(int xPosition, int yPosition, int width, int height, color primaryColor, color borderColor) {
      super(xPosition, yPosition, width, height, primaryColor);
      this.borderColor = borderColor;
    }
    
    public void draw() {
      stroke(borderColor);
      if(isHovered())
        fill(hoverColor);
      else
        fill(primaryColor);
      rect(xPosition, yPosition, width, height);
      triangle(xPosition+width/2, yPosition+height-width/4, xPosition+width/4, yPosition+height-width/4*3, xPosition+width/4*3, yPosition+height-width/4*3);
    }
  }
