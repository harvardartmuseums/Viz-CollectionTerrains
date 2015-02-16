/* Keyboard commands
    
    Enter - save a snapshot of the screen
    Left arrow - 
    Right arrow - 
    Up arrow - 
    Down arrow - 
    Spacebar - pause all animations
    A - toggle on/off the animation of the events data
    C - change the camera angle
    D - change the dataset
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
  }
  
  if (keyCode == KeyEvent.VK_D) {
    //toggle data set
    selectedDataSet = (selectedDataSet + 1) % dataSets.length;
  }  
}







