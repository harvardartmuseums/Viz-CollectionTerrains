/* Events can be... 
      move dates from location history
      edits on from the audit trail
      photography from media file dates
      study center views from events records
      page views from the website analytics
      conservation from ????
      on view in the galleries
      on view in an exhibition
      
--Types
-- 1 - PageViews
-- 2 - Study Center Views
-- 3 - Movement
-- 4 - Date Edit
-- 5 - Conservation      
*/

public class Event {
  LocalDate eventDate;
  int type;
  int objectID;
  int value; 
  
  public Event(String _data) {
    String bits[];    
    
    bits = split(_data, ",");

    eventDate = new LocalDate(bits[0]);    
    objectID = int(bits[1]);
    value = int(bits[2]);
    type = int(bits[3]);    
  } 
}
