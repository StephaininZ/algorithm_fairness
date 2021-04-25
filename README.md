# Abstract
While AI technology has expedited the decision-making process in business operations, liberating manual efforts and replacing rule-based models in the age of big data for firms, concerns have been aroused on AI adoption by business decision-makers. This paper reproduces Cowgill, Dell’Acqua, and Matz (2020) to reinvestigate the managerial impact of algorithm fairness using a RCT field experiment under two business decision-making scenarios. This paper identifies demographic traits explaining the fundamental diversity in firm manager’s attitude towards AI and further examines the effect of interventions on AI adoption through activism arguments on algorithmic fairness. This paper finds that counterfactual advocacy arguments on algorithmic bias are more e ective in promoting AI adoption for business use. Besides argument manipulations, race, gender, and knowledge on the status quo fundamentally impact manager’s judgment on AI adoption.

# Overview of the Data
The panel dataset records 498 subject observations with 50 variables for two business cases, including demographic information about the subject (i.e. dummy for gender, race), education, and AI-related experience, indicator variables flagging experiment treatments, and five survey answers at different experiment stages in numeric scale.
The dependent variables of interest listed below are answers to five adoption-related survey questions given by subjects at different stages during the experiment, which proxy respondent’s adoption decisions.
* `posneg`: Positive impact level the subject considers AI adoption (1-6)
* `recscale`: Recommendation scale on AI adoption (1-7)
* `recyesno`: Whether recommend adopting AI technology (0 or 1)
* `lawsuitspr`: How likely are AI lawsuits or PR problems (1-7)
* `damaging`: Magnitude of damage by AI bias (1-7)

# File Structure
* scripts: the folder contains R code to import and clean raw data
* inputs: the raw dataset and cleaned dataset are under the `data` subfolder
* outputs: the `paper` subfolder contains the kintted pdf, R markdown, and bib reference for paper. The `literature` subfolder contains the original paper to replicate, written by Bo Cowgill, Fabrizio Dell’Acqua, and Sandra Matz.
