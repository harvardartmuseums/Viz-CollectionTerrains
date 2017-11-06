/* Keyboard commands
    
    Enter - save a snapshot of the screen
    Left arrow - 
    Right arrow - 
    Up arrow - cycle through the data set filters
    Down arrow - 
    Spacebar - pause all animations
    A - toggle on/off the animation of the events data
    C - change the camera angle
    D - change the dataset
    F - change the color
    I - toggle on/off the information panel
    R - record every frame to disk
    
*/
void keyPressed() {
  if (keyCode == KeyEvent.VK_ENTER) {
    saveFrame("snapshots/snapshot-####.png");
  }
  
  if (keyCode == KeyEvent.VK_A) {
    animateEvents = !animateEvents;
  }
  
  if (keyCode == KeyEvent.VK_SPACE) {
    paused = !paused;
  }
  
  if (keyCode == KeyEvent.VK_I) {
    showInfoPanel = !showInfoPanel;
  }
  
  if (keyCode == KeyEvent.VK_R) {
    recording = !recording;
  }
  
  if (keyCode == KeyEvent.VK_C) {
    selectedCamera = (selectedCamera + 1) % cameras.length;
    setCams();
  }
  
  if (keyCode == KeyEvent.VK_D) {
    //toggle data set
    selectedDataSet = (selectedDataSet + 1) % dataSets.length;

    for (Artwork a: artworks.values()) {
      a.setDataset(selectedDataSet);
    }
 
    for (Artwork a: filterArtworks.values()) {
      a.setDataset(selectedDataSet);
    }    
  }  
  
  if (keyCode == KeyEvent.VK_F) {
    selectedFill = (selectedFill + 1) % fills.length;
    
    for (Artwork a: artworks.values()) {
      a.setColor(selectedFill);
    }
 
    for (Artwork a: filterArtworks.values()) {
      a.setColor(selectedFill);
    }   
  }    
  
  if (keyCode == KeyEvent.VK_UP) {
    //toggle classification
    selectedClassification = (selectedClassification + 1) % classifications.length;
        
    filterArtworks.clear();
    
    if (classifications[selectedClassification] == "all") {
      filterArtworks.putAll(artworks);    
    } else {
      for (Artwork a: artworks.values()) {
        if (a.classification.equals(classifications[selectedClassification])) {
          filterArtworks.put(a.objectID, a);
        }
      }
    }
  }  
}