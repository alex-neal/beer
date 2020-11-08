require(tidyverse)
require(corrplot)

# Import data
df = read_csv('beer_reviews.csv')


#####################################################
#  Which brewery produces the strongest beers by ABV
#####################################################

# Rank breweries by average beer ABV
strongest = df %>% 
  drop_na(beer_abv) %>%
  group_by(brewery_name, beer_name) %>% 
  summarize(abv=mean(beer_abv)) %>% 
  group_by(brewery_name) %>% 
  summarize(mean_abv=mean(abv), beer_count=n()) %>% 
  arrange(desc(mean_abv))

# Fix character issue in 9th brewery name
strongest$brewery_name[9] = "Rinkuškiai; Aluas Darykla"

# Make brewery name an ordered factor so ggplot will display bars in rank order
strongest$brewery_name = factor(strongest$brewery_name, levels=rev(strongest$brewery_name))

# Vizualize top 10 for all breweries
strongest %>% head(10) %>%
  ggplot() + geom_col(aes(x=brewery_name, y=mean_abv), fill='steelblue3') + coord_flip() +
  ggtitle('Top Breweries by ABV', subtitle='(all breweries)') + ylab('Average ABV (%)') + xlab('') 

# Vizualize top 10 for breweries with at least 4 beers
strongest %>% filter(beer_count > 3) %>% head(10) %>%
  ggplot() + geom_col(aes(x=brewery_name, y=mean_abv), fill='palegreen4') + coord_flip() +
  ggtitle('Top Breweries by ABV', subtitle='(breweries with at least 4 beers)') + ylab('Average ABV (%)') + xlab('') 

# Take a look at Schorschbräu's beers
schorschbrau = df %>%
  filter(brewery_name=='Schorschbräu') %>% 
  distinct(beer_name, beer_abv)

# Vizualize Schorschbräu beers
ggplot(schorschbrau) + geom_col(aes(x=beer_name, y=beer_abv), fill='goldenrod3') +
  coord_flip() + ggtitle('Schorschbräu Beers') + ylab('ABV (%)') + xlab('')



########################################################################################
#  If you had to pick 3 beers to recommend using only this data, which would you pick?
########################################################################################

# Get top 10 beers by overall score
beers = df %>% group_by(brewery_name, beer_name) %>%
  summarize(mean_aroma=mean(review_aroma), mean_taste=mean(review_taste), 
            mean_appearance=mean(review_appearance), mean_palate=mean(review_palate),
            mean_overall=mean(review_overall), sd_overall=sd(review_overall), 
            review_count=n()) %>%
  filter(review_count > 30) %>%
  mutate(ci=qnorm(0.975)*sd_overall/sqrt(review_count)) %>%  # Add a 95% CI
  arrange(desc(mean_overall)) %>% 
  head(10)

# Make beer name an ordered factor so ggplot will display bars in rank order
beers$beer_name = factor(beers$beer_name, levels=rev(beers$beer_name))
ggplot(beers, aes(x=beer_name, y=mean_overall)) +
  geom_col(fill='coral2') +
  geom_errorbar(aes(ymin=mean_overall-ci, ymax=mean_overall+ci),
                width=.2, position=position_dodge(.9)) + 
  coord_flip() + xlab('') + ylab('Mean Overall Score') +
  ggtitle('Highest Ranking Beers', subtitle="(at least 30 reviews)")


############################################################################################################################
# Which of the factors (aroma, taste, appearance, palette) are most important in determining the overall quality of a beer?
############################################################################################################################

# Calculate correlation matrix
reviews = select(df, c('review_overall', 'review_aroma', 'review_appearance', 'review_palate', 'review_taste'))
M = cor(reviews)

# Visualize correlation matrix
corrplot(M)


#############################################################################################
# If I typically enjoy a beer due to its aroma and appearance, which beer style should I try?
#############################################################################################

# Calculate composite score for each style and rank
df %>% group_by(beer_style) %>%
  summarize(count=n(), mean_aroma=mean(review_aroma), mean_appearance=mean(review_appearance)) %>%
  mutate(composite_score=(mean_aroma+mean_appearance)/2) %>%
  arrange(desc(composite_score))

