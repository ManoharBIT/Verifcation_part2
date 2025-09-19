module master(
    input [7:0] apb_write_padder, read_padder,
    input [7:0] apb_write_data, prdata,
    input presetn, pclk, read, write, transfer, pready,
    
    output reg psel1, psel2,
    output reg penable,
    output reg [8:0] paddr,
    output reg pwrite,
    output reg [7:0] pwdata, apb_read_data_out,
    output pslverr
);

    // State declaration
    reg [1:0] present_state, next_state;

    // Error signals
    reg invalid_setup_error;
    reg setup_error, invalid_read_padder, invalid_write_padder, invalid_write_data;

    // APB states
    parameter idle   = 2'b01,
              setup  = 2'b10,
              enable = 2'b11;

    // Sequential block for state register
    always @(posedge pclk or negedge presetn) begin
        if (!presetn)
            present_state <= idle;
        else
            present_state <= next_state;
    end

    // Combinational block for next state logic and outputs
    always @(*) begin
        // Default assignments
        next_state = present_state;
        penable = 1'b0;
        pwrite = write;
        paddr = 9'b0;
        pwdata = apb_write_data;
        apb_read_data_out = 8'b0;

        case (present_state)
            idle: begin
                if (transfer)
                    next_state = setup;
                else
                    next_state = idle;
            end

            setup: begin
                penable = 1'b0;
                if (read && !write)
                    paddr = read_padder;
                else if (!read && write)
                    pwdata = apb_write_data;
                next_state = enable;
            end

            enable: begin
                penable = 1'b1;
                if (transfer && !pslverr) begin
                    if (pready) begin
                        if (!read && write)
                            next_state = setup;
                        else if (read && !write) begin
                            next_state = setup;
                            apb_read_data_out = prdata;
                        end
                        else
                            next_state = enable;
                    end
                    else
                        next_state = enable;
                end
                else
                    next_state = idle;
            end

            default: next_state = idle;
        endcase
    end

    // Error detection logic
    always @(*) begin
        // Defaults
        setup_error = 1'b0;
        invalid_read_padder = 1'b0;
        invalid_write_padder = 1'b0;
        invalid_write_data = 1'b0;

        if (!presetn) begin
            // Reset all errors
            setup_error = 1'b0;
            invalid_read_padder = 1'b0;
            invalid_write_padder = 1'b0;
            invalid_write_data = 1'b0;
        end
        else begin
            // Setup error: going from idle to enable directly
            if (present_state == idle && next_state == enable)
                setup_error = 1'b1;

            // Invalid write data (simulation check)
            if ((write && !read) && (present_state == setup || present_state == enable))
                invalid_write_data = 1'b0; // replace with proper simulation check if needed

            // Invalid read padder
            if ((read && !write) && (present_state == setup || present_state == enable))
                invalid_read_padder = 1'b0; // replace with proper simulation check if needed
        end
    end

   
    assign pslverr = invalid_setup_error;

endmodule
