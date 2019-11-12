Simulation sim;
int rows;
int cols;

void setup(){

  size(1525, 700); //screen size in hard pixels
  rows = width;
  cols = height;
  
  sim = new Simulation(rows,cols-200);
  //decreasing cols by 200 results in 200*rows box for buttons on bottom
  //space for buttons and sliders is 900 wide and 200 high(700-900)

}

void draw(){
  
  sim.display();
  
  if (mousePressed){
    sim.mousePressed();
  }      
  
  if (keyPressed){
    sim.keyPressed();
  }
  
}
