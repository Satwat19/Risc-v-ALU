`timescale 1ns / 1ps

module ALU_LL_tb;

    reg clk;
    reg reset;
    reg [3:0] A, B;
    reg [3:0] G_sel;
    wire [3:0] G;
    wire [3:0] ZCNVFlags;

    ALU_LL alu (
        .clk(clk),
        .reset(reset),
        .A(A),
        .B(B),
        .G_sel(G_sel),
        .G(G),
        .ZCNVFlags(ZCNVFlags),
        .led_Z(), .led_C(), .led_N(), .led_V()
    );

    initial clk = 0;
    always #5 clk = ~clk;

    parameter ADD = 4'b0000;
    parameter SUB = 4'b0001;
    parameter XOR = 4'b1000;
    parameter OR  = 4'b1100;
    parameter AND = 4'b1110;

    initial begin
        reset = 1;
        A = 4'b0000; B = 4'b0000; G_sel = ADD;
        #12;
        reset = 0;

        A = 4'b0111; B = 4'b0001; G_sel = ADD;
        #20;

        A = 4'b0111; B = 4'b0001; G_sel = SUB;
        #20;

        A = 4'b0110; B = 4'b0011; G_sel = XOR;
        #20;

        A = 4'b0101; B = 4'b0011; G_sel = OR;
        #20;

        A = 4'b0101; B = 4'b0011; G_sel = AND;
        #20;

        $finish;
    end

    always @(posedge clk) begin
        $display("Time=%0t A=%b B=%b G_sel=%b => G=%b Flags={V=%b, N=%b, C=%b, Z=%b}",
                 $time, A, B, G_sel, G, ZCNVFlags[0], ZCNVFlags[1], ZCNVFlags[2], ZCNVFlags[3]);
    end
endmodule
