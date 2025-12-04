module rsa_uart_tb;
    reg clk, reset;
    reg send;
    reg [7:0] plaintext;
    wire [7:0]  decrypted;
 wire [7:0] ciphertext;
    wire uart_tx_signal;
    wire uart_rx_signal; // Now a wire
    wire [7:0] received_data;
    wire received_flag;

    // Instantiate RSA Module
    rsa rsa_module (
        .clk(clk),
        .reset(reset),
        .plaintext(plaintext),
        .ciphertext(ciphertext),
        .decrypted(decrypted)
    );

    // Instantiate UART Transmitter
    uart_tx uart_tx_module (
        .clk(clk),
        .send(send),
        .data_in(ciphertext),
        .tx(uart_tx_signal)
    );

    // Loopback: connect TX to RX
    assign uart_rx_signal = uart_tx_signal;

    // UART Receiver
    uart_rx uart_rx_module (
        .clk(clk),
        .rx(uart_rx_signal),
        .data_out(received_data),
        .received(received_flag)
    );

    // Clock Generation
    always #5 clk = ~clk;

    initial begin
        // VCD dump for waveform
        $dumpfile("waveform.vcd");
        $dumpvars(0, rsa_uart_tb);

        clk = 0;
        reset = 1;
        plaintext = 12;  
        send = 0;

        #10 reset = 0;
        #10 send = 1; // Start sending
        #20 send = 0; // Stop sending

        // Wait long enough for UART transfer to complete
        #200;

        $display("Original Plaintext: %d", plaintext);
        $display("Encrypted Ciphertext: %d", ciphertext);
        $display("Received Data: %d", received_data);
        $display("Decrypted Plaintext: %d", decrypted);

        if (decrypted == plaintext)
            $display("RSA over UART SUCCESSFUL!");
        else
            $display("RSA over UART FAILED!");

        if (ciphertext == received_data)
            $display("UART RX matched TX data.");
        else
            $display("UART RX data mismatch.");

        $finish;
    end
endmodule
