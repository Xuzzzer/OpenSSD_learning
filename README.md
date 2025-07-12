# OpenSSD_learning
综合通过文件：sccs_bch, skes_bch, t4_nfc。
下一步还需要修改每个文件夹的pin_order.cfg文件确定布局的位置。
另外，未通过的文件是nvme_ctrl和v2_nfc，这两个文件夹的共通点在于都还有vivado的大型IP，因此需要把接口接出来，下一步，尽快完成！

综合的报告可以在每个文件夹的designs/sccs_bch/runs/BCHSCCS_syn/logs/synthesis/
下
7月12日进展，skes_bch sccs_bch t4nfc等三个文件均跑至布线阶段，“[ERROR GRT-0119] Routing congestion too high.”此处均因此原因导致布线失败，我尝试的修复手段是在每个设计的config.json文件将FP_CORE_UTIL参数设置较低，但是仍旧因同样的原因失败了。
```json
{  "//": "Technology-Specific Configs",
    "pdk::sky130*": {
        "FP_CORE_UTIL": 30,
        "CLOCK_PERIOD": 10,
        "GLB_RESIZER_TIMING_OPTIMIZATIONS": 1,
        "PL_ROUTING_OPTIMIZATION": 1,
        "ROUTING_CORES": 32, 
        "scl::sky130_fd_sc_hs": {
            "CLOCK_PERIOD": 8
        },
        "scl::sky130_fd_sc_ls": {
            "MAX_FANOUT_CONSTRAINT": 5
        }
    },
}
