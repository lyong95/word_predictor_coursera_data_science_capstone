#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(dplyr)
library(tidyverse)
library(tidytext)
library(shiny)
library(wordcloud2)
library(stopwords)


## set wd
setwd("/Users/lyong/Desktop/Courses_and_Workshops/R_Programming/Coursera_Data_Science_with_R _Specialisation/10_Capsone_project/")

## create different ngrams
unigram = read.csv("./unigram.csv")
bigram = read.csv("./bigram.csv")
trigram = read.csv("./trigram.csv")

# separate bigrams and trigrams into individual wordsz
ngram3 = separate(trigram, ngram, c("word1", "word2", "word3"), sep = " ")
ngram2 = separate(bigram, ngram, c("word1", "word2"), sep = " ")

## function to predict user next word
predict_next_word = function(text){
    words = stringr::str_split(tolower(text)," " )[[1]]
    len = length(words)
    
    input = words[c(len-1, len)]
    p = ngram3 %>%  filter(word1 == input[1]) %>%  filter(word2 == input[2]) %>% arrange(desc(freq))
    p2 = ngram2 %>%  filter(word1 == input[1])  %>% arrange(desc(freq))
    
    if (nrow(p) > 5){
        next_word = p$word3[1:5]
        } else if(nrow(p) > 0 & nrow(p) <= 5){
        next_word = p$word3
        } else if (nrow(p2) > 5){
        next_word = p2$word2[1:5]
        } else if (nrow(p2) > 0 & nrow(p2) <= 5){
        next_word = p2$word2[1:5]
        } else {
          next_word = "try again with another input"
          }

    return(next_word)
}

# combine top 10 ngrams from bigrams and trigrams
top2 = bigram %>% slice_max(freq, n = 10) %>% add_column(ngram = "2-gram")
top3 = trigram %>% slice_max(freq, n = 10) %>% add_column(ngram = "3-gram")

top = bind_rows(top2, top3)

## define server behaviour to predict user's next word
shinyServer(function(input, output) {

  text = reactive({
    predict_next_word(input$user_text)
    })
    
    
  # display prediction outputs
  output$pred =  renderText(text()[1])
  output$pred2 = renderText(text()[2])
  output$pred3 = renderText(text()[3])
  
  #plot ngram top 10 from dataset
  output$ngram_plot = renderPlot({
    ggplot(top, aes(x = n, fct_reorder(ngram, n))) +
      geom_col(show.legend = FALSE) +
      facet_wrap(~ ngram.1, nrow = 1, scales = "free") +
      labs(title = "Top 10 ngrams", 
           x = "frequency",
           y = "")
    })
  
  # get top 10  of unigram
  unigram = unigram %>% 
    filter(!ngram %in% stop_words$word) %>% 
    slice_max(freq, n = 100) %>% 
    arrange(desc(freq))
  
  #build wordcloud 
  output$cloud = renderWordcloud2(
    wordcloud2(unigram)
  )
  
  #plot most common words before stop_words
  output$unigram_plot = renderPlot({
    ggplot(unigram, aes(x = n, fct_reorder(ngram, n))) +
      geom_col() +
      labs(title = "Top 10 words", 
           x = "frequency",
           y = "")
  })
  
})
  



  
