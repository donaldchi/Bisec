import x10.lang.*;
import x10.util.*;

public class BisecMain {
	var filename:String;

    public  def checkArgs(args:Rail[String])
    {
        // Console.OUT.println("Check args!");
        if( args.size < 2){
        	Console.OUT.println("Not Enough Parameters!!");
        	return;
        }

		for (var i:int=0n; i<args.size; i++) 
		{   
		    if (args(i).equals("-i")) 
		    {
		        filename = args(i+1);
		    }
		}
    }

	public static def main(args:Rail[String]) {
	   val bisecMain = new BisecMain();
	   bisecMain.checkArgs(args);
	   
	   Console.OUT.println(bisecMain.filename);
	   
	   val bisec = new Bisection( bisecMain.filename );
	   
	   // Console.OUT.println("phase1Iterator, phase2Iterator = " + bisec.phase1Iterator + ", " + bisec.phase2Iterator);
	   var isTrue:boolean = true;
	   var time1:int = 0n, time2:int = 0n;
	   var iterateTime:int = 0n;
	   var lNodes:ArrayList[int];
	   var rNodes:ArrayList[int];
	   var nodes:ArrayList[int];
	   var size:int = 0n;
	   size = bisec.size + 1n;

	   while ( isTrue ){
	   		iterateTime++;
			bisec.doPartition( size, 2n, bisec.phase1Iterator, bisec.phase2Iterator );

			lNodes = new ArrayList[int]();
			rNodes = new ArrayList[int]();

			for ( v in (0n..bisec.size)){
				if ( bisec.n2c(v) == 5n ) {
					time1++;
					lNodes.add(v);
				} else if ( bisec.n2c(v) == 6n ){
					time2++;
					rNodes.add(v);
				}
			}
			if( ( time1 > 3*time2/2 ) || ( time2 > 3*time1/2 ) ){
				isTrue = true;
				bisec.n2c = new Rail[int](bisec.size+1);
				nodes = ( time1 > time2 ) ? lNodes : rNodes;
				size = Int.operator_as(nodes.size());
				var node:int = 0n;
				for( i in (0..(size-1n))){
					node = nodes.get(i);
					bisec.n2c(node) = 0n;
				}
				time1 = 0n;
				time2 = 0n;
			} else {
				isTrue = false;
			}
	   }
	   Console.OUT.println(/* "L, R, CrossEdge = " + */time1 + ", " + time2 + ", " + bisec.getCrossEdge());
	   Console.OUT.println( "iterateTime = " + iterateTime );
	   Console.OUT.println("Sequential CrossEdge");
	   Console.OUT.println(bisec.getCrossEdgeSeq());
	}
}
