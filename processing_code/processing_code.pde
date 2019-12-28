import processing.serial.*;
Serial myPort;
 
Table table;
 
String val;
int numReadings = 10; 
int readingCounter = 0;
 
void setup() {
 String portName = Serial.list()[0];
 myPort = new Serial(this, portName, 9600);
 
  table = new Table();
 
  table.addColumn("Id");
  table.addColumn("Year");
  table.addColumn("Month");
  table.addColumn("Day");
  table.addColumn("Hour");
  table.addColumn("Minute");
  table.addColumn("Second");
  table.addColumn("Temperature");
  table.addColumn("Humidity");
  table.addColumn("Safe Level");
  table.addColumn("Water Level");
  table.addColumn("Rain Status");
  
}
 
void draw() {
 
  if(myPort.available() > 0){
    val = myPort.readStringUntil('\n');
    if(val != null){
      String[] dataValue = splitTokens(val, " ");
      System.out.println(dataValue.length);
 
      TableRow newRow = table.addRow();
      newRow.setInt("Id", table.lastRowIndex());
      newRow.setInt("Year", year());
      newRow.setInt("Month", month());
      newRow.setInt("Day", day());
      newRow.setInt("Hour", hour());
      newRow.setInt("Minute", minute());
      newRow.setInt("Second",second());
      newRow.setString("Temperature", dataValue[0].trim());
      newRow.setString("Humidity", dataValue[1].trim());
      newRow.setString("Safe Level", dataValue[2].trim());
      newRow.setString("Water Level", dataValue[3].trim());
      newRow.setString("Rain Status", dataValue[4].trim());
 
      readingCounter++;
 
     if (readingCounter % numReadings ==0)
       {
         saveTable(table, year()+"-"+month()+"-"+day()+"-"+readingCounter+".csv");
       }
    }
    println(val);
  }
}
