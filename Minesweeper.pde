//finish displayLosingMessage, make label buttons to bombs

import de.bezier.guido.*;
//Declare and initialize NUM_ROWS and NUM_COLS = 20, constants
public final static int NUM_ROWS = 25;
public final static int NUM_COLS = 25;
public final static int NUM_BOMBS = 50;
boolean startGame = false;
boolean gameOverScreen = false;
private MSButton[][] buttons; //2d array of minesweeper buttons, array of arrays
private ArrayList <MSButton> bombs = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(600, 600);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to declare and initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int rows = 0; rows < NUM_ROWS; rows++){
        for( int cols = 0; cols < NUM_COLS; cols++){
            buttons[rows][cols] = new MSButton(rows,cols);
        }
    }
    
    setBombs();
}
public void setBombs()
{
    //your code

    while(bombs.size() < NUM_BOMBS){
        int row = (int)(Math.random()*NUM_ROWS);
        int col = (int)(Math.random()*NUM_COLS);
        if(!bombs.contains(buttons[row][col])){
            bombs.add(buttons[row][col]);
        }
    }
}

public void draw ()
{
    background( 0 );
    if(isWon())
        displayWinningMessage();
}
public boolean isWon()
{
    //your code here
    for( int r = 0; r < NUM_ROWS; r++){
        for( int c = 0; c < NUM_COLS; c++){
            if(!buttons[r][c].isClicked() && !buttons[r][c].isMarked() ){
                return false;
            }
        }
    }

    return true;
}
public void displayLosingMessage()
{
    //your code here
    String losingMessage = "LOSER!";
    for( int r = 0; r < NUM_ROWS; r++){
        for( int c = 0; c < NUM_COLS; c++){
            if(bombs.contains(buttons[r][c])){
                buttons[r][c].setLabel("B");
            }
            if(!bombs.contains(buttons[r][c])){
                buttons[r][c].setClick();
            }
        }
    }
    for( int i = 0; i < losingMessage.length(); i++){
        buttons[NUM_ROWS/2][NUM_COLS/2 - losingMessage.length()/2 + i].setLabel(losingMessage.substring(i, i+1));
        bombs.add(buttons[NUM_ROWS/2][NUM_COLS/2 - losingMessage.length()/2 + i]);
        buttons[NUM_ROWS/2][NUM_COLS/2 - losingMessage.length()/2 + i].setClick();
    }
}
public void displayWinningMessage()
{
    //your code here
    String winningMessage = "WINNER";
    for( int i = 0; i < winningMessage.length(); i++){
        buttons[NUM_ROWS/2][NUM_COLS/2 - winningMessage.length()/2 + i].setLabel(winningMessage.substring(i, i+1));
        bombs.add(buttons[NUM_ROWS/2][NUM_COLS/2 - winningMessage.length()/2 + i]);
        buttons[NUM_ROWS/2][NUM_COLS/2 - winningMessage.length()/2 +i].setClick();
    }
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
        width = 600/NUM_COLS;
        height = 600/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    public void setClick(){
        clicked = true;
    }
    // called by manager
    
    public void mousePressed () 
    {
        clicked = true;
        if(mouseButton == RIGHT){
            marked = !marked;
        }
        else if(bombs.contains(this)){
            displayLosingMessage();
        }
        else if(countBombs(r, c) > 0){
            setLabel(str(countBombs(r,c)));
        }
        else{
            if(isValid(r,c-1) && !buttons[r][c-1].clicked){
                buttons[r][c-1].mousePressed();
            }
            if(isValid(r-1,c-1) && !buttons[r-1][c-1].clicked){
                buttons[r-1][c-1].mousePressed();
            }
            if(isValid(r-1,c) && !buttons[r-1][c].clicked){
                buttons[r-1][c].mousePressed();
            }
            if(isValid(r-1,c+1) && !buttons[r-1][c+1].clicked){
                buttons[r-1][c+1].mousePressed();
            }
            if(isValid(r,c+1) && !buttons[r][c+1].clicked){
                buttons[r][c+1].mousePressed();
            }
            if(isValid(r+1,c+1) && !buttons[r+1][c+1].clicked){
                buttons[r+1][c+1].mousePressed();
            }
            if(isValid(r+1,c) && !buttons[r+1][c].clicked){
                buttons[r+1][c].mousePressed();
            }
            if(isValid(r+1,c-1) && !buttons[r+1][c-1].clicked){
                buttons[r+1][c-1].mousePressed();
            }
        }
    }

    public void draw () 
    {    
        if (marked)
            fill(0);
        else if( clicked && bombs.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill(200); //after clicking the button
        else 
            fill(100); //display color
        stroke(0);
        rect(x, y, width, height);
        fill(0);
        stroke(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
        if(r >= 0 && r <= NUM_ROWS-1 && c >= 0 && c <= NUM_COLS-1){
            return true;
        }
        else return false;
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        if( isValid(row,col-1) && bombs.contains(buttons[row][col-1])){
            numBombs += 1;
        }
        if( isValid( row-1, col-1) && bombs.contains(buttons[row-1][col-1])){
            numBombs += 1;
        }
        if( isValid( row-1, col) && bombs.contains(buttons[row-1][col])){
            numBombs += 1;
        }
        if( isValid( row-1, col+1) && bombs.contains(buttons[row-1][col+1])){
            numBombs += 1;
        }
        if( isValid( row, col+1) && bombs.contains(buttons[row][col+1])){
            numBombs += 1;
        }
        if( isValid( row+1, col+1) && bombs.contains(buttons[row+1][col+1])){
            numBombs += 1;
        }
        if( isValid( row+1, col) && bombs.contains(buttons[row+1][col])){
            numBombs += 1;
        }
        if( isValid( row+1, col-1) && bombs.contains(buttons[row+1][col-1])){
            numBombs += 1;
        }
        return numBombs;
    }
}



