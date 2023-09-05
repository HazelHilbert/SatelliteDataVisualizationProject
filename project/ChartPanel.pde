
// Michal Bronicki and Mark Doyle

final int CHART_HEIGHT = 450;
final int CHARTMENU_HEIGHT = 105;
final int CHARTMENU_BUTTON_WIDTH = 100;
final int CHARTMENU_BUTTON_HEIGHT = 40;
final int CHARTMENU_BUTTON_SPACING = 10;

static final String TYPE_DROPDOWN_LABEL_FREQUENCY = "Frequency of";
static final String TYPE_DROPDOWN_LABEL_RANGE_FREQUENCY = "Range freq. of";
static final String TYPE_DROPDOWN_LABEL_TIMEPLOT = "Timeplot of";
static final String TYPE_DROPDOWN_LABEL_3DORBIT = "3D Orbit";
static final String TYPE_DROPDOWN_LABEL_HEATMAP = "Heatmap";
static final String FIELD_DROPDOWN_LABEL_STATE = "State";
static final String FIELD_DROPDOWN_LABEL_STATUS = "Status";
static final String FIELD_DROPDOWN_LABEL_MASS = "Mass";
static final String FIELD_DROPDOWN_LABEL_DIAMETER = "Diameter";
static final String FIELD_DROPDOWN_LABEL_PERIGEE = "Perigee";
static final String FIELD_DROPDOWN_LABEL_APOGEE = "Apogee";
static final String FIELD_DROPDOWN_LABEL_AVERAGE_MASS = "Avg. Mass";
static final String FIELD_DROPDOWN_LABEL_AVERAGE_DIAMETER = "Avg. Diameter";
static final String FIELD_DROPDOWN_LABEL_AVERAGE_PERIGEE = "Avg. Perigee";
static final String FIELD_DROPDOWN_LABEL_AVERAGE_APOGEE = "Avg. Apogee";
static final String STYLE_DROPDOWN_LABEL_BARCHART = "Bar chart";
static final String STYLE_DROPDOWN_LABEL_PIECHART = "Pie chart";
static final String STYLE_DROPDOWN_LABEL_LINECHART = "Line chart";

final class ChartPanel extends RectangleWidget {
  private int mainButtonsWidth = (width-2*CHARTMENU_BUTTON_SPACING)/3;
  private ClickableRectangleWidget objectDetailsButton;
  private ClickableRectangleWidget statisticsButton;
  private ClickableRectangleWidget graphsButton;
  private DropDownList graphTypeDropdown;
  private DropDownList fieldDropdown;
  private DropDownList chartStyleDropdown;
  private DataGeneratorHolder chartDataGeneratorHolder;
  private Widget currentChart;
  private Orbit orbitChart;
  private Statistics statisticsChart;
  private DataDependentWidget graphChart;
  private CheckboxWidget orbit3DRotationCheckbox;
  private final ChartPanel finalThis = this;

  public ChartPanel(int xPosition, int yPosition, int width, int height) {
    super(new RectangleWidgetBuilder()
              .leftCornerPosition(xPosition, yPosition)
              .size(width, height)
              .primaryColor(BACKGROUND_CLR)
    );
    chartDataGeneratorHolder = new DataGeneratorHolder();
    setupDefaultGraphChart();
    orbitChart = new Orbit(xPosition, yPosition+60, width, CHART_HEIGHT+70, 15, CHART_BACKGROUND_CLR, provider.getData().get(0));
    statisticsChart = new Statistics(xPosition, yPosition+height-CHART_HEIGHT, width, CHART_HEIGHT, 15, BACKGROUND_CLR); 
    currentChart = orbitChart;
    ClickableRectangleWidgetBuilder buttonBuilder;
    buttonBuilder = new ClickableRectangleWidgetBuilder()
                        .size(mainButtonsWidth, CHARTMENU_BUTTON_HEIGHT)
                        .cornersRadii(15)
                        .primaryColor(BUTTON_CLR)
                        .hoverColor(BUTTON_HOVER_CLR)
                        .labelTextColor(DARK_TEXT_CLR);
    objectDetailsButton = buttonBuilder
                        .leftCornerPosition(xPosition, yPosition)
                        .labelText("Object details")
                        .build();
    statisticsButton = buttonBuilder
                        .leftCornerPosition(xPosition+mainButtonsWidth+CHARTMENU_BUTTON_SPACING, yPosition)
                        .labelText("Statistics")
                        .build();
    graphsButton = buttonBuilder
                        .leftCornerPosition(xPosition+2*(mainButtonsWidth+CHARTMENU_BUTTON_SPACING), yPosition)
                        .labelText("Graphs")
                        .build();
    orbit3DRotationCheckbox = new CheckboxWidget(xPosition+mainButtonsWidth+CHARTMENU_BUTTON_SPACING, yPosition+CHARTMENU_BUTTON_HEIGHT+CHARTMENU_BUTTON_SPACING, 240, CHARTMENU_BUTTON_HEIGHT, 15, BUTTON_CLR, DARK_TEXT_CLR, "Rotate automatically");
    orbit3DRotationCheckbox.setChecked(true);
    orbit3DRotationCheckbox.hide();
    objectDetailsButton.setOnClickCallback(new Callback() { void call() {
      hideGraphsSubmenu();
      orbit3DRotationCheckbox.hide();
      currentChart.hide();
      currentChart = orbitChart;
      currentChart.display();
    }});
    statisticsButton.setOnClickCallback(new Callback() { void call() {
      hideGraphsSubmenu();
      orbit3DRotationCheckbox.hide();
      currentChart.hide();
      currentChart = statisticsChart;
      currentChart.display();

    }});
    graphsButton.setOnClickCallback(new Callback() { void call() {
      setupGraphsSubmenu();
      orbit3DRotationCheckbox.hide();
      currentChart.hide();
      setupDefaultGraphChart();
      currentChart = graphChart;
      currentChart.display();
    }});

    setupGraphsSubmenu();
    hideGraphsSubmenu();
  }

  private void setupDefaultGraphChart() {
    chartDataGeneratorHolder.setCurrentGenerator(new FrequencyDataGenerator(new FieldValueGetter<DataPoint, String>() { public String getFieldValue(DataPoint dataPoint) { return dataPoint.getState(); }}));
    graphChart = new BarChart(xPosition, yPosition+height-CHART_HEIGHT, width, CHART_HEIGHT, 15, CHART_BACKGROUND_CLR, chartDataGeneratorHolder); 
  }

  private void setupGraphsSubmenu() {
    String[] graphTypes = new String[] { TYPE_DROPDOWN_LABEL_FREQUENCY, TYPE_DROPDOWN_LABEL_RANGE_FREQUENCY, TYPE_DROPDOWN_LABEL_TIMEPLOT, TYPE_DROPDOWN_LABEL_3DORBIT, TYPE_DROPDOWN_LABEL_HEATMAP };
    graphTypeDropdown = new DropDownList(xPosition, yPosition+CHARTMENU_BUTTON_HEIGHT+CHARTMENU_BUTTON_SPACING, mainButtonsWidth, 40, BUTTON_CLR, DARK_TEXT_CLR, BUTTON_HOVER_CLR, graphTypes);
    String[] fieldTypes = new String[] { FIELD_DROPDOWN_LABEL_STATE, FIELD_DROPDOWN_LABEL_STATUS };
    setFieldDropdown(fieldTypes);
    String[] chartStyles = new String[] { STYLE_DROPDOWN_LABEL_BARCHART, STYLE_DROPDOWN_LABEL_PIECHART };
    setChartStyleDropdown(chartStyles);

    graphTypeDropdown.setOnChangeCallback(new Callback() { public void call() {
      orbit3DRotationCheckbox.hide();
      String currentGraphTypeSelection = graphTypeDropdown.getCurrentSelectionValue();
      if(currentGraphTypeSelection.equals(TYPE_DROPDOWN_LABEL_FREQUENCY)) {
        String[] fieldTypes = new String[] { FIELD_DROPDOWN_LABEL_STATE, FIELD_DROPDOWN_LABEL_STATUS };
        setFieldDropdown(fieldTypes);
        String[] chartStyles = new String[] { STYLE_DROPDOWN_LABEL_BARCHART, STYLE_DROPDOWN_LABEL_PIECHART };
        setChartStyleDropdown(chartStyles);
        chartDataGeneratorHolder.setCurrentGenerator(new FrequencyDataGenerator(new FieldValueGetter<DataPoint, String>() { public String getFieldValue(DataPoint dataPoint) { return dataPoint.getState(); }}));
        setGraphChart(new BarChart(xPosition, yPosition+height-CHART_HEIGHT, width, CHART_HEIGHT, 15, CHART_BACKGROUND_CLR, chartDataGeneratorHolder));
      } else if(currentGraphTypeSelection.equals(TYPE_DROPDOWN_LABEL_RANGE_FREQUENCY)) {
        String[] fieldTypes = new String[] { FIELD_DROPDOWN_LABEL_MASS, FIELD_DROPDOWN_LABEL_DIAMETER, FIELD_DROPDOWN_LABEL_PERIGEE, FIELD_DROPDOWN_LABEL_APOGEE };
        setFieldDropdown(fieldTypes);
        String[] chartStyles = new String[] { STYLE_DROPDOWN_LABEL_PIECHART };
        setChartStyleDropdown(chartStyles);
        chartStyleDropdown.hide();
        chartDataGeneratorHolder.setCurrentGenerator(new RangeFrequencyDataGenerator((new FieldValueGetter<DataPoint, Double>() { public Double getFieldValue(DataPoint dataPoint) { return dataPoint.getMass(); }}), 6));
        setGraphChart(new PieChart(xPosition, yPosition+height-CHART_HEIGHT, width, CHART_HEIGHT, 15, CHART_BACKGROUND_CLR, chartDataGeneratorHolder, true));
      } else if(currentGraphTypeSelection.equals(TYPE_DROPDOWN_LABEL_TIMEPLOT)) {
        String[] fieldTypes = new String[] { FIELD_DROPDOWN_LABEL_AVERAGE_MASS, FIELD_DROPDOWN_LABEL_AVERAGE_DIAMETER, FIELD_DROPDOWN_LABEL_AVERAGE_PERIGEE, FIELD_DROPDOWN_LABEL_AVERAGE_APOGEE };
        setFieldDropdown(fieldTypes);
        String[] chartStyles = new String[] { STYLE_DROPDOWN_LABEL_LINECHART };
        setChartStyleDropdown(chartStyles);
        chartStyleDropdown.hide();
        chartDataGeneratorHolder.setCurrentGenerator(new AverageValueTimePlotDataGenerator((new FieldValueGetter<DataPoint, Double>() { public Double getFieldValue(DataPoint dataPoint) { return dataPoint.getMass(); }})));
        setGraphChart(new LineChart(xPosition, yPosition+height-CHART_HEIGHT, width, CHART_HEIGHT, 15, CHART_BACKGROUND_CLR, chartDataGeneratorHolder));
      } else if(currentGraphTypeSelection.equals(TYPE_DROPDOWN_LABEL_3DORBIT)) {
        fieldDropdown.hide();
        chartStyleDropdown.hide();
        final Orbit3D orbit3DChart = new Orbit3D(xPosition, yPosition+height-CHART_HEIGHT, width, CHART_HEIGHT, DARK_TEXT_CLR, BACKGROUND_CLR);
        setGraphChart(orbit3DChart);
        orbit3DRotationCheckbox.setOnChangeCallback(new Callback() { public void call() {
          orbit3DChart.setAutomaticRotation(orbit3DRotationCheckbox.isChecked());
        }});
        orbit3DRotationCheckbox.setChecked(true);
        orbit3DRotationCheckbox.display();
      } else if(currentGraphTypeSelection.equals(TYPE_DROPDOWN_LABEL_HEATMAP)) {
        fieldDropdown.hide();
        chartStyleDropdown.hide();
        setGraphChart(new Heatmap(xPosition, yPosition+height-CHART_HEIGHT, width, CHART_HEIGHT, DARK_TEXT_CLR, BACKGROUND_CLR));
      }
    }});
    
    fieldDropdown.setOnChangeCallback(createFieldDropdownCallback()); 
    chartStyleDropdown.setOnChangeCallback(createChartStyleDropdownCallback());
  }

  private void setFieldDropdown(String[] items) {
    if(fieldDropdown != null)
      fieldDropdown.hide();
    fieldDropdown = new DropDownList(xPosition+mainButtonsWidth+CHARTMENU_BUTTON_SPACING, yPosition+CHARTMENU_BUTTON_HEIGHT+CHARTMENU_BUTTON_SPACING, mainButtonsWidth, 40, BUTTON_CLR, DARK_TEXT_CLR, BUTTON_HOVER_CLR, items);
    fieldDropdown.setOnChangeCallback(createFieldDropdownCallback());
    fieldDropdown.display();
  }

  private void setChartStyleDropdown(String[] items) {
    if(chartStyleDropdown != null)
      chartStyleDropdown.hide();
    chartStyleDropdown = new DropDownList(xPosition+2*(mainButtonsWidth+CHARTMENU_BUTTON_SPACING), yPosition+CHARTMENU_BUTTON_HEIGHT+CHARTMENU_BUTTON_SPACING, mainButtonsWidth, 40, BUTTON_CLR, DARK_TEXT_CLR, BUTTON_HOVER_CLR, items);
    chartStyleDropdown.setOnChangeCallback(createChartStyleDropdownCallback());
    chartStyleDropdown.display();
  }

  private Callback createFieldDropdownCallback() {
    return new Callback() { public void call() {
      String currentGraphTypeSelection = graphTypeDropdown.getCurrentSelectionValue();
      String currentFieldSelection = fieldDropdown.getCurrentSelectionValue();
      String currentChartStyleSelection = chartStyleDropdown.getCurrentSelectionValue();
      if(currentGraphTypeSelection.equals(TYPE_DROPDOWN_LABEL_FREQUENCY)) {
        if(currentFieldSelection.equals(FIELD_DROPDOWN_LABEL_STATE)) {
          if(currentChartStyleSelection.equals(STYLE_DROPDOWN_LABEL_BARCHART))
            chartDataGeneratorHolder.setCurrentGenerator(new FrequencyDataGenerator(new FieldValueGetter<DataPoint, String>() { public String getFieldValue(DataPoint dataPoint) { return dataPoint.getState(); }}));
          else
            chartDataGeneratorHolder.setCurrentGenerator(new FrequencyDataGenerator(new FieldValueGetter<DataPoint, String>() { public String getFieldValue(DataPoint dataPoint) { return dataPoint.getShortStateValue(); }}));
        } else if(currentFieldSelection.equals(FIELD_DROPDOWN_LABEL_STATUS)) {
          chartDataGeneratorHolder.setCurrentGenerator(new FrequencyDataGenerator(new FieldValueGetter<DataPoint, String>() { public String getFieldValue(DataPoint dataPoint) { return dataPoint.getStatus(); }})); 
        }
      } else if(currentGraphTypeSelection.equals(TYPE_DROPDOWN_LABEL_RANGE_FREQUENCY)) {
        if(currentFieldSelection.equals(FIELD_DROPDOWN_LABEL_MASS)) {
          chartDataGeneratorHolder.setCurrentGenerator(new RangeFrequencyDataGenerator((new FieldValueGetter<DataPoint, Double>() { public Double getFieldValue(DataPoint dataPoint) { return dataPoint.getMass(); }}), 6));
        } else if(currentFieldSelection.equals(FIELD_DROPDOWN_LABEL_DIAMETER)) {
          chartDataGeneratorHolder.setCurrentGenerator(new RangeFrequencyDataGenerator((new FieldValueGetter<DataPoint, Double>() { public Double getFieldValue(DataPoint dataPoint) { return dataPoint.getDiameter(); }}), 6));
        } else if(currentFieldSelection.equals(FIELD_DROPDOWN_LABEL_PERIGEE)) {
          chartDataGeneratorHolder.setCurrentGenerator(new RangeFrequencyDataGenerator((new FieldValueGetter<DataPoint, Double>() { public Double getFieldValue(DataPoint dataPoint) { return dataPoint.getPerigee(); }}), 6));
        } else if(currentFieldSelection.equals(FIELD_DROPDOWN_LABEL_APOGEE)) {
          chartDataGeneratorHolder.setCurrentGenerator(new RangeFrequencyDataGenerator((new FieldValueGetter<DataPoint, Double>() { public Double getFieldValue(DataPoint dataPoint) { return dataPoint.getApogee(); }}), 4));
        }
      } else if(currentGraphTypeSelection.equals(TYPE_DROPDOWN_LABEL_TIMEPLOT)) {
        if(currentFieldSelection.equals(FIELD_DROPDOWN_LABEL_AVERAGE_MASS)) {
          chartDataGeneratorHolder.setCurrentGenerator(new AverageValueTimePlotDataGenerator((new FieldValueGetter<DataPoint, Double>() { public Double getFieldValue(DataPoint dataPoint) { return dataPoint.getMass(); }})));
        } else if(currentFieldSelection.equals(FIELD_DROPDOWN_LABEL_AVERAGE_DIAMETER)) {
          chartDataGeneratorHolder.setCurrentGenerator(new AverageValueTimePlotDataGenerator((new FieldValueGetter<DataPoint, Double>() { public Double getFieldValue(DataPoint dataPoint) { return dataPoint.getDiameter(); }})));
        } else if(currentFieldSelection.equals(FIELD_DROPDOWN_LABEL_AVERAGE_PERIGEE)) {
          chartDataGeneratorHolder.setCurrentGenerator(new AverageValueTimePlotDataGenerator((new FieldValueGetter<DataPoint, Double>() { public Double getFieldValue(DataPoint dataPoint) { return dataPoint.getPerigee(); }})));
        } else if(currentFieldSelection.equals(FIELD_DROPDOWN_LABEL_AVERAGE_APOGEE)) {
          chartDataGeneratorHolder.setCurrentGenerator(new AverageValueTimePlotDataGenerator((new FieldValueGetter<DataPoint, Double>() { public Double getFieldValue(DataPoint dataPoint) { return dataPoint.getApogee(); }})));
        }
      }
      graphChart.update();
    }};
  }

  private Callback createChartStyleDropdownCallback() {
    return new Callback() { public void call() {
      String currentGraphTypeSelection = graphTypeDropdown.getCurrentSelectionValue();
      String currentFieldSelection = fieldDropdown.getCurrentSelectionValue();
      String currentChartStyleSelection = chartStyleDropdown.getCurrentSelectionValue();
      if(currentChartStyleSelection.equals(STYLE_DROPDOWN_LABEL_BARCHART)) {
        // sets shorter labels in case of state frequency barchart
        if(currentGraphTypeSelection.equals(TYPE_DROPDOWN_LABEL_FREQUENCY) && currentFieldSelection.equals(FIELD_DROPDOWN_LABEL_STATE))
          chartDataGeneratorHolder.setCurrentGenerator(new FrequencyDataGenerator(new FieldValueGetter<DataPoint, String>() { public String getFieldValue(DataPoint dataPoint) { return dataPoint.getState(); }}));
        setGraphChart(new BarChart(xPosition, yPosition+height-CHART_HEIGHT, width, CHART_HEIGHT, 15, CHART_BACKGROUND_CLR, chartDataGeneratorHolder));
      } else if(currentChartStyleSelection.equals(STYLE_DROPDOWN_LABEL_PIECHART)) {
        // sets longer labels in case of state frequency piechart
        if(currentGraphTypeSelection.equals(TYPE_DROPDOWN_LABEL_FREQUENCY) && currentFieldSelection.equals(FIELD_DROPDOWN_LABEL_STATE))
          chartDataGeneratorHolder.setCurrentGenerator(new FrequencyDataGenerator(new FieldValueGetter<DataPoint, String>() { public String getFieldValue(DataPoint dataPoint) { return dataPoint.getShortStateValue(); }}));
        setGraphChart(new PieChart(xPosition, yPosition+height-CHART_HEIGHT, width, CHART_HEIGHT, 15, CHART_BACKGROUND_CLR, chartDataGeneratorHolder, false));
      } else if(currentChartStyleSelection.equals(STYLE_DROPDOWN_LABEL_LINECHART)) {
        setGraphChart(new LineChart(xPosition, yPosition+height-CHART_HEIGHT, width, CHART_HEIGHT, 15, CHART_BACKGROUND_CLR, chartDataGeneratorHolder));
      }
    }};
  }

  private void setGraphChart(DataDependentWidget newGraphChart) {
    currentChart.hide();
    graphChart = newGraphChart;
    currentChart = graphChart;
    currentChart.display();
  }

  public String getCurrentGraphChartSelection() {
    if(currentChart != graphChart) return "";
    return graphTypeDropdown.getCurrentSelectionValue();
  }

  @Override
  public void draw() {
    if(isVisible) {
      super.draw();
      objectDetailsButton.draw();
      statisticsButton.draw();
      graphsButton.draw();
      currentChart.draw();
      graphTypeDropdown.draw();
      fieldDropdown.draw();
      orbit3DRotationCheckbox.draw();
      chartStyleDropdown.draw();
    }
  }
  @Override
  public void display() {
    if(!isVisible) {
      objectDetailsButton.display();
      statisticsButton.display();
      graphsButton.display();
      displayGraphsSubmenu();
      orbit3DRotationCheckbox.display();
      currentChart.display();
      isVisible = true;
    }
  }
  @Override
  public void hide() {
    if(isVisible) {
      objectDetailsButton.hide();
      statisticsButton.hide();
      graphsButton.hide();
      hideGraphsSubmenu();
      orbit3DRotationCheckbox.hide();
      currentChart.hide();
      isVisible = false;
    }
  }

  private void displayGraphsSubmenu() {
    graphTypeDropdown.display();
    fieldDropdown.display();
    chartStyleDropdown.display();
  }
  private void hideGraphsSubmenu() {
    graphTypeDropdown.hide();
    fieldDropdown.hide();
    chartStyleDropdown.hide();
  }

  public void setCurrentDataPoint(DataPoint newDataPoint) {
    if (newDataPoint != null) { 
      orbitChart.setDataPoint(newDataPoint);
      hideGraphsSubmenu();
      currentChart.hide();
      currentChart = orbitChart;
      currentChart.display();
    }
  }
}

class DataGeneratorHolder {
  private ChartDataGenerator currentDataGenerator;
  public ChartDataGenerator getCurrentGenerator() {
    return currentDataGenerator;  
  }
  public void setCurrentGenerator(ChartDataGenerator generator) {
    currentDataGenerator = generator;  
  }
}
