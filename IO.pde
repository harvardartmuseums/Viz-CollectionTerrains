void mousePressed() {}

void keyPressed() {
  if (key=='n') {
    conv=max(-60,conv-1);
    setCams();
  }
  if (key=='m') {
    conv=min(60,conv+1);
    setCams();
  }
  if (key==',') {
    depth=max(0,depth-2);
    setCams();
  }
  if (key=='.') {
    depth=min(150,depth+2);
    setCams();
  }    
  
  if (key=='a') {
    mode = (mode+1) % modes.length;
    setMaskMode();
  }    
  
  if (key=='p') {
    paused = !paused;
  }
  
  if (key == 'r') {
    recording = !recording;
  }
  
  if (key=='d') {
    //toggle data set
    selectedDataSet = (selectedDataSet + 1) % dataSets.length;
  }  
}







