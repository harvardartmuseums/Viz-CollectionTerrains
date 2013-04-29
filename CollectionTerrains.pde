/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/10227*@* */
/* !do not delete the line above, required for linking your tweak if you re-upload */

// anaglyph 3D Shapes     //
// Will Birtchnell 06/10  //

//High vantage point looking down, no movement
//PVector cameraEye = new PVector(4720, -12000, 6000);
//PVector cameraLookAt = new PVector(4720, 0, 2000);
//PVector cameraVelocity = new PVector(0, 0, 0);
//final static int ARTWORK_SIZE_WIDTH = 20;
//final static int ARTWORK_SIZE_DEPTH = 20;
//final static int ARTWORK_SIZE_HEIGHT = 20;
//final static int ARTWORK_SPACING = 0;

//Corner position, moving diagonally across the landscape (passing through the forest)
/*PVector cameraEye = new PVector(18500, -250, 18500);
PVector cameraLookAt = new PVector(0, -3000, 0);
PVector cameraVelocity = new PVector(-10, 0, -10);
final static int ARTWORK_SIZE_WIDTH = 20;
final static int ARTWORK_SIZE_DEPTH = 20;
final static int ARTWORK_SIZE_HEIGHT = 1;
final static int ARTWORK_SPACING = 10;*/

//Middle of grid, rising vertically from ground level
PVector cameraEye = new PVector(4720, 0, 6000);
PVector cameraLookAt = new PVector(4720, 0, 2000);
PVector cameraVelocity = new PVector(0, -10, 0);
final static int ARTWORK_SIZE_WIDTH = 20;
final static int ARTWORK_SIZE_DEPTH = 20;
final static int ARTWORK_SIZE_HEIGHT = 20;
final static int ARTWORK_SPACING = 0;

PFont fontA;

final static int MODE_LEFT = 0;
final static int MODE_RIGHT = 1;
final static int MODE_3D = 2;

String modes[] = {"left","right","red/cyan"};
int mode = MODE_LEFT;
int maskL;
int maskR;
int pixelCount;

PGraphics pgl;
PGraphics pgr;

int depth = 40;
int conv = -10;

String dataSets[] = {"pageviews","uniquepageviews","edits"};
int selectedDataSet = 0;

int dayCounter = 0;

final static String DATE_RANGE_START = "2009-05-18";
final static String DATE_RANGE_END = "2013-02-20";

final static String DATA_FILE_ARTWORKS = "data-objects.csv";
final static String DATA_FILE_EVENTS = "data-objects-events-pageviews.csv";

List<LocalDate> dates = new ArrayList<LocalDate>();
Map<Integer, Artwork> artworks = new LinkedHashMap<Integer, Artwork>();

boolean paused = false;
boolean animateEvents = true;
boolean animateCamera = true;
boolean showInfoPanel = true;
boolean recording = true;


void setup(){ 
  size(1280, 720, P3D);
  
  //Load data about the artworks  
  fillArtwork(artworks);  
  arrangeArtworks();
  
  //Create a list of dates for the time series
  LocalDate startDate = new LocalDate(DATE_RANGE_START);
  LocalDate endDate = new LocalDate(DATE_RANGE_END);

  int days = Days.daysBetween(startDate, endDate).getDays();
  for (int i=0; i < days; i++) {
      LocalDate d = startDate.withFieldAdded(DurationFieldType.days(), i);
      dates.add(d);
  }  
    
  //Create the two cameras for the 3D effect
  pixelCount = width * height;
  
  pgl = createGraphics(width, height, P3D);
  pgr = createGraphics(width, height, P3D);
  pgl.beginDraw();
  pgr.beginDraw();
  pgl.noStroke();
  pgr.noStroke();
  pgl.endDraw();
  pgr.endDraw();
  setCams();
  setMaskMode();
  
  //Prepare the remaining odds and ends
  fontA = loadFont("CourierNew36.vlw");
  textFont(fontA, 15);
} 

// set two cameras for left/right eye
void setCams() {
  pgl.camera(-depth+cameraEye.x,cameraEye.y,cameraEye.z, 
              -conv+cameraLookAt.x,cameraLookAt.y,cameraLookAt.z,  
              0,1.0,0);
  pgr.camera(depth+cameraEye.x,cameraEye.y,cameraEye.z,  
              conv+cameraLookAt.x,cameraLookAt.y,cameraLookAt.z,  
              0,1.0,0);
  
  float fov = PI/6.0;
  float cameraZ = (height/2.0) / tan(fov/2.0);
  pgl.perspective(fov, float(width)/float(height),cameraZ/10.0, cameraZ*10.0);
  pgr.perspective(fov, float(width)/float(height),cameraZ/10.0, cameraZ*10.0);
}

void setMaskMode() {    
  if (mode == MODE_LEFT) {
    maskL=0xffffff;
    maskR=0x000000;
  }
  if (mode == MODE_RIGHT) {
    maskL=0x000000;
    maskR=0xffffff;
  }
  if (mode == MODE_3D) {
    maskL=0xff0000;
    maskR=0x00ffff;
  }
}

void draw(){
  pgl.beginDraw();
  pgr.beginDraw();
  pgl.background(255);
  pgr.background(255); 
      
  pgl.directionalLight(255,255,255, 0, 0, -1);
  pgr.directionalLight(255,255,255, 0, 0, -1);
  
  LocalDate currentDate = dates.get(dayCounter);   

  int dataPoint = 0;
 
  //Draw all of the objects in the scene  
  for (Artwork a: artworks.values()) {  
    
    //Get some value from the current artwork. The value is the height of the block we're about to render.
    if (animateEvents) {
      dataPoint = a.getTotalEventsToDate(currentDate);
      
    } else {
      if (selectedDataSet == 0) {
        dataPoint = a.totalPageViews;
      } else if (selectedDataSet == 1) {
        dataPoint = a.totalUniquePageViews;
      } else if (selectedDataSet == 2) {
        dataPoint = a.totalEdits;
      }
    }
    
    if (dataPoint > 0) {      
      // draw image for left eye
      pgl.pushMatrix(); 
      pgl.translate(a.location.x, -(dataPoint*ARTWORK_SIZE_HEIGHT)/2, a.location.z); 
      if (a.hasEventsToday(currentDate)) {
        pgl.fill(200, 0, 0);
      } else {
        pgl.fill(200, 200, 200);
      }
      pgl.box(ARTWORK_SIZE_WIDTH, dataPoint*ARTWORK_SIZE_HEIGHT, ARTWORK_SIZE_DEPTH); 
      pgl.popMatrix();
      
      // draw image for rght eye
      pgr.pushMatrix(); 
      pgr.translate(a.location.x, -(dataPoint*ARTWORK_SIZE_HEIGHT)/2, a.location.z); 
      if (a.hasEventsToday(currentDate)) {
        pgr.fill(200, 0, 0);
      } else {
        pgr.fill(200, 200, 200);
      }
      pgr.box(ARTWORK_SIZE_WIDTH, dataPoint*ARTWORK_SIZE_HEIGHT, ARTWORK_SIZE_DEPTH); 
      pgr.popMatrix();  
    }      
  }
  
  pgl.endDraw();
  pgr.endDraw(); 

  // combine left/right image to make anaglyph image
  loadPixels();
  pgl.loadPixels();
  pgr.loadPixels();

  for (int px=0;px<(pixelCount);px++) {
    pixels[px]= pgl.pixels[px]&maskL | pgr.pixels[px]&maskR;
  }


  if (showInfoPanel) {
    noStroke();
    rect(0, height-60, width, 60);
    fill(0,80);
    text("depth:" + depth + " convengence:" +conv + " mode:"+ modes[mode], 8, height-6);  
    text("day:" + dates.get(dayCounter).toString("yyyy-MM-dd") + " (" + dates.get(dayCounter).dayOfWeek().getAsText() + ")", 8, height-24);      
    text("camera:" + cameraEye.toString(), 8, height-42);  
  }
    
  if (recording) {
    saveFrame("output/frames####.png");
  }
  
  if (animateCamera) {
    cameraEye.add(cameraVelocity);
  }

  setCams();
  
  if (dayCounter < dates.size()-1) {
    dayCounter++;
  }
} 

void arrangeArtworks() {
  //Arrange the artworks in a grid 
  int y = 0;
  int x = 0;
  int z = 0;
  int rowItemCounter = 0;
  float itemsPerRow = 0;
  
  //the grid shape will be a square
  itemsPerRow = sqrt(artworks.size());

  for (Artwork a: artworks.values()) {
    a.setLocation(new PVector(x, y, z));
    
    rowItemCounter++;
    if (rowItemCounter >= itemsPerRow) {
      rowItemCounter = 0;
      z = z + ARTWORK_SIZE_DEPTH + ARTWORK_SPACING;
    }    
    x = rowItemCounter * (ARTWORK_SIZE_WIDTH + ARTWORK_SPACING);
  } 
}
