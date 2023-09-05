import java.util.Collections;
import java.util.Comparator;

//Michal Bronicki, Udit Jain and Mark doyle
class DataProvider {
  private ArrayList<DataPoint> dataPoints;
  private ArrayList<DataPoint> filteredDataPoints;
  private Comparator<DataPoint> comparator;
  private double minMass, maxMass, minDiameter, maxDiameter, minApogee, maxApogee, minPerigee, maxPerigee, minLength, maxLength;
  private double sumOfMass, sumOfDiameter, sumOfApogee, sumOfPerigee, sumOfLength; 
  private int validMassEntriesCount, validDiameterEntriesCount, validApogeeEntriesCount, validPerigeeEntriesCount, validLengthEntriesCount;
  private int earliestYear, latestYear;
  private double averageMass, averageDiameter, averageApogee, averagePerigee, averageLength;
  
  DataProvider(String filename) {
    dataPoints = new ArrayList<DataPoint>();
    String[] lines = loadStrings(filename);
    // For loop starting at index 1 because file contains headers
    for(int i=1; i<lines.length; i++) {
      String[] fields = split(lines[i], '\t');  //fields refers to each attribute of the space objects
      try {
        Integer satcatInt = Integer.parseInt(fields[SATCAT_INDEX]);
        dataPoints.add( new DataPoint(fields[SATCAT_INDEX], fields[NAME_INDEX], fields[LAUNCH_DATE_INDEX], fields[STATUS_INDEX], fields[STATE_INDEX], 
                        fields[MASS_INDEX], fields[DIAMETER_INDEX], fields[PERIGEE_INDEX], fields[APOGEE_INDEX], fields[MANUFACTURER_INDEX],
                        fields[LENGTH_INDEX], fields[SHAPE_INDEX], fields[INCLINATION_INDEX]));  
      } catch(Exception exception) { 
        // invalid entry, ignored
      }                           
    }
    comparator = COMPARATOR_SATCAT_ASCENDING;
    setFilter(new Predicate<DataPoint>() { boolean test(DataPoint dataPoint) { return true; } });
  }
    
  ArrayList<DataPoint> getData() {
   return filteredDataPoints;
  }

  // filters data based on passed in query; calculates min, max and average values
  void setFilter(Predicate<DataPoint> predicate) {
    minMass = Double.NaN;
    maxMass = Double.NaN;
    minDiameter = Double.NaN;
    maxDiameter = Double.NaN;
    minApogee = Double.NaN;
    maxApogee = Double.NaN;
    minPerigee = Double.NaN;
    maxPerigee = Double.NaN;
    minLength = Double.NaN;
    maxLength = Double.NaN;
    earliestYear = 0;
    latestYear = 0;

    sumOfMass = 0;
    sumOfDiameter = 0;
    sumOfApogee = 0;
    sumOfPerigee = 0;
    sumOfLength = 0;
    validMassEntriesCount = 0;
    validDiameterEntriesCount = 0;
    validApogeeEntriesCount = 0;
    validPerigeeEntriesCount = 0;
    validLengthEntriesCount = 0;

    filteredDataPoints = new ArrayList<DataPoint>();
    for(DataPoint dataPoint : dataPoints) {
      if(predicate.test(dataPoint)) {
        filteredDataPoints.add(dataPoint);
        
        if(Double.isNaN(minMass) || dataPoint.getMass() < minMass) minMass = dataPoint.getMass();
        if(Double.isNaN(maxMass) || dataPoint.getMass() > maxMass) maxMass = dataPoint.getMass();
        if(Double.isNaN(minDiameter) || dataPoint.getDiameter() < minDiameter) minDiameter = dataPoint.getDiameter();
        if(Double.isNaN(maxDiameter) || dataPoint.getDiameter() > maxDiameter) maxDiameter = dataPoint.getDiameter();
        if(Double.isNaN(minApogee) || dataPoint.getApogee() < minApogee) minApogee = dataPoint.getApogee();
        if(Double.isNaN(maxApogee) || dataPoint.getApogee() > maxApogee) maxApogee = dataPoint.getApogee();
        if(Double.isNaN(minPerigee) || dataPoint.getPerigee() < minPerigee) minPerigee = dataPoint.getPerigee();
        if(Double.isNaN(maxPerigee) || dataPoint.getPerigee() > maxPerigee) maxPerigee = dataPoint.getPerigee();
        if(Double.isNaN(minLength) || dataPoint.getLength() < minLength) minLength = dataPoint.getLength();
        if(Double.isNaN(maxLength) || dataPoint.getLength() > maxLength) maxLength = dataPoint.getLength();        
        if(earliestYear == 0 || (dataPoint.getLaunchDate().getYear() != 0 && dataPoint.getLaunchDate().getYear() < earliestYear)) earliestYear = dataPoint.getLaunchDate().getYear();
        if(latestYear == 0 || (dataPoint.getLaunchDate().getYear() != 0 && dataPoint.getLaunchDate().getYear() > latestYear)) latestYear = dataPoint.getLaunchDate().getYear();

        if(isMeaningfulNumericalValue(dataPoint.getMass())) {
          sumOfMass += dataPoint.getMass();
          validMassEntriesCount++;
        }
        if(isMeaningfulNumericalValue(dataPoint.getDiameter())) {
          sumOfDiameter += dataPoint.getDiameter();
          validDiameterEntriesCount++;
        }
        if(isMeaningfulNumericalValue(dataPoint.getApogee())) {
          sumOfApogee += dataPoint.getApogee();
          validApogeeEntriesCount++;
        }
        if(isMeaningfulNumericalValue(dataPoint.getPerigee())) {
          sumOfPerigee += dataPoint.getPerigee();
          validPerigeeEntriesCount++;
        }
        if(isMeaningfulNumericalValue(dataPoint.getLength())) {
          sumOfLength += dataPoint.getLength();
          validLengthEntriesCount++;
        }
      }
    }
    if(validMassEntriesCount == 0)
      averageMass = Double.NaN;
    else
      averageMass = sumOfMass / validMassEntriesCount;
    if(validDiameterEntriesCount == 0)
      averageDiameter = Double.NaN;
    else
      averageDiameter = sumOfDiameter / validDiameterEntriesCount;
    if(validApogeeEntriesCount == 0)
      averageApogee = Double.NaN;
    else
      averageApogee = sumOfApogee / validApogeeEntriesCount;
    if(validPerigeeEntriesCount == 0)
      averagePerigee = Double.NaN;
    else
      averagePerigee = sumOfPerigee / validPerigeeEntriesCount;
    if(validLengthEntriesCount == 0)
      averageLength = Double.NaN;
    else
      averageLength = sumOfLength / validLengthEntriesCount;

    Collections.sort(filteredDataPoints, comparator);
    eventManager.updateDataDependentWidgets();
  }

  public void setSortingComparator(Comparator<DataPoint> comparator) {
    this.comparator = comparator;
    Collections.sort(filteredDataPoints, comparator);
    eventManager.updateDataDependentWidgets();
  }
  
  public Comparator<DataPoint> getSortingComparator(){
    return comparator;
  }

  public double getAverageMass() {
    return averageMass;
  }
  public double getAverageDiameter() {
    return averageDiameter;
  }
  public double getAverageApogee() {
    return averageApogee;
  }
  public double getAveragePerigee() {
    return averagePerigee;
  }
  public double getAverageLength() {
    return averageLength;
  }
  
  public double getMaxMass() {
    return maxMass;
  }
  public double getMinMass() {
    return minMass;
  }
  public double getMinDiameter() {
    return minDiameter;
  }  
  public double getMaxDiameter() {
    return maxDiameter;
  }
  public double getMinApogee() {
    return minApogee;
  }
  public double getMaxApogee() {
    return maxApogee;
  }
  public double getMinPerigee() {
    return minPerigee;
  }
  public double getMaxPerigee() { 
    return maxPerigee;
  }
  public double getMinLength() {
    return minLength;
  }
  public double getMaxLength() { 
    return maxLength;
  }
  public int getEarliestYear() { 
    return earliestYear;
  }
  public int getLatestYear() {
    return latestYear; 
  }  

  private boolean isMeaningfulNumericalValue(double value) {
    return (!Double.isNaN(value) && value != Double.NEGATIVE_INFINITY && value != Double.POSITIVE_INFINITY && value != 0);
  }
  
  // Hazel Hilbert: creates a string with headers for the important fields of the data points
  private String createHeader(String dataType) {
    StringBuilder stringBuilder = new StringBuilder(padWithSpaces("satcat", 8));
    stringBuilder.append(padWithSpaces("Name", 30));
    stringBuilder.append(padWithSpaces("Launch Date", 16));
    stringBuilder.append(padWithSpaces("Status", 8));
    stringBuilder.append(padWithSpaces("State", 8));
    stringBuilder.append(dataType);
    return stringBuilder.toString();
  }
}
  
interface Predicate<T> {
  boolean test(T object);  
}

// comparator classes for sorting the dataPoints by specified fields
// by Michal Bronicki
final static Comparator<DataPoint> COMPARATOR_SATCAT_ASCENDING = new Comparator<DataPoint>() {
  public int compare(DataPoint dataPoint1, DataPoint dataPoint2) {
    return ((Integer)(dataPoint1.getSatcatInt())).compareTo((Integer)(dataPoint2.getSatcatInt()));
  }
};
final static Comparator<DataPoint> COMPARATOR_SATCAT_DESCENDING = new Comparator<DataPoint>() {
  public int compare(DataPoint dataPoint1, DataPoint dataPoint2) {
    return -((Integer)(dataPoint1.getSatcatInt())).compareTo((Integer)(dataPoint2.getSatcatInt()));
  }
};
final static Comparator<DataPoint> COMPARATOR_NAME_ASCENDING = new Comparator<DataPoint>() {
  public int compare(DataPoint dataPoint1, DataPoint dataPoint2) {
    return (dataPoint1.getName().toLowerCase().compareTo(dataPoint2.getName().toLowerCase()));
  }
};
final static Comparator<DataPoint> COMPARATOR_NAME_DESCENDING = new Comparator<DataPoint>() {
  public int compare(DataPoint dataPoint1, DataPoint dataPoint2) {
    return -(dataPoint1.getName().toLowerCase().compareTo(dataPoint2.getName().toLowerCase()));
  }
};
final Comparator<DataPoint> COMPARATOR_LAUNCHDATE_ASCENDING = new Comparator<DataPoint>() {
  public int compare(DataPoint dataPoint1, DataPoint dataPoint2) {
    // makes sure the missing values are at the bottom of the list when sorted in an ascending order
    Date value1 = dataPoint1.getLaunchDate();
    if(value1.getDay() == 0 && value1.getMonth() == 0 && value1.getYear() == 0)
      value1 = new Date("9999 Dec 31");
    Date value2 = dataPoint2.getLaunchDate();
    if(value2.getDay() == 0 && value2.getMonth() == 0 && value2.getYear() == 0)
      value2 = new Date("9999 Dec 31");
    return (value1.compareTo(value2));
  }
};
final static Comparator<DataPoint> COMPARATOR_LAUNCHDATE_DESCENDING = new Comparator<DataPoint>() {
  public int compare(DataPoint dataPoint1, DataPoint dataPoint2) {
    return -(dataPoint1.getLaunchDate().compareTo(dataPoint2.getLaunchDate()));
  }
};
final static Comparator<DataPoint> COMPARATOR_STATUS_ASCENDING = new Comparator<DataPoint>() {
  public int compare(DataPoint dataPoint1, DataPoint dataPoint2) {
    return (dataPoint1.getStatus().toLowerCase().compareTo(dataPoint2.getStatus().toLowerCase()));
  }
};
final static Comparator<DataPoint> COMPARATOR_STATUS_DESCENDING = new Comparator<DataPoint>() {
  public int compare(DataPoint dataPoint1, DataPoint dataPoint2) {
    return -(dataPoint1.getStatus().toLowerCase().compareTo(dataPoint2.getStatus().toLowerCase()));
  }
};
final static Comparator<DataPoint> COMPARATOR_STATE_ASCENDING = new Comparator<DataPoint>() {
  public int compare(DataPoint dataPoint1, DataPoint dataPoint2) {
    return (dataPoint1.getState().toLowerCase().compareTo(dataPoint2.getState().toLowerCase()));
  }
};
final static Comparator<DataPoint> COMPARATOR_STATE_DESCENDING = new Comparator<DataPoint>() {
  public int compare(DataPoint dataPoint1, DataPoint dataPoint2) {
    return -(dataPoint1.getState().toLowerCase().compareTo(dataPoint2.getState().toLowerCase()));
  }
};
final static Comparator<DataPoint> COMPARATOR_MASS_ASCENDING = new Comparator<DataPoint>() {
  public int compare(DataPoint dataPoint1, DataPoint dataPoint2) {
    return ((Double)(dataPoint1.getMass())).compareTo((Double)(dataPoint2.getMass()));
  }
};
final static Comparator<DataPoint> COMPARATOR_MASS_DESCENDING = new Comparator<DataPoint>() {
  public int compare(DataPoint dataPoint1, DataPoint dataPoint2) {
    // makes sure the NaN values are at the bottom of the list when sorted in a descending order
    Double value1 = dataPoint1.getMass();
    if(Double.isNaN(value1))
      value1 = Double.NEGATIVE_INFINITY;
    Double value2 = dataPoint2.getMass();
    if(Double.isNaN(value2))
      value2 = Double.NEGATIVE_INFINITY;
    return -(value1.compareTo(value2));
  }
};
final static Comparator<DataPoint> COMPARATOR_DIAMETER_ASCENDING = new Comparator<DataPoint>() {
  public int compare(DataPoint dataPoint1, DataPoint dataPoint2) {
    return ((Double)(dataPoint1.getDiameter())).compareTo((Double)(dataPoint2.getDiameter()));
  }
};
final static Comparator<DataPoint> COMPARATOR_DIAMETER_DESCENDING = new Comparator<DataPoint>() {
  public int compare(DataPoint dataPoint1, DataPoint dataPoint2) {
    // makes sure the NaN values are at the bottom of the list when sorted in a descending order
    Double value1 = dataPoint1.getDiameter();
    if(Double.isNaN(value1))
      value1 = Double.NEGATIVE_INFINITY;
    Double value2 = dataPoint2.getDiameter();
    if(Double.isNaN(value2))
      value2 = Double.NEGATIVE_INFINITY;
    return -(value1.compareTo(value2));
  }
};
final static Comparator<DataPoint> COMPARATOR_PERIGEE_ASCENDING = new Comparator<DataPoint>() {
  public int compare(DataPoint dataPoint1, DataPoint dataPoint2) {
    return ((Double)(dataPoint1.getPerigee())).compareTo((Double)(dataPoint2.getPerigee()));
  }
};
final static Comparator<DataPoint> COMPARATOR_PERIGEE_DESCENDING = new Comparator<DataPoint>() {
  public int compare(DataPoint dataPoint1, DataPoint dataPoint2) {
    // makes sure the NaN values are at the bottom of the list when sorted in a descending order
    Double value1 = dataPoint1.getPerigee();
    if(Double.isNaN(value1))
      value1 = Double.NEGATIVE_INFINITY;
    Double value2 = dataPoint2.getPerigee();
    if(Double.isNaN(value2))
      value2 = Double.NEGATIVE_INFINITY;
    return -(value1.compareTo(value2));
  }
};
final static Comparator<DataPoint> COMPARATOR_APOGEE_ASCENDING = new Comparator<DataPoint>() {
  public int compare(DataPoint dataPoint1, DataPoint dataPoint2) {
    return ((Double)(dataPoint1.getApogee())).compareTo((Double)(dataPoint2.getApogee()));
  }
};
final static Comparator<DataPoint> COMPARATOR_APOGEE_DESCENDING = new Comparator<DataPoint>() {
  public int compare(DataPoint dataPoint1, DataPoint dataPoint2) {
    // makes sure the NaN values are at the bottom of the list when sorted in a descending order
    Double value1 = dataPoint1.getApogee();
    if(Double.isNaN(value1))
      value1 = Double.NEGATIVE_INFINITY;
    Double value2 = dataPoint2.getApogee();
    if(Double.isNaN(value2))
      value2 = Double.NEGATIVE_INFINITY;
    return -(value1.compareTo(value2));
  }
};
