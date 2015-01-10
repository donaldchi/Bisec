import x10.lang.*;
import x10.util.*;
import x10.compiler.*;

public class Bisection {
	static val NoGroup = 0n; //belong to none group
	static val L1 = 1n, R1 = 2n; 
	static val L2 = 3n, R2 = 4n; 
	static val L  = 5n, R  = 6n; //present partition names

	static val PhaseOne   = 1n;
	static val PhaseTwo   = 2n;
	static val PhaseThree = 3n;
	static val PhaseFour  = 4n;

	var g:Graph;
	var size:int;
	var n2c:Rail[int];
	val r = new Random();

	var phase1Iterator:int;
	var phase2Iterator:int;
	var phase3Iterator:int; //set every phase's iterate time

	var nodeLValue:int  = 0n;
	var nodeRValue:int  = 0n;; //store LValue, RValue 
	var xValue:int = 0n; //store the value for deciding group 

	public def this(){}

	public def this( fileName:String ){
		g = new Graph(fileName, null, 0n);
		size = g.nb_nodes;
		n2c = new Rail[int](size+1);
		for( i in (0..size)){
			n2c(i) = NoGroup;
		}
	}

	public def setParameters( size:Long ){
		var epsilon:double = 1 - ( Math.log10(16) / Math.log10(size) )/2;
		epsilon = epsilon - 0.1;
		phase1Iterator = Int.operator_as(Math.pow( size, epsilon ));
		phase2Iterator = Int.operator_as(( size ) / 4) + phase1Iterator;
	}

	public def getCrossEdge(){
		var crossEdge:int  = 0n;
		var startIndex:int = 0n;
		var neigh:int      = 0n;
		var neigh_comm:int = 0n;
		var node_comm:int  = 0n;

		for( node in (0n..size)){
			node_comm = n2c(node);
			if (node == 0n) 
		        startIndex = 0n;
		    else
		        startIndex = g.degrees( node-1n );
		    val deg = g.degrees(node);
		    for ( var i:int = startIndex; i<deg; i++)
		    {
				neigh = g.links(i);
				neigh_comm = n2c(neigh);
				crossEdge += ( node_comm == neigh_comm ) ? 0 : 1 ;
		    }    
		}
		return crossEdge / 2;
	}

	public def getCrossEdgeSeq(){

		var crossEdge:int = 0n;
		var nodeRan:int = 0n; 
		var startIndex:int = 0n;
		var neigh:int      = 0n;
		var neigh_comm:int = 0n;
		var node_comm:int  = 0n;
		// get the number of cross edge when sequentially devide the graph
		var random_order:Rail[int] = new Rail[int](size+1);
		for ( i in (0n..size)) {
			random_order(i) = i;
		}
		var rand_pos:int, tmp:int;
		for ( i in (0n..size)) {
			rand_pos = r.nextInt( size + 1n );
			tmp = random_order(i);
			random_order(i) = random_order(rand_pos);
			random_order(rand_pos) =tmp;	
		}
		
		for( i in (0..size)){
			nodeRan = random_order(i);
			n2c(nodeRan) = ( i < size / 2 ) ? L : R ;
		}

		for( node in (0n..size)){
			node_comm = n2c(node);
			if (node == 0n) 
		        startIndex = 0n;
		    else
		        startIndex = g.degrees( node-1n );
		    val deg = g.degrees(node);
		    for ( var i:int = startIndex; i<deg; i++)
		    {
				neigh = g.links(i);
				neigh_comm = n2c(neigh);
				crossEdge += ( node_comm == neigh_comm ) ? 0 : 1 ;
		    }    
		}

		return crossEdge / 2;
	}

	public def getNeighbors( node:int, phaseType:int ){
		var startIndex:int = 0n;
		var neigh:int      = 0n;
		var neigh_comm:int = 0n;
		var neigh_selected:int = -1n; //store selected neigh node
		var computeL:int = phaseType > 1n ? ( (phaseType > 2n) ? L : L2 ) : L1;
		var computeR:int = phaseType > 1n ? ( (phaseType > 2n) ? R : R2 ) : R1;
		// Console.OUT.println("phaseType, computeL, computeR = " + phaseType + ", " + computeL + ", " + computeR);
		nodeLValue = 0n;
		nodeRValue = 0n;

		if (node == 0n) 
	        startIndex = 0n;
	    else
	        startIndex = g.degrees( node-1n );
	    val deg = g.degrees(node);
	    var num:int = r.nextInt(deg-startIndex);
	    for ( var i:int = startIndex; i<deg; i++)
	    {
			neigh = g.links(i);
			neigh_comm = n2c(neigh);
			if( neigh_comm > 4n ) continue;
			if( i == (startIndex + num))
				neigh_selected = neigh;
			// if ( neigh_comm == NoGroup ) {
			// 	neigh_selected = neigh;
			// }
			nodeLValue = (neigh_comm == computeL) ? nodeLValue + 1n : nodeLValue;
			nodeRValue = (neigh_comm == computeR) ? nodeRValue + 1n : nodeRValue;
	    }
	    return neigh_selected;
	} 

	public def decideGroup( node:int, neigh:int, xValue:int, phaseType:int ){
		//decide the group of the node
		nodeLValue = 0n;
		nodeRValue = 0n; //decide which R and L will be used

		switch( phaseType ){
			case 1n: 
				nodeRValue = R1;
				nodeLValue = L1;
				break;
			case 2n: 
				nodeRValue = R2;
				nodeLValue = L2;
				break;
		}

		if( xValue > 0n ){
			n2c(node)  = nodeLValue;
			n2c(neigh) = nodeRValue; 
		} else if ( xValue == 0n ){
			var num:int = r.nextInt(4n); //if xValue = 0n, put node, neigh equiprobably
			switch(num){
				case 0n:
					n2c(node)  = nodeLValue; 
					n2c(neigh) = nodeRValue;
					break;
				case 1n: 
					n2c(node)  = nodeLValue; 
					n2c(neigh) = nodeLValue;				
					break;
				case 2n: 
					n2c(node)  = nodeRValue; 
					n2c(neigh) = nodeLValue;
					break;
				case 3n: 
					n2c(node)  = nodeRValue; 
					n2c(neigh) = nodeRValue;
					break;
			}
		} else {
			n2c(node)  = nodeRValue;
			n2c(neigh) = nodeLValue; 			
		}
	}

	public def doPartition( sizeVal:int, partitionNum:int, phase1Iterator:int, phase2Iterator:int ){
		//set parameter n2 = n/4, epsilon, n1 = n^(1-epsilon/2)
		setParameters( sizeVal );
		//partitionNum: 2 - bisection, l: l-partition
		//randomize nodes
		var random_order:Rail[int] = new Rail[int](size+1);
		for ( i in (0n..size)) {
			random_order(i) = i;
		}
		var rand_pos:int, tmp:int;
		for ( i in (0n..size)) {
			rand_pos = r.nextInt( size + 1n );
			tmp = random_order(i);
			random_order(i) = random_order(rand_pos);
			random_order(rand_pos) =tmp;	
		}

		//do phase 1 and 2, and store data for phase 3
		var iterator:int = 0n;
		var node:int, neigh:int;
		var time1:int = 0n, time2:int = 0n, time3:int = 0n;
		var phaseType:int;
		val newPhase2Iterator = phase1Iterator + phase2Iterator;
		for ( v in (0n..size)){
			xValue = 0n;
			node = random_order(v);
			if( n2c(node) > 4n ) continue;
			iterator++;
			if ( iterator <= phase1Iterator ){
				phaseType = PhaseOne;
				// time1++;
			} else if ( iterator <= newPhase2Iterator){
				phaseType = PhaseTwo;
				// time2++;
			} else {
				phaseType = PhaseThree;
				// time3++;
			}
			neigh = getNeighbors( node, phaseType );
			// if ( neigh < 0n ) { //if there is no unselected neigh node -> none iterate, select next node
			// 	iterator--;
			// 	continue;
			// }
			switch( phaseType ){
				case 1n: 
				case 2n:
					xValue = nodeLValue - nodeRValue;
					// Console.OUT.print("node, nodeLValue, nodeRValue = ");
					// Console.OUT.println(node + ", " + nodeLValue + ", " + nodeRValue);
					getNeighbors( neigh, phaseType );
					xValue = xValue - nodeLValue + nodeRValue;
					// Console.OUT.print("neigh, nodeLValue, nodeRValue, xValue = ");
					// Console.OUT.println(neigh + ", " + nodeLValue + ", " + nodeRValue + ", " + xValue);
					decideGroup( node, neigh, xValue, phaseType );
					break; // both in case 1 and case 2 will do the same thing
				case 3n:
					//Console.OUT.println("case3, node, LValue = " + node + ", " + nodeLValue); 
					break;
			}
		}

		// Console.OUT.println("time1, time2, time3 = " + time1 + ", " + time2 + ", " + time3);
		var l2v:ArrayList[NodeGroupPair]; //weight between node and L2
		l2v = new ArrayList[NodeGroupPair]();
		var ngp:NodeGroupPair;

		val remain = new ArrayList[int]();

		time1 = 0n; time2 = 0n; time3 =0n;
		for ( v in (0n..size)) {
			node = random_order(v);
			if( n2c(node) == 0n){
				getNeighbors( node, PhaseThree );
				ngp = new NodeGroupPair( node, nodeLValue );
				l2v.add(ngp);
				time1++;
			} else {
				remain.add(node);
				time2++;
			}
		}
		// Console.OUT.println("time1, time2, time3, l2v.size = " + time1 + ", " + time2 + ", " + time3 + ", " + l2v.size());

		l2v.sort();
		// for( var i:int = 0n; i < l2v.size(); i++ ){
		// 	Console.OUT.println("ndoe, l2v =  " + l2v(i).node + ", " + l2v(i).toGroupValue);
		// }

		val itt = l2v.iterator();
		var thisValue:int = itt.next().toGroupValue, nextValue:int = 0n;
		var maxValue:int = 0n, maxNode:int = 0n; 
		while( itt.hasNext() ){
			ngp = itt.next();
			nextValue = ngp.toGroupValue;
			if( maxValue < (nextValue - thisValue) ){
				maxValue = nextValue - thisValue;
				maxNode  = ngp.node; 
			}
			thisValue = nextValue;
		}
		// Console.OUT.println("maxNode, maxValue = " + maxNode + ", " + maxValue);
		time1 = 0n; time2 = 0n; time3 = 0n;
		for ( var i:int = 0n; i < l2v.size(); i++) {
			if( l2v(i).toGroupValue >= maxValue ){
				n2c(l2v(i).node) = L;
				time1++;
			} else {
				time2++;
				n2c(l2v(i).node) = R;
			}
		}
		// Console.OUT.println("time1, time2, time3 = " + time1 + ", " + time2 + ", " + time3);
		for ( var i:int = 0n; i < remain.size(); i++ ) {
			node = remain(i);
			getNeighbors(node, PhaseFour);
			if( nodeLValue > nodeRValue ){
				n2c(node) = L;
				time1++;
			}else{
				n2c(node) = R;
				time2++;
			}
		}
	}
}
