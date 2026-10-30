# load graph library
library(ggplot2)

kinematic_chain_plot <- function(data) {
  
  # missed the ball: fill in contact time as when approach data ends 
  if (sum(is.na(data$ball_hit_x)) == nrow(data)) {
    contact_row <- data %>%
      dplyr::filter(!is.na(vertical_approach_angle_x)) %>%
      slice_tail(n = 1)
    
    contact_time <- contact_row$time_x
  } 
  # hit the ball: contact time is the last row before hit ball measurements begin
  else {
    contact_row <- data %>%
      mutate(row_id = row_number()) %>%
      dplyr::filter(is.na(data$ball_hit_x) & dplyr::lead(!is.na(data$ball_hit_x), default = FALSE)) %>%
      slice(1)
    
    contact_time <- contact_row$time_x 
  }
  
  # plot angular velocity of 3 parts of kinematic sequence vs time
  plot <- data %>%
    dplyr::filter(time_x > 2) %>%
    ggplot(aes(x = time_x)) +
    geom_line(aes(y = pelvis_smooth, colour = "Pelvis"), linewidth = 0.5) +
    geom_line(aes(y = torso_smooth, colour = "Torso"), linewidth = 0.5) +
    geom_line(aes(y = lead_hand_smooth, colour = "Lead Hand"), linewidth = 0.5) +  
    geom_vline(xintercept = contact_time, color = "black", linetype = "dashed", linewidth = 0.5) +
    scale_color_manual(
      name = NULL,
      values = c("Pelvis"  = "red",
                 "Torso" = "blue",
                 "Lead Hand" = "yellow")) +
    theme_minimal() +
    labs(title = "Swing Kinematic Sequence Angular Velocity",
         x = "Time (s)",
         y = "Angular Velocity (°/s)") +
    theme(plot.title = element_text(hjust = 0.5))
  
  return(plot)
}

# create plots and save to folder
batter1_plot <- kinematic_chain_plot(batter1_smooth)
batter2_plot <- kinematic_chain_plot(batter2_smooth)
# skip batter3 because it is the same take as batter2
batter4_plot <- kinematic_chain_plot(batter4_smooth)
batter5_plot <- kinematic_chain_plot(batter5_smooth)

ggsave("outputs/batter1_sequence.png", plot = batter1_plot, width = 8, height = 4, dpi = 300)
ggsave("outputs/batter2_sequence.png", plot = batter2_plot, width = 8, height = 4, dpi = 300)
ggsave("outputs/batter4_sequence.png", plot = batter4_plot, width = 8, height = 4, dpi = 300)
ggsave("outputs/batter5_sequence.png", plot = batter5_plot, width = 8, height = 4, dpi = 300)




