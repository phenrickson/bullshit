# lady tasting tea example
# number of cups to be tested
n_cups <- 8

# actual cups
set.seed(32)
cups <- sample(rep(c("milk", "tea"), each = n_cups / 2))

# a guess
guesses <- sample(rep(c("milk", "tea"), each = n_cups / 2))

# results
results <- cups == guesses

# how many right?
correct <- sum(results)
correct

# function to implement this in one step
sim_null <- function(n_cups){
        
        # actual cups
        cups <- sample(rep(c("milk", "tea"), each = n_cups / 2))
        
        # a guess
        guesses <- sample(rep(c("milk", "tea"), each = n_cups / 2))
        
        # results
        results <- cups == guesses
        
        # how many right?
        correct <- sum(results)
        correct
        
}

library(gtools)


# all possible permutations
all_perms = permutations(2, 8, c("milk", "tea"), repeats.allowed = T)

# now get only those where there are 4 milks and 4 teas, there should be 70 sequences
sequences = all_perms[apply(all_perms == 'milk', 1, sum) == 4,] 

# shuffle these
set.seed(2)
shuffled = sequences[sample(nrow(sequences)),]

# now compare to our true sequence: cups
correct = apply(shuffled, 1, function(x) cups == x)

# how many times do we observe each correct?
sums = apply(correct, 2, sum)

# number correct
sums %>%
        tibble() %>%
        ggplot(aes(x=sums))+
        geom_histogram(binwidth = 0.5)+
        theme_minimal() +
        xlab("number correct")

# how many times would she be _exactly_ right?
sum(sums == 8) / nrow(sequences)

# how many times would she get 6 right?
sum(sums == 6) / nrow(sequences)


# shuffled
ft = shuffled %>%
        apply(1, paste, collapse = " ") %>%
        tibble(sequence = .) %>%
    #    bind_cols(., tibble(correct = sums)) %>%
        mutate(group = case_when(row_number() <= nrow(shuffled) / 2 ~ 'group1',
                                 row_number() > nrow(shuffled) /2 ~ 'group2')) %>%
        pivot_wider(names_from = c("group"),
                    values_fn = list,
                    values_from = c("sequence")) %>%
        unnest()

# all correct
all_correct_cups = cups
        
ft %>%
        flextable() %>%
        autofit() %>%
        align(part = 'all',
              align = 'center') %>%
        line_spacing(space = 0.1, part = "body") %>%
        delete_part(part = "header") %>%
        border_remove() %>%
        delete_part(part = "footer") %>%
        bg(i = ~ group2 %in% paste(cups, collapse = " "),
           j = ~ group2,
           bg = 'dodgerblue', 
           part = 'body') %>%
        bg(i = ~ group1 %in% paste(cups, collapse = " "),
           j = ~ group1,
           bg = 'dodgerblue', 
           part = 'body')


# three correct
three_correct_cups = shuffled[which(sums==6),]

# display sequences with at least three correct as well
ft %>%
        flextable() %>%
        autofit() %>%
        align(part = 'all',
              align = 'center') %>%
        line_spacing(space = 0.1, part = "body") %>%
        delete_part(part = "header") %>%
        border_remove() %>%
        delete_part(part = "footer") %>%
        bg(i = ~ group2 %in% apply(three_correct_cups, 1, paste, collapse = " "),
           j = ~ group2,
           bg = 'grey60', 
           part = 'body') %>%
        bg(i = ~ group1 %in% apply(three_correct_cups, 1, paste, collapse = " "),
           j = ~ group1,
           bg = 'grey60', 
           part = 'body') %>%
        bg(i = ~ group2 %in% paste(cups, collapse = " "),
           j = ~ group2,
           bg = 'dodgerblue', 
           part = 'body') %>%
        bg(i = ~ group1 %in% paste(cups, collapse = " "),
           j = ~ group1,
           bg = 'dodgerblue', 
           part = 'body')
