// Hazel Hilbert and Udit Jain: Orbit class to display space object's orbits and other details

class Orbit extends RectangleWidget {
  DataPoint dataPoint;
  int textCounter;
  OrbitPath orbitPath;
  String status;
  Boolean showOrbit;
  PImage statusIcon;
  
  Orbit(int xPosition, int yPosition, int width, int height, int radii, color backgroundColor, DataPoint dataPoint){
    super(xPosition, yPosition, width, height, radii, backgroundColor, backgroundColor);
    this.dataPoint= dataPoint;
    status = dataPoint.getStatus();
    showOrbit = showOrbit();
    if (showOrbit) orbitPath = new OrbitPath(xPosition+width/2, yPosition+height*3/4, dataPoint);
  }
  
  void draw() {
    noStroke();

    fill(LIGHT_TEXT_CLR);
    if (showOrbit) orbitPath.draw();
    else if (status.equals("DSO") || status.equals("DSA")) image(deepSpaceIcon, xPosition+width/2-deepSpaceIcon.width/2, yPosition+height*3/4-deepSpaceIcon.height/2);
    else if (status.equals("EVA")) image(spaceSuitIcon, xPosition+width/2-spaceSuitIcon.width/2, yPosition+height*3/4-spaceSuitIcon.height/2);
    else text("No Orbit to Display", xPosition+width/2, yPosition+height*3/4); 
    int buffer = 15;
    textAlign(LEFT, CENTER);
    textFont(courier30);
    AnimateText(dataPoint.getName(), xPosition+buffer, yPosition+buffer*7/4);
    
    textFont(courier15);
    text("Launched: ", xPosition+buffer, yPosition+40+buffer*3/2);
    text("Satcat: ", xPosition+width/2, yPosition+40+buffer*3/2);
    text("Status: ", xPosition+buffer, yPosition+70+buffer*3/2);
    text("State: ", xPosition+buffer, yPosition+100+buffer*3/2);
    text("Manufacturer: ", xPosition+buffer, yPosition+130+buffer*3/2);
    text("Mass: ", xPosition+buffer, yPosition+160+buffer*3/2);
    text("Diameter: ", xPosition+buffer, yPosition+185+buffer*3/2);
    text("Length: ", xPosition+buffer, yPosition+210+buffer*3/2);
    text("Shape: ", xPosition+buffer, yPosition+235+buffer*3/2);
    text("Perigee: ", xPosition+width/2, yPosition+160+buffer*3/2);
    text("Apogee: ", xPosition+width/2, yPosition+185+buffer*3/2);
    text("Inclination: ", xPosition+width/2, yPosition+210+buffer*3/2);
    
    textFont(courier17);
    AnimateText(dataPoint.getStatusValue(), xPosition+buffer+72, yPosition+70+buffer*3/2);
    AnimateText(dataPoint.getManufacturer(), xPosition+buffer+126, yPosition+130+buffer*3/2);

    textFont(courier20);
    AnimateText(dataPoint.getLaunchDate().dateToString(), xPosition+buffer+90, yPosition+40+buffer*3/2);
    AnimateText(dataPoint.getSatcat(), xPosition+width/2+72, yPosition+40+buffer*3/2);
    AnimateText(dataPoint.getStateValue(), xPosition+buffer+63, yPosition+100+buffer*3/2);
    text(Double.isNaN(dataPoint.getMass()) ? "-" : dataPoint.getMass()+" kg", xPosition+buffer+100, yPosition+160+buffer*3/2);
    text(Double.isNaN(dataPoint.getDiameter()) ? "-" : dataPoint.getDiameter()+" m", xPosition+buffer+100, yPosition+185+buffer*3/2);
    text(Double.isNaN(dataPoint.getLength()) ? "-" : dataPoint.getLength()+" m", xPosition+buffer+100, yPosition+210+buffer*3/2);
    text(dataPoint.getShape(), xPosition+buffer+100, yPosition+235+buffer*3/2);
    text(Double.isNaN(dataPoint.getPerigee()) ? "-" : dataPoint.getPerigee()+" km", xPosition+width/2+120, yPosition+160+buffer*3/2);
    text(Double.isNaN(dataPoint.getApogee()) ? "-" : dataPoint.getApogee()+" km", xPosition+width/2+120, yPosition+185+buffer*3/2);
    text(Double.isNaN(dataPoint.getInclination()) ? "-" : dataPoint.getInclination()+"°", xPosition+width/2+120, yPosition+210+buffer*3/2);
    textCounter += ((random(0,1) > 0.2) ? 1 : 3);
  }
  // Hazel Hilbert: method creates a new orbitPath from a new DataPoint
  public void setDataPoint(DataPoint newDataPoint){
    dataPoint = newDataPoint;
    status = dataPoint.getStatus();
    showOrbit = showOrbit();
    if (showOrbit) orbitPath = new OrbitPath(xPosition+width/2, yPosition+height*3/4, dataPoint);
    textCounter = 0;
  }
  
  // Hazel Hilbert: animates a string of text beeing typed out
  void AnimateText(String text, float xPosition, float yPosition){
    if (textCounter < text.length()*10) text(text.substring(0, textCounter/10), xPosition, yPosition);
    else text(text, xPosition, yPosition);
  }
  
  // Hazel Hilbert: returns if the orbit should be displayed based on status
  public boolean showOrbit(){
    return ((status.equals("O") || status.equals("AO") || status.equals("REL") || status.equals("E") || status.equals("N") || status.equals("GRP") || 
            status.equals("R") || status.equals("D") || status.equals("AR") || status.equals("DK") || status.equals("GRP") || status.equals("ATT") || 
            status.equals("TFR") || status.equals("C") || status.equals("R?") || status.equals("L?") || status.equals("L") || status.equals("OX")) && 
            !Double.isNaN(dataPoint.getPerigee()) && !Double.isNaN(dataPoint.getApogee())) ? true : false;
  }
}


// Hazel Hilbert: OrbitPath class to animate space object's orbits using their apogge and perigee

class OrbitPath {
  private float apogee, perigee;
  private float planetX, planetY;
  private float orbitHorizontalRadius, orbitVerticalRadius, centerToFocus;
  private float orbitCenterX, orbitCenterY;
  private float theta;
  
  OrbitPath(float planetX, float planetY, DataPoint dataPoint){
    this.planetX = planetX;
    this.planetY = planetY;
    
    apogee = abs((float) dataPoint.getApogee());
    perigee = abs((float) dataPoint.getPerigee());
    float ratio = perigee/apogee;
    apogee = map(abs((float) dataPoint.getApogee()), -100000, 100000, 0, width/10)+centralBodyIcon.width/2;
    perigee = apogee*ratio+centralBodyIcon.width/2; 

    orbitHorizontalRadius = (apogee+perigee)/2;
    centerToFocus = orbitHorizontalRadius-perigee;
    orbitVerticalRadius = sqrt(apogee*perigee);

    orbitCenterX =  planetX+centerToFocus;
    orbitCenterY = planetY;
    theta = 0;
  }
  
  public void draw(){
    stroke(ORBIT_CLR);
    noFill();
    ellipse(orbitCenterX, orbitCenterY, orbitHorizontalRadius*2, orbitVerticalRadius*2);
    image(centralBodyIcon, planetX-centralBodyIcon.width/2, planetY-centralBodyIcon.height/2);
    
    pushMatrix();
    translate(orbitCenterX+(orbitHorizontalRadius*cos(theta)), planetY+(orbitVerticalRadius*sin(theta)));
    rotate(theta);
    image(satelliteIcon, -satelliteIcon.width/2, -satelliteIcon.height/2);
    popMatrix();
    theta += 0.02;
  }
}
