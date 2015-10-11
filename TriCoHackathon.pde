/*******************************************************************
 *     My goal is to create an interactive visualization of the Philly 
 * crime data obtained from https://www.opendataphilly.org/dataset/
 * philadelphia-police-part-one-crime-incidents. This is a fairly big
 * data set, so I just picked the part about crimes in March, 2015 to the 18th
 * and decided to visualize specifically about the numbers of crimes for
 * each crime type. The data visualization contains of three parts: an
 * American blank map with Pennsylvania shown in red (while clicked on 
 * the rectangle enclosing the PA, a map of Philadelphia will be shown);
 * a bar graph that clearly shows the information when user click on the 
 * rectangle on the upper left corner labeling "display bar graph" 
 * (Besides, when mouse moves through each bar, the exact number will be
 * shown on the top); and a pie chart, which shows the comparison between
 * the number of crimes when user click on the circle labeling "display 
 * pie chart".
 *     Based on all of these information, I concluded that the most frequently 
 * crime happened in Philadelphia is the "Theft" crime. I also designed a 
 * legend displaying all the crime types and add interaction to each of them, 
 * so that users would be able to click on a crime and see the visuals for 
 * just that crime (Specifically the rectangle corresponds to the bar graph,
 * while the circle corresponds to the pie chart).
 *********************************************************************/
//declare global variables
PImage img;
PShape usa;
PShape pennsylvania;
int c = 14; // number of crimes types
int[] number = new int[c];
float[] perc = new float[c];
float [] bAngle = new float[c + 1];
float x, y, delta, w, z, cx, cy, px, py, d;
int TOTAL;
float minNumber, maxNumber, avg;
float beginAngle, endAngle;

//declare the arrays
color[] colors = {
  color(245, 119, 94), //AAF
  color(247, 227, 2), //AANF
  color(252, 66, 266), //BNR
  color(94, 245, 140), //BR
  color(181, 149, 227), //HC
  color(205, 102, 29), //HGN
  color(94, 245, 233), //HJ
  color(24, 133, 240), //MVT
  color(0, 0, 0), //R
  color(238, 18, 137), //RSMV
  color(247, 178, 2), //RF
  color(0, 0, 255), //RNF
  color(0, 206, 209), //TV
  color(174, 7, 247), //T
};

String[] crimes = {
  "Aggravated Assault Firearm", 
  "Aggravated Assault No Firearm", 
  "Burglary Non-Residential", 
  "Burglary Residential", 
  "Homicide - Criminal", 
  "Homicide - Gross Negligence", 
  "Homicide - Justifiable", 
  "Motor Vehicle Theft", 
  "Rape", 
  "Recovered Stolen Motor Vehicle", 
  "Robbery Firearm", 
  "Robbery No Firearm", 
  "Theft from Vehicle", 
  "Thefts",
};

String[] crimeAcronym = {
  "AAF", "AANF", "BNR", "BR", "HC", 
  "HGN", "HJ", "MVT", "R", "RSMV", 
  "RF", "RNF", "TV", "T"
};

void setup() {
  //drawing setup
  background(255);
  size(displayWidth, displayHeight);
  fill(0);

  //bar graph setup
  x = width/4;
  y = 0.7 * height;
  delta = 0.5 * width/c;
  w = 0.8 * delta;

  //load Philly map
  img = loadImage("philadelphia_downtown_map.jpg");
  usa = loadShape("Blank_US_Map.svg");
  pennsylvania = usa.getChild("PA");

  //read the data file
  String[] data = loadStrings("police_inct.csv");
  //set up the arrays for crime type
  String[] crime = new String[data.length];
  //split the data
  for (int i=0; i < data.length; i++) {
    String[] bits = split(data[i], ",");
    crime[i] = bits[2];
  }

  // count the number of crimes for each crime type
  for (int i=0; i<data.length; i++) {
    if (crime[i].equals("Aggravated Assault Firearm")) {
      number[0] = number[0] + 1; //AAF
    } else if (crime[i].equals("Aggravated Assault No Firearm")) {
      number[1] = number[1] + 1; //AANF
    } else if (crime[i].equals("Burglary Non-Residential")) {
      number[2] = number[2] + 1; //BNR
    } else if (crime[i].equals("Burglary Residential")) {
      number[3] = number[3] + 1; //BR
    } else if (crime[i].equals("Homicide - Criminal") || crime[i].equals("Homicide - Criminal ")) {
      number[4] = number[4] + 1; //HC
    } else if (crime[i].equals("Homicide - Gross Negligence")) {
      number[5] = number[5] + 1; //HGN
    } else if (crime[i].equals("Homicide - Justifiable ")) {
      number[6] = number[6] + 1; //HJ
    } else if (crime[i].equals("Motor Vehicle Theft")) {
      number[7] = number[7] + 1; //MVT
    } else if (crime[i].equals("Rape")) {
      number[8] = number[8] + 1; //R
    } else if (crime[i].equals("Recovered Stolen Motor Vehicle")) {
      number[9] = number[9] + 1; //RSMV
    } else if (crime[i].equals("Robbery Firearm")) {
      number[10] = number[10] + 1; //RF
    } else if (crime[i].equals("Robbery No Firearm")) {
      number[11] = number[11] + 1; //RNF
    } else if (crime[i].equals("Theft from Vehicle")) {
      number[12] = number[12] + 1; //TV
    } else if (crime[i].equals("Thefts")) {
      number[13] = number[13] + 1; //T
    }
  }

  //compute the total number of crimes
  for (int i = 0; i < c; i++) {
    TOTAL += number[i];
  }

  //pie chart setup
  //compute percentage
  for (int i = 0; i < c; i++) {
    perc[i] = number[i]/float(TOTAL);
  }
  //store endAngles in array bAngle
  endAngle = 0;
  bAngle[0] = endAngle;
  for (int i = 1; i < c + 1; i++) {
    bAngle[i] = bAngle[i - 1] + TWO_PI * perc[i - 1];
  }
  //initialize variable
  px = width/2;
  py = height/2;
  d = 400;
  //determine the min and max number of crimes
  minNumber = min(number);
  maxNumber = max(number);
  avg = TOTAL/float(c);

  // print out the crime numbers for each crime type in the console
  println("Number of Armed Aggravated Assaults: " + number[0]);
  println("Number of Unarmed Aggravated Assaults: " + number[1]);
  println("Number of Non-Residential Burglaries: " + number[2]);
  println("Number of Residential Burglaries: " + number[3]);
  println("Number of Criminal Homicides: " + number[4]);
  println("Number of Grossly-Negligent Homicides: " + number[5]);
  println("Number of Justified Homicides: " + number[6]);
  println("Number of Motor Vehicle Thefts: " + number[7]);
  println("Number of Rapes: " + number[8]);
  println("Number of Recovered Stolen Vehicles: " + number[9]);
  println("Number of Armed Robberies: " + number[10]);
  println("Number of Unarmed Robberies: " + number[11]);
  println("Number of Thefts from Vehicles: " + number[12]);
  println("Number of Thefts: " + number[13]);
  println("Total Number of Crimes: " + TOTAL);
}//setup

//add the interaction based on the mousePressed function and mouse position
void mousePressed() {
  cx = mouseX;
  cy = mouseY;
}

//save Screenshots
void keyPressed() {
  if (keyCode == RETURN || keyCode == ENTER) {
    save("PhillyCrimeData_March.jpg");
  } else if (keyCode == TAB) {
    save("PhillyCrimeDataPhillyMap_March.jpg");
  } else if (key == 'P' || key == 'p') {
    save("PieChart_March.jpg");
  } else if (key == 'B' || key == 'b') {
    save("BarGraph_March.jpg");
  }
}

void draw() {
  background(255);
  //Title
  drawTitle();
  //signature
  drawSignature();
  //draw legend
  drawLegend();

  if (cx > 10 && cx < 40 && cy > 100 && cy < 130) {
    //draw Bargraph
    //axis labels
    drawXLabels();
    drawYLabels();
    for (int i = 0; i < c; i++) {
      drawBarGraph(i);
    }
    //show the line of average crime
    z = map(avg, minNumber, maxNumber, 0, height/2);
    stroke(255, 0, 0);
    strokeWeight(2);
    line(x, y - z, x + c*delta, y - z);
    fill(255, 0, 0);
    textSize(15);
    text("Average crime number: " + avg, x + c*delta + 15, y - z + 5);
  } else if (sqrt((cx - 25)*(cx - 25) + (cy - 40) * (cy - 40))<= 15) {
    //draw Piechart
    endAngle = 0;
    for (int i = 0; i < c; i++) {
      drawPieChart(i);
    }
  } else {
    //display the full map
    usa.disableStyle();
    fill(220);
    stroke(255);
    shape(usa, width/4.8, height/12);
    fill(colors[9]);
    noStroke();
    //draw the state of pennsylvania
    shape(pennsylvania, width/4.8, height/12);
    //if clicked on the pennsylvania part, then the philly map will shown
    if (cx > 1000 && cx < 1080 && cy > 258 && cy < 300) {
      background(255);
      drawTitle();
      drawLegend();
      drawSignature();
      image(img, width/4, height/10, 2*width/3, 2*height/3);
    }
  }

  //draw the interaction of Bar Graph with respect to the rectangular crime type legend
  for (int i = 0; i < c; i++) {
    if (cx > 10 && cx < 35 && cy > height/3 + 30 * i && cy < height/3 + 30 * i + 25) {
      background(255);
      drawTitle();
      drawLegend();
      drawSignature();
      //axis labels
      drawXLabels();
      drawYLabels();
      drawBarGraph(i);
    }
  }
  //draw the interaction of Pie Chart with respect to the circular crime type legend
  for (int i = 0; i < c; i++) {
    if (sqrt((cx - 245)*(cx - 245) + (cy - 
      (height/3 + i*30 + 12.5)) * (cy - (height/3 + i*30 + 12.5)))<= 12.5) {
      background(255);
      drawTitle();
      drawLegend();
      drawSignature();
      drawPieChart(i);
    }
  }
}

//function drawXLabels for Bargraph
/* Draw the x Labels for the Bar Graph
 */
void drawXLabels() {
  textSize(15);
  for (int i = 0; i < c; i++) {
    fill(colors[i]);
    text(crimeAcronym[i], x + delta * i, y + 20);
  }
  fill(0);
  text("Types of Crimes", x + 280, y + 45);
}

//function drawYLabels for Bargraph
/* Draw the y Labels for the Bar Graph
 */
void drawYLabels() {
  fill(0);
  textSize(15);
  for (float i = minNumber; i < maxNumber + 5; i+= 60) {
    float h = map(i, minNumber, maxNumber, 0, height/2);
    text(floor(i), x - 35, y - h);
  }
  text("Number of Crimes", x - 35, y - 430);
}

//function drawTitle
/* Draw the Title
 */
void drawTitle() {
  textSize(20);
  fill(colors[13]);
  text("March 2015 to the 18th Philadelphia Crime Statistics", 
  x + 80, y - 500);
}

//function drawBarGraph
/* Draw the BarGraph
 * @param int i: the variable used to call a certain value inside array,
 * corresponding to the looping variable i within loops.
 */
void drawBarGraph(int i) {
  strokeWeight(1);
  stroke(0);
  fill(colors[i]);
  float h = map(number[i], minNumber, maxNumber, 0, height/2);
  rect(x + delta * i, y, w, -h);
  if (mouseX >= x + delta * i && mouseX <= x + delta * i + w && mouseY >= y - h && mouseY <= y) {
    textSize(20);
    text(number[i], x + delta * i + w/2 - 15, y - h - 10);
  }
}

//function drawPieChart
/* Draw the PieChart
 * @param int i: the variable used to call a certain value inside array,
 * corresponding to the looping variable i within loops.
 */
void drawPieChart(int i) {
  stroke(0);
  strokeWeight(1);
  fill(colors[i]);
  ellipseMode(CENTER);
  arc(px, py, d, d, bAngle[i], bAngle[i+1]);

  //draw the labels
  float theta = (bAngle[i] + bAngle[i+1])/2;
  float x1 = px + 0.95 * d/2 * cos(theta);
  float y1 = py + 0.95 * d/2 * sin(theta);
  float x2 = px + 1.05 * d/2 * cos(theta);
  float y2 = py + 1.05 * d/2 * sin(theta);
  stroke(255, 0, 0);
  line(x1, y1, x2, y2);
  textSize(20);
  if (theta < bAngle[5]) {
    text(crimeAcronym[i], x2 + 15, y2 + 12);
  } else if (theta < bAngle[6]) {
    text(crimeAcronym[i], x2 - 10, y2 + 30);
  } else if (theta < PI/2) {
    text(crimeAcronym[i], x2 - 20, y2 + 15);
  } else if (theta < PI) {
    text(crimeAcronym[i], x2 - 30, y2 + 20);
  } else if (theta < 3.0*PI/2) {
    text(crimeAcronym[i], x2 - 25, y2 - 5);
  } else {
    text(crimeAcronym[i], x2 + 15, y2 - 5);
  }
}


//function drawLegends
/* Draw the Legends
 */
void drawLegend() {
  //draw legend
  for (int i=0; i < c; i++) {
    noStroke();
    fill(colors[i]);
    rectMode(CORNER);
    rect(10, height/3 + i*30, 25, 25); 
    ellipseMode(CENTER);
    ellipse(245, height/3 + i*30 + 12.5, 25, 25);
    textSize(10);
    text(crimes[i] + "[" + crimeAcronym[i] + "]", 45, height/2.8 + i*30);
  }
  //draw upperleft Legends
  ellipseMode(CORNER);
  noStroke();
  fill(#5EF5D0);
  ellipse(10, 25, 30, 30);
  rect(10, 100, 30, 30);
  fill(255, 0, 0);
  textSize(15);
  text("Display Pie Chart", 45, 45);
  text("Display Bar Graph", 45, 120);

  //draw instructions
  textSize(15);
  fill(colors[13]);
  text("Save Screenshots:", 40, 160);
  textSize(10);
  text("Press 'ENTER' to save the welcoming page", 45, 180);
  text("Press 'TAB' to save the philly map", 45, 200);
  text("Press 'P or p' to save Pie Chart", 45, 220);
  text("Press 'B or b' to save Bar Graph", 45, 240);
}

//function drawSignature for my signature
/* Draw the Signature
 */

void drawSignature() {
  textSize(15);
  fill(colors[13]);
  text("Xinyue Zhang", 5 * width/6, 5 * height/6);
}