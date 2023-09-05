// Michal Bronicki
// data generators generate the necessary values for the charts
import java.util.Map;
import java.util.List;
import java.util.Collections;
import java.util.Comparator;

interface ChartDataGenerator {
  ChartData generate();
}

class FrequencyDataGenerator implements ChartDataGenerator {
  private FieldValueGetter<DataPoint, String> fieldValueGetter;
  
  FrequencyDataGenerator(FieldValueGetter<DataPoint, String> fieldValueGetter) {
    this.fieldValueGetter = fieldValueGetter;
  }
  
  public ChartData generate() {
    Map<String, Integer> countsMap = new HashMap<String, Integer>();
    for(DataPoint dataPoint : provider.getData()) {
      String currentFieldValue = fieldValueGetter.getFieldValue(dataPoint);
      Integer currentCount = countsMap.get(currentFieldValue);
      if(currentCount == null)
        countsMap.put(currentFieldValue, 1);
      else
        countsMap.put(currentFieldValue, currentCount+1);
    }
    List countsMapEntries = new ArrayList<Map.Entry<String, Integer>>(countsMap.entrySet());
    Collections.sort(countsMapEntries, new Comparator<Map.Entry<String, Integer>>() {
      public int compare(Map.Entry<String, Integer> entry1, Map.Entry<String, Integer> entry2) {
        return (-entry1.getValue().compareTo(entry2.getValue()));
      }
    });
    
    ChartData chartData = new ChartData();
    int othersSum = 0;
    for(int i=0; i<countsMapEntries.size(); i++) {
      Map.Entry<String, Integer> currentMapEntry = (Map.Entry<String, Integer>) countsMapEntries.get(i);
      if(i < MAXIMUM_NUMBER_OF_BARS-1 || (i == MAXIMUM_NUMBER_OF_BARS-1 && countsMapEntries.size() == MAXIMUM_NUMBER_OF_BARS)) {
        chartData.labels.add(currentMapEntry.getKey());
        chartData.values.add(Double.valueOf(currentMapEntry.getValue()));
      } else {
        othersSum += currentMapEntry.getValue();  
      }
    }
    if(countsMapEntries.size() > MAXIMUM_NUMBER_OF_BARS) {
      chartData.labels.add("OTH");
      chartData.values.add(Double.valueOf(othersSum));
    }
    return chartData;
  }
  
}

class RangeFrequencyDataGenerator implements ChartDataGenerator {
  private int numberOfRanges;
  private FieldValueGetter<DataPoint, Double> fieldValueGetter;
  
  RangeFrequencyDataGenerator(FieldValueGetter<DataPoint, Double> fieldValueGetter, int numberOfRanges) {
    this.fieldValueGetter = fieldValueGetter;
    this.numberOfRanges = numberOfRanges;
  }
  // generates values for the charts.
  public ChartData generate() {
    double minValue = Double.POSITIVE_INFINITY;
    double maxValue = Double.NEGATIVE_INFINITY;
    int positiveInfinityCount = 0;
    int nanCount = 0;
    for(DataPoint dataPoint : provider.getData()) {
      Double currentFieldValue = fieldValueGetter.getFieldValue(dataPoint);
      if(Double.isNaN(currentFieldValue))
        nanCount++;
      else if(currentFieldValue == Double.POSITIVE_INFINITY)
        positiveInfinityCount++;
      else {
        if(currentFieldValue < minValue)
          minValue = currentFieldValue;
        if(currentFieldValue > maxValue)
          maxValue = currentFieldValue;
      }
    }
    int numberOfAvailableBars = numberOfRanges;
    if(nanCount > 0) 
      numberOfAvailableBars--;
    if(positiveInfinityCount > 0) 
      numberOfAvailableBars--;
    if(minValue == maxValue && numberOfAvailableBars > 1)
      numberOfAvailableBars = 1; 
    int[] counts = new int[numberOfAvailableBars];
    double singleBarRange = (maxValue - minValue)/numberOfAvailableBars;
    for(DataPoint dataPoint : provider.getData()) {
      Double currentFieldValue = fieldValueGetter.getFieldValue(dataPoint);
      if(currentFieldValue == maxValue) {
        counts[counts.length-1]++;  
      } else {
        for(int barIndex=0; barIndex<numberOfAvailableBars; barIndex++) {
          if(currentFieldValue >= (minValue + barIndex*singleBarRange) && currentFieldValue < (minValue + (barIndex+1)*singleBarRange)) {
            counts[barIndex]++;
            break;
          }
        }
      }
    }
    ChartData chartData = new ChartData();
    for(int barIndex=0; barIndex<numberOfAvailableBars; barIndex++) {
      String minValueLabel = String.valueOf(ceil((float)(minValue + barIndex*singleBarRange)));
      String maxValueLabel = String.valueOf(floor((float)(minValue + (barIndex+1)*singleBarRange)));
      chartData.labels.add("["+minValueLabel + ", " + maxValueLabel+"]");
      chartData.values.add(Double.valueOf(counts[barIndex]));
    }
    if(positiveInfinityCount > 0) {
      chartData.labels.add("Infinity");
      chartData.values.add(Double.valueOf(positiveInfinityCount));
    }
    if(nanCount > 0) {
      chartData.labels.add("No data");
      chartData.values.add(Double.valueOf(nanCount));
    }
    return chartData;
  }
}

class AverageValueTimePlotDataGenerator implements ChartDataGenerator {
  private FieldValueGetter<DataPoint, Double> fieldValueGetter;
  
  AverageValueTimePlotDataGenerator(FieldValueGetter<DataPoint, Double> fieldValueGetter) {
    this.fieldValueGetter = fieldValueGetter;
  }

  public ChartData generate() {
    int minYear = provider.getEarliestYear();
    int maxYear = provider.getLatestYear();
    ArrayList<Double> sums = new ArrayList<Double>();
    ArrayList<Integer> counts = new ArrayList<Integer>();
    for(int year=minYear; year<=maxYear; year++) {  
      sums.add(Double.valueOf(0));
      counts.add(0);
    }

    for(DataPoint dataPoint : provider.getData()) {
      if(dataPoint.getLaunchDate().getYear() > 0) {
        int yearIndex = dataPoint.getLaunchDate().getYear() - minYear;
        double value = Math.abs(fieldValueGetter.getFieldValue(dataPoint));
        if(!Double.isNaN(value) && value != Double.NEGATIVE_INFINITY && value != Double.POSITIVE_INFINITY) {
          sums.set(yearIndex, sums.get(yearIndex)+(float)value);
          counts.set(yearIndex, counts.get(yearIndex)+1);
        }
      }
    }

    ChartData chartData = new ChartData();
    for(int year=minYear; year<=maxYear; year++) {
      if(year == minYear)
        chartData.labels.add(String.valueOf(minYear));
      else if(year == maxYear)
        chartData.labels.add(String.valueOf(maxYear));
      else
        chartData.labels.add("");
      chartData.values.add(sums.get(year-minYear) / counts.get(year-minYear));
    }
    return chartData;
  }
}

interface FieldValueGetter<T, U> {
  U getFieldValue(T object);  
}

class ChartData {
  public ArrayList<String> labels;
  public ArrayList<Double> values;
  
  public ChartData() {
    labels = new ArrayList<String>();
    values = new ArrayList<Double>();
  }
}
