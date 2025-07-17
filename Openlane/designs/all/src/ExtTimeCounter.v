

`timescale 1ns / 1ps

module ExtTimeCounter
#
(
    parameter TimerWidth            = 32        ,
    parameter DefaultPeriod         = 100000000
)
(
    iClock          ,
    iReset          ,
    iEnabled        ,
    iPeriodSetting  ,
    iSettingValid   ,
    iProbe          ,
    oCountValue     ,
    oPeriodValue
);
    input                       iClock          ;
    input                       iReset          ;
    input                       iEnabled        ;
    input   [TimerWidth - 1:0]  iPeriodSetting  ;           
    input                       iSettingValid   ;
    input                       iProbe          ;
    output  [TimerWidth - 1:0]  oCountValue     ;
    output  [TimerWidth - 1:0]  oPeriodValue    ;

    reg     [TimerWidth - 1:0]  rPeriod         ;
    reg     [TimerWidth - 1:0]  rSampledCount   ;
    reg     [TimerWidth - 1:0]  rCounter        ;
    reg     [TimerWidth - 1:0]  rTimeCount      ;
    
    always @ (posedge iClock)
        if (iReset | !iEnabled | rTimeCount == {(TimerWidth){1'b0}})
            rCounter <= {(TimerWidth){1'b0}};
        else
            if (iEnabled & iProbe)
                rCounter <= rCounter + 1'b1;

    always @ (posedge iClock)
        if (iReset | !iEnabled)
            rTimeCount <= DefaultPeriod;
        else
            if (iEnabled)
            begin
                if (rTimeCount == {(TimerWidth){1'b0}})
                    rTimeCount <= rPeriod;
                else
                    rTimeCount <= rTimeCount - 1'b1;
            end

    always @ (posedge iClock)
        if (iReset)
            rSampledCount <= {(TimerWidth){1'b0}};
        else
            if (rTimeCount == {(TimerWidth){1'b0}})
                rSampledCount <= rCounter;

    always @ (posedge iClock)
        if (iReset)
            rPeriod <= DefaultPeriod;
        else
            if (iSettingValid)
                rPeriod <= iPeriodSetting;
    
    assign oCountValue = rSampledCount;
    assign oPeriodValue = rPeriod;
    
endmodule
