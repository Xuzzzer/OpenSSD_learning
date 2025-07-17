

`define		D_AXI_RESP_OKAY					2'b00
`define		D_AXI_RESP_EXOKAY				2'b01
`define		D_AXI_RESP_SLVERR				2'b10
`define		D_AXI_RESP_DECERR				2'b11

`define		D_AXBURST_FIXED					2'b00
`define		D_AXBURST_INCR					2'b01
`define		D_AXBURST_WRAP					2'b10

`define		D_AXLOCK_NORMAL					2'b00
`define		D_AXLOCK_EXCLUSIVE				2'b01
`define		D_AXLOCK_LOCKED					2'b10

`define		D_AXCACHE_NON_CACHE				4'b0000
`define		D_AXCACHE_WA					4'b1000
`define		D_AXCACHE_RA					4'b0100
`define		D_AXCACHE_CACHEABLE				4'b0010
`define		D_AXCACHE_BUFFERABLE			4'b0001

`define		D_AXPROT_SECURE					3'b000
`define		D_AXPROT_PRIVILEGED				3'b001
`define		D_AXPROT_NON_SECURE				3'b010
`define		D_AXPROT_INSTRUCTION			3'b100

`define		D_AXSIZE_001_BYTES				3'b000
`define		D_AXSIZE_002_BYTES				3'b001
`define		D_AXSIZE_004_BYTES				3'b010
`define		D_AXSIZE_008_BYTES				3'b011
`define		D_AXSIZE_016_BYTES				3'b100
`define		D_AXSIZE_032_BYTES				3'b101
`define		D_AXSIZE_064_BYTES				3'b110
`define		D_AXSIZE_128_BYTES				3'b111

