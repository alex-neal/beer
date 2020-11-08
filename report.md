# BeerAdvocate Dataset Analysis

## Which brewery produces the strongest beers by ABV?

#### Methodology:
1. Remove all rows where the ABV value is missing.
2. Calculate the mean ABV of every *beer* in the dataset. This is the policy to handle any discrepencies in ABV among the reviews for a particular beer. 
3. Calculate the average ABV for each brewery by grouping the results of step 2 by brewery and taking the mean again.
4. Rank the breweries in order of decreasing average ABV. 

#### Results:
The following plot shows the average ABV of the top 10 breweries in the ranking. 

![top abv](img/brewery-abv-all.png)

Some of these breweries (e.g. Shoes, Alt-Oberurseler, and Rascal Creek) only have a single beer in the dataset. One beer isn't enough information to indicate if a brewery *consistently* creates high-ABV beers. Lets make another plot which only considers breweries with at least 4 different beers in the dataset.

![top abv with at least 4 beers](img/brewery-abv-4.png)

In any case, the German brewery **Schorschbräu is the clear winner**. *Prost!* Let's have a look at what they have on tap:

![schorschbrau beers](img/schorschbrau-abv.png)



<br>

## If you had to pick 3 beers to recommend using only this data, which would you pick?

#### Methodology:
First, it is necessary to answer this question: How many reviews does a beer need in order for its average review score to be considered reliable? 

Somewhat arbitrarily, I chose 30. This leads to the following methodology:
1. Calculate the total number of reviews and mean overall score for every beer.
2. Filter out all beers with less than 30 reviews.
3. Arrange the beers in order of decreasing mean score.

#### Results:

![schorschbrau beers](img/recommendation2.png)


| Brewery                                 | Beer            | Aroma | Taste | Appearance | Palate | Overall |
|-----------------------------------------|-----------------|-------|-------|------------|--------|---------|
| Peg's Cantina & Brewpub / Cycle Brewing | Rare D.O.S.     | 4.76  | 4.85  | 4.47       | 4.80   | 4.85    |
| De Struise Brouwers                     | Dirty Horse     | 4.62  | 4.74  | 4.42       | 4.58   | 4.82    |
| Southampton Publick House               | Berliner Weisse | 4.35  | 4.56  | 4.18       | 4.39   | 4.77    |

<br>

## Which of the factors (aroma, taste, appearance, palette) are most important in determining the overall quality of a beer?

#### Methodology
To answer this question, we can simply calculate a correlation matrix of the four factors along with the overall score.

#### Results
![correlation matrix](img/cormatrix.png)

We see that taste has a stronger positive correlation with overall score than any of the other three factors. **Taste is therefore the most important factor in determining the overall quality of a beer, according to the data.** 


<br>

## If I typically enjoy a beer due to its aroma and appearance, which beer style should I try?

Methodology: 
1. Calculate the mean aroma and mean appearance scores for every *style* of beer. 
2. Generate a composite score by averaging the aroma and appearance means. 
3. Rank the beer styles in order of decreasing composite score.

Result:


<br>

## Code

### Which brewery produces the strongest beers by ABV?

### If you had to pick 3 beers to recommend using only this data, which would you pick?


### Which of the factors (aroma, taste, appearance, palette) are most important in determining the overall quality of a beer?

### If I typically enjoy a beer due to its aroma and appearance, which beer style should I try?