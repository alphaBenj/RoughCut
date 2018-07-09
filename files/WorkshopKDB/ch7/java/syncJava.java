// starts a java process, connects to q server

import kx.c;

public class syncJava
{
  public static void main (String[] args)
  {
    c.Flip table = null;
    c c = null; 
    try {
	// create connection to the server
	c connection=new c("localhost", 5010);
        table = (c.Flip) connection.k("select from trade");	
        System.out.println(table);   //kdb+
        String test = table.x.toString();
	System.out.println(test);
	//System.out.println(table.x.toString()); //column names
        System.out.println(table.y.toString()); //values
    }
    catch(Exception e) {
     e.printStackTrace();
    }
  }
}
