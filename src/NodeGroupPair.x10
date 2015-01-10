import x10.util.*;
import x10.lang.*;

//node to group, this class is written for store the node and the the weight between node and one group 
public class NodeGroupPair implements x10.lang.Comparable[NodeGroupPair]{
	var node:int;
	var toGroupValue:int;

	public def this(){

	}

	public def this( node:int, toGroupValue:int ){
		this.node  = node;
		this.toGroupValue = toGroupValue;
	}

	//@Override compareTo to use the sort() method
	public def compareTo( any:NodeGroupPair ){
		val newNg:NodeGroupPair;
		newNg = any;
		return this.toGroupValue - newNg.toGroupValue;
	}
}
