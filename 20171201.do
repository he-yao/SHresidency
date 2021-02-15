/* -------------------------------------
AUTHOR: Yao He
PURPOSE: SH residency training trial run
DATE CREATED: 07/04/2017
NOTES:
CHANGELOG: Dataset and multilevel
----------------------------------- */

set more off
capture log close
set logtype text
log using 20171201.txt, replace

cd "C:\Users\YH\Documents\Work\Research\Shanghai residency homogeneity\Stata"

use SHresidency1201old, clear

drop if knowtrain==.
drop if knowrequire==.
drop if poliatt==.
drop if varall==.

tab sex yrsurvey, row col chi2
tab deg yrsurvey, row col chi2
tab recloc yrsurvey, row col chi2
tab prof yrsurvey, row col chi2
tab hoslev yrsurvey, row col chi2
tab hosaff yrsurvey, row col chi2

* Cronbach's Alpha to test consistency of items in the Likert score

alpha var1_proftheo	///
	var1_basictheo	///
	var1_newtech	///
	var1_eng 		///
	var2_medrec 	///
	var2_aux 		///
	var2_treat 		///
	var2_diag 		///
	var2_serious 	///
	var3 			///
	var4, item

* Average improvement score of the entire sample
sum varall

/* Unadjusted tests of the association between improvement overall scores
and hospital level, affiliation, and specialty. */

reg varall i.hoslev
reg varall i.hosaff
reg varall i.hos

/* Model 1: Take all variables into account and test associations */

reg varall	///
	i.yrsurvey	///
	age	///
	sex	///
	recloc	///
	i.deg	///
	i.prof	///
	i.hoslev	///
	i.hosaff	///
	knowtrain	///
	knowrequire

/* At the hospital level, is there any association between overall scores and any independent variable? */

* Model 2 Multilevel
mixed varall ///
	i.yrsurvey ///
	age	///
	sex	///
	recloc	///
	i.deg	///
	i.prof	///
	i.hoslev	///
	i.hosaff	///
	knowtrain	///
	knowrequire ///
	|| hos:, var nolog

recode hoslev (0=0)(1=1)(2=.), gen(hoslev1)
recode hoslev (0=0)(1=.)(2=1), gen(hoslev2)
	
* Model 3 Multilevel, gender-hospital level interaction
mixed varall ///
	i.yrsurvey ///
	age	///
	sex	///
	recloc	///
	i.deg	///
	knowtrain	///
	knowrequire ///
	c.sex#c.hoslev1	///
	c.sex#c.hoslev2	///
	i.hoslev	///
	i.hosaff	///
	|| hos:, cov(unstr)
	
label var varall "Improvement Score"
graph box varall, over(hoslev) horizontal
graph box varall, over(hosaff) horizontal

graph box varall, over(knowtrain) horizontal
graph box varall, over(knowrequire) horizontal

log close
