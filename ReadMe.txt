1.Compile or delete file using makefile
	- make
	- make clean

2.Convert txt graph data into binary data.
	#if data start from 0~9376 then -n 9376
	-./convert -i inputfilename.txt -o outputfilename.bin -n maxnode 

  If the txt graph data is directed graph data, use option -d.

	-./convert -i inputfilename.txt -o outputfilename.bin -n maxnode -d 

3.Calculate community 
    #if data start from 0~9376 then in bisection nb_nodes = 9377, nodes = 9376
	-./bisec  -i filename.bin
