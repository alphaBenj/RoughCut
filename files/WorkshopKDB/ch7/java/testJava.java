// starts a java process, connects to q server

import kx.c;
import java.util.TimeZone;

public class testJava
{
  public static void main (String[] args)
  {
	long time = System.currentTimeMillis();
	TimeZone tz = TimeZone.getDefault();
	System.out.println(tz.toString());
	long offset = tz.getOffset(time);
	System.out.println(offset);
	//tz.getOffset(x)
  
    }
  }
