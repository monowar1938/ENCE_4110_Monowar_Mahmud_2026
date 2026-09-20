module Full_Adder(
	input a, b, cin,
	output s, cout
);
	wire w_xor1;
	
	assign w_xor1 = a ^ b;
	assign s = w_xor1 ^ cin;
	
	mux_2_1 MUX1(
		.s(w_xor1),
		.x(b),
		.y(cin),
		.m(cout)
	);
	
endmodule