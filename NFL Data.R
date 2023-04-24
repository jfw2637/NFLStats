library(nflfastR)
library(dplyr, warn.conflicts = FALSE)
library(gsisdecoder)
library(ggplot2)
library(ggpubr)

get_pbp_data<-function(){
  options(nflreadr.verbose = FALSE)
  ids <- nflfastR::fast_scraper_schedules(2010:year(Sys.Date())) %>%
    dplyr::pull(game_id)
  tryCatch(
    {pbp <- nflfastR::load_pbp(2020:year(Sys.Date()))},
    error = function(e){ pbp <- nflfastR::load_pbp(2020:year(Sys.Date())-1)}
  )
  pbp <-  data.frame(pbp)
}

#filter_list<-list(
#qtr=data.frame(value_1=3,value_2="",type="equal to"),
#game_date=data.frame(value_1=as.Date("2022-01-01"),value_2=as.Date("2022-12-01"),type="between")
#)
#team="BUF"
#home_away="home"
#opponent="*"

filter_pbp_data<-function(pbp,team,home_away,opponent,filter_list){
pbp_filtered<-pbp
if(team!="" & team!="*"){pbp_filtered<-pbp_filtered[(pbp_filtered$home_team==team | pbp_filtered$away_team==team),]}
if(opponent!="" & opponent!="*"){pbp_filtered<-pbp_filtered[(pbp_filtered$home_team==opponent | pbp_filtered$away_team==opponent), ]}
if(home_away!="" & home_away!="*"){pbp_filtered<-pbp_filtered[if(home_away=="Home"){pbp_filtered$home_team==team}else{pbp_filtered$away_team==team}, ]}
if(length(filter_list)>0){
for(i in seq(1:length(filter_list))){
  if(grepl("equal", filter_list[[i]]$type,fixed = TRUE)){
    pbp_filtered<-pbp_filtered[pbp_filtered[,names(filter_list)[i]]==filter_list[[i]]$value_1,]
  }
  else if(filter_list[[i]]$type =="less than" | filter_list[[i]]$type=="<"){
    pbp_filtered<-pbp_filtered[pbp_filtered[,names(filter_list)[i]]<filter_list[[i]]$value_1,]
  }
  else if(grepl("less than or equal to", filter_list[[i]]$type,fixed = TRUE) |grepl("<=", filter_list[[i]]$type,fixed = TRUE)){
    pbp_filtered<-pbp_filtered[pbp_filtered[,names(filter_list)[i]]<=filter_list[[i]]$value_1,]
  }
  else if(filter_list[[i]]$type == "greater than"| ">" %in% filter_list[[i]]$type){
    pbp_filtered<-pbp_filtered[pbp_filtered[,names(filter_list)[i]]<filter_list[[i]]$value_1,]
  }
  else if(grepl("greater than or equal to", filter_list[[i]]$type,fixed = TRUE)|grepl(">=", filter_list[[i]]$type,fixed = TRUE) ){
    pbp_filtered<-pbp_filtered[pbp_filtered[,names(filter_list)[i]]<=filter_list[[i]]$value_1,]
  }
  else if(grepl("between", filter_list[[i]]$type,fixed = TRUE)){
    pbp_filtered<-pbp_filtered[pbp_filtered[,names(filter_list)[i]]>=filter_list[[i]]$value_1 & pbp_filtered[,names(filter_list)[i]]<=filter_list[[i]]$value_2,]
  }
  else if(grepl("in", filter_list[[i]]$type,fixed = TRUE)){
    pbp_filtered<-pbp_filtered[filter_list[[i]]$value_1 %in% pbp_filtered[,names(filter_list)[i]] ,]
  }
}
}
return(pbp_filtered)
}

general_stats<-function(pbp_filtered,agg_function){
  #score
  #touchdowns
}

plot_yard_histogram<-function(pbp){

yards_histogram <- pbp %>%    filter(!is.na(down)) 
yards_histogram<-data.frame(yards_histogram)
yards_histogram$down = as.factor(yards_histogram$down)
run_yards_hist<-ggplot(filter(yards_histogram,play_type =="run"), 
                       aes(x=yards_gained, color = down, fill = down)) + 
                      geom_histogram(alpha=0.5, position="dodge")+
                      scale_x_continuous(limits = c(-10, 80))+
                      scale_y_continuous(limits = c(0, 36000)) 
pass_yards_hist<-ggplot(filter(yards_histogram,play_type =="pass"), 
                        aes(x=yards_gained, color = down, fill = down)) + 
                        geom_histogram(alpha=0.5, position="dodge")+
                        scale_x_continuous(limits = c(-10, 80)) +
                        scale_y_continuous(limits = c(0, 36000)) 

return(ggarrange(run_yards_hist,pass_yards_hist, ncol=1,nrow=2))
}
