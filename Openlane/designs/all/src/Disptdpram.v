
module tdpram_32x1024 (
    input  wire         clk,
    input  wire         rst_a,
    input  wire         rst_b,
    input  wire         en_a,
    input  wire         en_b,
    input  wire         wea,       // byte write enable (not used here, assume all 4 bits = 1 if write)
    input  wire         web,
    input  wire [9:0]   addra,
    input  wire [9:0]   addrb,
    input  wire [31:0]  dina,
    input  wire [31:0]  dinb,
    output reg  [31:0]  douta,
    output reg  [31:0]  doutb
);

    // Internal memory
    reg [31:0] mem [0:1023];

    // Output registers (for READ_LATENCY = 1)
    reg [31:0] read_data_a;
    reg [31:0] read_data_b;

    // Port A
    always @(posedge clk) begin
        if (en_a) begin
            // Write operation
            if (|wea) begin
                mem[addra] <= dina;
                read_data_a <= dina; // write_first behavior
            end else begin
                read_data_a <= mem[addra];
            end
        end

        // Output register
        if (rst_a)
            douta <= 32'h0; // READ_RESET_VALUE_A = "0"
        else
            douta <= read_data_a;
    end

    // Port B
    always @(posedge clk) begin
        if (en_b) begin
            if (|web) begin
                mem[addrb] <= dinb;
                read_data_b <= dinb;
            end else begin
                read_data_b <= mem[addrb];
            end
        end

        if (rst_b)
            doutb <= 32'h0;
        else
            doutb <= read_data_b;
    end

endmodule
