// starts a java process, connects to q server

import kx.c;

public class asyncJava
{
  public static void main (String[] args)
  {      
    try {
        c connection=new c("localhost", 5010);
        int n=1000000;
        c.Timespan[]time=new c.Timespan[n];
  	String[]sym=new String[n];
        long[]size=new long[n];
        double[]price=new double[n];
        for(int i=0; i<n; i++) {
        time[i]=new c.Timespan(i);
        sym[i]="a";
        size[i]=i;
        price[i]=12.0+0.01*Math.floor(100*Math.random()-50);
      }
	Object[]data= {time,sym,size,price};
	connection.ks("insert","trade",data);
    }   
    catch(Exception e) {
     e.printStackTrace();
    }
  } 
}
