public class Artwork {
 
  int objectID;
  int imageCount;
  String division;
  String classification;
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
  Map<LocalDate, Integer> eventsPageViewCounts;  
  
  PVector location; 
   
  private color c;
  private float colorAlive = 255.0;
  private float colorDead = 48.0;
  private float colorNow = colorDead;
  private boolean isAlive = false;
  private float decayRate = 0.0;
  private int sizeMultiplier = 1;
  private int daysAlive = 0;
  private int eventsToDate = 0;
  
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
    noStroke();
    fill(c);
    pushMatrix();
    translate(location.x, location.y);
    rect(0, 0, ARTWORK_SIZE_WIDTH, ARTWORK_SIZE_DEPTH);
    popMatrix();
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
}
