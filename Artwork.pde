public class Artwork {
 
  int objectID;
  int imageCount;
  String division;
  String classification;
  String primaryColor;
  int totalPageViews;
  int totalUniquePageViews;
  int totalEdits;
  int imagePermission;
  int verificationLevel;
  int orderNumber;
  LocalDate dateFirstViewed;
  LocalDate dateLastViewed;
  Multimap<LocalDate, Event> events;
  Map<LocalDate, Integer> eventsCounts;  //total number of events for each day
  
  PVector location; 
   
  color fillColor = color(200, 200, 200);
  
  private int eventsToDate = 0;
  private int dataset = 0;
  private int width = 20;
  private int depth = 20;
  private int heightScaleFactor = 1;
  
  public Artwork(String _data) {
    String bits[];    
    
    bits = split(_data, ",");
    
    objectID = int(bits[0]);
    totalPageViews = int(bits[1]);
    totalUniquePageViews = int(bits[2]);
    totalEdits = int(bits[3]);
    classification = bits[4];
    imagePermission = int(bits[5]);
    verificationLevel = int(bits[6]);
    imageCount = int(bits[7]);
    division = bits[8];
    if (bits[9].equals("NULL") == false) dateFirstViewed = new LocalDate(bits[9]);
    if (bits[10].equals("NULL") == false) dateLastViewed = new LocalDate(bits[10]); 
    orderNumber = int(bits[11]);   
    if (bits[13].equals("NULL") == false) primaryColor = bits[13];
   
    events = ArrayListMultimap.create();  
    eventsCounts = new HashMap<LocalDate, Integer>();      
  }

  public void addEvent(Event _e) {  
    events.put(_e.eventDate, _e);
    
    Integer eventsTotalCount = 0;
    Integer eventsPageViews = 0;
    Integer eventsEdits = 0;
    Integer eventsMovement = 0;
    Integer eventsConservation = 0;
    Integer eventsStudyCenterViews = 0;
    
    for (Event e: events.get(_e.eventDate)) {
      eventsTotalCount += e.value;
      
      if (e.type == 1) {
        eventsPageViews += e.value;
      } else if (e.type == 2) {
        eventsStudyCenterViews += e.value;
      } else if (e.type == 3) {
        eventsMovement += e.value;
      } else if (e.type == 4) {
        eventsEdits += e.value;
      } else if (e.type == 5) {
        eventsConservation += e.value;
      }
    }
    eventsCounts.put(_e.eventDate, eventsTotalCount);
  }
  
  public void render() {
    int dataPoint = 0;
    
    if (dataset == 0) {
      dataPoint = totalPageViews;
    } else if (dataset == 1) {
      dataPoint = totalUniquePageViews;
    } else if (dataset == 2) {
      dataPoint = totalEdits;    
    }
    
    // Don't try draw it if there is no data to draw
    if (dataPoint > 0) {
      noStroke();
      fill(fillColor);
  
      pushMatrix();
      translate(location.x, -(dataPoint*heightScaleFactor)/2, location.z); 
      box(width, dataPoint*heightScaleFactor, depth); 
      popMatrix();
    }
  }

  //This doesn't differentiate between pageviews, edits, etc...
  public int getEventsCountByDate(LocalDate _d) {
    if (eventsCounts.containsKey(_d)) {
      return eventsCounts.get(_d);
    } else {
      return 0;
    }
  }
  
  //This doesn't differentiate between pageviews, edits, etc...  
  public int getTotalEventsToDate(LocalDate _d) {
    if (eventsCounts.containsKey(_d)) {
      return eventsToDate += eventsCounts.get(_d);
    } else {
      return eventsToDate;
    }    
  }
  
  public boolean hasEventsToday(LocalDate _d) {
    return eventsCounts.containsKey(_d);
  }
  
  public void setLocation(PVector _l) {
    location = _l;
  }
  
  public void setScale(int _s) {
    heightScaleFactor = _s;
  }
  
  public void setColor(int fillType) {
    // fillTypes
    // 0 - the standard color for all artworks
    // 1 - gradient by total value of the current dataset
    // 2 - the artworks primary color
    
    if (fillType == 0) {
      fillColor = color(200, 200, 200);
    } else if (fillType == 1) {
      fillColor = color(map(totalPageViews,0,1000,0,255)*2, 200, 200);        
    } else {
      if (primaryColor != null) {
        fillColor = unhex("FF" + primaryColor.substring(1));
      } else {
        fillColor = color(200, 200, 200);
      }  
    }
  }
  
  public void setDataset(int _d) {
    dataset = _d;
  }
}