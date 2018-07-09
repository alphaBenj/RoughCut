// start a q session, then load Workshop/7.API/java/demo.q
// and call run_single.sh to insert records into the table.

import kx.c;

public class SingleInserter
{
  public static void main(String[] args)
  {
    try {
      c connection=new c("localhost", 5010);
      int n=1000000;
      c.Timespan time=new c.Timespan(0);
      String sym="a";
      long size=1;
      double price=1.1;
      Object[]data= {time,sym,size,price};
      long start=System.currentTimeMillis();
      for(int i=0; i<n; i++) {
        connection.ks("insert","trade",data);
      }
      long end=System.currentTimeMillis();
      System.out.println("Sent "+n+" records in "+(end-start)+"ms");
    } catch(Exception e) {
      e.printStackTrace();
    }
  }
}
