import de.bezier.guido.*;
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
private boolean gg = false;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines; //ArrayList of just the minesweeper buttons that are mined
public void setup () {
  loop();
  size(400, 400);
  textAlign(CENTER, CENTER);
  // make the manager
  Interactive.make( this );
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int i = 0; i < NUM_ROWS; i++) {
    for (int j = 0; j < NUM_COLS; j++) {
      buttons[i][j] = new MSButton(i, j);
    }
  }
  mines = new ArrayList<MSButton>();
  for (int i = 0; i < 30; i++) {
    setmines();
  }
}
public void setmines() {
  int row = (int)(Math.random()*NUM_ROWS);
  int col = (int)(Math.random()*NUM_COLS);
  if (mines.contains(buttons[row][col])) {
    setmines();
  } 
  else {
    mines.add(buttons[row][col]);
  }
}

public void draw () {
  background( 0 );
  if (isWon()) {
    displayWinningMessage();
    noLoop();
  }
  if(gg) {
    displayLosingMessage();
    noLoop();
  }
}
public boolean isWon() {
  for (int i = 0; i < NUM_ROWS; i++) {
    for (int j = 0; j < NUM_COLS; j++) {
      if (!mines.contains(buttons[i][j]) && buttons[i][j].isClicked() == false) {
        return false;
      }
    }
  }
  return true;
}
public void displayLosingMessage() {
  buttons[0][5].setLabel("G");
  buttons[0][6].setLabel("A");
  buttons[0][7].setLabel("M");
  buttons[0][8].setLabel("E ");
  buttons[0][9].setLabel("");
  buttons[0][10].setLabel("O");
  buttons[0][11].setLabel("V");
  buttons[0][12].setLabel("E");
   buttons[0][13].setLabel("R");
  for (int i = 5; i < 14; i++) {
    buttons[0][i].setColor(255);
  }
}
public void displayWinningMessage() {
  buttons[0][6].setLabel("Y");
  buttons[0][7].setLabel("O");
  buttons[0][8].setLabel("U");
  buttons[0][9].setLabel(" ");
  buttons[0][10].setLabel("W");
  buttons[0][11].setLabel("I");
  buttons[0][12].setLabel("N");
  buttons[0][13].setLabel("!");
  for (int i = 6; i < 14; i++) {
    buttons[0][i].setColor(255);
  }
}

public class MSButton {
  private int r, c;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String label;
  private color textColor;
  public MSButton ( int rr, int cc ) {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    r = rr;
    c = cc; 
    x = c*width;
    y = r*height;
    label = "";
    flagged = clicked = false;
    textColor = 0;
    Interactive.add( this ); // register it with the manager
  }
  
    
  // called by manager
  public void mousePressed () {
    clicked = true;
    flagged = false;
    if (mines.contains(this)) {
      for (int i = 0; i < mines.size(); i++) {
        mines.get(i).setClicked(true);
      }
      gg = true;
    } 
    else if (countmines(r, c) > 0) {
      setLabel(str(countmines(r, c)));
    } 
    else {
      for (int row = r-1; row < r+2; row++) {
        for (int col = c-1; col < c+2; col++) {
          if (isValid(row, col) && !buttons[row][col].isClicked()) {
            buttons[row][col].mousePressed();
          }
        }
      }
    }
  }

  public void draw () {  
    if (flagged) {
      fill(0);
    }
    else if (clicked && mines.contains(this)) {
      fill(255, 0, 0);
    }
    else if (clicked) {
      fill( 200 );
    }
    else { 
      fill(100);
    }
    rect(x, y, width, height);
    fill(textColor);
    text(label, x+width/2, y+height/2);
    if (!isClicked() && keyPressed && mouseX > x && mouseX < x + 20 && mouseY > y && mouseY < y+20) {
      flagged = !flagged;
      if (!flagged) {
        clicked = false;
      }
    }
  }
  public void setLabel(String newLabel) {
    label = newLabel;
  }
  public boolean isValid(int r, int c) {
    if (r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS) {
      return true;
    } 
    else {
      return false;
    }
  }
  public int countmines(int row, int col) {
    int nummines = 0;
    for (int i = row-1; i < row+2; i++) {
      for (int j = col-1; j < col+2; j++) {
        if (isValid(i, j) && mines.contains(buttons[i][j])) {
          nummines+=1;
        }
      }
    }
    return nummines;
  }
  public boolean isflagged() {
    return flagged;
  }
  public boolean isClicked() {
    return clicked;
  }
  public void setColor(color tc) {
    textColor = tc;
  }
  private void setClicked(boolean rev) {
    clicked = rev; //attempting to use to fix github crash. doesnt work but i like how it looks so keeping it
  }
}
