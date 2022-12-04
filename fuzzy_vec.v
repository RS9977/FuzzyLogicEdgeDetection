`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2022 04:21:47 PM
// Design Name: 
// Module Name: fuzzy_vec
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fuzzy_vec(clk, rst, z0, z1, z2, z3, z4, z5, z6, z7, z8, rgb, S, done);
    input clk, rst;
    input [7:0] z0, z1, z2, z3, z4, z5, z6, z7, z8;
    output [7:0] rgb, S;
    output reg done;
    
    wire [7:0] D1, D2, D3, D4;
    
    wire [9:0] D1min, D1mid, D1max;
    wire [9:0] D2min, D2mid, D2max;
    wire [9:0] D3min, D3mid, D3max;
    wire [9:0] D4min, D4mid, D4max;
    wire [9:0] Mmax, Mmid, Mmin;
 
    
    Mor_Gradient_fuzzy M_mor_fuzz(z0, z1, z2, z3, z4, z5, z6, z7, z8, D1, D2, D3, D4, S);
    
    fuzzy_val MFD1(D1, D1min, D1mid, D1max);
    fuzzy_val MFD2(D2, D2min, D2mid, D2max);
    fuzzy_val MFD3(D3, D3min, D3mid, D3max);
    fuzzy_val MFD4(D4, D4min, D4mid, D4max);
    
    Min Modmin(D1min, D2min, D3min, D4min, Mmin);
    Max Modmid(D1mid, D2mid, D3mid, D4mid, Mmid);
    Max Modmax(D1max, D2max, D3max, D4max, Mmax);

    De_fuzz MdeF(Mmin, Mmid, Mmax, rgb);
    
    reg [3:0] state;
    always @(posedge clk) begin
        if(rst) begin
            state <= 1;
            done <= 0;
        end else
        case(state)
            0: begin 
                state <= 0;
            end
            1: begin              
                state <= 2;
                done <= 0;
            end
            2: begin
                state <= 3;
                done <= 1;
            end
            3: begin
                state <= 4;
            end
            4: begin
                done <= 0;
                state <= 0;
            end
            default: state <= 0;
        endcase
    end
    
endmodule
