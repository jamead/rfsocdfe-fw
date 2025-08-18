//The PSC interface defines many different MsgID's
//The PSC Header is always 8 bytes
#define MSGHDRLEN 8

//This message is for System Health
#define MSGID30 30
#define MSGID30LEN 1024 //748   //in bytes

//This message is for 10Hz data
#define MSGID31 31
#define MSGID31LEN 1024  //316   //in bytes

//This message is for system info
#define MSGID32 32
#define MSGID32LEN 1024  //400  //in bytes



//This message is for ADC Live waveform
//10000 pts * 4vals * 2bytes/val
#define MSGID51 51 
#define MSGID51LEN 80000   //in bytes

//This message is for TbT waveform
//1024 pts * 7vals * 4bytes/val (a,b,c,d,x,y,sum)
#define MSGID52 52 
#define MSGID52LEN 230000  //in bytes

//This message is for ADC DMA
//1e6 pts * 4vals * 2bytes/val
#define MSGID53 53
#define MSGID53LEN 8000000  //in bytes

//This message is for TBT DMA
//100e3 pts * 16vals * 4bytes/val
#define MSGID54 54
#define MSGID54LEN 6400000  //in bytes

//This message is for FA DMA
//20e3 pts * 10vals * 4bytes/val
#define MSGID55 55
#define MSGID55LEN 800000  //in bytes



/*
//global buffers
extern char msgid30_buf[MSGID30LEN];
extern char msgid31_buf[MSGID31LEN];
extern char msgid32_buf[MSGID32LEN];

extern char msgid51_buf[MSGID51LEN];
extern char msgid52_buf[MSGID52LEN];
extern char msgid53_buf[MSGID53LEN];
extern char msgid54_buf[MSGID54LEN];
extern char msgid55_buf[MSGID55LEN];
*/

// PSC Message ID 31
/*
typedef struct SAdataMsg {
	u32 count;        // PSC Offset 0
	u32 evr_ts_ns;    // PSC Offset 4
	u32 evr_ts_s;     // PSC Offset 8
	u32 cha_mag;      // PSC Offset 12
	u32 chb_mag;      // PSC Offset 16
	u32 chc_mag;      // PSC Offset 20
	u32 chd_mag;      // PSC Offset 24
	u32 sum;          // PSC Offset 28
	s32 xpos_nm;      // PSC Offset 32
	s32 ypos_nm;      // PSC Offset 36
} SAdataMsg;
*/

/*
// PSC Message ID 30
typedef struct SysHealthMsg {
	u32   git_shasum;    // PSC Offset 0   Firmware Version (git checksum)
	float dfe_temp[4];   // PSC Offset 4   ADT7410 Temperature Sensors
	float afe_temp[2];   // PSC Offset 20
    float fpga_dietemp;  // PSC Offset 28
    u32   uptime;        // PSC Offset 32
	u32   rsvd;          // PSC Offset 36
    float vin_v;         // PSC Offset 40   LTC2991 monitor
	float vin_i;         // PSC Offset 44
	float v3_3_v;        // PSC Offset 48
	float v3_3_i;		 // PSC Offset 52
	float v2_5_v;		 // PSC Offset 56
	float v2_5_i;		 // PSC Offset 60
	float v1_8_v;		 // PSC Offset 64
	float v1_8_i;		 // PSC Offset 68
    float v1_2ddr_v;	 // PSC Offset 72
    float v1_2ddr_i;	 // PSC Offset 76
    float v0_85_v;		 // PSC Offset 80
    float v0_85_i;		 // PSC Offset 84
    float v2_5mgt_v;	 // PSC Offset 88
    float v2_5mgt_i;	 // PSC Offset 92
    float v1_2mgt_v;	 // PSC Offset 96
    float v1_2mgt_i;	 // PSC Offset 100
    float v0_9mgt_v;	 // PSC Offset 104
    float v0_9mgt_i;     // PSC Offset 108
    float reg_temp[3];   // PSC Offset 112
    u32  rsvd2[4];       // PSC Offset 124
    float sfp_temp[6];   // PSC Offset 140
    float sfp_vcc[6];    // PSC Offset 164
    float sfp_txbias[6]; // PSC Offset 188
    float sfp_txpwr[6];  // PSC Offset 212
    float sfp_rxpwr[6];  // PSC Offset 236
    u32 rsvd3[5];        // PSC Offset 260
    float pwrmgmt_temp;  // PSC Offset 280  LTC2977 Temperature
    u32   rsvd4[10];
    float therm_temp[6]; // PSC Offset 324
} SysHealthMsg;
*/

/*
//PSC Message ID 31
typedef struct StatusMsg {
	u32 pll_locked;         //PSC Offset 0
	u32 cha_gain;           //PSC Offset 4
    u32 chb_gain;  		    //PSC Offset 8
    u32 chc_gain;           //PSC Offset 12
    u32 chd_gain;           //PSC Offset 16
    u32 rf_atten;           //PSC Offset 20
    u32 kx;				    //PSC Offset 24
    u32 ky; 			    //PSC Offset 28
    u32 bba_xoff;           //PSC Offset 32
    u32 bba_yoff;           //PSC Offset 36
    u32 evr_ts_s_triglat;   //PSC Offset 40
	u32 evr_ts_ns_triglat;  //PSC Offset 44
    u32 trig_eventno;       //PSC Offset 48
    u32 trig_dmacnt;        //PSC Offset 52
    u32 fine_trig_dly;      //PSC Offset 56
    u32 coarse_trig_dly;    //PSC Offset 60
    u32 trigtobeam_thresh;  //PSC Offset 64
	u32 trigtobeam_dly;     //PSC Offset 68
	u32 dma_adclen;         //PSC Offset 72
	u32 dma_tbtlen;         //PSC Offset 76
	u32 dma_falen;          //PSC Offset 80
	u32 dma_adc_active;     //PSC Offset 84
	u32 dma_tbt_active;     //PSC Offset 88
	u32 dma_fa_active;      //PSC Offset 92
	u32 dma_tx_active;      //PSC Offset 96
} StatusMsg;
*/


// Control Message Offsets
#define SOFT_TRIG_MSG 0
#define FP_LED_MSG 4
#define PILOT_TONE_ENB_MSG 8
#define ADC_IDLY_MSG 12
#define ADC_MMCM0_MSG 16
#define ADC_MMCM1_MSG 20
#define ADC_SPI_MSG 24
#define EVENT_SRC_SEL_MSG 36
#define DMA_TRIG_SRC_MSG 52
#define DMA_ADCLEN_MSG 56
#define DMA_TBTLEN_MSG 60
#define DMA_FALEN_MSG 64
#define MACHINE_SEL_MSG 76
#define PILOT_TONE_SPI_MSG 104
#define RF_ATTEN_MSG 132
#define PT_ATTEN_MSG 136
#define KX_MSG 144
#define KY_MSG 148
#define BBA_XOFF_MSG 152
#define BBA_YOFF_MSG 156
#define CHA_GAIN_MSG 160
#define CHB_GAIN_MSG 164
#define CHC_GAIN_MSG 168
#define CHD_GAIN_MSG 172
#define FINE_TRIG_DLY_MSG 192  //Geo Delay
#define TBT_GATE_WIDTH_MSG 196
#define COARSE_TRIG_DLY_MSG 272
#define TRIGTOBEAM_THRESH_MSG 276
#define EVENT_NO_MSG 320
#define RFFESW_ENB_MSG 400
#define RFFESW_TRIGDLY_MSG 404
#define RFFESW_DEMUXDLY_MSG 408




