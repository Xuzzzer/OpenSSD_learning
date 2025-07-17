`timescale 1ns/10ps


module fifo_async #(
    parameter DATASIZE=64,
    parameter ADDRSIZE=7
  )

(
    output [DATASIZE-1:0] rdata,
    output wfull,rempty,
    output [ADDRSIZE:0] wptr_gray,
    output [ADDRSIZE:0] rptr_gray,
    output [ADDRSIZE:0] r2wptr,
    output [ADDRSIZE:0] w2rptr,
    input  [DATASIZE-1:0] wdata,
    input wclk,wrst_n,w_en,
    input rclk,rrst_n,r_en
);

    logic [ADDRSIZE-1:0] waddr,raddr;

fifo_memory fifo_memory
  (
    .wclk(wclk),
    .wfull(wfull),
    .wdata(wdata),.rdata(rdata),
    .raddr(raddr),.waddr(waddr),
    .w_en(w_en)
  );

WriteModule WriteModule 
  (
    .wclk(wclk),.wrst_n(wrst_n),.w_en(w_en),.r2wptr(r2wptr),.wfull(wfull),.wptr_gray(wptr_gray),.waddr(waddr)
  );

ReadModule ReadModule 
  (
    .rclk(rclk),.rrst_n(rrst_n),.r_en(r_en),.w2rptr(w2rptr),.rempty(rempty),.rptr_gray(rptr_gray),.raddr(raddr)
  );

ClkSyncModule ClkSyncModule
  (
    .wclk(wclk),.wrst_n(wrst_n),.rptr_gray(rptr_gray),.w2rptr(w2rptr),.r2wptr(r2wptr),.rclk(rclk),.rrst_n(rrst_n),.wptr_gray(wptr_gray)
  );
endmodule

module WriteModule
#(parameter ADDRSIZE = 7)
//根据结构框图，声明输入和输出变量
(
  output reg [ADDRSIZE:0]   wptr_gray, //写指针8位，转换成格雷码后赋予给它作为进位判断满信号
  output logic [ADDRSIZE-1:0] waddr,   //写地址7位，用于顺序写数据
  output reg wfull,                   //写满信号标志位
  input  wclk,wrst_n,w_en,            //写时钟、写复位(低电平有效)、写使能
  input  wire [ADDRSIZE:0]   r2wptr  //由读子模块同步到写时钟用作与写时针格雷码比较判断满信号，此信号已经在ReadModule转换成格雷码
);
//声明内部变量，考虑写指针需要有二进制形式和格雷码形式
  reg [ADDRSIZE:0] wptr_bina;
//写指针+1运算
  always@(posedge wclk or negedge wrst_n)
  begin
    if(!wrst_n) wptr_bina<=0;
    else if(w_en&&!wfull) wptr_bina<=wptr_bina+1'b1;  
  end
//将写指针-1位后赋予给写地址
  assign waddr = wptr_bina[ADDRSIZE-1:0];
//二进制转换成格雷码
  assign wptr_gray = (wptr_bina>>1)^wptr_bina;
//判断满信号是否产生，最高位和次高位不同，其他位均相同代表满信号产生
  always@(posedge wclk or negedge wrst_n)
  begin
    if(!wrst_n) 
         wfull<=0;
    else 
    if(wptr_gray ==  {~r2wptr[ADDRSIZE], r2wptr[ADDRSIZE-1:0]} )
         wfull<= 1;  
    else wfull<=0;
   end
endmodule


// Copyright (C) 2024 by Berial
// Module Name: ReadModule
// Description: Module for reading and empty flag generation including transmission of reading address to fifo_memory and binary to gray 
module ReadModule
//声明读地址位宽
#(parameter ADDRSIZE = 7)
//声明输入和输出变量
(
    output reg [ADDRSIZE:0] rptr_gray,   //读指针8位，转换成格雷码后赋予给它作为进位判断空信号
    output reg [ADDRSIZE-1:0] raddr,//读地址7位，用于顺序读取数据
    output reg rempty,              //读空信号标志位
    input  rclk,rrst_n,r_en,        //读时钟、读复位(低电平有效)、读使能
    input [ADDRSIZE:0] w2rptr       //由写模块同步到读时钟，用作与读指针格雷码比较判断空信号，此信号已经在WriteModule转换成格雷码
);
//声明内部变量，考虑读指针需要有二进制形式和格雷码形式
  reg [ADDRSIZE:0] rptr_bina;
//读指针+1运算
  always@(posedge rclk or negedge rrst_n)
  begin
    if(!rrst_n) rptr_bina<=0;
    else if(r_en&&!rempty) rptr_bina<=rptr_bina+1'b1;  
  end
//二进制转换成格雷码
  assign rptr_gray = (rptr_bina>>1)^rptr_bina;
//判断空信号是否产生，所有位数均相同代表空信号产生
  always@(posedge rclk or negedge rrst_n)
  begin
    if(!rrst_n) rempty<=1'b0;
    else if(rptr_gray == {w2rptr[ADDRSIZE:0]}) rempty<= 1;
    else rempty<=0;  
  end
//将读指针-1位后赋予给读地址
  assign raddr = rptr_bina[ADDRSIZE-1:0];
endmodule

module ClkSyncModule
//声明读地址位宽
#(parameter ADDRSIZE = 7)
//声明输入和输出变量
(
    output logic [ADDRSIZE:0] w2rptr,//来自写模块同步到读时钟的写指针
    output logic [ADDRSIZE:0] r2wptr,//来自读模块同步到写时钟的读指针
    input  [ADDRSIZE:0] wptr_gray,   //写指针格雷码形式
    input  [ADDRSIZE:0] rptr_gray,        //读指针格雷码形式
    input wclk,wrst_n,rclk,rrst_n    //写时钟,写复位,读时钟,读复位
);
//声明内部变量，考虑两个D触发器中第一级DFF的输出
    logic   [ADDRSIZE:0] wptr1;
    logic   [ADDRSIZE:0] rptr1;
//写指针同步到读时钟的二级DFF
always@(posedge rclk or negedge rrst_n)
    if(!rrst_n) begin wptr1<=0;w2rptr<=0; end
    else begin w2rptr<=wptr1;wptr1<=wptr_gray;end//写指针同步到读时钟，打两拍
//读指针同步到写时钟的二级DFF
always@(posedge wclk or negedge wrst_n)
    if(!wrst_n) begin rptr1<=0;r2wptr<=0; end
    else begin r2wptr<=rptr1;rptr1<=rptr_gray;end//读指针同步到写时钟，打两拍
endmodule

// Copyright (C) 2024 by Berial
// Module Name: fifo_memory
// Description: memory for fifo, define read and write operation
module fifo_memory
//�������ݿ��Ⱥ͵�ַ����
 #(
    parameter DATASIZE=64,
    parameter ADDRSIZE=7
  )
//��������������
  (
    output reg [DATASIZE-1:0] rdata,
    input  [DATASIZE-1:0] wdata,
    input  [ADDRSIZE-1:0] raddr,
    input  [ADDRSIZE-1:0] waddr,
    input  wclk,
    input  w_en,
    input  wfull
  );
//����������ȣ���mem���Դ���ٸ�������
  localparam DATADEP = 1<<ADDRSIZE;
//����64λ��mem���������Ϊ2^7=128
  reg [DATASIZE-1:0] MEM [0:DATADEP-1];
//�����ݲ���
    assign rdata = MEM[raddr];
//д���ݲ���������дʱ�������ؽ��У������ж�д��λ��Ч��дʹ����Ч
  always@(posedge wclk)
     if(!wfull && w_en) MEM[waddr]<=wdata;
endmodule
