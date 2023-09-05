/* Generic types in the builder classes defined below are used to allow builder inheritance.
*  Solution inspired by code posted by StackOverflow user Radiodef on Jan 13, 2014 at 9:58 in the thread:
*  https://stackoverflow.com/questions/21086417/builder-pattern-and-inheritance
*/

// Widget classes mostly written by Michal Bronicki, some widgets created and edited by Hazel Hilbert
interface Widget {
  void draw(); 
  void hide();
  void display(); 
}
interface ClickableWidget extends Widget {
  boolean isHovered();
  void invokeOnClickCallback();
  void setOnClickCallback(Callback onClickCallback);
}
interface DraggableWidget extends Widget {
  boolean isHovered();
  boolean isBeingDragged();
  void startDragging();
  void updatePosition();
  void stopDragging();
  void setOnDragCallback(Callback onDragCallback);
}
interface ScrollableWidget extends Widget {
  boolean isHovered();
  void invokeMouseWheelUsed(MouseEvent event);
}
interface TypableWidget extends Widget {
  void invokeOnKeyPressedCallback();
  void setOnSubmitCallback(Callback onSubmitCallback);
}
interface DataDependentWidget extends Widget {
  void update();    
}

class RectangleWidget implements Widget {
  protected int xPosition;
  protected int yPosition;
  protected int width;
  protected int height;
  protected int radiusTopLeft, radiusTopRight, radiusBottomRight, radiusBottomLeft;
  protected color primaryColor;
  protected color hoverColor;
  protected boolean border;
  protected int borderWidth;
  protected int hoverBorderWidth;
  protected color borderColor;
  protected color hoverBorderColor;
  protected String text;
  protected PFont font;
  protected color labelColor;
  protected color hoverLabelColor;
  protected boolean isVisible;
  
  public <BuilderT extends GenericRectangleWidgetBuilder> RectangleWidget (BuilderT builder) {
    builder.validate();
    xPosition = builder.xPosition;
    yPosition = builder.yPosition;
    width = builder.width;
    height = builder.height;
    radiusTopLeft = builder.radiusTopLeft;
    radiusTopRight = builder.radiusTopRight;
    radiusBottomRight = builder.radiusBottomRight;
    radiusBottomLeft = builder.radiusBottomLeft;
    primaryColor = builder.primaryColor;
    hoverColor = builder.hoverColor;
    border = builder.border;
    borderWidth = builder.borderWidth;
    hoverBorderWidth = builder.hoverBorderWidth;
    borderColor = builder.borderColor;
    hoverBorderColor = builder.hoverBorderColor;
    text = builder.text;
    font = builder.font;
    labelColor = builder.labelColor;
    hoverLabelColor = builder.hoverLabelColor;
    isVisible = true;
  }

  // Old constructors, currently left for compatibility reasons, to be removed after refactoring the rest of the code to use RectangleWidgetBuilder
  RectangleWidget(int xPosition, int yPosition, int width, int height, color primaryColor) {
    this(xPosition, yPosition, width, height, primaryColor, primaryColor);
  }
  RectangleWidget(int xPosition, int yPosition, int width, int height, color primaryColor, color hoverColor) {
    this(xPosition, yPosition, width, height, 0, primaryColor, hoverColor);
  }
  RectangleWidget(int xPosition, int yPosition, int width, int height, int radii, color primaryColor, color hoverColor) {
    this.xPosition = xPosition;
    this.yPosition = yPosition;
    this.width = width;
    this.height = height;
    this.radiusTopLeft = radii;
    this.radiusTopRight = radii;
    this.radiusBottomRight = radii;
    this.radiusBottomLeft = radii;
    this.primaryColor = primaryColor;
    this.hoverColor = hoverColor;
    border = false;
    borderWidth = 0;
    hoverBorderWidth = 0;
    borderColor = primaryColor;
    hoverBorderColor = hoverColor;
    isVisible = true;
    text = "";
    font = courier15;
    labelColor = color(DARK_TEXT_CLR);
    hoverLabelColor = color(DARK_TEXT_CLR);
  }
  
  public void draw() {
    if(isVisible) {
      if(border && !isHovered()) {
        stroke(borderColor);
        strokeWeight(borderWidth);
      } else if(border && isHovered()) {
        stroke(hoverBorderColor);
        strokeWeight(hoverBorderWidth);
      } else {
        noStroke();
      }
      if(isHovered()) 
        fill(hoverColor);
      else 
        fill(primaryColor);
      rect(xPosition, yPosition, width, height, radiusTopLeft, radiusTopRight, radiusBottomRight, radiusBottomLeft);
      fill(labelColor);
      textFont(font);
      textAlign(CENTER, CENTER);
      text(text, xPosition+width/2, yPosition+height/2);
    }
  }

  public void setPrimaryColor(color primaryColor) {
    this.primaryColor = primaryColor; 
  }
  public void setHoverColor(color hoverColor) {
    this.hoverColor = hoverColor; 
  }
  
  public boolean isHovered() {
      return (mouseX >= xPosition && mouseX < xPosition + width && mouseY >= yPosition && mouseY < yPosition + height);
  }
  public void display() {
    if(!isVisible)
      isVisible = true;
  }
  public void hide() {
    if(isVisible)
      isVisible = false;
  
  
  
  
  }
}
// Builder class for constructing RectangleWidget objects
final class RectangleWidgetBuilder extends GenericRectangleWidgetBuilder<RectangleWidgetBuilder> {
  @Override
  public RectangleWidget build() {
    validate();
    return new RectangleWidget(this);
  }
}
abstract class GenericRectangleWidgetBuilder<BuilderT extends GenericRectangleWidgetBuilder<BuilderT>> {
  protected int xPosition = 0;
  protected int yPosition = 0;
  protected int width = 0;
  protected int height = 0;
  protected int radiusTopLeft = 0;
  protected int radiusTopRight = 0;
  protected int radiusBottomRight = 0;
  protected int radiusBottomLeft = 0;
  protected color primaryColor = color(0);
  protected Integer hoverColor = null;
  protected boolean border = false;
  protected Integer borderWidth = null; 
  protected Integer hoverBorderWidth = null;
  protected Integer borderColor = null; 
  protected Integer hoverBorderColor = null;
  protected String text = "";
  protected PFont font = courier15;
  protected Integer labelColor = null;
  protected Integer hoverLabelColor = null;

  public BuilderT leftCornerPosition(int xPosition, int yPosition) {
    this.xPosition = xPosition;
    this.yPosition = yPosition;
    return thisCast();
  }
  public BuilderT size(int width, int height) {
    this.width = width;
    this.height = height;
    return thisCast();
  }
  public BuilderT cornersRadii(int radii) {
    this.radiusTopLeft = radii;
    this.radiusTopRight = radii;
    this.radiusBottomRight = radii;
    this.radiusBottomLeft = radii;
    return thisCast();
  }
  public BuilderT cornersRadii(int radiusTopLeft, int radiusTopRight, int radiusBottomRight, int radiusBottomLeft) {
    this.radiusTopLeft = radiusTopLeft;
    this.radiusTopRight = radiusTopRight;
    this.radiusBottomRight = radiusBottomRight;
    this.radiusBottomLeft = radiusBottomLeft;
    return thisCast();
  }
  public BuilderT primaryColor(color primaryColor) {
    this.primaryColor = primaryColor;
    return thisCast();
  }
  public BuilderT primaryColor(int r, int g, int b) {
    this.primaryColor = color(r, g, b);
    return thisCast();
  }
  public BuilderT hoverColor(color hoverColor) {
    this.hoverColor = hoverColor;
    return thisCast();
  }
  public BuilderT hoverColor(int r, int g, int b) {
    this.hoverColor = color(r, g, b);
    return thisCast();
  }
  public BuilderT borderWidth(int borderWidth) {
    border = true;
    this.borderWidth = borderWidth;
    return thisCast();
  }
  public BuilderT hoverBorderWidth(int hoverBorderWidth) {
    border = true;
    this.hoverBorderWidth = hoverBorderWidth;
    return thisCast();
  }
  public BuilderT borderColor(color borderColor) {
    border = true;
    this.borderColor = borderColor;
    return thisCast();
  }
  public BuilderT borderColor(int r, int g, int b) {
    border = true;
    this.borderColor = color(r, g, b);
    return thisCast();
  }
  public BuilderT hoverBorderColor(color hoverBorderColor) {
    border = true;
    this.hoverBorderColor = hoverBorderColor;
    return thisCast();
  }
  public BuilderT hoverBorderColor(int r, int g, int b) {
    border = true;
    this.hoverBorderColor = color(r, g, b);
    return thisCast();
  }
  public BuilderT labelText(String text) {
    this.text = text;
    return thisCast();
  }
  public BuilderT labelTextFont(PFont font) {
    this.font = font;
    return thisCast();
  }
  public BuilderT labelTextColor(color labelColor) {
    this.labelColor = labelColor;
    return thisCast();
  }
  public BuilderT labelTextColor(int r, int g, int b) {
    this.labelColor = color(r, g, b);
    return thisCast();
  }
  public BuilderT hoverLabelTextColor(color hoverLabelColor) {
    this.hoverLabelColor = hoverLabelColor;
    return thisCast();
  }
  public BuilderT hoverLabelTextColor(int r, int g, int b) {
    this.hoverLabelColor = color(r, g, b);
    return thisCast();
  }

  public abstract RectangleWidget build();

  // validates the fields and provides default values if necessary
  protected void validate() {
    if(width < 0) 
      width = 0;
    if(height < 0)
      height = 0;
    if(radiusTopLeft < 0)
      radiusTopLeft = 0;
    if(radiusTopRight < 0)
      radiusTopRight = 0;
    if(radiusBottomRight < 0)
      radiusBottomRight = 0;
    if(radiusBottomLeft < 0)
      radiusBottomLeft = 0;
    if(hoverColor == null)
      hoverColor = primaryColor;
    if(border) {
      if(borderWidth == null && hoverBorderWidth == null) {
        borderWidth = 1;
        hoverBorderWidth = 1;
      } else if(borderWidth == null) {
        borderWidth = 0;
      } else if(hoverBorderWidth == null) {
        hoverBorderWidth = borderWidth;
      }
      if(borderColor == null && hoverBorderColor == null) {
        borderColor = color(0);
        hoverBorderColor = color(0);
      } else if(borderColor == null) {
        borderColor = primaryColor;
      } else if(hoverBorderColor == null) {
        hoverBorderColor = borderColor;
      }
    } else {
      borderWidth = 0;
      hoverBorderWidth = 0;
      borderColor = color(0);
      hoverBorderColor = color(0);
    }
    if(labelColor == null && hoverLabelColor == null) {
      labelColor = color(DARK_TEXT_CLR);
      hoverLabelColor = color(DARK_TEXT_CLR);
    } else if(labelColor == null) {
      labelColor = color(DARK_TEXT_CLR);
    } else if(hoverLabelColor == null) {
      hoverLabelColor = labelColor;
    }
  }

  protected final BuilderT thisCast() {
    return (BuilderT) this;
  }
}

class ClickableRectangleWidget extends RectangleWidget implements ClickableWidget {
  private Callback onClickCallback;

  public <BuilderT extends GenericClickableRectangleWidgetBuilder> ClickableRectangleWidget(BuilderT builder) {
    super(builder);
    onClickCallback = builder.onClickCallback;
    eventManager.registerClickableWidget(this);
  }

  // Old constructors, currently left for compatibility reasons, to be removed after refactoring the rest of the code to use ClickableRectangleWidgetBuilder
  ClickableRectangleWidget(int xPosition, int yPosition, int width, int height, color primaryColor) {
    this(xPosition, yPosition, width, height, 0, primaryColor, primaryColor, primaryColor, courier15, "");
  }
  ClickableRectangleWidget(int xPosition, int yPosition, int width, int height, color primaryColor, color hoverColor) {
    this(xPosition, yPosition, width, height, 0, primaryColor, hoverColor, primaryColor, courier15, "");
  }
  ClickableRectangleWidget(int xPosition, int yPosition, int width, int height, int radii, color primaryColor, color hoverColor, PFont font, String text) {
    this(xPosition, yPosition, width, height, radii, primaryColor, hoverColor, primaryColor, font, text);
  }
  ClickableRectangleWidget(int xPosition, int yPosition, int width, int height, int radii, color primaryColor, color hoverColor, color clickedColor, PFont font, String text) {
    super(xPosition, yPosition, width, height, primaryColor, hoverColor);
    this.radiusTopLeft = radii;
    this.radiusTopRight = radii;
    this.radiusBottomRight = radii;
    this.radiusBottomLeft = radii;
    this.text=text; labelColor = DARK_TEXT_CLR; this.font = font;
    eventManager.registerClickableWidget(this);
    onClickCallback = new Callback() { void call() {} };
    hoverLabelColor = DARK_TEXT_CLR;
  }
  
  public void setOnClickCallback(Callback onClickCallback) {
    this.onClickCallback = onClickCallback;
  }
  public void invokeOnClickCallback() {
    onClickCallback.call();
  }

  @Override
  public void display() {
    if(!isVisible) {
      eventManager.registerClickableWidget(this);
      isVisible = true;
    }
  }
  @Override
  public void hide() {
    if(isVisible) {
      eventManager.removeClickableWidget(this);
      isVisible = false;
    }
  }
}
// Builder class for constructing ClickableRectangleWidget objects
final class ClickableRectangleWidgetBuilder extends GenericClickableRectangleWidgetBuilder<ClickableRectangleWidgetBuilder> {
  @Override
  public ClickableRectangleWidget build() {
    validate();
    return new ClickableRectangleWidget(this);
  }
}
abstract class GenericClickableRectangleWidgetBuilder<BuilderT extends GenericClickableRectangleWidgetBuilder<BuilderT>> 
                extends GenericRectangleWidgetBuilder<BuilderT> {
  protected Callback onClickCallback = new Callback() { void call() {} };

  public BuilderT onClickCallback(Callback onClickCallback) {
    this.onClickCallback = onClickCallback;
    return thisCast();
  }

  @Override
  public abstract ClickableRectangleWidget build();
}

class VerticallyDraggableRectangleWidget extends RectangleWidget implements DraggableWidget {
  protected int yTopBorder;
  protected int yBottomBorder;
  private boolean isBeingDragged;
  private int yRelativeDraggingPosition;
  private Callback onDragCallback;
  
  public <BuilderT extends GenericVerticallyDraggableRectangleWidgetBuilder> VerticallyDraggableRectangleWidget(BuilderT builder) {
    super(builder);
    yTopBorder = builder.yTopBorder;
    yBottomBorder = builder.yBottomBorder;
    onDragCallback = builder.onDragCallback;
    isBeingDragged = false;
    yRelativeDraggingPosition = 0;
    eventManager.registerDraggableWidget(this);
  }

  // Old constructors, currently left for compatibility reasons, to be removed after refactoring the rest of the code to use VerticallyDraggableRectangleWidgetBuilder
  VerticallyDraggableRectangleWidget(int xPosition, int yPosition, int width, int height, int yTopBorder, int yBottomBorder, color primaryColor) {
    this(xPosition, yPosition, width, height, 0, yTopBorder, yBottomBorder, primaryColor, primaryColor);
  }
  VerticallyDraggableRectangleWidget(int xPosition, int yPosition, int width, int height, int yTopBorder, int yBottomBorder, color primaryColor, color hoverColor) {
    this(xPosition, yPosition, width, height, 0, yTopBorder, yBottomBorder, primaryColor, hoverColor);
  }
  VerticallyDraggableRectangleWidget(int xPosition, int yPosition, int width, int height, int radii, int yTopBorder, int yBottomBorder, color primaryColor, color hoverColor) {
    super(xPosition, yPosition, width, height, radii, primaryColor, hoverColor);
    this.yTopBorder = yTopBorder;
    this.yBottomBorder = yBottomBorder;
    isBeingDragged = false;
    yRelativeDraggingPosition = 0;
    onDragCallback = new Callback() { void call() {} };
    eventManager.registerDraggableWidget(this);
  }
  
  public double getValue() {
    return (double)(yPosition - yTopBorder)/(yBottomBorder - yTopBorder - height);
  }
  public void setValue(double value) {
    yPosition = (int) map((float)value, 0.0, 1.0, yTopBorder, yBottomBorder - height);
  }
  
  public boolean isBeingDragged() {
    return isBeingDragged;  
  }
  public void startDragging() {
    if(isHovered()) {
      yRelativeDraggingPosition = mouseY - yPosition;
    } else {
      yRelativeDraggingPosition = 0; 
    }
    isBeingDragged = true;
  }
  public void updatePosition() {
    int previousYPosition = yPosition;
    yPosition = mouseY - yRelativeDraggingPosition;
    if(yPosition < yTopBorder)
      yPosition = yTopBorder;
    else if(yPosition + height > yBottomBorder)
      yPosition = yBottomBorder - height;
    if(yPosition != previousYPosition)
      onDragCallback.call();
  }
  public void stopDragging() {
    isBeingDragged = false;  
  }
  public int getCurrentPosition() {
    return yPosition;  
  }
  public void setCurrentPosition(int newPosition) {
    yPosition = newPosition;  
  }
  
  public void setOnDragCallback(Callback onDragCallback) {
    this.onDragCallback = onDragCallback;
  }

  @Override
  public void display() {
    if(!isVisible) {
      eventManager.registerDraggableWidget(this);
      isVisible = true;
    }
  }
  @Override
  public void hide() {
    if(isVisible) {
      eventManager.removeDraggableWidget(this);
      isVisible = false;
    }
  }
}
// Builder class for constructing VerticallyDraggableRectangleWidget objects
final class VerticallyDraggableRectangleWidgetBuilder extends GenericVerticallyDraggableRectangleWidgetBuilder<VerticallyDraggableRectangleWidgetBuilder> {
  @Override
  public VerticallyDraggableRectangleWidget build() {
    validate();
    return new VerticallyDraggableRectangleWidget(this);
  }
}
abstract class GenericVerticallyDraggableRectangleWidgetBuilder<BuilderT extends GenericVerticallyDraggableRectangleWidgetBuilder<BuilderT>>
                extends GenericRectangleWidgetBuilder<BuilderT> {
  protected Integer yTopBorder = null;
  protected Integer yBottomBorder = null;
  protected Callback onDragCallback = new Callback() { void call() {} };

  public BuilderT verticalDraggingBorder(int yTopBorder, int yBottomBorder) {
    this.yTopBorder = yTopBorder;
    this.yBottomBorder = yBottomBorder;
    return thisCast();
  }
  public BuilderT onDragCallback(Callback onDragCallback) {
    this.onDragCallback = onDragCallback;
    return thisCast();
  }

  @Override
  public abstract VerticallyDraggableRectangleWidget build();

  @Override
  protected void validate() {
    super.validate();
    if(yTopBorder == null)
      yTopBorder = yPosition;
    if(yBottomBorder == null)
      yBottomBorder = yPosition + height;
  }
}

// Hazel Hilbert: wrote TextWidget to provide search bar functionality
class TextWidget extends ClickableRectangleWidget implements TypableWidget {
  protected int maxlen;
  private String label;
  private String defaultInput;
  protected String input;
  private color labelColor;
  private color secondaryColor;
  private PFont widgetFont;
  private Callback onKeyPressedCallback;
  private Callback onSubmitCallback;
  private boolean isVisible;
  
  TextWidget(int xPosition, int yPosition, int width, int height, color primaryColor, color secondaryColor, String label, PFont font, int maxlen, Callback onSubmitCallback){
    super(xPosition, yPosition, width, height, primaryColor);
    this.label = label; widgetFont = font; this.secondaryColor = secondaryColor;
    labelColor= DARK_TEXT_CLR; this.maxlen = maxlen;
    defaultInput = "click here";
    this.input = defaultInput;
    final TextWidget finalThis = this;
    setOnClickCallback(new Callback() { void call() {
      finalThis.input = "";
      eventManager.setFocus(finalThis);
    }});
    onKeyPressedCallback = new Callback() { void call() {
       if (keyCode == ENTER) {
         finalThis.onSubmitCallback.call();
         if (input.equals("")) input = defaultInput;
       }
       else append(key); 
    }};
    this.onSubmitCallback = onSubmitCallback;
    eventManager.registerTypableWidget(this);
    isVisible = true;
  }
  
  public void setOnSubmitCallback(Callback onSubmitCallback) {
    this.onSubmitCallback = onSubmitCallback;
  }
  public String getText() {
    return input;  
  }
 public void setDefaultInput(){
   input = defaultInput;
 }
  public void setLabel(String text){
    label = text;
  }
  protected void append(char s) {
    if(s == BACKSPACE && !input.isEmpty()) {
      input=input.substring(0,input.length()-1);
    } else if(input.length() < maxlen && s >= ' ' && s <= '~') {
      input=input+str(s);
    }
  }
  public void draw() {
    if(isVisible) {
      noStroke();
      if(isHovered())
        fill(hoverColor);
      else
        fill(primaryColor);
        
      rect(xPosition, yPosition, width, height, 15);
      fill(TEXTBOX_CLR); 
      rect(xPosition+textWidth(label)+5, yPosition+(height/8.0), width-textWidth(label)-10, height*3/4, 15);
      fill(labelColor);
      textFont(widgetFont);
      textAlign(LEFT, CENTER);
      text(label+" "+input, xPosition+10, yPosition+height/2);
    }
  }
  public void display() {
    if(!isVisible) {
      eventManager.registerClickableWidget(this);
      eventManager.registerTypableWidget(this);
      isVisible = true;
    }
  }
  public void hide() {
    if(isVisible) {
      eventManager.removeClickableWidget(this);
      eventManager.removeTypableWidget(this);
      isVisible = false;
      if (input.equals("")) {
        onSubmitCallback.call();
        input = defaultInput;
      }
    }
  }
  
  public void invokeOnKeyPressedCallback() {
    onKeyPressedCallback.call();  
  }
}

class NumberInputWidget extends TextWidget {
  private double defaultValue;

  NumberInputWidget(int xPosition, int yPosition, int width, int height, color primaryColor, color secondaryColor, String label, PFont font, int maxlen, Callback onSubmitCallback, double defaultValue) {
    super(xPosition, yPosition, width, height, primaryColor, secondaryColor, label, font, maxlen, onSubmitCallback);
    this.defaultValue = defaultValue;
  }

  public double getValue() {
    double value = defaultValue;
    try {
      value = Double.parseDouble(input);
    } catch(NumberFormatException e) { 

    }
    return value;
  }

  protected void append(char c) {
    if(c == BACKSPACE && !input.isEmpty()) {
        input = input.substring(0,input.length()-1);
    } else if(input.length() < maxlen && (Character.isDigit(c) || (c == '-' && input.isEmpty()) || (c == '.' && !input.contains(".")))) {
      input = input+str(c);
    } 
  }
}

class RangeInputWidget extends RectangleWidget {
  private NumberInputWidget minNumberInputWidget;
  private NumberInputWidget maxNumberInputWidget;
  private boolean isVisible;

  RangeInputWidget(int xPosition, int yPosition, int width, int height, color primaryColor, color secondaryColor, String labelA, String labelB, PFont font, int maxlen, Callback onSubmitCallback) {
    super(xPosition, yPosition, width, height, 15, primaryColor, primaryColor);
    minNumberInputWidget = new NumberInputWidget(xPosition, yPosition, width/2, height, primaryColor, secondaryColor, labelA, font, maxlen, onSubmitCallback, Double.NEGATIVE_INFINITY);
    maxNumberInputWidget = new NumberInputWidget(xPosition+width/2, yPosition, width/2, height, primaryColor, secondaryColor, labelB, font, maxlen, onSubmitCallback, Double.POSITIVE_INFINITY);
    isVisible = true;
  }

  public double getMinValue() {
    return minNumberInputWidget.getValue();
  }
  public double getMaxValue() {
    return maxNumberInputWidget.getValue();
  }
  public void setDefaultInput(){
   minNumberInputWidget.setDefaultInput();
   maxNumberInputWidget.setDefaultInput();
 }
  public void draw() {
    if(isVisible) {
      super.draw();
      minNumberInputWidget.draw();
      maxNumberInputWidget.draw();
    }
  }
  public void display() {
    if(!isVisible) {
      minNumberInputWidget.display();
      maxNumberInputWidget.display();
      isVisible = true;
    }
  }
  public void hide() {
    if(isVisible) {
      minNumberInputWidget.hide();
      maxNumberInputWidget.hide();
      isVisible = false;
    }
  }
}

final int DROPDOWN_ROW_HEIGHT = 20;
final int DROPDOWN_SIDE_PADDING = 10;
class DropDownList implements Widget {
  private int xPosition;
  private int yPosition;
  private int width;
  private int height;
  private int radii;
  private color backgroundColor;
  private color strokeColor;
  private color hoverColor;
  private boolean isVisible;
  private DropDownButton dropDownButton;
  private boolean isOpen;
  private final String[] items;
  private ArrayList<ClickableRectangleWidget> itemWidgets;
  private int selectedItemIndex;
  private Callback onChangeCallback;
  
  public DropDownList(DropDownListBuilder builder) {
    builder.validate();
    this.xPosition = builder.xPosition;
    this.yPosition = builder.yPosition;
    this.width = builder.width;
    this.height = builder.height;
    this.radii = builder.radii;
    this.backgroundColor = builder.backgroundColor;
    this.strokeColor = builder.strokeColor;
    this.hoverColor = builder.hoverColor;
    this.items = builder.items;
    this.onChangeCallback = builder.onChangeCallback;
    isOpen = false;
    dropDownButton = new DropDownButton(xPosition+width-DROPDOWN_ROW_HEIGHT-DROPDOWN_SIDE_PADDING, yPosition+height/2-DROPDOWN_ROW_HEIGHT/2, DROPDOWN_ROW_HEIGHT, DROPDOWN_ROW_HEIGHT, backgroundColor, strokeColor);
    dropDownButton.setOnClickCallback(new Callback() { void call() {
      if(isOpen) {
        hideItemWidgets();
        isOpen = false;
      } else {
        displayItemWidgets();
        isOpen = true;
      }
    }});
    itemWidgets = new ArrayList<ClickableRectangleWidget>();
    ClickableRectangleWidgetBuilder itemWidgetBuilder;
    itemWidgetBuilder = new ClickableRectangleWidgetBuilder()
                            .size(width, DROPDOWN_ROW_HEIGHT)
                            .primaryColor(backgroundColor)
                            .hoverColor(hoverColor)
                            .borderWidth(1)
                            .borderColor(strokeColor)
                            .labelTextColor(strokeColor);
    for(int i=0; i<items.length; i++) {
      final int itemIndex = i;
      if(i == items.length-1) itemWidgetBuilder.cornersRadii(0, 0, 15, 15);
      itemWidgets.add(itemWidgetBuilder
                            .leftCornerPosition(xPosition, yPosition + height+(i)*DROPDOWN_ROW_HEIGHT)
                            .labelText(items[i])
                            .onClickCallback(new Callback() { void call() {
                              selectedItemIndex = itemIndex;
                              hideItemWidgets();
                              isOpen = false;
                              onChangeCallback.call();
                            }})
                            .build()
                      );
    }
    hideItemWidgets();
    selectedItemIndex = 0;
    isVisible = true;
  }

  //Old constructor, currently left for compatibility reasons, to be removed after refactoring the rest of the code to use DropDownListBuilder
  public DropDownList(int xPosition, int yPosition, int width, int height, color backgroundColor, color strokeColor, color hoverColor, String[] items) {
    this.xPosition = xPosition;
    this.yPosition = yPosition;
    this.width = width;
    this.height = height;
    this.backgroundColor = backgroundColor;
    this.strokeColor = strokeColor;
    this.hoverColor = hoverColor;
    isOpen = false;
    onChangeCallback = new Callback() { void call() {} };
    dropDownButton = new DropDownButton(xPosition+width-DROPDOWN_ROW_HEIGHT-DROPDOWN_SIDE_PADDING, yPosition+height/2-DROPDOWN_ROW_HEIGHT/2, DROPDOWN_ROW_HEIGHT, DROPDOWN_ROW_HEIGHT, backgroundColor, strokeColor);
    dropDownButton.setOnClickCallback(new Callback() { void call() {
      if(isOpen) {
        hideItemWidgets();
        isOpen = false;
      } else {
        displayItemWidgets();
        isOpen = true;
      }
     }});
    this.items = items;
    if(items == null || items.length == 0) {
      items = new String[] { "" };
    }
    itemWidgets = new ArrayList<ClickableRectangleWidget>();
    ClickableRectangleWidgetBuilder builder;
    builder = new ClickableRectangleWidgetBuilder()
                        .size(width, DROPDOWN_ROW_HEIGHT)
                        .primaryColor(backgroundColor)
                        .hoverColor(hoverColor)
                        .borderWidth(1)
                        .borderColor(strokeColor)
                        .labelTextColor(strokeColor);
    for(int i=0; i<items.length; i++) {
      final int itemIndex = i;
      if(i == items.length-1)
        builder.cornersRadii(0, 0, 15, 15);
      itemWidgets.add(builder
                        .leftCornerPosition(xPosition, yPosition + height+(i)*DROPDOWN_ROW_HEIGHT)
                        .labelText(items[i])
                        .onClickCallback(new Callback() { void call() {
                          selectedItemIndex = itemIndex;
                          hideItemWidgets();
                          isOpen = false;
                          onChangeCallback.call();
                        }})
                        .build()
                      );
    }
    hideItemWidgets();
    selectedItemIndex = 0;
    isVisible = true;
  }

  public int getCurrentSelectionIndex() {
    return selectedItemIndex;
  }

  public String getCurrentSelectionValue() {
    return items[selectedItemIndex];
  }
  
  public void setOnChangeCallback(Callback onChangeCallback) {
    this.onChangeCallback = onChangeCallback;  
  }
  
  @Override
  public void draw() {
    if(isVisible) {
      stroke(strokeColor);
      strokeWeight(1);
      fill(backgroundColor);
      if(isOpen)
        rect(xPosition, yPosition, width, height, 15, 15, 0, 0);
      else
        rect(xPosition, yPosition, width, height, 15);
      fill(strokeColor);
      textAlign(LEFT, CENTER);
      text(items[selectedItemIndex], xPosition+DROPDOWN_SIDE_PADDING, yPosition+height/2);
      dropDownButton.draw();
      if(isOpen) {
        for(ClickableRectangleWidget itemWidget : itemWidgets) {
          itemWidget.draw();
        }
      }
      noStroke();
    }
  }
  @Override
  public void hide() {
    if(isVisible) {
      hideItemWidgets();
      isOpen = false;
      dropDownButton.hide();
      isVisible = false;
    }
  }
  @Override
  public void display() {
    if(!isVisible) {
      dropDownButton.display();
      isVisible = true;
    }
  }

  private void displayItemWidgets() {
    for(ClickableRectangleWidget itemWidget : itemWidgets) {
      itemWidget.display();
    }
  }
  private void hideItemWidgets() {
    for(ClickableRectangleWidget itemWidget : itemWidgets) {
      itemWidget.hide();
    }
  }
  
  private class DropDownButton extends ClickableRectangleWidget {
    private color strokeColor;
    
    DropDownButton(int xPosition, int yPosition, int width, int height, color backgroundColor, color strokeColor) {
      super(xPosition, yPosition, width, height, backgroundColor);
      this.strokeColor = strokeColor;
    }
    
    @Override
    public void draw() {
      stroke(strokeColor);
      fill(primaryColor);
      rect(xPosition, yPosition, width, height, radiusTopLeft, radiusTopRight, radiusBottomRight, radiusBottomLeft);
      triangle(xPosition+width/2, yPosition+height-width/4, xPosition+width/4, yPosition+height-width/4*3, xPosition+width/4*3, yPosition+height-width/4*3);
      noStroke();
    }
  }
}
// Builder class for constructing DropDownList objects
final class DropDownListBuilder {
  private int xPosition = 0;
  private int yPosition = 0;
  private int width = 0;
  private int height = 0;
  private int radii = 0;
  private color backgroundColor = color(0);
  private color strokeColor = color(0);
  private Integer hoverColor = null;
  private String[] items = new String[] { "" };
  private Callback onChangeCallback = EMPTY_CALLBACK;

  public DropDownListBuilder leftCornerPosition(int xPosition, int yPosition) {
    this.xPosition = xPosition;
    this.yPosition = yPosition;
    return this;
  }
  public DropDownListBuilder size(int width, int height) {
    this.width = width;
    this.height = height;
    return this;
  }
  public DropDownListBuilder cornersRadii(int radii) {
    this.radii = radii;
    return this;
  }
  public DropDownListBuilder backgroundColor(color backgroundColor) {
    this.backgroundColor = backgroundColor;
    return this;
  }
  public DropDownListBuilder backgroundColor(int r, int g, int b) {
    this.backgroundColor = color(r, g, b);
    return this;
  }
  public DropDownListBuilder strokeColor(color strokeColor) {
    this.strokeColor = strokeColor;
    return this;
  }
  public DropDownListBuilder strokeColor(int r, int g, int b) {
    this.strokeColor = color(r, g, b);
    return this;
  }
  public DropDownListBuilder hoverColor(color hoverColor) {
    this.hoverColor = hoverColor;
    return this;
  }
  public DropDownListBuilder hoverColor(int r, int g, int b) {
    this.hoverColor = color(r, g, b);
    return this;
  }
  public DropDownListBuilder listItems(String[] items) {
    this.items = items;
    return this;
  }
  public DropDownListBuilder onChangeCallback(Callback onChangeCallback) {
    this.onChangeCallback = onChangeCallback;
    return this;
  }

  public DropDownList build() {
    validate();
    return new DropDownList(this);
  }

  // validates the fields and provides default values if necessary
  private void validate() {
    if(width < 0) 
      width = 0;
    if(height < 0)
      height = 0;
    if(radii < 0)
      radii = 0;
    if(hoverColor == null)
      hoverColor = backgroundColor;
    if(items == null || items.length == 0) 
      items = new String[] { "" };
    if(onChangeCallback == null)
      onChangeCallback = EMPTY_CALLBACK;
  }
}

final int CHECKBOX_SIZE = 20;
final int CHECKBOX_SIDE_MARGIN = 10;
class CheckboxWidget extends ClickableRectangleWidget {
  private RectangleWidget checkbox;
  private RectangleWidget label;
  private color strokeColor;
  private boolean checked;
  private Callback onChangeCallback;

  public CheckboxWidget(int xPosition, int yPosition, int width, int height, int radii, color backgroundColor, color strokeColor, String labelText) {
    super(new ClickableRectangleWidgetBuilder()
                    .leftCornerPosition(xPosition, yPosition)
                    .size(width, height)
                    .cornersRadii(radii)
                    .primaryColor(backgroundColor));
    checkbox = new RectangleWidgetBuilder()
                    .leftCornerPosition(xPosition+CHECKBOX_SIDE_MARGIN, yPosition+CHECKBOX_SIDE_MARGIN)
                    .size(CHECKBOX_SIZE, CHECKBOX_SIZE)
                    .primaryColor(backgroundColor)
                    .borderColor(strokeColor)
                    .labelTextColor(strokeColor)
                    .build();
    label = new RectangleWidgetBuilder()
                    .leftCornerPosition(xPosition+2*CHECKBOX_SIDE_MARGIN+CHECKBOX_SIZE, yPosition)
                    .size(width-(2*CHECKBOX_SIDE_MARGIN+CHECKBOX_SIZE), height)
                    .cornersRadii(radii)
                    .primaryColor(backgroundColor)
                    .labelTextColor(strokeColor)
                    .labelText(labelText)
                    .build();
    setOnClickCallback(new Callback() { void call() {
      checked = !checked;
    }});
    this.strokeColor = strokeColor;
    checked = false;
    onChangeCallback = EMPTY_CALLBACK;
  }

  public void setOnChangeCallback(Callback onChangeCallback) {
    final Callback callback = onChangeCallback;
    setOnClickCallback(new Callback() { public void call() {
      checked = !checked;
      callback.call();
    }});
  }

  public boolean isChecked() {
    return checked;
  }
  public void setChecked(boolean checked) {
    this.checked = checked;
    onChangeCallback.call();
  }

  @Override
  public void draw() {
    if(isVisible) {
      super.draw();
      checkbox.draw();
      label.draw();
      if(checked) {
        stroke(strokeColor); textFont(courier15); textAlign(CENTER, CENTER);
        text("x", xPosition+CHECKBOX_SIDE_MARGIN+CHECKBOX_SIZE/2, yPosition+CHECKBOX_SIDE_MARGIN+CHECKBOX_SIZE/2-1);
        //strokeWeight(1);
        //line(xPosition+CHECKBOX_SIDE_MARGIN, yPosition+CHECKBOX_SIDE_MARGIN, xPosition+CHECKBOX_SIDE_MARGIN+CHECKBOX_SIZE, yPosition+CHECKBOX_SIDE_MARGIN+CHECKBOX_SIZE);
        //line(xPosition+CHECKBOX_SIDE_MARGIN+CHECKBOX_SIZE, yPosition+CHECKBOX_SIDE_MARGIN, xPosition+CHECKBOX_SIDE_MARGIN, yPosition+CHECKBOX_SIDE_MARGIN+CHECKBOX_SIZE);
      }
    }
  }
  @Override
  public void display() {
    if(!isVisible) {
      checkbox.display();
      label.display();
      isVisible = true;
    }
  }
  @Override
  public void hide() {
    if(isVisible) {
      checkbox.hide();
      label.hide();
      isVisible = false;
    }
  }
}
