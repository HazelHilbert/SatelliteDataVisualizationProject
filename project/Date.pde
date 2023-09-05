
// Hazel Hilbert: Date class to represent dates in the form of strings as objects

final String[] months = {"", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};

class Date {
  private String[] date;
  private int year;
  private int month;
  private int day;  
  
  // the constructor for the Date class takes a String date, converts it to an array of strings and splits it into int values day, month, and year
  public Date(String d){
    date = split(d, " ");
    if (date.length == 1) {
      year = 0; 
      month = 0; 
      day = 0;
    }
    else{
      year = Integer.valueOf(date[0].replaceAll("[^0-9]", ""));
      String monthName = date[1];
      for (int i = 0; i < months.length; i++)
        if (months[i].equals(monthName)) month = i;
      if (date[2].equals("")) day = Integer.valueOf(date[3].replaceAll("[^0-9]", ""));
      else day = Integer.valueOf(date[2].replaceAll("[^0-9]", ""));
    }
  }
  
  public int getDay(){
    return day;
  }
  public int getMonth(){
    return month;
  }
  public String getMonthName(){
    return months[month];
  }
  public int getYear(){
    return year;
  }
  
  // returns string representation of a Date
  public String dateToString(){
    if(year == 0 && month == 0 && day == 0) return "-";
    return (day + "/" + month + "/" + year);
  }
  
  // returns true if a date is earlier than a passed date, false if latter
  public boolean isEarlierThan(Date d){
    if (d.getYear() > year) return true;
    else if (d.getYear() == year){
      if (d.getMonth() > month) return true;
      else if (d.getMonth() == month){
        if (d.getDay() >= day) return true;
      }
    }
    return false;
  }
  
  public boolean isEqual(Date d){
   return (d.getYear() == year && d.getMonth() == month && d.getDay() == day);
  }
  
  public int compareTo(Date d){
    if (this.isEqual(d)) return 0;
    if (this.isEarlierThan(d)) return -1;
    else return 1;
  }
}
