module adder_32( //the dynamic adder design 
    input F, cin, adder_clk,
    input [31:0] a, b,
    output cout,
    output [31:0] sum);

    wire [31:0] p, temp_sum; // temp_sum holds sum till ready signal R is 1
    wire R;

    bitslices_32 add_logic (.a(a), .b(b), .cin(cin), .cout(cout), .sum(temp_sum), .p(p));

    timer timing_logic (.clk(adder_clk, ).middle_p(p[17:14]), .F(F), .R(R));

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


module timer( //timing logic. limitations -> 1. clk has to be a factor of system clk and greater than three gate delays 2. has the area of approximately 4 bit slices
    input clk, F, // F is the "First" or start signal
    input [3:0] middle_p,
    output R);

    wire [3:0] full_time;
    counter_4 full_counter (clk, F, full_time);

    assign R = ~&middle_p ? &{|{full_time[2],R},~F} : &{|{&{full_time[3],full_time[0]},R},~F};

endmodule

module counter_4(
    input clk,
    input reset,      // Synchronous active-high reset
    output [2:0] q);

    reg S3, S2, S1, S0, S3b, S2b, S1b, S0b;

    ff i3 (clk,&{S3^&{S2,S1,S0},~reset},S3,S3b);
    ff i2 (clk,&{S2^&{S1,S0},~reset},S2,S2b);
    ff i1 (clk,&{S1^S0,~reset},S1,S1b);
    ff i0 (clk,&{~S0,~reset},S0,S0b);

    assign q = {S3,S2,S1,S0};

endmodule


module ff (
    input clk, D,
    output reg Q, Qb);

    always @(posedge clk) Q <= D;
    assign Qb = ~Q; 

endmodule