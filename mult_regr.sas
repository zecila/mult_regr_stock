/* Generated Code (IMPORT) */
/* Source File: stock_price.xlsx */
/* Source Path: /home/u63739291 */
/* Code generated on: 4/27/24, 8:41 PM */

%web_drop_table(WORK.IMPORT);


FILENAME REFFILE '/home/u63739291/mult_regr.xlsx';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=WORK.mult_regr;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.mult_regr; RUN;

%web_open_table(WORK.IMPORT);

/*proc print data=mult_regr(obs=10); run;*/
/*proc corr data=mult_regr;
	var _numeric_;
	with tpr;
	run; */

/* Stepwise Regression */
proc reg data=mult_regr;
	model tpr = abnb amzn aptv azo bbwi bby bkng bwa czr kmx ccl cmg dri 
				deck dpz dhi ebay etsy expe f grmn gm gpc has hlt hd lvs 
				len lkq low lulu mar mcd mgm mhk nke nclh nvr orly pool phm 
				rl rost rcl sbux tsla tjx tsco ulta wynn yum
				/ selection=stepwise slentry=0.01 slstay=0.01; run;

/* at alpha=0.05, vars significant: amzn, aptv, azo, bbwi, bkng, kmx, dri, dpz, ebay, etsy, expe, lkq, mar, nke, nclh, rl, rost, rcl, sbux, tsla, wynn, yum
proc reg data=mult_regr;
	model tpr = amzn aptv azo bbwi bkng kmx dri dpz ebay etsy expe lkq mar nke nclh rl rost rcl sbux tsla wynn yum;
	run;
proc reg data=mult_regr;
	model tpr = amzn aptv azo bbwi bkng kmx dri dpz ebay etsy expe lkq mar nke nclh rl rost rcl sbux tsla wynn yum/vif;
	run; */


/* at alpha=0.01, vars significant: azo, bbwi, ccl, dri, dpz, ebay, etsy, gm, lvs, lkq, nke, rl, tjx */
proc reg data=mult_regr;
	model tpr = azo bbwi ccl dri dpz ebay etsy gm lvs lkq nke rl tjx/vif;
	run;
/* took out tjx and gm */
proc reg data=mult_regr;
	model tpr = azo bbwi ccl dri dpz ebay etsy lvs lkq nke rl/vif;
	run;

/*================================================================================*/

/* R-square: 
   best first order, 10 var model is:
   DRI DPZ EBAY ETSY GM LKQ NKE RL TSLA YUM */
proc reg data=mult_regr;
	model tpr = abnb amzn aptv azo bbwi bby bkng bwa czr kmx ccl cmg dri 
				deck dpz dhi ebay etsy expe f grmn gm gpc has hlt hd lvs 
				len lkq low lulu mar mcd mgm mhk nke nclh nvr orly pool phm 
				rl rost rcl sbux tsla tjx tsco ulta wynn yum
				/selection=rsquare start=1 stop=10 best=5; run;

/* R-adj: 
   best first order, 10 var model is:
   DRI DPZ EBAY ETSY GM LKQ NKE RL TSLA YUM */
proc reg data=mult_regr;
	model tpr = abnb amzn aptv azo bbwi bby bkng bwa czr kmx ccl cmg dri 
				deck dpz dhi ebay etsy expe f grmn gm gpc has hlt hd lvs 
				len lkq low lulu mar mcd mgm mhk nke nclh nvr orly pool phm 
				rl rost rcl sbux tsla tjx tsco ulta wynn yum
				/selection=adjrsq start=1 stop=10 best=5; run;

/* C(p) 
   best first order, 10 var model is: 
   DRI DPZ EBAY ETSY GM LKQ NKE RL TSLA YUM */
proc reg data=mult_regr;
	model tpr = abnb amzn aptv azo bbwi bby bkng bwa czr kmx ccl cmg dri 
				deck dpz dhi ebay etsy expe f grmn gm gpc has hlt hd lvs 
				len lkq low lulu mar mcd mgm mhk nke nclh nvr orly pool phm 
				rl rost rcl sbux tsla tjx tsco ulta wynn yum
				/selection=cp start=1 stop=10 best=5; run;

/* rsquare, radj, cp all gave same best 10 var model
   now we check vif for that model */
proc reg data=mult_regr;
  	model tpr = DRI DPZ EBAY ETSY GM LKQ NKE RL TSLA YUM/vif; run;
/*took out gm, all VIF<10 now */
proc reg data=mult_regr;
  	model tpr = DRI DPZ EBAY ETSY LKQ NKE RL TSLA YUM/vif; run;
  	
/*=============================================================================*/

/* PRESS 
   best first order var model is:
   AZO BBWI CZR CCL DRI DPZ EBAY ETSY GM LVS LKQ NKE RL TJX */
proc glmselect data=mult_regr;
	model tpr = abnb amzn aptv azo bbwi bby bkng bwa czr kmx ccl cmg dri 
				deck dpz dhi ebay etsy expe f grmn gm gpc has hlt hd lvs 
				len lkq low lulu mar mcd mgm mhk nke nclh nvr orly pool phm 
				rl rost rcl sbux tsla tjx tsco ulta wynn yum
				/selection=stepwise(choose=press); run;
				
/* testing best model from PRESS */
proc reg data=mult_regr;
	model tpr = AZO BBWI CZR CCL DRI DPZ EBAY ETSY GM LVS LKQ NKE RL TJX/vif; run;
/* removed tjx, gm, dpz */
proc reg data=mult_regr;
	model tpr = AZO BBWI CZR CCL DRI EBAY ETSY LVS LKQ NKE RL/vif; run;
	
/*=============================================================================*/
	
/* testing first var regression models */
/* stepwise regression */
proc reg data=mult_regr;
	model tpr = azo bbwi ccl dri dpz ebay etsy lvs lkq nke rl; run;
/* r-sq, r-adj, cp */
proc reg data=mult_regr;
	model tpr = DRI DPZ EBAY ETSY LKQ NKE RL TSLA YUM; run;
/* press*/
proc reg data=mult_regr;
	model tpr = AZO BBWI CZR CCL DRI EBAY ETSY LVS LKQ NKE RL; run;

/* CONCLUSION: STEPWISE REGRESSION HAS BEST FIRST ORDER MODEL: tpr = azo bbwi ccl dri dpz ebay etsy lvs lkq nke rl */
/*=============================================================================*/

/* checking for interaction terms */
proc glm data=mult_regr;
	model tpr=nke | rl /solution;
	store GLMMODEL;
proc plm restore=GLMMODEL noinfo;
	effectplot slicefit (x=nke sliceby=rl);
	run;

/* interactions with: 	azo/ccl, azo/dpz, azo/etsy, azo/lvs, azo/lkq, azo/nke, 
						bbwi/ccl, bbwi/etsy, bbwi/nke, ccl/dpz, ccl/etsy, ccl/nke, 
						dri/dpz, dri/etsy, dri/nke, dri/rl, dpz/etsy, dpz/lkq, dpz/nke, 
						ebay/etsy, ebay/lvs, ebay/rl, etsy/lvs etsy/lkq, etsy/rl,
						lvs/lkq, lvs/nke, lkq/nke, nke/rl*/

/* new dataset */
Data mult_regr_2;
	set mult_regr;
	azo_ccl = azo*ccl; azo_dpz = azo*dpz; azo_etsy = azo*etsy; azo_lvs = azo*lvs; azo_lkq = azo*lkq; azo_nke = azo*nke;
	bbwi_ccl = bbwi*ccl; bbw_etsy = bbwi*etsy; bbwi_nke = bbwi*nke; ccl_dpz = ccl*dpz; ccl_etsy = ccl*etsy; ccl_nke = ccl*nke;
	dri_dpz = dri*dpz; dri_etsy = dri*etsy; dri_nke = dri*nke; dri_rl = dri*rl; dpz_etsy = dpz*etsy; dpz_lkq = dpz*lkq; dpz_nke = dpz*nke;
	ebay_etsy = ebay*etsy; ebay_lvs = ebay*lvs; ebay_rl = ebay*rl; etsy_lvs = etsy*lvs; etsy_lkq = etsy*lkq; etsy_rl = etsy*rl;
	lvs_lkq = lvs*lkq; lvs_nke = lvs*nke; nke_rl = nke*rl;
	
proc reg data=mult_regr_2;
	model tpr = azo bbwi ccl dri dpz ebay etsy lvs lkq nke rl
				azo_ccl azo_dpz azo_etsy azo_lvs azo_lkq azo_nke bbwi_ccl bbw_etsy bbwi_nke ccl_dpz ccl_etsy ccl_nke
				dri_dpz dri_etsy dri_nke dri_rl dpz_etsy dpz_lkq dpz_nke ebay_etsy ebay_lvs ebay_rl etsy_lvs
				etsy_lkq etsy_rl lvs_lkq lvs_nke nke_rl;
	test azo_ccl, azo_dpz, azo_etsy, azo_lvs, azo_lkq, azo_nke, bbwi_ccl, bbw_etsy, bbwi_nke, ccl_dpz, ccl_etsy, ccl_nke,
				dri_dpz, dri_etsy, dri_nke, dri_rl, dpz_etsy, dpz_lkq, dpz_nke, ebay_etsy, ebay_lvs, ebay_rl, etsy_lvs,
				etsy_lkq, etsy_rl, lvs_lkq, lvs_nke, nke_rl;
				run;

/*=============================================================================*/
/* checking for quadratic terms one var at a time
   only one that looks suspicious is lkq */
proc sgplot data=mult_regr;
	scatter x=lkq y=tpr;
	run;

Data mult_regr_quadratic;
	set mult_regr;
	lkq_sq = lkq**2;

proc reg data=mult_regr_quadratic;
	model tpr = azo bbwi ccl dri dpz ebay etsy lvs lkq nke rl lkq_sq; run;
/* no significant quadratic terms */
