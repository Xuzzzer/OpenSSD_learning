module RTL_Simple_Dual_Port_RAM
#(
    parameter ADDR_A_WIDTH = 14,
    parameter ADDR_B_WIDTH = 13,
    parameter WRITE_DATA_WIDTH_A = 16,
    parameter READ_DATA_WIDTH_B = 32,
    parameter MEM_DEPTH  = 16384 // 2^14
)
(

    input                               clk,
    //Write Port        
    input                               ena,    
    input  [ADDR_A_WIDTH-1:0]           addra,  
    input  [WRITE_DATA_WIDTH_A-1:0]     dina,   
    //Read Port
    input                               enb,    
    input  [ADDR_B_WIDTH-1:0]           addrb,  
    output reg [READ_DATA_WIDTH_B-1:0]  doutb   
);
 
    reg [ADDR_A_WIDTH-1:0] mem [0:MEM_DEPTH-1];

    always @(posedge clk) begin
        if (ena) begin
            mem[addra] <= dina;
        end
    end

    always @(posedge clk) begin
        if (enb) begin
            doutb <= {mem[{addrb, 1'b1}], mem[{addrb, 1'b0}]}; 
        end
    end

endmodule