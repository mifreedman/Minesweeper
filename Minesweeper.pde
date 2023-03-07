import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 450);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS] [NUM_COLS];
    for (int r = 0; r < NUM_ROWS; r++) {
      for (int c = 0; c < NUM_COLS; c++) {
        buttons [r] [c] = new MSButton(r, c);
      }
    }
    for (int i = 0; i < 40; i++) {
      setMines();
    }
}
public void setMines()
{
    int r = (int)(Math.random()*NUM_ROWS);
    int c = (int)(Math.random()*NUM_ROWS);
    if (!mines.contains(buttons[r][c]))
      mines.add(buttons[r][c]);
}

public void draw ()
{
    background(0);
    if(isWon() == true) {
        noLoop();
        displayWinningMessage();
    }
}
public boolean isWon()
{
  //ArrayList <MSButton> clickedButtons = new ArrayList <MSButton>(); 
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      if(mines.contains(buttons[r][c]) && !buttons[r][c].isFlagged()) 
        return false;
      }
    }
    return true;
  }
public void displayLosingMessage()
{
  for (int i = 0; i < mines.size(); i++)
     if (!mines.get(i).isClicked() )
     text("You lose :(", 200, 420); 
     }
public void displayWinningMessage()
{
    fill(255, 0, 0);
    text("You win!", 200, 420);
}
public boolean isValid(int r, int c)
{
    if (r>=0 && r<NUM_ROWS && c>=0 && c<NUM_ROWS)
      return true;
    else
      return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for (int r = row-1; r<= row+1; r++) {
      for (int c= col-1; c <= col+1; c++) {
        if (isValid(r, c) && mines.contains(buttons[r][c]))
          numMines++;
      }
    }
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isClicked ()
    {
      return clicked;
    }
    // called by manager
    public void mousePressed () 
    {
        clicked = true;
        if (mouseButton == RIGHT) {
          flagged = !flagged;
        if (flagged == true) 
          clicked = false;
        if (flagged == false)
          clicked = false;
        } else if (mines.contains(buttons[myRow][myCol])) {
          fill(255, 0, 0);
          noLoop();
          text("You lost :(", 200, 420); //losing message
        } else if (countMines(myRow, myCol) > 0) {
          myLabel = "" + countMines(myRow, myCol);
        } else {
        for(int c = myCol-1; c <=myCol+1; c++)
          for (int r = myRow - 1;r <= myRow+1; r++) {
            if (isValid(r, c) && !buttons[r][c].isClicked() && !mines.contains(buttons[r][c]))
              buttons[r][c].mousePressed();
          }
        }
    }
    public void draw () 
    {   
      stroke(30, 150, 150);
        if (flagged) {
            fill(180, 200, 40);
        } else if( clicked && mines.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
