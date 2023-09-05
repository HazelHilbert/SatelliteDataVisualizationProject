final int SATCAT_INDEX = 1;
final int NAME_INDEX = 4;
final int LAUNCH_DATE_INDEX = 6;
final int STATUS_INDEX = 11;
final int STATE_INDEX = 14;
final int MASS_INDEX = 18;
final int DIAMETER_INDEX = 26;
final int PERIGEE_INDEX = 32;
final int APOGEE_INDEX = 34;
final int MANUFACTURER_INDEX = 15;
final int LENGTH_INDEX = 24;
final int SHAPE_INDEX = 30;
final int INCLINATION_INDEX = 36;
final StringDict statusValues = new StringDict();
final StringDict stateValues = new StringDict();
final StringDict shortStateValues = new StringDict();

class DataPoint {
  private String satcat;
  private int satcatInt;
  private String name;
  private Date launchDate;
  private String status;
  private String state;
  private double mass;
  private double diameter;
  private double perigee;
  private double apogee;
  private String manufacturer;
  private double length;
  private String shape;
  private double inclination;
  private String description;
  
  DataPoint(String satcat, String name, String launchDate, String status, String state, String mass, String diameter, String perigee, String apogee, String manufacturer, String length, String shape, String inclination) {
      this.satcat = satcat;
      this.satcatInt = Integer.parseInt(satcat);
      this.name = name;
      this.launchDate = new Date(launchDate);
      this.status = status;
      this.state = state;
      this.mass = safeStringToDouble(mass);
      if(this.mass == 0.0) this.mass = Double.NaN;
      this.diameter = safeStringToDouble(diameter);
      if(this.diameter == 0.0) this.diameter = Double.NaN;
      this.perigee = safeStringToDouble(perigee);
      if(this.perigee == 0.0) this.perigee = Double.NaN;
      this.apogee = safeStringToDouble(apogee);
      if(this.apogee == 0.0) this.apogee = Double.NaN;
      this.manufacturer = manufacturer;
      this.length = safeStringToDouble(length);
      if(this.length == 0.0) this.length = Double.NaN;
      this.shape = shape;
      this.inclination = safeStringToDouble(inclination);
      createDescription(MASS);
  }
  
  public String getSatcat() {
    return satcat;  
  }
  public int getSatcatInt() {
    return satcatInt;
  }
  public String getName() {
    return name;  
  }
  public Date getLaunchDate() {
    return launchDate;  
  }
  public String getStatus() {
    return status;  
  }
  // Hazel Hilbert: returns String discription of the status abreviation
  public String getStatusValue(){
    if (status.contains("?")) {
      String tempStatus = status.substring(0,status.length()-1);
      return (statusValues.hasKey(tempStatus)) ? statusValues.get(tempStatus) + "?" : status;
    }
    else return (statusValues.hasKey(status)) ? statusValues.get(status) : status;
  }
  public String getStateValue(){
    if (state.contains("?")) {
      String tempState = state.substring(0, state.length()-1);
      return (stateValues.hasKey(tempState)) ? stateValues.get(tempState) + "?" : state;
    }
    else return (stateValues.hasKey(state)) ? stateValues.get(state) : state;
  }
  public String getShortStateValue(){
    if (state.contains("?")) {
      String tempState = state.substring(0, state.length()-1);
      return (shortStateValues.hasKey(tempState)) ? shortStateValues.get(tempState) + "?" : state;
    }
    else return (shortStateValues.hasKey(state)) ? shortStateValues.get(state) : state;
  }
  public String getState() {
    return state;  
  }
  public double getMass() {
    return mass;  
  }
  public double getDiameter() {
    return diameter;  
  }
  public double getPerigee() {
    return perigee;  
  }
  public double getApogee() {
    return apogee;  
  }
  public String getManufacturer() {
    return manufacturer;
  }
  public double getLength() {
    return length;
  }
  public String getShape() {
    return shape;
  }
  public double getInclination() {
    return inclination;
  }
  public String getDescription(String dataType) {
    createDescription(dataType);
    return description;  
  }
  
  // Michal Bronicki and Hazel Hilbert: creates a string that displays the fields of the data points
  private void createDescription(String dataType) {
    StringBuilder stringBuilder = new StringBuilder(padWithSpaces(satcat, 8));
    stringBuilder.append(padWithSpaces(name, 30));
    stringBuilder.append(padWithSpaces(launchDate.dateToString(), 16));
    stringBuilder.append(padWithSpaces(status, 8));
    stringBuilder.append(padWithSpaces(state, 8));
    if(dataType.equals(MASS) && !Double.isNaN(mass)) stringBuilder.append(mass);
    else if(dataType.equals(MASS)) stringBuilder.append('-');
    else if(dataType.equals(DIAMETER) && !Double.isNaN(diameter)) stringBuilder.append(diameter);
    else if(dataType.equals(DIAMETER)) stringBuilder.append('-');
    else if(dataType.equals(PERIGEE)) stringBuilder.append(doubleToStringWithNoDecimalPlaces(perigee));
    else if(dataType.equals(APOGEE)) stringBuilder.append(doubleToStringWithNoDecimalPlaces(apogee));
    description = stringBuilder.toString();
  }
}

// check for special values and converts a string to double 
double safeStringToDouble(String string) {
  if(string.trim().equalsIgnoreCase("Inf"))
    return Double.POSITIVE_INFINITY;
  if(string.trim().equals("-"))
    return Double.NaN;
  double result = Double.NaN;
  try {
    result = Double.parseDouble(string);
  } catch(Exception exception) {
    println(exception);
  }
  return result;
}

// pads a string wit spaces to a set length
String padWithSpaces(String word, int length){
  int wordLength = word.length();
  for (int i = 0; i < length-wordLength; i++) word += " ";
  return word;
}

String doubleToStringWithNoDecimalPlaces(double value) {
  if(Double.isNaN(value))
    return "-";
  if(value == Double.NEGATIVE_INFINITY)
    return "-Infinity";
  if(value == Double.POSITIVE_INFINITY)
    return "Infinity";
  return String.valueOf((int)value);  
}

// Hazel Hilbert: initializes the status dictonary
void initializeStatusDict(StringDict statusValues){
  statusValues.set("O", "Orbit");
  statusValues.set("AO", "Attached in Orbit");
  statusValues.set("AO IN", "Attached Inside");
  statusValues.set("UDK", "Undocked");
  statusValues.set("REL", "Released");
  statusValues.set("DEP", "Deployed");
  statusValues.set("LO", "Liftoff");
  statusValues.set("ALO", "Attached at Liftoff");
  statusValues.set("E", "Exploded");
  statusValues.set("N", "Renamed");
  statusValues.set("LEASE", "Lease");
  statusValues.set("R", "Reentered");
  statusValues.set("D", "Deorbited");
  statusValues.set("L", "Landed");
  statusValues.set("AR", "Reentered Attached");
  statusValues.set("AR IN", "Reentered Inside");
  statusValues.set("AL", "Landed Attached"); 
  statusValues.set("AL IN", "Landed Inside");
  statusValues.set("TX", "Transmission Ended");
  statusValues.set("F", "Failed");
  statusValues.set("AF", "Failed Attached");
  statusValues.set("DSO", "Deep Space"); 
  statusValues.set("DSA", "Deep Space Attached");
  statusValues.set("DSA IN", "Deep Space Inside");
  statusValues.set("LO", "Liftoff"); 
  statusValues.set("REFLT", "Reflight");
  statusValues.set("DK", "Docked"); 
  statusValues.set("GRP", "Grappled");
  statusValues.set("ATT", "Attached");
  statusValues.set("TFR", "Transfer");
  statusValues.set("TFR E", "Transfer External"); 
  statusValues.set("RET", "Retrieved");
  statusValues.set("C", "Collided");
  statusValues.set("EVA", "Spacewalk");
  statusValues.set("REFLT", "Reflight"); 
  statusValues.set("EO", "Escape");
  statusValues.set("EAO", "Escape Attached"); 
}

void initializeStateDict(StringDict stateValues){
  stateValues.set("US", "United States");
  stateValues.set("SU", "Soviet Union");
  stateValues.set("RU", "Russia");  
  stateValues.set("CN", "China");
  stateValues.set("CA", "Canada");  
  stateValues.set("IN", "India");
  stateValues.set("F", "France");
  stateValues.set("J", "Japan");
  stateValues.set("UK", "United Kingdom");
  stateValues.set("I", "Italy");
  stateValues.set("I-ESA", "European Space Agency");
  stateValues.set("I-INT", "Internation Space Agency");
  stateValues.set("SA", "Saudi Arabia");
  stateValues.set("MX", "Mexico");
  stateValues.set("UAE", "United Arab Emirates");
  stateValues.set("AU", "Australia");
  stateValues.set("E", "Spain");
  stateValues.set("ID", "Indonesia");
  stateValues.set("L", "Luxembourg");
  stateValues.set("D", "Germany");
  stateValues.set("T", "Thailand");
  stateValues.set("QA", "Qatar");
  stateValues.set("SG", "Singapore");
  stateValues.set("TR", "Tonga");
  stateValues.set("MY", "Malaysia");
  stateValues.set("CYM", "Cuba");
  stateValues.set("NL", "Netherlands");
  stateValues.set("BM", "Bermuda");
  stateValues.set("BR", "Brazil");
  stateValues.set("I-EUT", "European Telecommunications Satellite Organization");
  stateValues.set("HK", "Hong Kong");
  stateValues.set("I_EUM", "European Meteorological Satellite Organization");
  stateValues.set("N","Norway");
  stateValues.set("IL","Israel");
  stateValues.set("AR","Argentina");
  stateValues.set("TW","Taiwan");
  stateValues.set("I-ARAB","Arabsat");
  stateValues.set("IE","Ireland");
  stateValues.set("BG","Bulgaria");
  stateValues.set("AZ","Azerbaijan");
  stateValues.set("BY","Belarus");
  stateValues.set("DZ","Algeria");
  stateValues.set("NG","Nigeria");
  stateValues.set("BO","Bolivia");
  stateValues.set("LA","Laos");
  stateValues.set("KR","South Korea");
  stateValues.set("BD","Bangladesh");
  stateValues.set("MU","Mauritius");
  stateValues.set("PK","Pakistan");
  stateValues.set("S","Sweden");
  stateValues.set("EG","Egypt");
  stateValues.set("VE","Venezuela");
  stateValues.set("PH","Philipines");
  stateValues.set("UA","Ukraine");
  stateValues.set("I-EU","European Union");
  stateValues.set("I-INM","International Maritime Satellite Organization");
  stateValues.set("HKUK","Hong Kong");
  stateValues.set("VN","Vietnam");
  stateValues.set("I-NATO","North Atlantic Treaty Organization");
  stateValues.set("PG","Papua New Guinea");
  stateValues.set("KZ","Kazakhstan");
  stateValues.set("GR","Greece");
  stateValues.set("MC","Monaco");
  stateValues.set("I-RASC","Regional African Satellite Communication Organization");
  stateValues.set("IR","Iran");
  stateValues.set("I-ESRO","European Space Research Organization");
  stateValues.set("NZ","New Zeland");
  stateValues.set("PE","Peru");
  stateValues.set("CL","Chile");
  stateValues.set("ZA","South Africa");
  stateValues.set("KP","North Korea");
  stateValues.set("FI","Finland");
  stateValues.set("CZ","Czech Republic");
  stateValues.set("CSSR","Czech Republic");
  stateValues.set("CSFR","Czech Republic");
  stateValues.set("SI","Slovenia");
  stateValues.set("DK","Denmark");
  stateValues.set("P","Portugal");
  stateValues.set("UY","Uruguay");
  stateValues.set("ET","Ethiopia");
  stateValues.set("SD","Sudan");
  stateValues.set("B","Belguim");
  stateValues.set("LT","Lithuania");
  stateValues.set("RW","Rwanda");
  stateValues.set("BGN","Bulgaria");
  stateValues.set("AT","Austria");
  stateValues.set("PL","Poland");
  stateValues.set("LV","Latvia");
  stateValues.set("CH","Switzerland");
  stateValues.set("EC","Ecuador");
  stateValues.set("HU","Hungary");
  stateValues.set("CO","Colombia");
  stateValues.set("PR","Puerto Rico");
  stateValues.set("TN","Tunisia");
  stateValues.set("RO","Romania");
  stateValues.set("EE","Estonia");
  stateValues.set("SK","Slovakia");
  stateValues.set("GH","Ghana");
  stateValues.set("MN","Mongolia");
  stateValues.set("KE","Kenya");
  stateValues.set("CR","Costa Rica");
  stateValues.set("BT","Bhutan");
  stateValues.set("JO","Jordan");
  stateValues.set("LK","Sri Lanka");
  stateValues.set("NP","Nepal");
  stateValues.set("GT","Guatemala");
  stateValues.set("PY","Paraguay");
  stateValues.set("KW","Kuwait");
  stateValues.set("AO", "Angola");
}

void initializeShortStateDict(StringDict shortStateValues){
  shortStateValues.set("US", "USA");
  shortStateValues.set("SU", "USSR");
  shortStateValues.set("RU", "Russia");  
  shortStateValues.set("CN", "China");
  shortStateValues.set("CA", "Canada");  
  shortStateValues.set("IN", "India");
  shortStateValues.set("F", "France");
  shortStateValues.set("J", "Japan");
  shortStateValues.set("UK", "UK");
  shortStateValues.set("I", "Italy");
  shortStateValues.set("I-ESA", "ESA");
  shortStateValues.set("I-INT", "INT");
  shortStateValues.set("SA", "S.Arabia");
  shortStateValues.set("MX", "Mexico");
  shortStateValues.set("UAE", "UAE");
  shortStateValues.set("AU", "Australia");
  shortStateValues.set("E", "Spain");
  shortStateValues.set("ID", "Indonesia");
  shortStateValues.set("L", "Luxembourg");
  shortStateValues.set("D", "Germany");
  shortStateValues.set("T", "Thailand");
  shortStateValues.set("QA", "Qatar");
  shortStateValues.set("SG", "Singapore");
  shortStateValues.set("TR", "Tonga");
  shortStateValues.set("MY", "Malaysia");
  shortStateValues.set("CYM", "Cuba");
  shortStateValues.set("NL", "Netherlands");
  shortStateValues.set("BM", "Bermuda");
  shortStateValues.set("BR", "Brazil");
  shortStateValues.set("I-EUT", "EUT");
  shortStateValues.set("HK", "Hong Kong");
  shortStateValues.set("I_EUM", "EUM");
  shortStateValues.set("N","Norway");
  shortStateValues.set("IL","Israel");
  shortStateValues.set("AR","Argentina");
  shortStateValues.set("TW","Taiwan");
  shortStateValues.set("I-ARAB","Arabsat");
  shortStateValues.set("IE","Ireland");
  shortStateValues.set("BG","Bulgaria");
  shortStateValues.set("AZ","Azerbaijan");
  shortStateValues.set("BY","Belarus");
  shortStateValues.set("DZ","Algeria");
  shortStateValues.set("NG","Nigeria");
  shortStateValues.set("BO","Bolivia");
  shortStateValues.set("LA","Laos");
  shortStateValues.set("KR","South Korea");
  shortStateValues.set("BD","Bangladesh");
  shortStateValues.set("MU","Mauritius");
  shortStateValues.set("PK","Pakistan");
  shortStateValues.set("S","Sweden");
  shortStateValues.set("EG","Egypt");
  shortStateValues.set("VE","Venezuela");
  shortStateValues.set("PH","Philipines");
  shortStateValues.set("UA","Ukraine");
  shortStateValues.set("I-EU","EU");
  shortStateValues.set("I-INM","INM");
  shortStateValues.set("HKUK","Hong Kong");
  shortStateValues.set("VN","Vietnam");
  shortStateValues.set("I-NATO","NATO");
  shortStateValues.set("PG","P.New Guinea");
  shortStateValues.set("KZ","Kazakhstan");
  shortStateValues.set("GR","Greece");
  shortStateValues.set("MC","Monaco");
  shortStateValues.set("I-RASC","RASC");
  shortStateValues.set("IR","Iran");
  shortStateValues.set("I-ESRO","ESRO");
  shortStateValues.set("NZ","New Zeland");
  shortStateValues.set("PE","Peru");
  shortStateValues.set("CL","Chile");
  shortStateValues.set("ZA","South Africa");
  shortStateValues.set("KP","North Korea");
  shortStateValues.set("FI","Finland");
  shortStateValues.set("CZ","Czechia");
  shortStateValues.set("CSSR","Czechia");
  shortStateValues.set("CSFR","Czechia");
  shortStateValues.set("SI","Slovenia");
  shortStateValues.set("DK","Denmark");
  shortStateValues.set("P","Portugal");
  shortStateValues.set("UY","Uruguay");
  shortStateValues.set("ET","Ethiopia");
  shortStateValues.set("SD","Sudan");
  shortStateValues.set("B","Belguim");
  shortStateValues.set("LT","Lithuania");
  shortStateValues.set("RW","Rwanda");
  shortStateValues.set("BGN","Bulgaria");
  shortStateValues.set("AT","Austria");
  shortStateValues.set("PL","Poland");
  shortStateValues.set("LV","Latvia");
  shortStateValues.set("CH","Switzerland");
  shortStateValues.set("EC","Ecuador");
  shortStateValues.set("HU","Hungary");
  shortStateValues.set("CO","Colombia");
  shortStateValues.set("PR","Puerto Rico");
  shortStateValues.set("TN","Tunisia");
  shortStateValues.set("RO","Romania");
  shortStateValues.set("EE","Estonia");
  shortStateValues.set("SK","Slovakia");
  shortStateValues.set("GH","Ghana");
  shortStateValues.set("MN","Mongolia");
  shortStateValues.set("KE","Kenya");
  shortStateValues.set("CR","Costa Rica");
  shortStateValues.set("BT","Bhutan");
  shortStateValues.set("JO","Jordan");
  shortStateValues.set("LK","Sri Lanka");
  shortStateValues.set("NP","Nepal");
  shortStateValues.set("GT","Guatemala");
  shortStateValues.set("PY","Paraguay");
  shortStateValues.set("KW","Kuwait");
  shortStateValues.set("AO", "Angola");
}
