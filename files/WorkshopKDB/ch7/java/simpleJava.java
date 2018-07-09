// starts a java process, connects to q server

import kx.c;

public class simpleJava
{
  public static void main (String[] args)
  {
    c.Flip table = null;
    c c = null; 
    try {
	// create connection to the server
	c connection=new c("localhost", 5010);
        table = (c.Flip) connection.k("select from trade");	
        System.out.println(table);
    }
    catch(Exception e) {
     e.printStackTrace();
    }
  }
}
