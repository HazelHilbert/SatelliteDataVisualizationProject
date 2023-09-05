PFont courier15, courier17, courier20, courier30, courierBold15;
PImage satelliteIcon, centralBodyIcon, deepSpaceIcon, spaceSuitIcon, globeTexture, resetIcon;
EventManager eventManager;
DataProvider provider;
ScrollableTextArea scrollableTextArea;
FilterMenu filterMenu;
ChartPanel chartPanel;

void setup() {
  println("this is a copy");
  size(1310, 680, P3D);
  
  courier15 = loadFont("Courier-15.vlw");
  courier17 = loadFont("Courier-17.vlw");
  courier20 = loadFont("Courier-20.vlw");
  courier30 = loadFont("Courier-30.vlw");
  courierBold15 = loadFont("Courier-Bold-15.vlw");
  textFont(courier15);
  
  satelliteIcon = loadImage("satelliteIcon.png");
  satelliteIcon.resize(50, 50);
  centralBodyIcon = loadImage("centralBodyIcon.png");
  centralBodyIcon.resize(50, 50);
  deepSpaceIcon = loadImage("deepSpaceIcon.png");
  deepSpaceIcon.resize(200, 200);
  spaceSuitIcon = loadImage("spaceSuitIcon.png");
  spaceSuitIcon.resize(200, 200);
  globeTexture = loadImage("globeTexture.jpg");
  resetIcon = loadImage("resetIcon.png");
  resetIcon.resize(20, 20);
  
  eventManager = new EventManager();
  provider = new DataProvider("gcat.tsv");
  
  initializeStatusDict(statusValues);
  initializeStateDict(stateValues);
  initializeShortStateDict(shortStateValues);
  
  scrollableTextArea = new ScrollableTextArea(20, 210, 740, 400);
  filterMenu = new FilterMenu(20, 50, 40, 10, 15, BUTTON_CLR, BUTTON_HOVER_CLR, 100, courier15);
  chartPanel = new ChartPanel(790, 50, 500, 580);
}

void draw() {
  background(BACKGROUND_CLR);
  scrollableTextArea.draw();
  filterMenu.draw();
  chartPanel.draw();
}

void keyPressed() {
  if (scrollableTextArea.requireScrolling()){
    if(keyCode == DOWN)
      scrollableTextArea.setStartingIndexAndSlider(scrollableTextArea.getStartingIndex()+1);
    else if(keyCode == UP)
      scrollableTextArea.setStartingIndexAndSlider(scrollableTextArea.getStartingIndex()-1);
  }
  eventManager.invokeKeyPressed();
}

void mouseWheel(MouseEvent event) {
  eventManager.invokeMouseWheelUsed(event);
}

void mouseClicked() {
  eventManager.invokeMouseClicked();
}

void mousePressed() {
  eventManager.invokeMousePressed();
}

void mouseDragged() {
  eventManager.invokeMouseDragged();
}

void mouseReleased() {
  eventManager.invokeMouseReleased();
}
