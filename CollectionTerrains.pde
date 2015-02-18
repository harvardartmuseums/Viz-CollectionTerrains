PVector cameras[][] = {  //Eye, LookAt, Eye Velocity, LookAt Velocity
        {new PVector(4720, -12000, 6000), new PVector(4720, 0, 2000), new PVector(0, 0, 0), new PVector(0, 0, 0)},      //High vantage point looking down, no movement
        {new PVector(7650, -30000, 7650), new PVector(7650, 0, 7630), new PVector(0, 0, 0), new PVector(0, 0, 0)},      //Centered overhead looking straight down, no movement
        {new PVector(18500, -250, 18500), new PVector(0, -3000, 0), new PVector(-10, 0, -10), new PVector(0, 0, 0)},    //Corner position, moving diagonally across the landscape (passing through the forest)
        {new PVector(4720, 0, 6000), new PVector(4720, 0, 2000), new PVector(0, -10, 0), new PVector(0, 0, 0)},             //Middle of grid, rising vertically from ground level
        {new PVector(-3000, -1550, 20000), new PVector(20000, -100, -3000), new PVector(-5, 0, -5), new PVector(5, 0, 5)}  //Front right corner position, moving diagonally across the landscape (passing by the forest)
};

//High vantage point looking down, no movement
//final static int ARTWORK_SIZE_WIDTH = 20;
//final static int ARTWORK_SIZE_DEPTH = 20;
//final static int ARTWORK_SIZE_HEIGHT = 20;
//final static int ARTWORK_SPACING = 0;

//Overhead vantage point looking straight down, no movement
//final static int ARTWORK_SIZE_WIDTH = 30;
//final static int ARTWORK_SIZE_DEPTH = 30;
//final static float ARTWORK_SIZE_HEIGHT = 1;
//final static int ARTWORK_SPACING = 0;

//Corner position, moving diagonally across the landscape (passing through the forest)
//final static int ARTWORK_SIZE_WIDTH = 20;
//final static int ARTWORK_SIZE_DEPTH = 20;
//final static int ARTWORK_SIZE_HEIGHT = 1;
//final static int ARTWORK_SPACING = 10;

//Middle of grid, rising vertically from ground level
//final static int ARTWORK_SIZE_WIDTH = 20;
//final static int ARTWORK_SIZE_DEPTH = 20;
//final static int ARTWORK_SIZE_HEIGHT = 20;
//final static int ARTWORK_SPACING = 0;

//Corner position, moving diagonally across the landscape (passing through the forest)
final static int ARTWORK_SIZE_WIDTH = 20;
final static int ARTWORK_SIZE_DEPTH = 20;
final static int ARTWORK_SIZE_HEIGHT = 1;
final static int ARTWORK_SPACING = 10;

PFont fontA;

PGraphics cam;
int selectedCamera = 4;

String dataSets[] = {"pageviews","uniquepageviews","edits"};
int selectedDataSet = 0;

String fills[] = {"default","gradient","objectcolor"};
int selectedFill = 0;

int dayCounter = 0;

int terrainWidth = 0;
int terrainHeight = 0;

final static String DATE_RANGE_START = "2009-05-13";
final static String DATE_RANGE_END = "2014-08-09";

final static String DATA_FILE_ARTWORKS = "data-objects.csv";
//final static String DATA_FILE_ARTWORKS = "data-objects-by-culture.csv";
//final static String DATA_FILE_ARTWORKS = "data-objects-by-classification.csv";
//final static String DATA_FILE_ARTWORKS = "data-objects-by-verification.csv";
//final static String DATA_FILE_ARTWORKS = "data-objects-by-pageviews.csv";
final static String DATA_FILE_EVENTS = "data-objects-events-pageviews.csv";

List<LocalDate> dates = new ArrayList<LocalDate>();
Map<Integer, Artwork> artworks = new LinkedHashMap<Integer, Artwork>();

boolean paused = false;
boolean animateEvents = false;
boolean animateCamera = true;
boolean showInfoPanel = true;
boolean recording = false;


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
      
  cam = createGraphics(width, height, P3D);
  cam.beginDraw();
  cam.noStroke();
  cam.endDraw();
  setCams();
  
  //Prepare the remaining odds and ends
  fontA = loadFont("CourierNew36.vlw");
  textFont(fontA, 15);
} 

void setCams() {
  cam.camera(cameras[selectedCamera][0].x,cameras[selectedCamera][0].y,cameras[selectedCamera][0].z, 
              cameras[selectedCamera][1].x,cameras[selectedCamera][1].y,cameras[selectedCamera][1].z,  
              0,1.0,0);              
  
  float fov = PI/6.0;
  float cameraZ = (height/2.0) / tan(fov/2.0);
  cam.perspective(fov, float(width)/float(height),cameraZ/10.0, cameraZ*10.0);
}

void draw(){
  cam.beginDraw();
  cam.background(255);
      
//  cam.directionalLight(255,255,255, 18500, 0, -1);
  
  LocalDate currentDate = dates.get(dayCounter);   

  int dataPoint = 0;
  int dataPointCurrentDay = 0;
 
  //Draw all of the objects in the scene  
  for (Artwork a: artworks.values()) {  
        
    //Get some value from the current artwork. The value is the height of the block we're about to render.
    if (animateEvents) {
      if (a.hasEventsToday(currentDate)) {
        dataPointCurrentDay = a.getEventsCountByDate(currentDate);
        dataPoint = a.getTotalEventsToDate(currentDate) - dataPointCurrentDay;
        if (dataPoint == dataPointCurrentDay) {
          dataPoint = 0;
        }
      } else {
        dataPointCurrentDay = 0;
        dataPoint = a.getTotalEventsToDate(currentDate);
      }
      
    } else {
      if (selectedDataSet == 0) {
        dataPoint = a.totalPageViews;
      } else if (selectedDataSet == 1) {
        dataPoint = a.totalUniquePageViews;
      } else if (selectedDataSet == 2) {
        dataPoint = a.totalEdits;
      }
    }
    

    if (dataPoint > 0 || dataPointCurrentDay > 0) {      
      cam.pushMatrix(); 
      cam.translate(a.location.x, -(dataPoint*ARTWORK_SIZE_HEIGHT)/2, a.location.z); 

      //Color the object box
      if (selectedFill == 0) {
        cam.fill(200, 200, 200);
      } else if (selectedFill == 1) {
        cam.fill(map(a.totalPageViews,0,1000,0,255)*2, 200, 200);        
      } else {
        if (a.primaryColor != null) {
          color c = unhex("FF" + a.primaryColor.substring(1));
          cam.fill(c);        
        } else {
          cam.fill(200, 200, 200);
        }  
      }
      
      cam.box(ARTWORK_SIZE_WIDTH, dataPoint*ARTWORK_SIZE_HEIGHT, ARTWORK_SIZE_DEPTH); 
      cam.popMatrix();

      if (animateEvents && a.hasEventsToday(currentDate)) {
        cam.pushMatrix(); 
        cam.translate(a.location.x, -((dataPoint*ARTWORK_SIZE_HEIGHT) + ((dataPointCurrentDay*ARTWORK_SIZE_HEIGHT)/2)), a.location.z); 
        cam.fill(200, 0, 0);
        cam.box(ARTWORK_SIZE_WIDTH, dataPointCurrentDay*ARTWORK_SIZE_HEIGHT, ARTWORK_SIZE_DEPTH); 
        cam.popMatrix();      
      }
    }  
  }
  
  cam.endDraw();

  loadPixels();
  cam.loadPixels();
  arrayCopy(cam.pixels, pixels);


  if (showInfoPanel) {
    noStroke();
    fill(255);
    rect(0, height-60, width, 60);
    fill(0,80);
    text("dataset:" +  dataSets[selectedDataSet], 8, height-6);
    text("day:" + dates.get(dayCounter).toString("yyyy-MM-dd") + " (" + dates.get(dayCounter).dayOfWeek().getAsText() + ")", 8, height-24);      
    text("camera " + selectedCamera + ":" + cameras[selectedCamera][0].toString() + ", look at:" + cameras[selectedCamera][1].toString(), 8, height-42);  
  }
    
  if (recording) {
    saveFrame("output/frames####.png");
  }
  
  if (animateCamera) {
    for (int i=0; i<cameras.length; i++) {
      cameras[i][0].add(cameras[i][2]);
      cameras[i][1].add(cameras[i][3]);
    }
    
    setCams();
  }
 

  if (animateEvents) {
    //There is a problem here. The dayCounter stops at the last day and there is no mechanism to stop adding the days event.
   // So last days events keep getting added to each object as the sketch continues to run. FIX THIS!!!!
    if (dayCounter < dates.size()-1) {
      dayCounter++;
    } else {
      animateEvents = false;
    }
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
  
  //calculate the dimesions of terrain
  terrainWidth = round(itemsPerRow) * (ARTWORK_SIZE_WIDTH + ARTWORK_SPACING);
  terrainHeight = round(itemsPerRow) * (ARTWORK_SIZE_WIDTH + ARTWORK_SPACING);  

  //set the location of every artwork
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
