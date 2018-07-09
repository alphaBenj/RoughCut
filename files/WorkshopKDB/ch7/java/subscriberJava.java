// Subscribes to a kdb+ process and calls k method in a while loop
import java.io.IOException;

import kx.c;
import kx.c.KException;

public class subscriberJava {

	public static void main(String[] args) {
	try {
		c con = new c("localhost", 5010);
		con.k(".u.sub[`trade;`]"); 

		while (true) {
    		try {
        		Object r = con.k();
        		if (r != null) {
            		Object[] data = (Object[]) r;

            		String tblname = (data[1]).toString();
            		c.Flip tbl = (c.Flip) data[2];
            		String[] colNames = tbl.x;
            		Object[] colData = tbl.y;

            		String s = tblname + " update. row 1/" + colData.length + " ->";
            		for (int i = 0; i < colData.length; i++) {
                	s += " " + colNames[i] + ":" + c.at(colData[i], 0).toString();
            		}
            		System.out.println(s);
        				}
    		    } catch (Exception e) {
            	System.err.println(e.toString());
    		  }	 	
		}
		} catch (KException e) {
                        e.printStackTrace();
                } catch (IOException e) {
                        e.printStackTrace();
            }

        }
}
