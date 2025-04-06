module sum_product();
	integer a,b;
	integer sum_init;
	
	real c,d;
	real product;
	
	initial begin
		a=5;
		b=7;
		sum_init = a+b;
		$display ("%d+%d=%d\n", a,b,sum_init);
		c= 10.23;
		d= -15.16;
		product = c*d;
		$display ("%0.2f x %0.2f = %0.2f",c,d, product);
		
	end
	
endmodule