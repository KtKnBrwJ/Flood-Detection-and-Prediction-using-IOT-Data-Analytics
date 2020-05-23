import processing.serial.*;
Serial myPort; //creates a software serial port on which you will listen to Arduino
Table dataTable; //table where we will read in and store values.
int numReadings = 15000; //keeps track of how many readings you'd like to take before writing the file. 
int readingCounter = 0; //counts each reading to compare to numReadings. 
 
String fileName;
String val;

void setup()
{
  String portName = Serial.list()[0]; 
  dataTable = new Table();
  myPort = new Serial(this, portName, 9600); //set up your port to listen to the serial port 
  dataTable.addColumn("id"); 
  
  dataTable.addColumn("year");
  dataTable.addColumn("month");
  dataTable.addColumn("day");
  dataTable.addColumn("hour");
  dataTable.addColumn("minute");
  dataTable.addColumn("second");
  
  //Add as many columns as you have data values.
  //Make sure they are in the same order as the order that Arduino is sending them!
  dataTable.addColumn("Temparature");
  dataTable.addColumn("Humidity");
  dataTable.addColumn("Safe Level");
  dataTable.addColumn("Water Level");
  dataTable.addColumn("Rain Status");
  dataTable.addColumn("Status"); 
}
 
void serialEvent(Serial myPort){
  int stat;
  val = myPort.readStringUntil('\n'); //The newline separator separates each Arduino loop. 
                                      //We will parse the data by each newline separator. 
  if (val!= null) { 
    val = trim(val); //gets rid of any whitespace or Unicode nonbreakable space
    println(val); 
    float sensorVals[] = float(split(val, ',')); //parses the packet from Arduino and 
                                                //places the valeus into the sensorVals array. 
   
    TableRow newRow = dataTable.addRow(); //add a row for this new reading
    newRow.setInt("id", dataTable.lastRowIndex());//record a unique identifier (the row's index)
    
    //record time stamp
    newRow.setInt("year", year());
    newRow.setInt("month", month());
    newRow.setInt("day", day());
    newRow.setInt("hour", hour());
    newRow.setInt("minute", minute());
    newRow.setInt("second", second());
    
    //record sensor information. 
    newRow.setFloat("Temparature", sensorVals[0]);
    newRow.setFloat("Humidity", sensorVals[1]);
    newRow.setFloat("Safe Level", sensorVals[2]);
    newRow.setFloat("Water Level", sensorVals[3]);
    newRow.setFloat("Rain Status", sensorVals[4]);
    
    if(sensorVals[0] < 21 && sensorVals[1] < 45 && sensorVals[2] < 250 && sensorVals[3] == 1 
       && sensorVals[4] == 1111)
    stat=1;
    else
    stat=0;
    newRow.setFloat("Status",stat);
    
    readingCounter++;  
    //saves the table as a csv in the same folder as the sketch every numReadings. 
    if (readingCounter % numReadings ==0)
    {
      fileName = str(year()) + str(month()) + str(day()) + str(dataTable.lastRowIndex()) + ".csv" ;
      saveTable(dataTable, fileName);  
    }
  }
}
