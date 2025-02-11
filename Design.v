module spi_master ( 
    input wire clk, 
    input wire reset, 
    input wire start, 
    input wire [7:0] data_in, 
    output reg mosi, 
    output reg sck, 
    output reg cs,    //active low
    input wire miso, 
    output reg done 
); 
    reg [3:0] bit_count; 
    reg [7:0] shift_reg; 
    reg state; 
 
    localparam IDLE = 1'b0; 
    localparam TRANSFER = 1'b1; 
 
    always @(posedge clk or posedge reset) begin 
        if (reset) begin 
            mosi <= 0; 
            sck <= 0; 
            cs <= 1; 
            done <= 0; 
            state <= IDLE; 
            bit_count <= 0; 
        end else begin 
            case (state) 
                IDLE: begin 
                    cs <= 1; // Chip select inactive 
                    done <= 0; 
                    if (start) begin 
                        cs <= 0; // Chip select active 
                        shift_reg <= data_in; 
                        bit_count <= 8; 
                        state <= TRANSFER; 
                    end 
                end 
 
                TRANSFER: begin 
                    if (bit_count > 0) begin 
                        sck <= ~sck; // Toggle clock 
                        if (!sck) begin
    mosi <= shift_reg[7];  // Send MSB
end 
                      else begin
    shift_reg <= {shift_reg[6:0], miso};  // Shift in MISO
    bit_count <= bit_count - 1;
end

                      
                    end else begin 
                        cs <= 1; // Chip select inactive 
                        done <= 1; // Indicate transfer complete 
                        state <= IDLE; 
                    end 
                end 
            endcase 
        end 
    end 
endmodule 
