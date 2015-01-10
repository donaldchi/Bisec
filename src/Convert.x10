import x10.util.*;
import x10.lang.*;
import x10.array.*;

public class Convert 
{
    var do_renumber:boolean = false;
    var infile:String = null;
    var outfile:String = null;
    var outfile_w:String = null;
    var type_file:int = 0n; //0:unweighted graph data, 1:weighted graph data
    var maxNode:int = 0n;
    var direct:int = 0n; //0:two-way graph data, 1:one-way graph data

    public def parse_args(args:Rail[String])
    {
        for (var i:int=0n; i<args.size; i++) 
        {   
            if (args(i).equals("-n")) 
            {
                maxNode = Int.parse(args(i+1));
            }
            if (args(i).equals("-i")) 
            {
                infile = args(i+1);
            }
            if (args(i).equals("-o")) 
            {
                outfile = args(i+1);    
            }
            if (args(i).equals("-r")) 
            {
                do_renumber = true;
            }
            if (args(i).equals("-w")) 
            {
                type_file = 1n;
            }
            if (args(i).equals("-d")) 
            {
                direct = 1n;
            }   
        }
    }

	public static def main(args:Rail[String]) 
	{
    	
        Console.OUT.println("Start Convert!!");
        var con:Convert = new Convert();

        if (args(0).equals("-r")) {
            Console.OUT.println("-r");
        }

        if (args.size<2) 
        {
            Console.OUT.println("Not Enough Parameter!!");
        }
        con.parse_args(args);

        Console.OUT.println("infile, outfile, outfile_w, type_file, maxNode, direct, do_renumber ");
        Console.OUT.println(con.infile+ "," + con.outfile + "," + con.outfile_w + ", " + con.type_file + ", " + con.maxNode + ", " + con.direct + ", " + con.do_renumber);
   
        con.outfile_w = con.outfile.substring(0n, con.outfile.indexOf(".bin"))+"_w.bin";
        
        var g:Graph = new Graph(con.infile, con.type_file, con.maxNode, con.direct, con.do_renumber);
        Console.OUT.println("after read file");
        if (con.do_renumber) {
            g.renumber(con.type_file);
        }

        //Console.OUT.println();
        g.display_binary(con.outfile, con.outfile_w, con.type_file); //convert to binary data file
    }
}
