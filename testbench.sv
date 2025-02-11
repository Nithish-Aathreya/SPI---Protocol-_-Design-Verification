module tb_spi_master; 
    reg clk; 
    reg reset; 
    reg start; 
    reg [7:0] data_in; 
    wire mosi; 
    wire sck; 
    wire cs; 
    wire done; 
    reg miso; 
 
    // Instantiate the SPI master 
    spi_master my_spi ( 
        .clk(clk), 
        .reset(reset), 
        .start(start), 
        .data_in(data_in), 
        .mosi(mosi), 
        .sck(sck), 
        .cs(cs), 
        .miso(miso), 
        .done(done) 
    ); 
 
    // Clock generation 
    initial begin 
        clk = 0; 
        forever #5 clk = ~clk; // 10 time units clock period 
    end 
 
    // Test sequence 
    initial begin 
        // Initialize signals 
        reset = 1; 
        start = 0; 
        data_in = 8'hA5; // Example data 
        miso = 0; 
 
        // Reset the SPI master 
        #10 reset = 0; 
 
        // Start the SPI transfer 
        #10 start = 1; 
        #10 start = 0; 
 
        // Wait for transfer to complete 
        wait(done); 
        $display("Transfer complete. MOSI: %b", mosi); 
 
    
      
    end 
  
  initial begin
    wait(cs == 0); // Wait for chip select activation

    @(negedge sck) miso = 1;
    @(negedge sck) miso = 1;
    @(negedge sck) miso = 1;
    @(negedge sck) miso = 1;
    @(negedge sck) miso = 0;
    @(negedge sck) miso = 0;
    @(negedge sck) miso = 1;
    @(negedge sck) miso = 0;
    
    #50 $finish;
    
    
end

  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(0,tb_spi_master);
      
    end
endmodule 
