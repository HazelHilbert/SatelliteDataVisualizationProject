// Michal Bronicki

class EventManager {
  private ArrayList<ClickableWidget> clickableWidgets;
  private ArrayList<DraggableWidget> draggableWidgets;
  private ArrayList<ScrollableWidget> scrollableWidgets;
  private ArrayList<TypableWidget> typableWidgets;
  private ArrayList<DataDependentWidget> dataDependentWidgets;
  
  private Widget focusedWidget;
  
  EventManager() {
    clickableWidgets = new ArrayList<ClickableWidget>();
    draggableWidgets = new ArrayList<DraggableWidget>();
    scrollableWidgets = new ArrayList<ScrollableWidget>();
    typableWidgets = new ArrayList<TypableWidget>();
    dataDependentWidgets = new ArrayList<DataDependentWidget>();
    focusedWidget = null;
  }
  
  public void registerClickableWidget(ClickableWidget clickableWidget) {
    clickableWidgets.add(clickableWidget);  
  }
  public void registerDraggableWidget(DraggableWidget draggableWidget) {
    draggableWidgets.add(draggableWidget);  
  }
  public void registerScrollableWidget(ScrollableWidget scrollableWidget) {
    scrollableWidgets.add(scrollableWidget);
  }
  public void registerTypableWidget(TypableWidget typableWidget) {
    typableWidgets.add(typableWidget);  
  }
  public void registerDataDependentWidget(DataDependentWidget dataDependentWidget) {
    dataDependentWidgets.add(dataDependentWidget);  
  }
  
  public void removeClickableWidget(ClickableWidget clickableWidgetToBeRemoved) {
    for(int i=0; i<clickableWidgets.size(); i++) {
      if(clickableWidgets.get(i) == clickableWidgetToBeRemoved) {
        clickableWidgets.remove(i);
        break;
      }
    }
  }
  public void removeDraggableWidget(DraggableWidget draggableWidgetToBeRemoved) {
    for(int i=0; i<draggableWidgets.size(); i++) {
      if(draggableWidgets.get(i) == draggableWidgetToBeRemoved) {
        draggableWidgets.remove(i);
        break;
      }
    }
  }
  public void removeScrollableWidget(ScrollableWidget scrollableWidgetToBeRemoved) {
    for(int i=0; i<scrollableWidgets.size(); i++) {
      if(scrollableWidgets.get(i) == scrollableWidgetToBeRemoved) {
        scrollableWidgets.remove(i);
        break;
      }
    }
  }
  public void removeTypableWidget(TypableWidget typableWidgetToBeRemoved) {
    for(int i=0; i<typableWidgets.size(); i++) {
      if(typableWidgets.get(i) == typableWidgetToBeRemoved) {
        typableWidgets.remove(i);
        break;
      }
    }
  }
  public void removeDataDependentWidget(DataDependentWidget dataDependentWidgetToBeRemoved) {
    for(int i=0; i<dataDependentWidgets.size(); i++) {
      if(dataDependentWidgets.get(i) == dataDependentWidgetToBeRemoved) {
        dataDependentWidgets.remove(i);
        break;
      }
    }
  }
  
  public void invokeMouseClicked() {
    for(int i=0; i<clickableWidgets.size(); i++) {
      if(clickableWidgets.get(i).isHovered())
        clickableWidgets.get(i).invokeOnClickCallback();
    }
  }
  public void invokeMousePressed() {
    for(DraggableWidget draggableWidget : draggableWidgets) {
      if(draggableWidget.isHovered())
        draggableWidget.startDragging();
    }
  }
  public void invokeMouseDragged() {
    for(DraggableWidget draggableWidget : draggableWidgets) {
      if(draggableWidget.isBeingDragged())
        draggableWidget.updatePosition();
    }
  }
  public void invokeMouseReleased() {
    for(DraggableWidget draggableWidget : draggableWidgets) {
      if(draggableWidget.isBeingDragged())
        draggableWidget.stopDragging();
    }
  }
  public void invokeMouseWheelUsed(MouseEvent event) {
    for(ScrollableWidget scrollableWidget : scrollableWidgets) {
      if(scrollableWidget.isHovered())
        scrollableWidget.invokeMouseWheelUsed(event);
    }
  }
  public void invokeKeyPressed() {
    for(TypableWidget typableWidget : typableWidgets) {
        if(focusedWidget == typableWidget)
          typableWidget.invokeOnKeyPressedCallback();
    }
  }
  
  // called automatically by setFilter method in the DataProvider class
  public void updateDataDependentWidgets() {
    for(DataDependentWidget dataDependentWidget : dataDependentWidgets) {
      dataDependentWidget.update();  
    }
  }
  
  public void setFocus(Widget widget) {
    focusedWidget = widget;
  }
}

interface Callback {
  void call();  
}

final static Callback EMPTY_CALLBACK = new Callback() { public void call() {}};
