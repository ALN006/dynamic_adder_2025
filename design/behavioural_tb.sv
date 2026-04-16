`timescale 1ns/1ps
`include "adder_behavioural.sv"

module CRCA_multi_tb;

    // Bitwidths
    localparam N0 = 8;
    localparam N1 = 12;
    localparam N2 = 16;
    localparam N3 = 20;
    localparam N4 = 24;
    localparam N5 = 28;
    localparam N6 = 32;

    reg Cin, first, request;

    // Inputs
    reg [N0-1:0] A0, B0;
    reg [N1-1:0] A1, B1;
    reg [N2-1:0] A2, B2;
    reg [N3-1:0] A3, B3;
    reg [N4-1:0] A4, B4;
    reg [N5-1:0] A5, B5;
    reg [N6-1:0] A6, B6;

    // Outputs
    wire ready0, ready1, ready2, ready3, ready4, ready5, ready6;
    wire [N0-1:0] S0;
    wire [N1-1:0] S1;
    wire [N2-1:0] S2;
    wire [N3-1:0] S3;
    wire [N4-1:0] S4;
    wire [N5-1:0] S5;
    wire [N6-1:0] S6;

    wire Cout0, Cout1, Cout2, Cout3, Cout4, Cout5, Cout6;

    // Instantiate DUTs
    CRCA #(.N(N0)) d0 (.A(A0), .B(B0), .Cin(Cin), .first(first), .request(request), .S(S0), .Cout(Cout0), .ready(ready0));
    CRCA #(.N(N1)) d1 (.A(A1), .B(B1), .Cin(Cin), .first(first), .request(request), .S(S1), .Cout(Cout1), .ready(ready1));
    CRCA #(.N(N2)) d2 (.A(A2), .B(B2), .Cin(Cin), .first(first), .request(request), .S(S2), .Cout(Cout2), .ready(ready2));
    CRCA #(.N(N3)) d3 (.A(A3), .B(B3), .Cin(Cin), .first(first), .request(request), .S(S3), .Cout(Cout3), .ready(ready3));
    CRCA #(.N(N4)) d4 (.A(A4), .B(B4), .Cin(Cin), .first(first), .request(request), .S(S4), .Cout(Cout4), .ready(ready4));
    CRCA #(.N(N5)) d5 (.A(A5), .B(B5), .Cin(Cin), .first(first), .request(request), .S(S5), .Cout(Cout5), .ready(ready5));
    CRCA #(.N(N6)) d6 (.A(A6), .B(B6), .Cin(Cin), .first(first), .request(request), .S(S6), .Cout(Cout6), .ready(ready6));

    integer file;
    integer i;

    integer t0, t1, t2, t3, t4, t5, t6;
    integer lat0, lat1, lat2, lat3, lat4, lat5, lat6;

    initial begin
        file = $fopen("latency_multi.csv", "w");
        $fwrite(file, "bitwidth,A,B,Cin,Latency\n");

        Cin = 0;
        first = 1;
        request = 0;

        #5;
        first = 0;

        for (i = 0; i < 100_000; i = i + 1) begin

            // Random inputs
            A0 = $urandom % (1 << N0); B0 = $urandom % (1 << N0);
            A1 = $urandom % (1 << N1); B1 = $urandom % (1 << N1);
            A2 = $urandom % (1 << N2); B2 = $urandom % (1 << N2);
            A3 = $urandom % (1 << N3); B3 = $urandom % (1 << N3);
            A4 = $urandom % (1 << N4); B4 = $urandom % (1 << N4);
            A5 = $urandom % (1 << N5); B5 = $urandom % (1 << N5);
            A6 = $urandom % (1 << N6); B6 = $urandom % (1 << N6);

            Cin = $urandom % 2;

            // Reset timers
            first = 1;
            #1;
            first = 0;

            request = 1;

            t0 = $time; t1 = $time; t2 = $time; t3 = $time;
            t4 = $time; t5 = $time; t6 = $time;

            fork
                begin wait(ready0); lat0 = $time - t0; $fwrite(file,"%0d,%0d,%0d,%0d,%0d\n",N0,A0,B0,Cin,lat0); end
                begin wait(ready1); lat1 = $time - t1; $fwrite(file,"%0d,%0d,%0d,%0d,%0d\n",N1,A1,B1,Cin,lat1); end
                begin wait(ready2); lat2 = $time - t2; $fwrite(file,"%0d,%0d,%0d,%0d,%0d\n",N2,A2,B2,Cin,lat2); end
                begin wait(ready3); lat3 = $time - t3; $fwrite(file,"%0d,%0d,%0d,%0d,%0d\n",N3,A3,B3,Cin,lat3); end
                begin wait(ready4); lat4 = $time - t4; $fwrite(file,"%0d,%0d,%0d,%0d,%0d\n",N4,A4,B4,Cin,lat4); end
                begin wait(ready5); lat5 = $time - t5; $fwrite(file,"%0d,%0d,%0d,%0d,%0d\n",N5,A5,B5,Cin,lat5); end
                begin wait(ready6); lat6 = $time - t6; $fwrite(file,"%0d,%0d,%0d,%0d,%0d\n",N6,A6,B6,Cin,lat6); end
            join

            request = 0;
            #10;
        end

        $fclose(file);
        $finish;
    end

endmodule