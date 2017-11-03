public void fillArtwork(Map<Integer, Artwork> _a) {
  String lines[] = loadStrings(DATA_FILE_ARTWORKS);
  
  println("Loaded " + lines.length + " bits of artworks data");
    
  //Skip the first row because it contains column names
  for(int i=1; i<lines.length; i++) {
    Artwork a = new Artwork(lines[i]);
    _a.put(a.objectID, a);
  }
  
  println("Done stepping through the artworks data");
  
  fillArtworkEvents(_a);
  
  filterArtworks.putAll(_a);
}

public void fillArtworkEvents(Map<Integer, Artwork> _a) {
  String lines[] = loadStrings(DATA_FILE_EVENTS);
  
  println("Loaded " + lines.length + " bits of events data");
  
  //Skip the first row because it contains column names
  for(int i=1; i<lines.length; i++) { 
    Event e = new Event(lines[i]);
    if (_a.containsKey(e.objectID)) {
      _a.get(e.objectID).addEvent(e);
    }      
  }
  
  println("Done stepping through the events data");
}