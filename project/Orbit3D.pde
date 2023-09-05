// Michal Bronicki
// displays a 3D orbit visualisation
class Orbit3D extends RectangleWidget implements DraggableWidget, ScrollableWidget, DataDependentWidget {
  private final float EARTH_RADIUS = 6378; 
  private float scale;
  PGraphics graphics;
  private PShape globe;
  private boolean isBeingDragged;
  private float xAngle;
  private float yAngle;
  private boolean automaticRotation;

  Orbit3D(int xPosition, int yPosition, int width, int height, int radii, color backgroundColor){
    super(new RectangleWidgetBuilder()
                .leftCornerPosition(xPosition, yPosition)
                .size(width, height)
                .cornersRadii(radii)
                .primaryColor(backgroundColor)
                .borderColor(BACKGROUND_CLR));
    graphics = createGraphics(width, height, P3D);
    scale = height/(4*EARTH_RADIUS);
    globe = graphics.createShape(SPHERE, EARTH_RADIUS*scale); 
    globe.setStroke(false);
    globe.setTexture(globeTexture);
    isBeingDragged = false;
    xAngle = 0;
    yAngle = 0;
    automaticRotation = true;
    eventManager.registerDraggableWidget(this);
    eventManager.registerScrollableWidget(this);
  }

  @Override
  public void draw() {
    if(automaticRotation) xAngle -= 0.01;
    super.draw(); 
    graphics.beginDraw();
    graphics.translate(width/2, height/2);
    graphics.beginCamera();
    graphics.camera(0,0,500,0,0,0,0,1,0);
    graphics.rotateX(yAngle);
    graphics.rotateY(xAngle);
    graphics.endCamera();
    
    graphics.background(primaryColor);
    graphics.noStroke();
    graphics.shape(globe);
    graphics.noFill();
    graphics.stroke(ORBIT_CLR);
    graphics.strokeWeight(2);
    for(DataPoint selectedDataPoint : scrollableTextArea.getSelectedDataPoints()) {
      graphics.rotateX((float)selectedDataPoint.getInclination() * PI/180);
      float apogee = (float)Math.abs(selectedDataPoint.getApogee()) + EARTH_RADIUS;
      float perigee = (float)Math.abs(selectedDataPoint.getPerigee()) + EARTH_RADIUS;
      graphics.ellipse(0.5*(apogee-perigee)*scale, 0, (apogee+perigee)*scale, 2*sqrt(apogee*perigee)*scale);
      graphics.rotateX(-(float)selectedDataPoint.getInclination() * PI/180);
    }
    graphics.endDraw();
    image(graphics, xPosition, yPosition);
  }

  public void setAutomaticRotation(boolean automaticRotation) {
    this.automaticRotation = automaticRotation;
  }

  @Override
  public void display() {
    if(!isVisible) {
      eventManager.registerDraggableWidget(this);
      eventManager.registerScrollableWidget(this);
      isVisible = true;
    }
  }
  @Override
  public void hide() {
    if(isVisible) {
      eventManager.removeDraggableWidget(this);
      eventManager.removeScrollableWidget(this);
      isVisible = false;
    }
  }
  @Override
  public void update() { }

  @Override
  public void invokeMouseWheelUsed(MouseEvent event) {
    float e = event.getCount();
    if(scale+0.0001*e > 0 && scale+0.0001*e < 0.035)
      scale += 0.0001*e;
    globe = graphics.createShape(SPHERE, EARTH_RADIUS*scale); 
    globe.setStroke(false);
    globe.setTexture(globeTexture);
  }
  @Override
  public boolean isBeingDragged() {
    return isBeingDragged;
  }
  @Override
  public void startDragging() {
    if(isHovered()) {
      isBeingDragged = true;
    }
  }
  @Override
  public void updatePosition() {
    float dx = mouseX - pmouseX;
    float dy = mouseY - pmouseY;
    
    xAngle += dx * 0.1*PI/(EARTH_RADIUS*scale);
    yAngle -= dy * 0.1*PI/(EARTH_RADIUS*scale);
  }
  @Override
  public void stopDragging() {
    isBeingDragged = false;
  }
  @Override
  public void setOnDragCallback(Callback onDragCallback) {}
}
