module cache(
    clk,
    proc_reset,
    proc_read,
    proc_write,
    proc_addr,
    proc_rdata,
    proc_wdata,
    proc_stall,
    mem_read,
    mem_write,
    mem_addr,
    mem_rdata,
    mem_wdata,
    mem_ready
);
    
//==== input/output definition ============================
    input          clk;
    // processor interface
    input          proc_reset;
    input          proc_read, proc_write;
    input   [29:0] proc_addr;
    input   [31:0] proc_wdata;
    output         proc_stall;
    output  [31:0] proc_rdata;
    // memory interface
    input  [127:0] mem_rdata;
    input          mem_ready;
    output         mem_read, mem_write;
    output  [27:0] mem_addr;
    output [127:0] mem_wdata;
//====parameters   ========================================
    localparam IDLE = 2'd0;
    localparam READ_STALL = 2'd1;
    localparam WRITE_STALL_READ = 2'd2;
    localparam WRITE_STALL_WRITE = 2'd3;
//==== wire/reg definition ================================
    //state reg
    reg [1:0] state_r, state_w;
    //cache reg 8 x (25+ 32x4) = 8 x 153
    reg [153:0] cache_r[0:7] ,cache_w[0:7]; //format: v/tag/word3/word2/word1/word0
    //output reg
    reg proc_stall_r, proc_stall_w;
    reg [31:0] proc_rdata; 

    reg mem_read_r, mem_read_w;
    reg mem_write_r, mem_write_w;
    reg [27:0] mem_addr_r, mem_addr_w;
    reg [127:0] mem_wdata_r, mem_wdata_w;
    //index tag wire                                     //can be spare for area 
    wire [2:0] index;
    wire [24:0] tag, tag_in_cache;
    wire valid_in_cache;

    reg mem_ready_r;
//==== Assignment =========================================
    //assign tag data1 data2 data3 data4                //can be spare for area
    assign index            = proc_addr[4:2];           
    assign tag              = proc_addr[29:5];
    assign tag_in_cache     = cache_r[index][152:128];
    assign valid_in_cache   = cache_r[index][153];
    //output
    assign proc_stall   = proc_stall_w;
    assign mem_read     = mem_read_r;
    assign mem_write    = mem_write_r;
    assign mem_addr     = mem_addr_r;
    assign mem_wdata    = mem_wdata_r;

//==== combinational circuit ==============================
    integer idx; //for cache update
    always@(*) begin 
        state_w         = state_r;
        proc_stall_w    = proc_stall_r;
        mem_read_w      = mem_read_r;
        mem_write_w     = mem_write_r;
        mem_addr_w      = mem_addr_r;
        mem_wdata_w     = mem_wdata_r;
        proc_rdata      = 32'd0;
        for(idx = 0; idx <= 7; idx = idx+1) begin
             cache_w[idx] = cache_r[idx];
        end

        case(state_r)
        IDLE:
        begin
            if(proc_read) begin //read
                if(valid_in_cache) begin //valid
                    if(tag != tag_in_cache) begin //read miss
                        state_w         = READ_STALL;
                        proc_stall_w    = 1'd1;
                        mem_read_w      = 1'd1;
                        mem_addr_w      = proc_addr[29:2];
                    end
                    else begin //read hit
                        //modified
                        case(proc_addr[4:2]) //index
                            3'd0:
                            begin
                                case(proc_addr[1:0]) 
                                    2'd3: proc_rdata = cache_r[0][127:96]; //word0
                                    2'd2: proc_rdata = cache_r[0][95:64];  //word1 
                                    2'd1: proc_rdata = cache_r[0][63:32];  //word2
                                    2'd0: proc_rdata = cache_r[0][31:0];   //word3
                                    default: proc_rdata = 32'd0;
                                endcase
                            end
                            3'd1:
                            begin
                                case(proc_addr[1:0]) 
                                    2'd3: proc_rdata = cache_r[1][127:96]; //word0
                                    2'd2: proc_rdata = cache_r[1][95:64];  //word1 
                                    2'd1: proc_rdata = cache_r[1][63:32];  //word2
                                    2'd0: proc_rdata = cache_r[1][31:0];   //word3
                                    default: proc_rdata = 32'd0;
                                endcase
                            end
                            3'd2:
                            begin
                                case(proc_addr[1:0]) 
                                    2'd3: proc_rdata = cache_r[2][127:96]; //word0
                                    2'd2: proc_rdata = cache_r[2][95:64];  //word1 
                                    2'd1: proc_rdata = cache_r[2][63:32];  //word2
                                    2'd0: proc_rdata = cache_r[2][31:0];   //word3
                                    default: proc_rdata = 32'd0;
                                endcase
                            end
                            3'd3:
                            begin
                                case(proc_addr[1:0]) 
                                    2'd3: proc_rdata = cache_r[3][127:96]; //word0
                                    2'd2: proc_rdata = cache_r[3][95:64];  //word1 
                                    2'd1: proc_rdata = cache_r[3][63:32];  //word2
                                    2'd0: proc_rdata = cache_r[3][31:0];   //word3
                                    default: proc_rdata = 32'd0;
                                endcase
                            end
                            3'd4:
                            begin
                                case(proc_addr[1:0]) 
                                    2'd3: proc_rdata = cache_r[4][127:96]; //word0
                                    2'd2: proc_rdata = cache_r[4][95:64];  //word1 
                                    2'd1: proc_rdata = cache_r[4][63:32];  //word2
                                    2'd0: proc_rdata = cache_r[4][31:0];   //word3
                                    default: proc_rdata = 32'd0;
                                endcase
                            end
                            3'd5:
                            begin
                                case(proc_addr[1:0]) 
                                    2'd3: proc_rdata = cache_r[5][127:96]; //word0
                                    2'd2: proc_rdata = cache_r[5][95:64];  //word1 
                                    2'd1: proc_rdata = cache_r[5][63:32];  //word2
                                    2'd0: proc_rdata = cache_r[5][31:0];   //word3
                                    default: proc_rdata = 32'd0;
                                endcase
                            end
                            3'd6:
                            begin
                                case(proc_addr[1:0]) 
                                    2'd3: proc_rdata = cache_r[6][127:96]; //word0
                                    2'd2: proc_rdata = cache_r[6][95:64];  //word1 
                                    2'd1: proc_rdata = cache_r[6][63:32];  //word2
                                    2'd0: proc_rdata = cache_r[6][31:0];   //word3
                                    default: proc_rdata = 32'd0;
                                endcase
                            end
                            3'd7:
                            begin
                                case(proc_addr[1:0]) 
                                    2'd3: proc_rdata = cache_r[7][127:96]; //word0
                                    2'd2: proc_rdata = cache_r[7][95:64];  //word1 
                                    2'd1: proc_rdata = cache_r[7][63:32];  //word2
                                    2'd0: proc_rdata = cache_r[7][31:0];   //word3
                                    default: proc_rdata = 32'd0;
                                endcase
                            end
                            default:
                            begin
                                proc_rdata = 32'd0;
                            end
                        endcase
                        // case(proc_addr[1:0])
                        //     2'd3: proc_rdata = cache_r[index][127:96]; //word0
                        //     2'd2: proc_rdata = cache_r[index][95:64];  //word1 
                        //     2'd1: proc_rdata = cache_r[index][63:32];  //word2
                        //     2'd0: proc_rdata = cache_r[index][31:0];   //word3
                        //     default: proc_rdata = 32'd0;
                        // endcase
                    end
                end
                else begin //not valid -> read miss
                    state_w         = READ_STALL;
                    proc_stall_w    = 1'd1;
                    mem_read_w      = 1'd1;
                    mem_addr_w      = proc_addr[29:2];
                    //update valid bit
                    cache_w[index][153] = 1'd1;
                end           
            end

            if(proc_write) begin //write
                if(valid_in_cache) begin
                    if(tag != tag_in_cache) begin //write miss
                        state_w = WRITE_STALL_READ;
                        proc_stall_w    = 1'd1;
                        mem_read_w      = 1'd1;
                        mem_addr_w      = proc_addr[29:2];
                    end
                    else begin //write hit for 'write through'
                        state_w = WRITE_STALL_WRITE;
                        //update data in cache
                        case(proc_addr[4:2]) //index
                            3'd0:
                            begin
                                case(proc_addr[1:0])
                                    2'd3: cache_w[0][127:96]= proc_wdata;
                                    2'd2: cache_w[0][95:64] = proc_wdata; 
                                    2'd1: cache_w[0][63:32] = proc_wdata;
                                    2'd0: cache_w[0][31:0]  = proc_wdata;
                                    default: cache_w[0]     = cache_r[0];
                                endcase
                            end
                            3'd1:
                            begin
                                case(proc_addr[1:0])
                                    2'd3: cache_w[1][127:96]= proc_wdata;
                                    2'd2: cache_w[1][95:64] = proc_wdata; 
                                    2'd1: cache_w[1][63:32] = proc_wdata;
                                    2'd0: cache_w[1][31:0]  = proc_wdata;
                                    default: cache_w[1]     = cache_r[1];
                                endcase
                            end
                            3'd2:
                            begin
                                case(proc_addr[1:0])
                                    2'd3: cache_w[2][127:96]= proc_wdata;
                                    2'd2: cache_w[2][95:64] = proc_wdata; 
                                    2'd1: cache_w[2][63:32] = proc_wdata;
                                    2'd0: cache_w[2][31:0]  = proc_wdata;
                                    default: cache_w[2]     = cache_r[2];
                                endcase
                            end
                            3'd3:
                            begin
                                case(proc_addr[1:0])
                                    2'd3: cache_w[3][127:96]= proc_wdata;
                                    2'd2: cache_w[3][95:64] = proc_wdata; 
                                    2'd1: cache_w[3][63:32] = proc_wdata;
                                    2'd0: cache_w[3][31:0]  = proc_wdata;
                                    default: cache_w[3]     = cache_r[3];
                                endcase
                            end
                            3'd4:
                            begin
                                case(proc_addr[1:0])
                                    2'd3: cache_w[4][127:96]= proc_wdata;
                                    2'd2: cache_w[4][95:64] = proc_wdata; 
                                    2'd1: cache_w[4][63:32] = proc_wdata;
                                    2'd0: cache_w[4][31:0]  = proc_wdata;
                                    default: cache_w[4]     = cache_r[4];
                                endcase
                            end
                            3'd5:
                            begin
                                case(proc_addr[1:0])
                                    2'd3: cache_w[5][127:96]= proc_wdata;
                                    2'd2: cache_w[5][95:64] = proc_wdata; 
                                    2'd1: cache_w[5][63:32] = proc_wdata;
                                    2'd0: cache_w[5][31:0]  = proc_wdata;
                                    default: cache_w[5]     = cache_r[5];
                                endcase
                            end
                            3'd6:
                            begin
                                case(proc_addr[1:0])
                                    2'd3: cache_w[6][127:96]= proc_wdata;
                                    2'd2: cache_w[6][95:64] = proc_wdata; 
                                    2'd1: cache_w[6][63:32] = proc_wdata;
                                    2'd0: cache_w[6][31:0]  = proc_wdata;
                                    default: cache_w[6]     = cache_r[6];
                                endcase
                            end
                            3'd7:
                            begin
                                case(proc_addr[1:0])
                                    2'd3: cache_w[7][127:96]= proc_wdata;
                                    2'd2: cache_w[7][95:64] = proc_wdata; 
                                    2'd1: cache_w[7][63:32] = proc_wdata;
                                    2'd0: cache_w[7][31:0]  = proc_wdata;
                                    default: cache_w[7]     = cache_r[7];
                                endcase
                            end
                            default:
                            begin
                                cache_w[0] = cache_r[0];
                            end
                        endcase
                        // case(proc_addr[1:0])
                        //     2'd3: cache_w[index][127:96]= proc_wdata;
                        //     2'd2: cache_w[index][95:64] = proc_wdata; 
                        //     2'd1: cache_w[index][63:32] = proc_wdata;
                        //     2'd0: cache_w[index][31:0]  = proc_wdata;
                        //     default: cache_w[index]     = cache_r[index];
                        // endcase
                        //signal to change
                        proc_stall_w    = 1'd1;
                        mem_write_w     = 1'd1;
                        mem_addr_w      = proc_addr[29:2];
                        mem_wdata_w     = cache_w[index][127:0];
                    end
                end
                else begin //not valid -> write miss
                    state_w = WRITE_STALL_READ;
                    proc_stall_w    = 1'd1;
                    mem_read_w      = 1'd1;
                    mem_addr_w      = proc_addr[29:2];
                    //update valid bit
                    cache_w[index][153] = 1'd1;
                end  
            end
        end
        READ_STALL:
        begin
            proc_stall_w            = 1'd1;
            if(mem_ready) begin
                state_w                 = IDLE;
                proc_stall_w            = 1'd0;
                mem_read_w              = 1'd0;
                mem_addr_w              = 28'd0;
                cache_w[index][152:128] = tag;      //update tag
                cache_w[index][127:0]   = mem_rdata;//update data
                //read data output
                case(proc_addr[1:0])
                    2'd3: proc_rdata = mem_rdata[127:96]; //word0
                    2'd2: proc_rdata = mem_rdata[95:64];  //word1 
                    2'd1: proc_rdata = mem_rdata[63:32];  //word2
                    2'd0: proc_rdata = mem_rdata[31:0];   //word3
                    default: proc_rdata = 32'd0;
                endcase
            end
        end
        WRITE_STALL_READ:
        begin
            
            if(mem_ready) begin
                
                //updata data in cache
                // cache_w[index][152:128] = tag;      //update tag
                // cache_w[index][127:0]   = mem_rdata;  //updata data
                //write hit
                case(proc_addr[4:2]) //index
                    3'd0:
                    begin
                        cache_w[0][152:128] = tag;
                        cache_w[0][127:0] = mem_rdata;
                        case(proc_addr[1:0])
                            2'd3: cache_w[0][127:96]= proc_wdata;
                            2'd2: cache_w[0][95:64] = proc_wdata; 
                            2'd1: cache_w[0][63:32] = proc_wdata;
                            2'd0: cache_w[0][31:0]  = proc_wdata;
                            default: cache_w[0]     = cache_r[0];
                        endcase
                    end
                    3'd1:
                    begin
                        cache_w[1][152:128] = tag;
                        cache_w[1][127:0] = mem_rdata;
                        case(proc_addr[1:0])
                            2'd3: cache_w[1][127:96]= proc_wdata;
                            2'd2: cache_w[1][95:64] = proc_wdata; 
                            2'd1: cache_w[1][63:32] = proc_wdata;
                            2'd0: cache_w[1][31:0]  = proc_wdata;
                            default: cache_w[1]     = cache_r[1];
                        endcase
                    end
                    3'd2:
                    begin
                        cache_w[2][152:128] = tag;
                        cache_w[2][127:0] = mem_rdata;
                        case(proc_addr[1:0])
                            2'd3: cache_w[2][127:96]= proc_wdata;
                            2'd2: cache_w[2][95:64] = proc_wdata; 
                            2'd1: cache_w[2][63:32] = proc_wdata;
                            2'd0: cache_w[2][31:0]  = proc_wdata;
                            default: cache_w[2]     = cache_r[2];
                        endcase
                    end
                    3'd3:
                    begin
                        cache_w[3][152:128] = tag;
                        cache_w[3][127:0] = mem_rdata;
                        case(proc_addr[1:0])
                            2'd3: cache_w[3][127:96]= proc_wdata;
                            2'd2: cache_w[3][95:64] = proc_wdata; 
                            2'd1: cache_w[3][63:32] = proc_wdata;
                            2'd0: cache_w[3][31:0]  = proc_wdata;
                            default: cache_w[3]     = cache_r[3];
                        endcase
                    end
                    3'd4:
                    begin
                        cache_w[4][152:128] = tag;
                        cache_w[4][127:0] = mem_rdata;
                        case(proc_addr[1:0])
                            2'd3: cache_w[4][127:96]= proc_wdata;
                            2'd2: cache_w[4][95:64] = proc_wdata; 
                            2'd1: cache_w[4][63:32] = proc_wdata;
                            2'd0: cache_w[4][31:0]  = proc_wdata;
                            default: cache_w[4]     = cache_r[4];
                        endcase
                    end
                    3'd5:
                    begin
                        cache_w[5][152:128] = tag;
                        cache_w[5][127:0] = mem_rdata;
                        case(proc_addr[1:0])
                            2'd3: cache_w[5][127:96]= proc_wdata;
                            2'd2: cache_w[5][95:64] = proc_wdata; 
                            2'd1: cache_w[5][63:32] = proc_wdata;
                            2'd0: cache_w[5][31:0]  = proc_wdata;
                            default: cache_w[5]     = cache_r[5];
                        endcase
                    end
                    3'd6:
                    begin
                        cache_w[6][152:128] = tag;
                        cache_w[6][127:0] = mem_rdata;
                        case(proc_addr[1:0])
                            2'd3: cache_w[6][127:96]= proc_wdata;
                            2'd2: cache_w[6][95:64] = proc_wdata; 
                            2'd1: cache_w[6][63:32] = proc_wdata;
                            2'd0: cache_w[6][31:0]  = proc_wdata;
                            default: cache_w[6]     = cache_r[6];
                        endcase
                    end
                    3'd7:
                    begin
                        cache_w[7][152:128] = tag;
                        cache_w[7][127:0] = mem_rdata;
                        case(proc_addr[1:0])
                            2'd3: cache_w[7][127:96]= proc_wdata;
                            2'd2: cache_w[7][95:64] = proc_wdata; 
                            2'd1: cache_w[7][63:32] = proc_wdata;
                            2'd0: cache_w[7][31:0]  = proc_wdata;
                            default: cache_w[7]     = cache_r[7];
                        endcase
                    end
                    default:
                    begin
                        cache_w[0] = cache_r[0];
                    end
                endcase
                
                mem_read_w = 1'd0;
                mem_write_w = 1'd1;
                mem_addr_w = proc_addr[29:2];
                mem_wdata_w = cache_w[index][127:0];
                state_w = WRITE_STALL_WRITE;

            end
            else begin
                proc_stall_w            = 1'd1;
                state_w                 = WRITE_STALL_READ;
                mem_read_w = 1'd1;
            end
        end
        WRITE_STALL_WRITE: 
        begin
            proc_stall_w            = 1'd1;
            
            if(mem_ready) begin
                state_w         = IDLE;
                proc_stall_w    = 1'd0;
                mem_write_w     = 1'd0;
                mem_addr_w      = 28'd0;
            end
        end
        default:
        begin
            state_w         = state_r;
            proc_stall_w    = proc_stall_r;
            mem_read_w      = mem_read_r;
            mem_write_w     = mem_write_r;
            mem_addr_w      = mem_addr_r;
            mem_wdata_w     = mem_wdata_r;
            for(idx = 0; idx <= 7; idx = idx+1) begin
                 cache_w[idx] = cache_r[idx];
            end
        end
        endcase
    end
//==== sequential circuit =================================
integer i;
always@( posedge clk ) begin
    if( proc_reset ) begin
        for(i = 0; i<=7; i = i+1) begin
            cache_r[i]  <= 154'd0;
        end
        state_r         <= 2'd0;
        proc_stall_r    <= 1'd0;
        mem_read_r      <= 1'd0;
        mem_write_r     <= 1'd0;
        mem_addr_r      <= 28'd0;
        mem_wdata_r     <= 128'd0;
        mem_ready_r <= 0;
    end
    else begin
        for(i = 0; i<=7; i = i+1) begin
            cache_r[i]  <= cache_w[i];
        end
        state_r         <= state_w;
        proc_stall_r    <= proc_stall_w;
        mem_read_r      <= mem_read_w;
        mem_write_r     <= mem_write_w;
        mem_addr_r      <= mem_addr_w;
        mem_wdata_r     <= mem_wdata_w;
        mem_ready_r <= mem_ready;
    end
end
endmodule