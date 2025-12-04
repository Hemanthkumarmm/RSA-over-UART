module RSA(
    input wire clk,
    input wire reset,
    input wire [7:0] plaintext,  // 8-bit input message
    output reg [7:0] ciphertext,
    output reg [7:0] decrypted
);
    reg [7:0] p = 11, q = 13;  // Prime numbers
    reg [7:0] n, phi_n, e, d;

    // Function to calculate GCD without using %
    function integer gcd(input integer a, input integer b);
        integer temp;
        begin
            if (b != 0) begin
                if (a >= b) a = a - b;  // Replacing modulus operation
                temp = b;
                b = a;
                a = temp;
            end
            gcd = a;
        end
    endfunction

    // Function to calculate modular inverse using Extended Euclidean Algorithm
    function integer mod_inverse(input integer e, input integer phi);
        integer t, new_t, r, new_r, quotient, temp;
        begin
            t = 0; new_t = 1;
            r = phi; new_r = e;

            if (new_r != 0) begin
                quotient = 0;
                if (r >= new_r) begin
                    r = r - new_r;
                    quotient = quotient + 1;
                end

                temp = new_t;
                new_t = t - quotient * new_t;
                t = temp;

                temp = new_r;
                new_r = r;
                r = temp;
            end

            if (r > 1) mod_inverse = 0;
            else if (t < 0) mod_inverse = t + phi;
            else mod_inverse = t;
        end
    endfunction

    // Function to perform modular exponentiation
    function integer mod_exp(input integer base, input integer exp, input integer mod);
        integer result;
        begin
            result = 1;
            if (exp > 0) begin
                if (exp & 1) begin  // Using bitwise AND instead of %
                    result = result * base;
                    if (result >= mod) result = result - mod;  // Replacing modulus
                end
                base = base * base;
                if (base >= mod) base = base - mod;  // Replacing modulus
                exp = exp >> 1;  // Using shift instead of division by 2
            end
            mod_exp = result;
        end
    endfunction

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            n = p * q;                       // Compute n
            phi_n = (p - 1) * (q - 1);       // Compute ?(n)

            // Find e (smallest odd number coprime with ?(n))
            e = 3;
            if (gcd(e, phi_n) != 1) e = e + 2;

            // Compute d (modular inverse of e)
            d = mod_inverse(e, phi_n);

            // Encrypt: C = M^e mod n
            ciphertext = mod_exp(plaintext, e, n);

            // Decrypt: M = C^d mod n
            decrypted = mod_exp(ciphertext, d, n);

            // Debugging Output
            $display("Public Key: e = %d, n = %d", e, n);
            $display("Private Key: d = %d, n = %d", d, n);
            $display("Plaintext: %d", plaintext);
            $display("Encrypted Ciphertext: %d", ciphertext);
            $display("Decrypted Text: %d", decrypted);
        end
    end
endmodule
module uart_tx(
    input wire clk,
    input wire send,
    input wire [7:0] data_in,
    output reg tx
);
    reg [3:0] bit_index = 0;
    reg [9:0] shift_reg;
    reg transmitting = 0;

    always @(posedge clk) begin
        if (send && !transmitting) begin
            shift_reg <= {1'b1, data_in, 1'b0}; // Start bit (0), Data, Stop bit (1)
            bit_index <= 0;
            transmitting <= 1;
        end
        if (transmitting) begin
            tx <= shift_reg[bit_index];
            bit_index <= bit_index + 1;
            if (bit_index == 9) transmitting <= 0; // Done sending
        end
    end
endmodule
module uart_rx(
    input wire clk,
    input wire rx,
    output reg [7:0] data_out,
    output reg received
);
    reg [3:0] bit_index = 0;
    reg [9:0] shift_reg;
    reg receiving = 0;

    always @(posedge clk) begin
        if (!receiving && !rx) begin  // Start bit detected
            receiving <= 1;
            bit_index <= 0;
        end
        if (receiving) begin
            shift_reg[bit_index] <= rx;
            bit_index <= bit_index + 1;
            if (bit_index == 8) begin
                data_out <= shift_reg[7:0];
                received <= 1;
                receiving <= 0;
            end
        end
    end
endmodule


