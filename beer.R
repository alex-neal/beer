require(tidyverse)
require(corrplot)
df = read_csv('beer_reviews.csv')



#  Which brewery produces the strongest beers by ABV
strongest = df %>% 
  drop_na(beer_abv) %>%
  group_by(brewery_name, beer_name) %>% 
  summarize(abv=mean(beer_abv)) %>% 
  group_by(brewery_name) %>% 
  summarize(mean_abv=mean(abv), beer_count=n()) %>% 
  arrange(desc(mean_abv))

strongest %>% head(5) %>%
  ggplot() + geom_col(aes(x=brewery_name, y=mean_abv))


#  If you had to pick 3 beers to recommend using only this data, which would you pick?
beers = df %>% group_by(brewery_name, beer_name) %>%
  summarize(mean_overall=mean(review_overall), sd_overall=sd(review_overall), review_count=n()) %>%
  arrange(desc(mean_overall))

ggplot(beers) + geom_histogram(aes(x=review_count))

beers2 = beers %>% filter(review_count > 30)

# Which of the factors (aroma, taste, appearance, palette) are most important in determining the overall quality of a beer?
reviews = select(df, c('review_overall', 'review_aroma', 'review_appearance', 'review_palate', 'review_taste'))
M = cor(reviews)
corrplot(M)

model = lm(review_overall ~ ., data=reviews)


# If I typically enjoy a beer due to its aroma and appearance, which beer style should I try?
a = df %>% group_by(beer_style) %>%
  summarize(count=n(), mean_aroma=mean(review_aroma), mean_appearance=mean(review_appearance)) %>%
  mutate(composite_score=(mean_aroma+mean_appearance)/2) %>%
  arrange(desc(composite_score))

