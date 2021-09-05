*Home Delivery

meta set prop_dom prop_dom_se , random(dlaird) studylabel( country )

*Meta-Analysis
meta summarize, subgroup(tgroup)
meta forestplot, random subgroup(tgroup) esrefline columnopts(_esci, supertitle("Proportion") title("with 95% CI") format(%9.2f)) cibind(parentheses) graphregion(color(white)) plotregion(color(white)) insidemarker  ///
  subti("Home delivered", size(7)) ///
  xtitle("Proportion",size(3))  ///
  plotregion(icolor(white)) ysize(16) xsize(9) noohomtest noosigtest  nogwhomtests nogbhomtests
graph export "D:\Figure 2.png", as(png) name("Graph") replace width(2000)

*Sensitivity Analysis
meta forestplot, random leaveoneout esrefline columnopts(_esci, supertitle("Proportion") title("with 95% CI") format(%9.2f)) cibind(parentheses) graphregion(color(white)) plotregion(color(white))   ///
  subti("Home delivered", size(7)) ///
  xtitle("Proportion",size(3))  ///
  plotregion(icolor(white)) ysize(16) xsize(8)
graph export "D:\Figure Sensitivity.png", as(png) name("Graph") replace width(2000)