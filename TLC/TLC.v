module TLC(
    input clk, rst, emg,
    output reg [11:0] TL // Updated to 12-bit for full color representation
);
    parameter RED = 3'b100, GREEN = 3'b001, YELLOW = 3'b010;

    reg [2:0] north, east, south, west;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            north <= GREEN;
            east  <= RED;
            south <= RED;
            west  <= RED;
        end 
        else if (emg) begin // Emergency Mode: Prioritize North
            north <= GREEN;
            east  <= RED;
            south <= RED;
            west  <= RED;
        end 
        else begin // Normal Operation
            if (north == GREEN) begin
                north <= YELLOW;
                east  = RED;
                south = RED;
                west  = RED;
            end 
            else if (north == YELLOW) begin
                north <= RED;
                south = RED;
                west  = RED;
                east  <= GREEN;
            end 
            else if (east == GREEN) begin
                east  <= YELLOW;
                north = RED;
                south = RED;
                west  = RED;
            end 
            else if (east == YELLOW) begin
                east  <= RED;
                south <= GREEN;
                north = RED;
                west  = RED;
            end 
            else if (south == GREEN) begin
                south <= YELLOW;
                east  = RED;
                north = RED;
                west  = RED;
            end 
            else if (south == YELLOW) begin
                south <= RED;
                west  <= GREEN;
                east  = RED;
                north = RED;
            end 
            else if (west == GREEN) begin
                west  <= YELLOW;
                south = RED;
                east  = RED;
                north = RED;
            end 
            else if (west == YELLOW) begin
                west  <= RED;
                north <= GREEN;
                south = RED;
                east  = RED;
            end
        end
    end

    always @(*) begin
        TL[11:9] = (west  == GREEN) ? 3'b001 : (west == YELLOW) ? 3'b010 : 3'b100;
        TL[8:6]  = (south == GREEN) ? 3'b001 : (south  == YELLOW) ? 3'b010 : 3'b100;
        TL[5:3]  = (east  == GREEN) ? 3'b001 : (east == YELLOW) ? 3'b010 : 3'b100;
        TL[2:0]  = (north == GREEN) ? 3'b001 : (north  == YELLOW) ? 3'b010 : 3'b100;
    end
endmodule
