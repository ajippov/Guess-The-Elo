*** Guess the Elo Data Analysis ***
*** First 43 Episodes Included (excluding one which seems to have been taken down?) ***

** Change Working Directory

cd "D:\Coding Folder\Guess The Elo"

** Importing Data

import excel "D:\Coding Folder\Guess The Elo\GuessTheEloData.xlsx", sheet("Sheet1") firstrow

** Cleaning

drop if Episode == 41
gen same = 0
replace same = 1 if BottomRange == TopRange
replace BottomRange = BottomRange-50 if same == 1
replace TopRange = TopRange+50 if same == 1
drop same

** Within Range: 1 if it's in the range specified, 2 if it's within 100 points of either end, 3 if it's within 200 points of either end, 4 otherwise
gen WithinRange = 0 
gen TopRangeDiff = Rating - TopRange
gen BottomRangeDiff = Rating - BottomRange
replace WithinRange = 1 if Rating >= BottomRange & Rating < TopRange
replace WithinRange = 2 if BottomRangeDiff < 0 & BottomRangeDiff > -100
replace WithinRange = 2 if TopRangeDiff > 0 & TopRangeDiff < 100
replace WithinRange = 3 if BottomRangeDiff < -100 & BottomRangeDiff > -200
replace WithinRange = 3 if TopRangeDiff > 100 & TopRangeDiff < 200
replace WithinRange = 4 if BottomRangeDiff < -200 & BottomRangeDiff > -300
replace WithinRange = 4 if TopRangeDiff > 200 & TopRangeDiff < 300
replace WithinRange = 5 if WithinRange == 0 

** Graphs

* Split of Black/White Pieces

graph pie, over(Color) plabel(_all sum, color(white) size(medlarge)) title(Split of White/Black Pieces) legend(order(1 "Black" 2 "White"))
graph export "D:\Coding Folder\Guess The Elo\WhiteBlackSplit.png", replace

* Guess Accuracy

twoway (scatter Rating Episode if WithinRange == 1) (scatter Rating Episode if WithinRange == 2) (scatter Rating Episode if WithinRange == 3) (scatter Rating Episode if WithinRange == 4) (scatter Rating Episode if WithinRange == 5), title(Guess Accuracy by Episode) legend(order(1 "In Range" 2 "Within 100 Points" 3 "Within 200 Points" 4 "Within 300 Points" 5 "Trash Guess"))
graph export "D:\Coding Folder\Guess The Elo\GuessAccuracy.png", replace

graph pie, over(WithinRange) plabel(_all sum, color(white) size(medlarge)) legend(on order(1 "Within Range" 2 "Within 100 Points" 3 "Within 200 Points" 4 "Within 300 Points" 5 "Trash Guess"))
graph export "D:\Coding Folder\Guess The Elo\GuessRanges.png", replace

* Rating Distribution

histogram Rating, percent addlabel title(Rating Distribution)
graph export "D:\Coding Folder\Guess The Elo\RatingDistribution.png", replace

