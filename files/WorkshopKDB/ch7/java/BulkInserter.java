// start a q session, then load Workshop/7.API/java/demo.q
// and call run_bulk.sh to insert records into the table.

import kx.c;

public class BulkInserter
{
  public static void main(String[] args)
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
      long start=System.currentTimeMillis();
      connection.ks("insert","trade",data);
      long end=System.currentTimeMillis();
      System.out.println("Sent "+n+" records in "+(end-start)+"ms");
    } catch(Exception e) {
      e.printStackTrace();
    }
  }
}
