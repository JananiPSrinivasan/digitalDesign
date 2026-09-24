- Refresh Concepts : 
	- Refer [[FIFO Concepts]]

- Thought Process :
	1. Problem is asking for parameterized FIFO
	2. The FIFO is synchronous (No CDC, so no need for pointer sync)
	3. Do successful Read and Write
	4. Occupancy Tracking means maintain a counter to track valid entries
	5. Generate flags based on conditions
- starting to code
	1. Create parameter
	2. Create I/O
	3. Before anything we have a condition to be checked which is the depth and width of FIFO. Check them using assertions
	4. now, you need the actual memory, so Create a memory. This is the FIFO memory with valid depth and width
	5. Now since we have the memory we need pointers and counters to navigate through
	6. 
	7. 



