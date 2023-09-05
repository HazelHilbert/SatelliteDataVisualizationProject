// Michal Bronicki
// displays a dynamic heatmap based on the current filtered data
class Heatmap extends RectangleWidget implements DataDependentWidget {
  private PShape shape;
  private Map<String, Integer> countsMap;
  private int currentMaxCount;
  private float logCurrentMaxCount;

  Heatmap(int xPosition, int yPosition, int width, int height, int radii, color backgroundColor){
    super(new RectangleWidgetBuilder()
                .leftCornerPosition(xPosition, yPosition)
                .size(width, height)
                .cornersRadii(radii)
                .primaryColor(backgroundColor)
                .borderColor(backgroundColor));
    countsMap = new HashMap<String, Integer>();
    currentMaxCount = 0;
    logCurrentMaxCount = 0;
    shape = loadShape("world.svg");
    eventManager.registerDataDependentWidget(this);
    update();
  }

  @Override
  public void draw() {
    super.draw();
    float scale = width/shape.width;
    for(String state : HEATMAP_AVAILABLE_STATES) {
      Integer currentCount = countsMap.get(state);
      if(currentCount == null) currentCount = 0;
      float logCurrentCount = log(currentCount+1);
      
      color fillColor = color(255, 145+110*(1-((float)logCurrentCount/logCurrentMaxCount)), 20+235*(1-((float)logCurrentCount/logCurrentMaxCount)));

      if(currentMaxCount == 0) fillColor = color(255);
      shape.setFill(fillColor);
      shape(shape.getChild(state), xPosition, yPosition + 0.5*(height-shape.height*scale), shape.getChild(state).width * scale, shape.getChild(state).height * scale);
    }
  }

  @Override
  public void update() {
    currentMaxCount = 0;
    logCurrentMaxCount = 0;
    countsMap.clear();
    for(DataPoint dataPoint : provider.getData()) {
      String state = dataPoint.getState();
      if(state.equals("SU")) state = "RU";
      else if(state.equals("F")) state = "FR";
      else if(state.equals("J")) state = "JP";
      else if(state.equals("UK")) state = "GB";
      else if(state.equals("I")) state = "IT";
      else if(state.equals("UAE")) state = "AE";
      else if(state.equals("E")) state = "ES";
      else if(state.equals("L")) state = "LU";
      else if(state.equals("D")) state = "DE";
      else if(state.equals("T")) state = "TH";
      else if(state.equals("CYM")) state = "CU";
      else if(state.equals("N")) state = "NO";
      else if(state.equals("S")) state = "SE";
      else if(state.equals("HKUK")) state = "HK";
      else if(state.equals("CSSR")) state = "CZ";
      else if(state.equals("CSFR")) state = "CZ";
      else if(state.equals("P")) state = "PT";
      else if(state.equals("B")) state = "BE";
      else if(state.equals("BGN")) state = "BG";
      
      Integer currentCount = countsMap.get(state);
      if(currentCount == null)
          countsMap.put(state, 1);
      else
          countsMap.put(state, currentCount+1);
    }
    for(Map.Entry<String, Integer> entry : countsMap.entrySet()) {
      if(entry.getValue() > currentMaxCount) {
        for(String state : HEATMAP_AVAILABLE_STATES) {
          if(state.equals(entry.getKey())) {
            currentMaxCount = entry.getValue();
            break;
          }
        }
      }
    }
    logCurrentMaxCount = log(currentMaxCount+1);
  }

  @Override
  public void display() {
    if(!isVisible) {
      eventManager.registerDataDependentWidget(this);
      isVisible = true;
    }
  }
  @Override
  public void hide() {
    if(isVisible) {
      eventManager.removeDataDependentWidget(this);
      isVisible = false;
    }
  }
}

final static String[] HEATMAP_AVAILABLE_STATES = new String[] {"AD", "AE", "AF", "AG", "AI", "AL", "AM", "AO", "AR", "AS", "AT", "AU", "AW", "AX", "AZ", "BA", "BB", "BD", "BE", "BF", "BG", "BH", "BI", "BJ", "BL", "BN", "BO", "BM", "BQ", "BR", "BS", "BT", "BV", "BW", "BY", "BZ", "CA", "CC", "CD", "CF", "CG", "CH", "CI", "CK", "CL", "CM", "CN", "CO", "CR", "CU", "CV", "CW", "CX", "CY", "CZ", "DE", "DJ", "DK", "DM", "DO", "DZ", "EC", "EG", "EE", "EH", "ER", "ES", "ET", "FI", "FJ", "FK", "FM", "FO", "FR", "GA", "GB", "GE", "GD", "GF", "GG", "GH", "GI", "GL", "GM", "GN", "GO", "GP", "GQ", "GR", "GS", "GT", "GU", "GW", "GY", "HK", "HM", "HN", "HR", "HT", "HU", "ID", "IE", "IL", "IM", "IN", "IO", "IQ", "IR", "IS", "IT", "JE", "JM", "JO", "JP", "JU", "KE", "KG", "KH", "KI", "KM", "KN", "KP", "KR", "XK", "KW", "KY", "KZ", "LA", "LB", "LC", "LI", "LK", "LR", "LS", "LT", "LU", "LV", "LY", "MA", "MC", "MD", "MG", "ME", "MF", "MH", "MK", "ML", "MO", "MM", "MN", "MP", "MQ", "MR", "MS", "MT", "MU", "MV", "MW", "MX", "MY", "MZ", "NA", "NC", "NE", "NF", "NG", "NI", "NL", "NO", "NP", "NR", "NU", "NZ", "OM", "PA", "PE", "PF", "PG", "PH", "PK", "PL", "PM", "PN", "PR", "PS", "PT", "PW", "PY", "QA", "RE", "RO", "RS", "RU", "RW", "SA", "SB", "SC", "SD", "SE", "SG", "SH", "SI", "SJ", "SK", "SL", "SM", "SN", "SO", "SR", "SS", "ST", "SV", "SX", "SY", "SZ", "TC", "TD", "TF", "TG", "TH", "TJ", "TK", "TL", "TM", "TN", "TO", "TR", "TT", "TV", "TW", "TZ", "UA", "UG", "UM-DQ", "UM-FQ", "UM-HQ", "UM-JQ", "UM-MQ", "UM-WQ", "US", "UY", "UZ", "VA", "VC", "VE", "VG", "VI", "VN", "VU", "WF", "WS", "YE", "YT", "ZA", "ZM", "ZW", "ZW"};
