
// Mark Doyle and Hazel Hilbert

class Statistics extends RectangleWidget implements DataDependentWidget {
  String[] tableRows = new String[7];
  
  Statistics(int xPosition, int yPosition, int width, int height, int radii, color backgroundColor){
    super(xPosition, yPosition, width, height, radii, backgroundColor, backgroundColor);
    initializeTableRows();
    eventManager.registerDataDependentWidget(this);
  }
  
  void draw() {
    super.draw();
    textFont(courier15); textAlign(LEFT, CENTER); fill(LIGHT_TEXT_CLR);
    int buffer = 40;
    for (int i = 0; i < tableRows.length; i++) text(tableRows[i], xPosition+buffer, yPosition+50*(i+1));
    drawTabel(xPosition+buffer/2, yPosition, 7, 4, 50, 108);
  } 
  
  public void update(){
    initializeTableRows();
  }
  
  // Hazel Hilbert: builds a row for a tabel with equal spacing
  public String rowMaker(String str1, String str2, String str3, String str4){
    StringBuilder stringBuilder = new StringBuilder(padWithSpaces(str1, 15));
    stringBuilder.append(padWithSpaces(str2, 12));
    stringBuilder.append(padWithSpaces(str3, 12));
    stringBuilder.append(str4);
    return stringBuilder.toString();
  }
  
  // Hazel Hilbert: draws outline of a table
  public void drawTabel(int xPos, int yPos, int rows, int cols, int rowBuffer, int colBuffer){    
    stroke(LIGHT_TEXT_CLR); strokeWeight(2); noFill();
    for (int row = 2; row < rows; row++) line(xPos, yPos+25+rowBuffer*row,  xPos+25+colBuffer*cols, yPos+25+rowBuffer*row);
    for (int col = 1; col < cols-1; col++) line(xPos+135+colBuffer*col, yPos+25, xPos+135+colBuffer*col, yPos+25+rowBuffer*rows);
    line(xPos+135, yPos+25+rowBuffer, xPos+135, yPos+25+rowBuffer*rows);
    rect(xPos, yPos+25+rowBuffer, 27+colBuffer*cols, rowBuffer*(rows-1), 15, 0, 15, 15);
    rect(xPos+135, yPos+25, colBuffer*3, rowBuffer, 15, 15, 0, 0);
  }
  
  // Hazel Hilbert: initizlizes the text to display on each row of the table
  public void initializeTableRows(){
    tableRows[0] = rowMaker("", "Minimum", "Maximum", "Average");
    if (Double.isNaN(provider.getMinMass())) tableRows[1] = rowMaker("   Mass (kg)", "-", "-", "-");
    else tableRows[1] = rowMaker("   Mass (kg)", nf((float) provider.getMinMass(), 0, 3), nf((float) provider.getMaxMass(), 0, 1), nf((float) provider.getAverageMass(), 0, 2)); 
    if (Double.isNaN(provider.getMinDiameter())) tableRows[2] = rowMaker("Diameter (m)", "-", "-", "-");
    else tableRows[2] = rowMaker("Diameter (m)", nf((float) provider.getMinDiameter(), 0, 3), nf((float) provider.getMaxDiameter(), 0, 1), nf((float) provider.getAverageDiameter(), 0, 2));
    if (Double.isNaN(provider.getMinLength())) tableRows[3] = rowMaker("  Length (m)", "-", "-", "-");
    else tableRows[3] = rowMaker("  Length (m)", nf((float) provider.getMinLength(), 0, 3), nf((float) provider.getMaxLength(), 0, 1), nf((float) provider.getAverageLength(), 0, 2));
    if (Double.isNaN(provider.getMinPerigee())) tableRows[4] = rowMaker("Perigee (km)", "-", "-", "-");
    else tableRows[4] = rowMaker("Perigee (km)", nf((float) provider.getMinPerigee()), nf((float) provider.getMaxPerigee()), String.valueOf(round((float) provider.getAveragePerigee())));
    if (Double.isNaN(provider.getMinApogee())) tableRows[5] = rowMaker(" Apogee (km)", "-", "-", "-");
    else tableRows[5] = rowMaker(" Apogee (km)", nf((float) provider.getMinApogee()), nf((float) provider.getMaxApogee()), String.valueOf(round((float) provider.getAverageApogee())));
    if (provider.getEarliestYear() == 0) tableRows[6] = rowMaker(" Launch Date", "-", "-", "-");
    else tableRows[6] = rowMaker(" Launch Date", nf((float) provider.getEarliestYear()), nf((float) provider.getLatestYear()), "-"); 
  }
}
