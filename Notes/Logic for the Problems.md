
1. Edge / Pulse detector [[Edge_Detector or Pulse_Detector]]
	1. Using FF delay
		1. Postive edge : original_signal & ~delayed signal
		2. Negative edge : ~original_signal  & delayed signal
		3. Toggle : original signal ^ delayed signal
	2. Using Shift register delay
		1. Pattern detection 
		2. One pulse trigger 
			1. (~signal_in & delay_in_1 & ~delay_in_2 ) (010)
			2.  (signal_in & ~delay_in_1 & delay_in_2 ) (101)
2. Binary to Gray [[Binary_to_gray]]
	1. 