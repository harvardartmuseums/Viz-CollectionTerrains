public class Artwork {
 
  int objectID;
  int imageCount;
  String division;
  String classification;
  String primaryColor;
  
  int totalPageViews;
  int totalUniquePageViews;  //get rid of this
  int totalEdits;
  int totalMoves;
  int totalConservation;
  int totalStudyCenter;
  int totalEvents;
  
  int imagePermission;
  int verificationLevel;
  int orderNumber;
  LocalDate dateFirstViewed;
  LocalDate dateLastViewed;
  Multimap<LocalDate, Event> events;
  Map<String, Integer> eventsCounts;  //total number of events for each day
  
  PVector location; 
   
  color fillColor = color(200, 200, 200);
  
  private int eventsToDateTotal = 0;
  private int eventsToDatePageViews = 0;
  private int eventsToDateEdits = 0;
  private int eventsToDateMoves = 0;
  private int eventsToDateConservation = 0;
  private int eventsToDateStudyCenter = 0;
  private int dataset = 0;
  private int width = 20;
  private int depth = 20;
  private int heightScaleFactor = 1;
  
  public Artwork(String _data) {
    String bits[];    
    
    bits = split(_data, ",");
    
    objectID = int(bits[0]);
    //totalPageViews = int(bits[1]);
    //totalUniquePageViews = int(bits[2]);  //get rid of this
    //totalEdits = int(bits[3]);
    classification = bits[4];
    imagePermission = int(bits[5]);
    verificationLevel = int(bits[6]);
    imageCount = int(bits[7]);
    division = bits[8];
    if (bits[9].equals("NULL") == false) dateFirstViewed = new LocalDate(bits[9]);
    if (bits[10].equals("NULL") == false) dateLastViewed = new LocalDate(bits[10]); 
    orderNumber = int(bits[11]);   
    if (bits[13].equals("NULL") == false) primaryColor = bits[13];
    
    totalPageViews = 0;
    totalEdits = 0;
    totalMoves = 0;
    totalConservation = 0;
    totalStudyCenter = 0;
    totalEvents = 0;
   
    events = ArrayListMultimap.create();  
    eventsCounts = new HashMap<String, Integer>();      
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
      eventsCounts.put(_e.eventDate.toString() + ":0", eventsTotalCount);
      totalEvents += e.value;
      
      if (e.type == 1) {
        eventsPageViews += e.value;
        eventsCounts.put(_e.eventDate.toString() + ":" + e.type, eventsPageViews);
        totalPageViews += e.value;

      } else if (e.type == 2) {
        eventsStudyCenterViews += e.value;
        eventsCounts.put(_e.eventDate.toString() + ":" + e.type, eventsStudyCenterViews);
        totalStudyCenter += e.value;
      
      } else if (e.type == 3) {
        eventsMovement += e.value;
        eventsCounts.put(_e.eventDate.toString() + ":" + e.type, eventsMovement);
        totalMoves += e.value;
        
      } else if (e.type == 4) {
        eventsEdits += e.value;
        eventsCounts.put(_e.eventDate.toString() + ":" + e.type, eventsEdits);
        totalEdits += e.value;
        
      } else if (e.type == 5) {
        eventsConservation += e.value;
        eventsCounts.put(_e.eventDate.toString() + ":" + e.type, eventsConservation);
        totalConservation += e.value;        
      }
    }
  }
  
  public void render() {
    int dataPoint = 0;
    
    if (dataset == 0) {
      dataPoint = totalEvents;
    } else if (dataset == 1) {
      dataPoint = totalPageViews;
    } else if (dataset == 2) {
      dataPoint = totalStudyCenter;    
    } else if (dataset == 3) {
      dataPoint = totalMoves;    
    } else if (dataset == 4) {
      dataPoint = totalEdits;    
    } else if (dataset == 5) {
      dataPoint = totalConservation;    
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

  public void update(LocalDate _d) {
    if (eventsCounts.containsKey(_d.toString() + ":0")) {
      eventsToDateTotal += eventsCounts.get(_d.toString() + ":0");
    }
    if (eventsCounts.containsKey(_d.toString() + ":1")) {
      eventsToDatePageViews += eventsCounts.get(_d.toString() + ":1");
    }
    if (eventsCounts.containsKey(_d.toString() + ":2")) {
      eventsToDateStudyCenter += eventsCounts.get(_d.toString() + ":2");
    }
    if (eventsCounts.containsKey(_d.toString() + ":3")) {
      eventsToDateMoves += eventsCounts.get(_d.toString() + ":3");
    }
    if (eventsCounts.containsKey(_d.toString() + ":4")) {
      eventsToDateEdits += eventsCounts.get(_d.toString() + ":4");
    }
    if (eventsCounts.containsKey(_d.toString() + ":5")) {
      eventsToDateConservation += eventsCounts.get(_d.toString() + ":5");
    }
  }

  //This doesn't differentiate between pageviews, edits, etc...
  public int getEventsCountByDate(LocalDate _d) {
    if (eventsCounts.containsKey(_d.toString() + ":" + dataset)) {
      return eventsCounts.get(_d.toString() + ":" + dataset);
    } else {
      return 0;
    }
  }
  
  //This doesn't differentiate between pageviews, edits, etc...  
  public int getTotalEventsToDate(LocalDate _d) {
    if (dataset == 0) {
      return eventsToDateTotal;
    } else if (dataset == 1) {
      return eventsToDatePageViews;
    } else if (dataset == 2) {
      return eventsToDateStudyCenter;    
    } else if (dataset == 3) {
      return eventsToDateMoves;    
    } else if (dataset == 4) {
      return eventsToDateEdits;    
    } else if (dataset == 5) {
      return eventsToDateConservation;    
    } else {
      return 0;
    }
    //if (eventsCounts.containsKey(_d.toString() + ":" + dataset)) {
    //  return eventsToDateTotal += eventsCounts.get(_d.toString() + ":" + dataset);
    //} else {
    //  return eventsToDateTotal;
    //}    
  }
  
  public boolean hasEventsToday(LocalDate _d) {
    return eventsCounts.containsKey(_d.toString() + ":" + dataset);
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