module adder_32( //the dynamic adder design 
    input F, Cin, request,
    input [31:0] A, B,
    output Cout,
    output [31:0] sum);

    wire [31:0] P, temp_sum; // temp_sum holds sum till ready signal R is 1
    wire R;

    bitslices_32 add_logic (.a(A), .b(B), .cin(Cin), .cout(Cout), .sum(temp_sum), .p(P));

    timer timing_logic (.clk(adder_clk),.middle_p(p[17:14]), .F(F), .R(R));

    buffer_32 output_buffer (.signal(temp_sum), .enable(R), .out(sum));

endmodule


module bitslices_32(  //instantiates 32 bit slices which are connected ripple carry style
    input [31:0] a, b,
    input cin,
    output cout,
    output [31:0] p, sum);

    wire [31:0]carry;

    FA instance1 (a[0],b[0],cin,carry[0],p[0],sum[0]);

    genvar i;
    generate
        for ( i =1; i < $bits(sum); i++) begin : adder
            FA u0 (a[i],b[i],carry[i-1],carry[i],p[i],sum[i]);
        end
    endgenerate

    assign cout = carry[31];

endmodule


module FA( // dynamic adder bitslice
    input a,b, cin
    output cout, p, s);

    assign p = a^b;
    assign s = p^cin;
    assign cout = ~&{~&{a,b},~&{p,cin}};

endmodule


module buffer_32( //32bit tri-state buffer
    input [31:0] signal,
    input enable,
    output [31:0] out);

    assign out = control ? signal : 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz; 

endmodule


module timer( 
    input clk, F, // F is the "First" or start signal, it is high for the first clock cycle
    input [5:0] analyzed_p,
    output R);

    wire [3:0] full_time;
    counter_4 full_counter (clk, F, full_time);

    assign R = ~&middle_p ? &{|{full_time[2],R},~F} : &{|{&{full_time[3],full_time[0]},R},~F};

endmodule

module counter_3(     // Asynchronous up counter
    input reset,      // Asynchronous active-high reset
    output [2:0] q);

    wire S2, S1, S0;

    assign S2 = &{S2^&{S1,S0},~reset};
    assign S1 = &{S1^&{S0,1'b1},~reset};
    assign S0 = &{^{1'b1,&{S0,S0}},~reset};

    assign q = {S2,S1,S0};

endmodule


module ff (
    input clk, D,
    output reg Q, Qb);

    always @(posedge clk) Q <= D;
    assign Qb = ~Q; 

endmodule

module timer_3(
    input F, // the "first" signal
    output c0,c1,c2
);
    parameter and_d = 2, xor_d = 3; 
    wire xc0, xc1, xc2;
    wire xc0o, xc1o, xc2o;
    wire ac0, ac1, ac2;
    assign xc0o = 1'b1;
    and #(and_d) a001 (xc1o, 1'b1, c0);
    and #(and_d) a002 (xc2o, c0, c1);
    xor #(xor_d) x0 (xc0, ac0, xc0o);
    xor #(xor_d) x1 (xc1, ac1, xc1o);
    xor #(xor_d) x2 (xc2, ac2, xc2o);
    and #(and_d) a00 (c0, xc0, ~F);
    and #(and_d) a01 (c1, xc1, ~F);
    and #(and_d) a02 (c2, xc2, ~F);
    and #(and_d) a0 (ac0, c0, c0);
    and #(and_d) a1 (ac1, c1, c1);
    and #(and_d) a2 (ac2, c2, c2);
endmodule